-- mod-version:4
local core = require "core"
local command = require "core.command"
local common = require "core.common"
local keymap = require "core.keymap"
local style = require "core.style"
local DocView = require "core.docview"
local EmptyView = require "core.emptyview"
local RootView = require "core.rootview"
local ContextMenu = require "core.contextmenu"

local DIVIDER = ContextMenu.DIVIDER


local function active_tab()
  local view = core.active_view
  if not view then return end
  local node = core.root_view.root_node:get_node_for_view(view)
  if node then
    return node, view
  end
end


local function doc_view()
  local view = core.active_view
  if view and view.doc then
    return true, view
  end
  return false
end


local function is_protected(view)
  return view.tab_pinned or view.tab_kept_open
end


local function close_views(node, views)
  if #views == 0 then return end
  local docs, seen = {}, {}
  for _, view in ipairs(views) do
    if view.doc and not seen[view.doc] then
      seen[view.doc] = true
      docs[#docs + 1] = view.doc
    end
  end

  local function do_close()
    for i = #views, 1, -1 do
      local view = views[i]
      if view.doc then
        node:close_view_direct(core.root_view.root_node, view)
      else
        node:close_view(core.root_view.root_node, view)
      end
    end
  end

  if #docs > 0 then
    core.confirm_close_docs(docs, do_close)
  else
    do_close()
  end
end


local function views_except(node, selected)
  local views = {}
  for _, view in ipairs(node.views) do
    if view ~= selected and not is_protected(view) then
      views[#views + 1] = view
    end
  end
  return views
end


local function views_to_right(node, selected)
  local index = node:get_view_idx(selected)
  local views = {}
  for i = index + 1, #node.views do
    local view = node.views[i]
    if not is_protected(view) then
      views[#views + 1] = view
    end
  end
  return views
end


local function views_saved(node)
  local views = {}
  for _, view in ipairs(node.views) do
    if view.doc and not view.doc:is_dirty() and not is_protected(view) then
      views[#views + 1] = view
    end
  end
  return views
end


local function views_all(node)
  local views = {}
  for _, view in ipairs(node.views) do
    if not is_protected(view) then
      views[#views + 1] = view
    end
  end
  return views
end


local function open_in_system(path)
  if PLATFORM == "Windows" then
    system.exec('start "" ' .. common.quote_shell_path(path))
  elseif PLATFORM == "Mac OS X" then
    system.exec("open " .. common.quote_shell_path(path))
  else
    system.exec("xdg-open " .. common.quote_shell_path(path))
  end
end


local function reveal_in_file_manager(path)
  if PLATFORM == "Windows" then
    system.exec(string.format('explorer /select,%s',
      common.quote_shell_path(path:gsub("/", "\\"))))
  elseif PLATFORM == "Mac OS X" then
    system.exec("open -R " .. common.quote_shell_path(path))
  else
    system.exec("xdg-open " .. common.quote_shell_path(common.dirname(path)))
  end
end


local function reveal_in_explorer(path)
  local ok, tree = pcall(require, "plugins.treeview")
  if not ok or type(tree) ~= "table" then return end
  tree.visible = true
  pcall(tree.set_selection_to_path, tree, path, true, true, true)
  core.set_active_view(tree)
end


local function open_new_window(view, move)
  local doc = view.doc
  if not doc then return end
  local path = doc.abs_filename
  if not path then
    core.status_view:show_message("i", style.text, "Save the file before opening a new window")
    return
  end
  if doc:is_dirty() then
    doc:save()
  end
  system.exec(common.quote_shell_path(EXEFILE) .. " " .. common.quote_shell_path(path))
  if move then
    local node = core.root_view.root_node:get_node_for_view(view)
    if node then
      node:close_view(core.root_view.root_node, view)
    end
  end
end


local function split_and_move(view, direction)
  local root = core.root_view.root_node
  local node = root:get_node_for_view(view)
  if not node then return end

  local new_node = node:split(direction)
  local current_node = root:get_node_for_view(view)
  if not current_node or not new_node then return end

  if #current_node.views == 1 then
    current_node:add_view(EmptyView())
  end
  current_node:remove_view(root, view)
  new_node:add_view(view)
  core.set_active_view(view)
end


local function editor_submenu(view)
  local path = view.doc and (view.doc.abs_filename or view.doc.filename)
  local items = {
    {
      text = "T Code (Built-in)",
      command = function() core.set_active_view(view) end,
    },
  }
  if path then
    table.insert(items, {
      text = "System Default",
      command = function() open_in_system(path) end,
    })
  end
  return items
end


local function split_move_submenu(view)
  local function item(label, direction)
    return {
      text = label,
      command = function() split_and_move(view, direction) end,
    }
  end
  return {
    item("Split Right", "right"),
    item("Split Down", "down"),
    item("Split Left", "left"),
    item("Split Up", "up"),
  }
end


local function build_tab_menu(view)
  local items = {}
  local function add(text, cmd, extra)
    local item = { text = text, command = cmd }
    for key, value in pairs(extra or {}) do
      item[key] = value
    end
    items[#items + 1] = item
  end

  add("Close", "tab:close")
  add("Close Others", "tab:close-others")
  add("Close to the Right", "tab:close-right")
  add("Close Saved", "tab:close-saved")
  add("Close All", "tab:close-all")
  items[#items + 1] = DIVIDER

  if view.doc then
    add("Copy Path", "tab:copy-path")
    add("Copy Relative Path", "tab:copy-relative-path")
    items[#items + 1] = DIVIDER
    add("Reopen Editor With...", nil, {
      get_submenu = function() return editor_submenu(view) end,
    })
    items[#items + 1] = DIVIDER
    add("Reveal in File Explorer", "tab:reveal-file")
    add("Reveal in Explorer View", "tab:reveal-in-explorer")
    items[#items + 1] = DIVIDER
  end

  add((view.tab_kept_open and "* " or "  ") .. "Keep Open", "tab:keep-open")
  add((view.tab_pinned and "* " or "  ") .. "Pin", "tab:pin")

  if view.doc then
    items[#items + 1] = DIVIDER
    add("Split Right", "tab:split-right")
    add("Split & Move", nil, {
      get_submenu = function() return split_move_submenu(view) end,
    })
    items[#items + 1] = DIVIDER
    add("Move into New Window", "tab:move-new-window")
    add("Copy into New Window", "tab:copy-new-window")
  end

  return items
end


command.add(nil, {
  ["tab:close"] = function()
    command.perform("root:close")
  end,
  ["tab:close-others"] = function()
    local node, view = active_tab()
    if node then close_views(node, views_except(node, view)) end
  end,
  ["tab:close-right"] = function()
    local node, view = active_tab()
    if node then close_views(node, views_to_right(node, view)) end
  end,
  ["tab:close-saved"] = function()
    local node = select(1, active_tab())
    if node then close_views(node, views_saved(node)) end
  end,
  ["tab:close-all"] = function()
    local node = select(1, active_tab())
    if node then close_views(node, views_all(node)) end
  end,
  ["tab:keep-open"] = function()
    local _, view = active_tab()
    if not view then return end
    view.tab_kept_open = not view.tab_kept_open
    core.status_view:show_message("i", style.text,
      "Keep Open: " .. (view.tab_kept_open and "On" or "Off"))
    core.redraw = true
  end,
  ["tab:pin"] = function()
    local _, view = active_tab()
    if not view then return end
    view.tab_pinned = not view.tab_pinned
    core.status_view:show_message("i", style.text,
      "Pin: " .. (view.tab_pinned and "On" or "Off"))
    core.redraw = true
  end,
})


command.add(doc_view, {
  ["tab:copy-path"] = function(view)
    local path = view.doc.abs_filename or view.doc.filename
    if path then
      system.set_clipboard(path)
      core.status_view:show_message("i", style.text, "Copied path")
    end
  end,
  ["tab:copy-relative-path"] = function(view)
    local path = view.doc.abs_filename or view.doc.filename
    if not path then return end
    local project = core.root_project()
    if project and project.path then
      local prefix = project.path .. PATHSEP
      if path:sub(1, #prefix) == prefix then
        path = path:sub(#prefix + 1)
      end
    end
    system.set_clipboard(path)
    core.status_view:show_message("i", style.text, "Copied relative path")
  end,
  ["tab:reveal-file"] = function(view)
    local path = view.doc.abs_filename
    if path then reveal_in_file_manager(path) end
  end,
  ["tab:reveal-in-explorer"] = function(view)
    local path = view.doc.abs_filename
    if path then reveal_in_explorer(path) end
  end,
  ["tab:split-right"] = function(view)
    command.perform("root:split-right")
  end,
  ["tab:move-new-window"] = function(view)
    open_new_window(view, true)
  end,
  ["tab:copy-new-window"] = function(view)
    open_new_window(view, false)
  end,
})


keymap.add({
  ["ctrl+f4"] = "tab:close",
  ["shift+alt+c"] = "tab:copy-path",
  ["shift+alt+r"] = "tab:reveal-file",
})

-- Keep the existing treeview toggle fallback when the tree is focused.
keymap.add({
  ["ctrl+\\"] = "tab:split-right",
})


local old_on_mouse_pressed = RootView.on_mouse_pressed
function RootView:on_mouse_pressed(button, x, y, clicks)
  if button == "right" and not self.context_menu.visible then
    local node = self.root_node:get_child_overlapping_point(x, y)
    local index = node and node:get_tab_overlapping_point(x, y)
    if index then
      local view = node.views[index]
      if view then
        node:set_active_view(view)
        if self.context_menu:show(x, y, build_tab_menu(view)) then
          return true
        end
      end
    end
  end
  return old_on_mouse_pressed(self, button, x, y, clicks)
end


return {}
