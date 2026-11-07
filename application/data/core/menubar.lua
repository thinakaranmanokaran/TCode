local core = require "core"
local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local View = require "core.view"
local ContextMenu = require "core.contextmenu"

local DIVIDER = ContextMenu.DIVIDER
local BRAND_NAME = "T Code"

local menus = {
  {
    name = "File",
    items = {
      { text = "New File", command = "core:new-doc" },
      { text = "Open File...", command = "core:open-file" },
      { text = "Open Project Folder...", command = "core:open-project-folder" },
      DIVIDER,
      {
        text = "Theme: Bearded Themes (10)",
        get_text = function()
          return (config.theme_category == "bearded" and "* " or "  ")
            .. "Theme: Bearded Themes (10)"
        end,
        get_submenu = function()
          return config.theme_menu and config.theme_menu("bearded") or {}
        end,
      },
      {
        text = "Theme: Monokai Themes (10)",
        get_text = function()
          return (config.theme_category == "monokai" and "* " or "  ")
            .. "Theme: Monokai Themes (10)"
        end,
        get_submenu = function()
          return config.theme_menu and config.theme_menu("monokai") or {}
        end,
      },
      {
        text = "Theme: Default",
        get_text = function()
          return (config.theme == "default" and "* " or "  ") .. "Theme: Default"
        end,
        command = "theme:default",
      },
      DIVIDER,
      { text = "Save", command = "doc:save" },
      { text = "Save As...", command = "doc:save-as" },
      DIVIDER,
      { text = "Close Tab", command = "root:close" },
      { text = "Close All Tabs", command = "root:close-all" },
      { text = "Close Other Tabs", command = "root:close-all-others" },
      { text = "Reopen Closed Tab", command = "root:reopen-closed-tab" },
      DIVIDER,
      { text = "Quit", command = "core:quit" },
    },
  },
  {
    name = "Edit",
    items = {
      { text = "Undo", command = "doc:undo" },
      { text = "Redo", command = "doc:redo" },
      DIVIDER,
      { text = "Cut", command = "doc:cut" },
      { text = "Copy", command = "doc:copy" },
      { text = "Paste", command = "doc:paste" },
      { text = "Select All", command = "doc:select-all" },
      DIVIDER,
      { text = "Find", command = "find-replace:find" },
      { text = "Replace", command = "find-replace:replace" },
      { text = "Toggle Word Wrap", command = "line-wrapping:toggle" },
    },
  },
  {
    name = "Selection",
    items = {
      { text = "Select All", command = "doc:select-all" },
      { text = "Expand Selection", command = "selection:expand" },
      { text = "Shrink Selection", command = "selection:shrink" },
      DIVIDER,
      { text = "Copy Line Up", command = "selection:copy-line-up" },
      { text = "Copy Line Down", command = "selection:copy-line-down" },
      { text = "Move Line Up", command = "doc:move-lines-up" },
      { text = "Move Line Down", command = "doc:move-lines-down" },
      { text = "Duplicate Selection", command = "selection:duplicate" },
      DIVIDER,
      { text = "Add Cursor Above", command = "doc:create-cursor-previous-line" },
      { text = "Add Cursor Below", command = "doc:create-cursor-next-line" },
      { text = "Add Cursors to Line Ends", command = "selection:add-cursors-to-line-ends" },
      { text = "Add Next Occurrence", command = "selection:add-next-occurrence" },
      { text = "Add Previous Occurrence", command = "selection:add-previous-occurrence" },
      { text = "Select All Occurrences", command = "selection:select-all-occurrences" },
      DIVIDER,
      {
        text = "Switch to Ctrl+Click for Multi-Cursor",
        get_text = function()
          local modifier = config.plugins.selection
            and config.plugins.selection.multicursor_modifier or "ctrl"
          return modifier == "ctrl"
            and "Switch to Alt+Click for Multi-Cursor"
            or "Switch to Ctrl+Click for Multi-Cursor"
        end,
        command = "selection:toggle-multicursor-modifier",
      },
      {
        text = "Column Selection Mode",
        get_text = function()
          return "Column Selection Mode: " .. (config.selection_column_mode and "On" or "Off")
        end,
        command = "selection:toggle-column-mode",
      },
    },
  },
  {
    name = "View",
    items = {
      { text = "Toggle Sidebar", command = "treeview:toggle" },
      { text = "Toggle Activity Bar", command = "activitybar:toggle" },
      { text = "Toggle Terminal", command = "terminal:toggle-tab" },
      { text = "Toggle Word Wrap", command = "line-wrapping:toggle" },
      DIVIDER,
      { text = "Toggle Fullscreen", command = "core:toggle-fullscreen" },
      { text = "Zoom In", command = "scale:increase" },
      { text = "Zoom Out", command = "scale:decrease" },
      { text = "Reset Zoom", command = "scale:reset" },
      DIVIDER,
      { text = "Command Palette", command = "core:find-command" },
    },
  },
  {
    name = "Go",
    items = {
      { text = "Go to Line...", command = "doc:go-to-line" },
      { text = "Go to File...", command = "core:find-file" },
      { text = "Find in Project...", command = "project-search:find" },
      DIVIDER,
      { text = "Next Tab", command = "root:switch-to-next-tab" },
      { text = "Previous Tab", command = "root:switch-to-previous-tab" },
      DIVIDER,
      { text = "Reopen Closed Tab", command = "root:reopen-closed-tab" },
    },
  },
  {
    name = "Run",
    items = {
      { text = "Execute in Terminal...", command = "terminal:execute" },
      { text = "Open Terminal", command = "terminal:open-tab" },
      DIVIDER,
      { text = "Find in Project...", command = "project-search:find" },
      { text = "Command Palette", command = "core:find-command" },
    },
  },
  {
    name = "Terminal",
    items = {
      { text = "Toggle Terminal", command = "terminal:toggle-tab" },
      { text = "New Terminal Tab", command = "terminal:open-tab" },
      { text = "Toggle Drawer", command = "terminal:toggle-drawer" },
      { text = "Select Profile...", command = "terminal:select-profile" },
      { text = "Restart Shell", command = "terminal:restart" },
      DIVIDER,
      { text = "Clear", command = "terminal:clear" },
      { text = "Close Terminal", command = "terminal:close-tab" },
    },
  },
  {
    name = "Help",
    items = {
      { text = "About T Code", command = "core:about" },
      { text = "Command Palette", command = "core:find-command" },
      { text = "Show Log", command = "core:open-log" },
      { text = "Open User Module", command = "core:open-user-module" },
      { text = "Open Project Module", command = "core:open-project-module" },
    },
  },
}

---VS Code-style top menu bar.
---@class core.menubar : core.view
---@field super core.view
---@field visible boolean
---@field hovered integer?
local MenuBar = View:extend()

function MenuBar:__tostring() return "MenuBar" end

local function menu_height()
  return style.font:get_height() + style.padding.y * 2
end

function MenuBar:new()
  MenuBar.super.new(self)
  self.visible = true
  self.hovered = nil
  self.open_menu = nil
  self.suppress_menu = nil
  self.size.y = menu_height()
  self.cursor = "arrow"
end


function MenuBar:update()
  self.size.y = self.visible and menu_height() or 0
  MenuBar.super.update(self)
  self:update_hover_menu()
end


function MenuBar:get_brand_width()
  return style.font:get_width(BRAND_NAME) + style.padding.x * 2
end


function MenuBar:get_menu_layout()
  local layout = {}
  local x = self.position.x + self:get_brand_width()
  local y = self.position.y
  local h = self.size.y
  local max_x = self.position.x + self.size.x
  for _, menu in ipairs(menus) do
    local w = style.font:get_width(menu.name) + style.padding.x * 2
    if x + w > max_x then break end
    table.insert(layout, { menu = menu, x = x, y = y, w = w, h = h })
    x = x + w
  end
  return layout
end


function MenuBar:get_menu_at(px, py)
  if not self.visible or py < self.position.y or py >= self.position.y + self.size.y then
    return nil
  end
  for _, item in ipairs(self:get_menu_layout()) do
    if px >= item.x and px < item.x + item.w then
      return item
    end
  end
end


function MenuBar:show_menu(item, pin)
  self.suppress_menu = nil
  local menu = core.root_view.context_menu
  local previous = core.active_view
  if not previous or previous == self or previous == menu then
    previous = core.last_active_view or core.root_view:get_primary_node().active_view
  end
  if previous and previous ~= self and previous ~= menu then
    core.set_active_view(previous)
  end
  for _, menu_item in ipairs(item.menu.items) do
    if menu_item ~= DIVIDER and menu_item.get_text then
      menu_item.text = menu_item.get_text()
    end
  end
  if menu:show(item.x, self.position.y + self.size.y, item.menu.items) then
    menu.menubar_menu = item.menu
    self.open_menu = item.menu
    if pin then
      self.pinned_menu = item.menu
    end
  else
    self.open_menu = nil
    self.pinned_menu = nil
  end
end


function MenuBar:update_hover_menu()
  if not self.visible then return end
  if core.root_view.grab or core.root_view.dragged_divider
    or (core.root_view.dragged_node and core.root_view.dragged_node.dragging) then
    return
  end
  local mouse = core.root_view.mouse
  local menu = core.root_view.context_menu
  local item = self:get_menu_at(mouse.x, mouse.y)

  if self.pinned_menu then
    if not menu.visible or menu.menubar_menu ~= self.pinned_menu then
      self.pinned_menu = nil
    else
      self.hovered = self.pinned_menu
      return
    end
  end

  if menu.visible and menu.submenu and menu.submenu.pinned then
    self.hovered = self.open_menu
    return
  end

  self.hovered = item and item.menu or self.open_menu
  if self.suppress_menu and (not item or item.menu ~= self.suppress_menu) then
    self.suppress_menu = nil
  end

  if self.open_menu then
    if not menu.visible or menu.menubar_menu ~= self.open_menu then
      self.open_menu = nil
      return
    end

    local inside_menu = menu:is_point_inside(mouse.x, mouse.y)
    local over_bar = mouse.x >= self.position.x
      and mouse.x < self.position.x + self.size.x
      and mouse.y >= self.position.y
      and mouse.y < self.position.y + self.size.y

    if item then
      if item.menu ~= self.open_menu then
        self:show_menu(item)
      end
    elseif not inside_menu and not over_bar then
      menu:hide()
      self.open_menu = nil
    end
  elseif not menu.visible and item and item.menu ~= self.suppress_menu then
    self:show_menu(item)
  end
end


function MenuBar:draw()
  if not self.visible then return end
  self:draw_background(style.background2)
  renderer.draw_rect(self.position.x, self.position.y + self.size.y - style.divider_size,
                    self.size.x, style.divider_size, style.divider)

  local x = self.position.x + style.padding.x
  common.draw_text(style.font, style.dim, BRAND_NAME, nil, x, self.position.y, 0, self.size.y)

  for _, item in ipairs(self:get_menu_layout()) do
    if self.hovered == item.menu then
      renderer.draw_rect(item.x, item.y, item.w, item.h, style.line_highlight)
    end
    local color = self.hovered == item.menu and style.text or style.dim
    common.draw_text(style.font, color, item.menu.name, "center", item.x, item.y, item.w, item.h)
  end
end


function MenuBar:on_mouse_pressed(button, x, y, clicks)
  if not self.visible or button ~= "left" then return false end
  local item = self:get_menu_at(x, y)
  if item then
    local menu = core.root_view.context_menu
    if self.open_menu == item.menu and menu.visible and menu.menubar_menu == item.menu then
      if self.pinned_menu == item.menu then
        menu:hide()
        self.open_menu = nil
        self.pinned_menu = nil
        self.suppress_menu = item.menu
      else
        self.pinned_menu = item.menu
      end
    else
      self:show_menu(item, true)
    end
  end
  return true
end


function MenuBar:on_mouse_moved(x, y)
  if not self.visible then return end
  local item = self:get_menu_at(x, y)
  self.hovered = item and item.menu or nil
  core.request_cursor(item and "arrow" or nil)
  return item ~= nil
end


function MenuBar:on_mouse_left()
  self.hovered = nil
end


function MenuBar:on_mouse_released(button, x, y)
  return self:get_menu_at(x, y) ~= nil
end


return MenuBar
