-- mod-version:4
local core = require "core"
local common = require "core.common"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"
local style = require "core.style"
local View = require "core.view"
local ContextMenu = require "core.contextmenu"
local RootView = require "core.rootview"
local CommandView = require "core.commandview"
local DocView = require "core.docview"
local Dirwatch = require "core.dirwatch"

config.plugins.treeview = common.merge({
  -- Default treeview width
  size = 200 * SCALE,
  highlight_focused_file = true,
  expand_dirs_to_focused_file = false,
  scroll_to_focused_file = false,
  animate_scroll_to_focused_file = true,
  show_hidden = false,
  show_ignored = true,
  show_header = true,
  visible = true
}, config.plugins.treeview)

local tooltip_offset = style.font:get_height()
local tooltip_border = 1
local tooltip_delay = 0.5
local tooltip_alpha = 255
local tooltip_alpha_rate = 1

local ICON_NEW_FILE = "\u{ea7f}"
local ICON_NEW_FOLDER = "\u{ea80}"
local ICON_REFRESH = "\u{eb37}"
local ICON_COLLAPSE_ALL = "\u{eac5}"


local function get_depth(filename)
  if filename == "" then return 0 end
  local n = 1
  for _ in filename:gmatch(PATHSEP) do
    n = n + 1
  end
  return n
end


local function replace_alpha(color, alpha)
  local r, g, b = table.unpack(color)
  return { r, g, b, alpha }
end


local TreeView = View:extend()

function TreeView:__tostring() return "TreeView" end

function TreeView:new()
  TreeView.super.new(self)
  self.scrollable = true
  self.visible = config.plugins.treeview.visible
  self.init_size = true
  self.target_size = config.plugins.treeview.size
  self.show_hidden = config.plugins.treeview.show_hidden
  self.show_ignored = config.plugins.treeview.show_ignored
  self.cache = {}
  self.expanded = {}
  self.tooltip = { x = 0, y = 0, begin = 0, alpha = 0 }
  self.last_scroll_y = 0

  self.item_icon_width = 0
  self.item_text_spacing = 0
  self.watches = { }
  self.header_hovered = nil
  self.header_tooltip = false
  self.header_items = {
    { symbol = ICON_NEW_FILE, command = "treeview:new-file-at-root", label = "New File" },
    { symbol = ICON_NEW_FOLDER, command = "treeview:new-folder-at-root", label = "New Folder" },
    { symbol = ICON_REFRESH, command = "treeview:refresh", label = "Refresh Explorer" },
    { symbol = ICON_COLLAPSE_ALL, command = "treeview:collapse-all", label = "Collapse All" },
  }
end


function TreeView:set_target_size(axis, value)
  if axis == "x" then
    self.target_size = value
    return true
  end
end


function TreeView:get_header_height()
  if config.plugins.treeview.show_header == false then return 0 end
  return style.codicon_font:get_height() + style.padding.y * 2
end


function TreeView:each_header_item()
  local font = style.codicon_font
  local icon_w = font:get_width("\u{ea7f}")
  local item_pad = style.padding.x / 4
  local item_w = icon_w + item_pad * 2
  local total_w = item_w * #self.header_items
  local x = self.position.x + self.size.x - style.scrollbar_size
    - style.padding.x / 2 - total_w
  local y = self.position.y
  local h = self:get_header_height()
  local index = 0
  return function()
    index = index + 1
    if index <= #self.header_items then
      return self.header_items[index], x + item_w * (index - 1), y, item_w, h
    end
  end
end


function TreeView:get_header_button_at(px, py)
  if self:get_header_height() == 0 then return nil end
  for item, x, y, w, h in self:each_header_item() do
    if px >= x and py >= y and px <= x + w and py <= y + h then
      return item
    end
  end
end


function TreeView:draw_header()
  local h = self:get_header_height()
  if h == 0 then return end
  local x, y, w = self.position.x, self.position.y, self.size.x
  renderer.draw_rect(x, y, w, h, style.background2)

  local iter = self:each_header_item()
  local _, first_x = iter()
  local title = "EXPLORER"
  local title_x = x + style.padding.x
  if first_x and title_x + style.font:get_width(title) + style.padding.x <= first_x then
    common.draw_text(style.font, style.dim, title, nil, title_x, y, 0, h)
  end

  local font = style.codicon_font
  for item, ix, iy, iw, ih in self:each_header_item() do
    if item == self.header_hovered then
      renderer.draw_rect(ix + 1, iy + 2, iw - 2, ih - 4, style.line_highlight)
    end
    local color = item == self.header_hovered and command.is_valid(item.command)
      and style.text or style.dim
    common.draw_text(font, color, item.symbol, "center", ix, iy, iw, ih)
  end

  renderer.draw_rect(x, y + h - style.divider_size, w, style.divider_size, style.divider)
end


function TreeView:get_content_offset()
  local x, y = TreeView.super.get_content_offset(self)
  return x, y + self:get_header_height()
end



function TreeView:get_cached(project, path)
  local t = self.cache[path]
  if not t then
    if not self.watches[project] then self.watches[project] = Dirwatch.new() end
    local truncated = path:sub(#project.path + 2)
    local basename = common.basename(path)
    local info
    if self.show_ignored then
      info = system.get_file_info(path)
    else
      info = project:get_file_info(path)
    end
    if not info then return nil end
    t = {
      filename = basename,
      depth = get_depth(truncated),
      abs_filename = path,
      project = project,
      name = basename,
      type = info.type,
      project = project,
      ignored = self.show_ignored and project:is_ignored(info, path)
    }
    if self.expanded[path] ~= nil then 
      t.expanded = self.expanded[path]
    else 
      t.expanded = (info.type == "dir" and #truncated <= 1) 
    end
    if t.expanded then self.watches[project]:watch(path) end
    self.cache[path] = t
  end
  if t.expanded and t.type == "dir" and not t.files then
    t.files = {}
    for i, file in ipairs(system.list_dir(path)) do
      local l = path .. PATHSEP .. file
      local f
      if self.show_ignored then
        f = system.get_file_info(l)
      else
        f = project:get_file_info(l)
      end
      if f and f.type then
        f.name = file
        f.abs_filename = l
        f.ignored = self.show_ignored and project:is_ignored(f, l)
        table.insert(t.files, f)
      end
      self.cache[l] = nil
    end
    table.sort(t.files, function(a, b) return system.path_compare(a.name, a.type, b.name, b.type) end)
  end
  return t
end


function TreeView:get_name()
  return nil
end


function TreeView:get_item_height()
  return style.font:get_height() + style.padding.y
end


function TreeView:get_items(project, path, x, y, w, h)
  local dir = self:get_cached(project, path)
  coroutine.yield(dir, x, y, w, h)
  local count_lines = 1
  if dir and dir.files and dir.expanded then
    for i, file in ipairs(dir.files) do
      if self.show_hidden or not file.name:find("^%.") then
        count_lines = count_lines + self:get_items(project, path .. PATHSEP .. file.name, x, y + count_lines * h, w, h)
      end
    end
  end
  return count_lines
end


function TreeView:each_item()
  return coroutine.wrap(function()
    local count_lines = 0
    local ox, oy = self:get_content_offset()
    local h = self:get_item_height()
    for k, project in ipairs(core.projects) do
      count_lines = count_lines + self:get_items(project, project.path, ox, oy + style.padding.y + h * count_lines, self.size.x, h)
    end
    self.count_lines = count_lines
  end)
end


function TreeView:set_selection(selection, selection_y, center, instant)
  self.selected_item = selection
  if selection and selection_y
      and (selection_y <= 0 or selection_y >= self.size.y) then
    local lh = self:get_item_height()
    if not center and selection_y >= self.size.y - lh then
      selection_y = selection_y - self.size.y + lh
    end
    if center then
      selection_y = selection_y - (self.size.y - lh) / 2
    end
    local _, y = self:get_content_offset()
    self.scroll.to.y = selection_y - y
    self.scroll.to.y = common.clamp(self.scroll.to.y, 0, self:get_scrollable_size() - self.size.y)
    if instant then
      self.scroll.y = self.scroll.to.y
    end
  end
end

---Sets the selection to the file with the specified path.
---
---@param path string #Absolute path of item to select
---@param expand boolean #Expand dirs leading to the item
---@param scroll_to boolean #Scroll to make the item visible
---@param instant boolean #Don't animate the scroll
---@return table? #The selected item
function TreeView:set_selection_to_path(path, expand, scroll_to, instant)
  local to_select, to_select_y
  local let_it_finish, done
  ::restart::
  for item, x,y,w,h in self:each_item() do
    if not done then
      if item.type == "dir" then
        local _, to = string.find(path, item.abs_filename..PATHSEP, 1, true)
        if to and to == #item.abs_filename + #PATHSEP then
          to_select, to_select_y = item, y
          if expand and not item.expanded then
            -- Use TreeView:toggle_expand to update the directory structure.
            -- Directly using item.expanded doesn't update the cached tree.
            self:toggle_expand(true, item)
            -- Because we altered the size of the TreeView
            -- and because TreeView:get_scrollable_size uses self.count_lines
            -- which gets updated only when TreeView:each_item finishes,
            -- we can't stop here or we risk that the scroll
            -- gets clamped by View:clamp_scroll_position.
            let_it_finish = true
            -- We need to restart the process because if TreeView:toggle_expand
            -- altered the cache, TreeView:each_item risks looping indefinitely.
            goto restart
          end
        end
      else
        if item.abs_filename == path then
          to_select, to_select_y = item, y
          done = true
          if not let_it_finish then break end
        end
      end
    end
  end
  if to_select then
    self:set_selection(to_select, scroll_to and to_select_y, true, instant)
  end
  return to_select
end


function TreeView:get_text_bounding_box(item, x, y, w, h)
  local icon_width = style.codicon_font:get_width("\u{eaf7}")
  local xoffset = item.depth * style.padding.x + style.padding.x + icon_width
  x = x + xoffset
  w = style.font:get_width(item.name) + 2 * style.padding.x
  return x, y, w, h
end



function TreeView:on_mouse_moved(px, py, ...)
  if not self.visible then return end
  if TreeView.super.on_mouse_moved(self, px, py, ...) then
    -- mouse movement handled by the View (scrollbar)
    self.hovered_item = nil
    self.header_hovered = nil
    if self.header_tooltip then
      core.status_view:remove_tooltip()
      self.header_tooltip = false
    end
    return
  end

  local header_item = self:get_header_button_at(px, py)
  if header_item then
    self.hovered_item = nil
    self.header_hovered = header_item
    local binding = keymap.get_binding(header_item.command)
    core.status_view:show_tooltip(binding and
      { header_item.label, style.dim, "  ", binding } or { header_item.label })
    self.header_tooltip = true
    return
  end
  self.header_hovered = nil
  if self.header_tooltip then
    core.status_view:remove_tooltip()
    self.header_tooltip = false
  end

  local item_changed, tooltip_changed
  for item, x,y,w,h in self:each_item() do
    if px > x and py > y and px <= x + w and py <= y + h then
      item_changed = true
      self.hovered_item = item

      x,y,w,h = self:get_text_bounding_box(item, x,y,w,h)
      if px > x and py > y and px <= x + w and py <= y + h then
        tooltip_changed = true
        self.tooltip.x, self.tooltip.y = px, py
        self.tooltip.begin = system.get_time()
      end
      break
    end
  end
  if not item_changed then self.hovered_item = nil end
  if not tooltip_changed then self.tooltip.x, self.tooltip.y = nil, nil end
end


function TreeView:on_mouse_pressed(button, x, y, clicks)
  if TreeView.super.on_mouse_pressed(self, button, x, y, clicks) then
    return true
  end
  if button == "left" then
    local item = self:get_header_button_at(x, y)
    if item then
      if command.is_valid(item.command) then
        command.perform(item.command)
      end
      return true
    end
  end
end


function TreeView:on_mouse_left()
  TreeView.super.on_mouse_left(self)
  self.hovered_item = nil
  self.header_hovered = nil
  if self.header_tooltip then
    core.status_view:remove_tooltip()
    self.header_tooltip = false
  end
end


function TreeView:update()
  -- update width
  local dest = self.visible and self.target_size or 0
  if self.init_size then
    self.size.x = dest
    self.init_size = false
  else
    self:move_towards(self.size, "x", dest, nil, "treeview")
  end

  if self.size.x == 0 or self.size.y == 0 or not self.visible then return end

  local duration = system.get_time() - self.tooltip.begin
  if self.hovered_item and self.tooltip.x and duration > tooltip_delay then
    self:move_towards(self.tooltip, "alpha", tooltip_alpha, tooltip_alpha_rate, "treeview")
  else
    self.tooltip.alpha = 0
  end

  self.item_icon_width = style.codicon_font:get_width("\u{eaf7}")
  self.item_text_spacing = style.codicon_font:get_width("\u{ea7b}") / 2

  -- this will make sure hovered_item is updated
  local dy = math.abs(self.last_scroll_y - self.scroll.y)
  if dy > 0 then
    self:on_mouse_moved(core.root_view.mouse.x, core.root_view.mouse.y, 0, 0)
    self.last_scroll_y = self.scroll.y
  end

  local config = config.plugins.treeview
  if config.highlight_focused_file then
    -- Try to only highlight when we actually change tabs
    local current_node = core.root_view:get_active_node()
    local current_active_view = core.active_view
    if current_node and not current_node.locked
     and current_active_view ~= self and current_active_view ~= self.last_active_view then
      self.selected_item = nil
      self.last_active_view = current_active_view
      if DocView:is_extended_by(current_active_view) then
        local abs_filename = current_active_view.doc
                             and current_active_view.doc.abs_filename or ""
        self:set_selection_to_path(abs_filename,
                                   config.expand_dirs_to_focused_file,
                                   config.scroll_to_focused_file,
                                   not config.animate_scroll_to_focused_file)
      end
    end
  end

  TreeView.super.update(self)
end


function TreeView:get_scrollable_size()
  return (self.count_lines and self:get_item_height() * (self.count_lines + 1) or math.huge)
    + self:get_header_height()
end


function TreeView:draw_tooltip()
  local text = common.home_encode(self.hovered_item.abs_filename)
  local w, h = style.font:get_width(text), style.font:get_height(text)

  local x, y = self.tooltip.x + tooltip_offset, self.tooltip.y + tooltip_offset
  w, h = w + style.padding.x, h + style.padding.y

  if x + w > core.root_view.root_node.size.x then -- check if we can span right
    x = x - w -- span left instead
  end

  local bx, by = x - tooltip_border, y - tooltip_border
  local bw, bh = w + 2 * tooltip_border, h + 2 * tooltip_border
  renderer.draw_rect(bx, by, bw, bh, replace_alpha(style.text, self.tooltip.alpha))
  renderer.draw_rect(x, y, w, h, replace_alpha(style.background2, self.tooltip.alpha))
  common.draw_text(style.font, replace_alpha(style.text, self.tooltip.alpha), text, "center", x, y, w, h)
end


function TreeView:get_item_icon(item, active, hovered)
  local character = "\u{ea7b}"
  if item.type == "dir" then
    character = item.expanded and "\u{eaf7}" or "\u{ea83}"
  end
  local font = style.codicon_font
  local color = style.text
  if active or hovered then
    color = style.accent
  elseif item.ignored then
    color = style.dim
  end
  return character, font, color
end

function TreeView:get_item_text(item, active, hovered)
  local text = item.name
  local font = style.font
  local color = style.text
  if active or hovered then
    color = style.accent
  elseif item.ignored then
    color = style.dim
  end
  return text, font, color
end


function TreeView:draw_item_text(item, active, hovered, x, y, w, h)
  local item_text, item_font, item_color = self:get_item_text(item, active, hovered)
  common.draw_text(item_font, item_color, item_text, nil, x, y, 0, h)
end


function TreeView:draw_item_icon(item, active, hovered, x, y, w, h)
  local icon_char, icon_font, icon_color = self:get_item_icon(item, active, hovered)
  common.draw_text(icon_font, icon_color, icon_char, nil, x, y, 0, h)
  return self.item_icon_width + self.item_text_spacing
end


function TreeView:draw_item_body(item, active, hovered, x, y, w, h)
    x = x + self:draw_item_icon(item, active, hovered, x, y, w, h)
    self:draw_item_text(item, active, hovered, x, y, w, h)
end


function TreeView:draw_item_chevron(item, active, hovered, x, y, w, h)
  if item.type == "dir" then
    local chevron_icon = item.expanded and "\u{eab4}" or "\u{eab6}"
    local chevron_color = hovered and style.accent or style.text
    common.draw_text(style.codicon_font, chevron_color, chevron_icon, nil, x, y, 0, h)
  end
  return style.padding.x
end


function TreeView:draw_item_background(item, active, hovered, x, y, w, h)
  if hovered then
    local hover_color = { table.unpack(style.line_highlight) }
    hover_color[4] = 160
    renderer.draw_rect(x, y, w, h, hover_color)
  elseif active then
    renderer.draw_rect(x, y, w, h, style.line_highlight)
  end
end


function TreeView:draw_item(item, active, hovered, x, y, w, h)
  self:draw_item_background(item, active, hovered, x, y, w, h)

  x = x + item.depth * style.padding.x + style.padding.x
  x = x + self:draw_item_chevron(item, active, hovered, x, y, w, h)

  self:draw_item_body(item, active, hovered, x, y, w, h)
end


function TreeView:draw()
  if not self.visible then return end
  self:draw_background(style.background2)
  local _y, _h = self.position.y, self.size.y

  for item, x,y,w,h in self:each_item() do
    if y + h >= _y and y < _y + _h then
      self:draw_item(item,
        item == self.selected_item,
        item == self.hovered_item,
        x, y, w, h)
    end
  end

  self:draw_scrollbar()
  self:draw_header()
  if self.hovered_item and self.tooltip.x and self.tooltip.alpha > 0 then
    core.root_view:defer_draw(self.draw_tooltip, self)
  end
end


function TreeView:get_parent(item)
  local parent_path = common.dirname(item.abs_filename)
  if not parent_path then return end
  for it, _, y in self:each_item() do
    if it.abs_filename == parent_path then
      return it, y
    end
  end
end


function TreeView:get_item(item, where)
  local last_item, last_x, last_y, last_w, last_h
  local stop = false

  for it, x, y, w, h in self:each_item() do
    if not item and where >= 0 then
      return it, x, y, w, h
    end
    if item == it then
      if where < 0 and last_item then
        break
      elseif where == 0 or (where < 0 and not last_item) then
        return it, x, y, w, h
      end
      stop = true
    elseif stop then
      item = it
      return it, x, y, w, h
    end
    last_item, last_x, last_y, last_w, last_h = it, x, y, w, h
  end
  return last_item, last_x, last_y, last_w, last_h
end

function TreeView:get_next(item)
  return self:get_item(item, 1)
end

function TreeView:get_previous(item)
  return self:get_item(item, -1)
end


function TreeView:toggle_expand(toggle, item)
  item = item or self.selected_item

  if not item then return end

  if item.type == "dir" then
    if type(toggle) == "boolean" then
      item.expanded = toggle
    else
      item.expanded = not item.expanded
    end
    self.expanded[item.abs_filename] = item.expanded
    if self.watches[item.project] then
      self.watches[item.project]:watch(item.abs_filename, item.expanded)
    end
  end
end

function TreeView:open_doc(filename)
  core.root_view:open_doc(core.open_doc(filename))
end

-- init
local view = TreeView()
local node = core.root_view:get_active_node()
view.node = node:split("left", view, {x = true}, true)

-- A vertical activity bar on the far left of the sidebar, similar to
-- VS Code. It hosts the common explorer and application actions.
local activity_view = nil
local activity_plugin, ActivityBar = pcall(require, "plugins.activitybar")
if config.plugins.activitybar ~= false and activity_plugin then
  activity_view = ActivityBar()
  view.node:split("left", activity_view, {x = true})
  command.add(nil, {
    ["activitybar:toggle"] = function()
      activity_view:toggle_visible()
    end,
  })
end

view:set_target_size("x", config.plugins.treeview.size)


local function new_path_at_root(kind)
  local project = core.root_project()
  local label = kind == "file" and "Filename" or "Folder Name"
  core.command_view:enter(label, {
    text = "",
    submit = function(filename)
      if filename == "" then return end
      local path = project:absolute_path(filename)
      if kind == "file" then
        local file, err = io.open(path, "a+")
        if not file then
          core.error("Error: unable to create a new file in \"%s\": %s", path, err)
          return
        end
        file:close()
        view:open_doc(path)
        core.log("Created %s", path)
      else
        local ok, err = common.mkdirp(path)
        if not ok then
          core.error("Error: unable to create folder \"%s\": %s", path, err)
          return
        end
        core.log("Created %s", path)
      end
    end,
    suggest = function(text)
      return common.path_suggest(text, project.path)
    end,
  })
end


command.add(nil, {
  ["treeview:show"] = function()
    view.visible = true
  end,

  ["treeview:hide"] = function()
    view.visible = false
  end,

  ["treeview:new-file-at-root"] = function()
    new_path_at_root("file")
  end,

  ["treeview:new-folder-at-root"] = function()
    new_path_at_root("folder")
  end,

  ["treeview:collapse-all"] = function()
    view.expanded = {}
    view.cache = {}
    view.selected_item = nil
    core.redraw = true
  end,

  ["treeview:refresh"] = function()
    view.cache = {}
    view.selected_item = nil
    core.redraw = true
  end,
})


local old_remove_project = core.remove_project
function core.remove_project(project, force)
  local project = old_remove_project(project, force)
  view.cache = {}
  view.watches[project] = nil
end

core.add_thread(function()
  while true do
    for k,v in pairs(view.watches) do
      v:check(function(directory)
        view.cache[directory] = nil
      end)
    end
    coroutine.yield(0.01)
  end
end)

local on_quit_project = core.on_quit_project
function core.on_quit_project()
  view.cache = {}
  on_quit_project()
end

local function is_project_folder(item)
  return item.abs_filename == item.project.path
end

local function is_primary_project_folder(path)
  return core.root_project().path == path
end


local function treeitem() return view.hovered_item or view.selected_item end

local file_clipboard = nil

local function valid_item(active_view)
  local item = treeitem()
  return item ~= nil and (active_view or core.active_view) == view, item
end

local function movable_item(active_view)
  local item = treeitem()
  return item ~= nil and not is_project_folder(item)
    and (active_view or core.active_view) == view, item
end

local function paste_item(active_view)
  local item = treeitem()
  return item ~= nil and file_clipboard ~= nil
    and (active_view or core.active_view) == view, item
end

local function add_project_item(active_view)
  local item = treeitem()
  return item ~= nil and item.type == "dir" and not is_project_folder(item)
    and (active_view or core.active_view) == view, item
end

local function path_is_inside(path, parent)
  return path == parent or path:sub(1, #parent + 1) == parent .. PATHSEP
end

local function base_name(path)
  return path:match("([^/\\]+)$") or path
end

local function dir_name(path)
  return path:match("^(.*)[/\\][^/\\]+$")
end

local function unique_destination(path)
  if not system.get_file_info(path) then return path end
  local dir, name = dir_name(path), base_name(path)
  local base, ext = name:match("^(.*)(%.[^%.]+)$")
  if not base then base, ext = name, "" end
  local index = 1
  while true do
    local suffix = index == 1 and " copy" or " copy " .. index
    local candidate = dir .. PATHSEP .. base .. suffix .. ext
    if not system.get_file_info(candidate) then return candidate end
    index = index + 1
  end
end

local function copy_path(src, dst)
  local info = system.get_file_info(src)
  if not info then return false, "source not found" end
  if info.type == "dir" then
    local ok, err = common.mkdirp(dst)
    if not ok then return false, err end
    for _, name in ipairs(system.list_dir(src) or {}) do
      local copied, copy_err = copy_path(src .. PATHSEP .. name, dst .. PATHSEP .. name)
      if not copied then return false, copy_err end
    end
  else
    local input, err = io.open(src, "rb")
    if not input then return false, err end
    local data = input:read("*a")
    input:close()
    local output, open_err = io.open(dst, "wb")
    if not output then return false, open_err end
    output:write(data)
    output:close()
  end
  return true
end

local function move_path(src, dst)
  local renamed = os.rename(src, dst)
  if renamed then return true end
  local copied, err = copy_path(src, dst)
  if not copied then return false, err end
  local removed, remove_err = common.rm(src, true)
  if not removed then return false, remove_err end
  return true
end

local function update_open_docs(src, dst)
  for _, doc in ipairs(core.docs) do
    local filename = doc.abs_filename
    if filename then
      if filename == src then
        doc:set_filename(core.normalize_to_project_dir(dst), dst)
      elseif filename:sub(1, #src + 1) == src .. PATHSEP then
        local new_abs = dst .. filename:sub(#src + 1)
        doc:set_filename(core.normalize_to_project_dir(new_abs), new_abs)
      end
    end
  end
end

local function paste_into(item)
  if not file_clipboard then return end
  local target = item.type == "dir" and item.abs_filename or common.dirname(item.abs_filename)
  local mode = file_clipboard.mode
  for _, src in ipairs(file_clipboard.items) do
    if not path_is_inside(target, src) then
      if not (mode == "cut" and target == dir_name(src)) then
        local dst = unique_destination(target .. PATHSEP .. base_name(src))
        local ok, err
        if mode == "cut" then
          ok, err = move_path(src, dst)
          if ok then update_open_docs(src, dst) end
        else
          ok, err = copy_path(src, dst)
        end
        if not ok then
          core.error("Error: %s", tostring(err))
        end
      end
    end
  end
  if mode == "cut" then file_clipboard = nil end
  view.cache = {}
  view.selected_item = nil
  view.hovered_item = nil
  view.expanded[target] = true
  core.redraw = true
end

local function reveal_in_file_manager(path)
  if PLATFORM == "Windows" then
    system.exec(string.format('explorer /select,%s',
      common.quote_shell_path(path:gsub("/", "\\"))))
  elseif string.find(PLATFORM, "Mac") then
    system.exec("open -R " .. common.quote_shell_path(path))
  elseif PLATFORM == "Linux" or string.find(PLATFORM, "BSD") then
    system.exec("xdg-open " .. common.quote_shell_path(dir_name(path)))
  end
end

local function file_url(path)
  local normalized = path:gsub("\\", "/")
  return "file://" .. (normalized:sub(1, 1) == "/" and "" or "/") .. normalized
end


function TreeView:on_context_menu()
  return { items = {
    { text = "New File...", command = "treeview:new-file" },
    { text = "New Folder...", command = "treeview:new-folder" },
    { text = "Reveal in File Explorer", command = "treeview:reveal-in-file-explorer" },
    { text = "Open in Integrated Terminal", command = "treeview:open-in-terminal" },
    {
      text = "Share",
      get_submenu = function()
        return {
          { text = "Copy Path", command = "treeview:copy-path" },
          { text = "Copy Relative Path", command = "treeview:copy-relative-path" },
          { text = "Copy File URL", command = "treeview:copy-url" },
        }
      end,
    },
    ContextMenu.DIVIDER,
    { text = "Find in Folder...", command = "treeview:search-in-directory" },
    ContextMenu.DIVIDER,
    { text = "Cut", command = "treeview:cut" },
    { text = "Copy", command = "treeview:copy" },
    { text = "Paste", command = "treeview:paste" },
    ContextMenu.DIVIDER,
    { text = "Copy Path", command = "treeview:copy-path" },
    { text = "Copy Relative Path", command = "treeview:copy-relative-path" },
    ContextMenu.DIVIDER,
    { text = "Rename...", command = "treeview:rename" },
    { text = "Delete", command = "treeview:delete" },
    ContextMenu.DIVIDER,
    { text = "Open in System", command = "treeview:open-in-system" },
    { text = "Remove directory", command = "treeview:remove-project-directory" },
    { text = "Add as Project Folder", command = "treeview:add-project-directory" },
  } }, self
end

local projectsearch = pcall(require, "plugins.projectsearch")
if projectsearch then
  command.add(function(active_view)
    local item = treeitem()
    return item and item.type == "dir"
      and (active_view or core.active_view) == view, item
  end, {
    ["treeview:search-in-directory"] = function(item)
      command.perform("project-search:find", item.abs_filename)
    end
  })
end

command.add(valid_item, {
  ["treeview:reveal-in-file-explorer"] = function(item)
    reveal_in_file_manager(item.abs_filename)
  end,
  ["treeview:copy-path"] = function(item)
    system.set_clipboard(item.abs_filename)
    core.status_view:show_message("i", style.text, "Copied path")
  end,
  ["treeview:copy-relative-path"] = function(item)
    system.set_clipboard(core.normalize_to_project_dir(item.abs_filename))
    core.status_view:show_message("i", style.text, "Copied relative path")
  end,
  ["treeview:copy-url"] = function(item)
    system.set_clipboard(file_url(item.abs_filename))
    core.status_view:show_message("i", style.text, "Copied file URL")
  end,
})

command.add(function(active_view)
  local item = treeitem()
  return item and command.map["terminal:open-at"]
    and (active_view or core.active_view) == view, item
end, {
  ["treeview:open-in-terminal"] = function(item)
    local cwd = item.type == "dir" and item.abs_filename or dir_name(item.abs_filename)
    command.perform("terminal:open-at", cwd)
  end,
})

command.add(movable_item, {
  ["treeview:cut"] = function(item)
    file_clipboard = { mode = "cut", items = { item.abs_filename } }
    core.status_view:show_message("i", style.text,
      "Cut: " .. base_name(item.abs_filename))
    core.redraw = true
  end,
  ["treeview:copy"] = function(item)
    file_clipboard = { mode = "copy", items = { item.abs_filename } }
    core.status_view:show_message("i", style.text,
      "Copied: " .. base_name(item.abs_filename))
    core.redraw = true
  end,
})

command.add(paste_item, {
  ["treeview:paste"] = function(item)
    paste_into(item)
  end,
})

command.add(add_project_item, {
  ["treeview:add-project-directory"] = function(item)
    core.add_project(item.abs_filename)
    view.cache = {}
    core.redraw = true
  end,
})

command.add(function()
  local item = treeitem()
  return item and not is_project_folder(item) and core.active_view == view, item
end, {
  ["treeview:delete"] = function(item)
    local filename = item.abs_filename
    local relfilename = item.filename
    if item.project ~= core.root_project() then
      -- add secondary project dirs names to the file path to show
      relfilename = common.basename(item.abs_filename) .. PATHSEP .. relfilename
    end
    local file_info = system.get_file_info(filename)
    local file_type = file_info.type == "dir" and "Directory" or "File"
    -- Ask before deleting
    local opt = {
      { text = "Yes", default_yes = true },
      { text = "No", default_no = true }
    }
    core.nag_view:show(
      string.format("Delete %s", file_type),
      string.format(
        "Are you sure you want to delete the %s?\n%s: %s",
        file_type:lower(), file_type, relfilename
      ),
      opt,
      function(item)
        if item.text == "Yes" then
          if file_info.type == "dir" then
            local deleted, error, path = common.rm(filename, true)
            if not deleted then
              core.error("Error: %s - \"%s\" ", error, path)
              return
            end
          else
            local removed, error = os.remove(filename)
            if not removed then
              core.error("Error: %s - \"%s\"", error, filename)
              return
            end
          end
          core.log("Deleted \"%s\"", filename)
        end
      end
    )
  end,

  ["treeview:rename"] = function(item)
    local old_filename = core.normalize_to_project_dir(item.abs_filename)
    local old_abs_filename = item.abs_filename
    core.command_view:enter("Rename", {
      text = old_filename,
      submit = function(filename)
        local abs_filename = item.project:absolute_path(filename)
        local res, err = os.rename(old_abs_filename, abs_filename)
        if res then -- successfully renamed
          for _, doc in ipairs(core.docs) do
            if doc.abs_filename and old_abs_filename == doc.abs_filename then
              doc:set_filename(filename, abs_filename) -- make doc point to the new filename
              doc:reset_syntax()
              break -- only first needed
            end
          end
          core.log("Renamed \"%s\" to \"%s\"", old_filename, filename)
        else
          core.error("Error while renaming \"%s\" to \"%s\": %s", old_abs_filename, abs_filename, err)
        end
      end,
      suggest = function(text)
        return common.path_suggest(text, item.project and item.project.path)
      end
    })
  end
})

local previous_view = nil

-- Register the TreeView commands and keymap
command.add(nil, {
  ["treeview:toggle"] = function()
    view.visible = not view.visible
  end,

  ["treeview:toggle-hidden"] = function()
    view.show_hidden = not view.show_hidden
    view.cache = {}
  end,

  ["treeview:toggle-ignored"] = function()
    view.show_ignored = not view.show_ignored
    view.cache = {}
  end,

  ["treeview:toggle-focus"] = function()
    if not core.active_view:is(TreeView) then
      if core.active_view:is(CommandView) then
        previous_view = core.last_active_view
      else
        previous_view = core.active_view
      end
      if not previous_view then
        previous_view = core.root_view:get_primary_node().active_view
      end
      core.set_active_view(view)
      if not view.selected_item then
        for it, _, y in view:each_item() do
          view:set_selection(it, y)
          break
        end
      end

    else
      core.set_active_view(
        previous_view or core.root_view:get_primary_node().active_view
      )
    end
  end
})

command.add(TreeView, {
  ["treeview:next"] = function()
    local item, _, item_y = view:get_next(view.selected_item)
    view:set_selection(item, item_y)
  end,

  ["treeview:previous"] = function()
    local item, _, item_y = view:get_previous(view.selected_item)
    view:set_selection(item, item_y)
  end,

  ["treeview:open"] = function()
    local item = view.selected_item
    if not item then return end
    if item.type == "dir" then
      view:toggle_expand()
    else
      core.try(function()
        if core.last_active_view and core.active_view == view then
          core.set_active_view(core.last_active_view)
        end
        view:open_doc(core.normalize_to_project_dir(item.abs_filename))
      end)
    end
  end,

  ["treeview:deselect"] = function()
    view.selected_item = nil
  end,

  ["treeview:select"] = function()
    view:set_selection(view.hovered_item)
  end,

  ["treeview:select-and-open"] = function()
    if view.hovered_item then
      view:set_selection(view.hovered_item)
      command.perform "treeview:open"
    end
  end,

  ["treeview:collapse"] = function()
    if view.selected_item then
      if view.selected_item.type == "dir" and view.selected_item.expanded then
        view:toggle_expand(false)
      else
        local parent_item, y = view:get_parent(view.selected_item)
        if parent_item then
          view:set_selection(parent_item, y)
        end
      end
    end
  end,

  ["treeview:expand"] = function()
    local item = view.selected_item
    if not item or item.type ~= "dir" then return end

    if item.expanded then
      local next_item, _, next_y = view:get_next(item)
      if next_item.depth > item.depth then
        view:set_selection(next_item, next_y)
      end
    else
      view:toggle_expand(true)
    end
  end,
})


command.add(
  function(active_view)
    local item = treeitem()
    return item ~= nil and (active_view or core.active_view) == view, item
  end, {

  ["treeview:new-file"] = function(item)
    local text
    if not is_project_folder(item) then
      if item.type == "dir" then
        text = item.project:normalize_path(item.abs_filename) .. PATHSEP
      elseif item.type == "file" then
        text = item.project:normalize_path(common.dirname(item.abs_filename)) .. PATHSEP
      end
    end
    core.command_view:enter("Filename", {
      text = text,
      submit = function(filename)
        local doc_filename = item.project:absolute_path(filename)
        local file, err = io.open(doc_filename, "a+")
        if not file then
          core.error("Error: unable to create a new file in \"%s\": %s", doc_filename, err)
          return
        end
        file:close()
        view:open_doc(doc_filename)
        core.log("Created %s", doc_filename)
      end,
      suggest = function(text)
        return common.path_suggest(text, item.project and item.project.path)
      end
    })
  end,

  ["treeview:new-folder"] = function(item)
    local text
    if not is_project_folder(item) then
      if item.type == "dir" then
        text = item.project:normalize_path(item.abs_filename) .. PATHSEP
      elseif item.type == "file" then
        text = item.project:normalize_path(common.dirname(item.abs_filename)) .. PATHSEP
      end
    end
    core.command_view:enter("Folder Name", {
      text = text,
      submit = function(filename)
        local dir_path = item.project:absolute_path(filename)
        common.mkdirp(dir_path)
        core.log("Created %s", dir_path)
      end,
      suggest = function(text)
        return common.path_suggest(text, item.project and item.project.path)
      end
    })
  end,

  ["treeview:open-in-system"] = function(item)
    if PLATFORM == "Windows" then
      system.exec('start "" ' .. common.quote_shell_path(item.abs_filename))
    elseif string.find(PLATFORM, "Mac") then
      system.exec("open " .. common.quote_shell_path(item.abs_filename))
    elseif PLATFORM == "Linux" or string.find(PLATFORM, "BSD") then
      system.exec("xdg-open " .. common.quote_shell_path(item.abs_filename))
    end
  end
})

command.add(function()
    local item = treeitem()
    return item
      and not is_primary_project_folder(item.abs_filename)
      and is_project_folder(item), item
  end, {
  ["treeview:remove-project-directory"] = function(item)
    core.remove_project(item.project)
  end,
})



keymap.add {
  ["ctrl+\\"]     = "treeview:toggle",
  ["ctrl+h"]      = "treeview:toggle-hidden",
  ["ctrl+i"]      = "treeview:toggle-ignored",
  ["up"]          = "treeview:previous",
  ["down"]        = "treeview:next",
  ["left"]        = "treeview:collapse",
  ["right"]       = "treeview:expand",
  ["return"]      = "treeview:open",
  ["escape"]      = "treeview:deselect",
  ["delete"]      = "treeview:delete",
  ["f2"]          = "treeview:rename",
  ["ctrl+x"]      = "treeview:cut",
  ["ctrl+c"]      = "treeview:copy",
  ["ctrl+v"]      = "treeview:paste",
  ["shift+alt+f"] = "treeview:search-in-directory",
  ["shift+alt+r"] = "treeview:reveal-in-file-explorer",
  ["shift+alt+c"] = "treeview:copy-path",
  ["ctrl+return"] = "treeview:new-folder",
  ["lclick"]      = "treeview:select-and-open",
  ["mclick"]      = "treeview:select",
  ["ctrl+lclick"] = "treeview:new-folder"
}

-- The config specification used by gui generators
config.plugins.treeview.config_spec = {
  name = "Treeview",
  {
    label = "Size",
    description = "Default treeview width.",
    path = "size",
    type = "number",
    default = 200 * SCALE,
    min = 100 * SCALE,
    get_value = function(value)
      return value / SCALE
    end,
    set_value = function(value)
      return value * SCALE
    end,
    on_apply = function(value)
      view:set_target_size("x", value)
    end
  },
  {
    label = "Hide on Startup",
    description = "Show or hide the treeview on startup.",
    path = "visible",
    type = "toggle",
    default = false,
    on_apply = function(value)
      view.visible = not value
    end
  },
  {
    label = "Show Header",
    description = "Show the Explorer header with file and folder actions.",
    path = "show_header",
    type = "toggle",
    default = true,
    on_apply = function(value)
      core.redraw = true
    end
  }
}

-- Return the treeview with activity bar and contextmenu to allow
-- user or plugin modifications
view.activity_bar = activity_view

return view
