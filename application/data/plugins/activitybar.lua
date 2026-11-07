-- mod-version:4
local core = require "core"
local common = require "core.common"
local command = require "core.command"
local keymap = require "core.keymap"
local style = require "core.style"
local View = require "core.view"

local ICON_EXPLORER = "\u{eaf0}"
local ICON_SEARCH = "\u{ea6d}"
local ICON_TERMINAL = "\u{ea85}"
local ICON_MENU = "\u{eb94}"
local ICON_SETTINGS = "\u{eaf8}"

---@class core.activitybar : core.view
---@field super core.view
---@field visible boolean
---@field hovered_item table?
local ActivityBar = View:extend()

function ActivityBar:__tostring() return "ActivityBar" end

function ActivityBar:new()
  ActivityBar.super.new(self)
  self.visible = true
  self.hovered_item = nil
  self.tooltip = false
  self.bar_font = style.codicon_big_font
  self.items = {
    { symbol = ICON_EXPLORER,  command = "treeview:show",            label = "Explorer" },
    { symbol = ICON_SEARCH,    command = "project-search:find",       label = "Search in Project" },
    { symbol = ICON_TERMINAL,  command = "terminal:toggle-tab",      label = "Terminal" },
    { symbol = ICON_MENU,      command = "core:find-command",         label = "Command Palette" },
    { symbol = ICON_SETTINGS,  command = "core:open-user-module",     label = "Settings" },
  }
  self.cursor = "arrow"
end


function ActivityBar:get_width()
  return self.bar_font:get_width("\u{eaf0}") + style.padding.x * 2
end


function ActivityBar:update()
  self.size.x = self.visible and self:get_width() or 0
  ActivityBar.super.update(self)
end


function ActivityBar:toggle_visible()
  self.visible = not self.visible
  self.hovered_item = nil
  if self.tooltip then
    core.status_view:remove_tooltip()
    self.tooltip = false
  end
end


function ActivityBar:each_item()
  local icon_w, icon_h = self.bar_font:get_width("\u{eaf0}"), self.bar_font:get_height()
  local item_h = icon_h + style.padding.y
  local ox, oy = self:get_content_offset()
  local index = 0
  local iter = function()
    index = index + 1
    if index <= #self.items then
      local item = self.items[index]
      local x = ox + (self.size.x - icon_w) / 2
      local y = oy + style.padding.y + item_h * (index - 1)
      if y + icon_h > oy + self.size.y then return end
      return item, x, y, icon_w, icon_h
    end
  end
  return iter
end


function ActivityBar:draw()
  if not self.visible then return end
  self:draw_background(style.background2)
  renderer.draw_rect(self.position.x + self.size.x - style.divider_size, self.position.y,
                    style.divider_size, self.size.y, style.divider)

  for item, x, y, w, h in self:each_item() do
    if item == self.hovered_item then
      local pad = style.padding.x / 2
      renderer.draw_rect(self.position.x + pad, y - style.padding.y / 2,
                        self.size.x - pad * 2, h + style.padding.y, style.line_highlight)
    end
    local color = item == self.hovered_item and command.is_valid(item.command) and style.text or style.dim
    common.draw_text(self.bar_font, color, item.symbol, nil, x, y, 0, h)
  end
end


function ActivityBar:get_item_at(px, py)
  for item, x, y, w, h in self:each_item() do
    if px >= x and py >= y and px <= x + w and py <= y + h then
      return item
    end
  end
end


function ActivityBar:on_mouse_pressed(button, x, y, clicks)
  if not self.visible or button ~= "left" then return false end
  local item = self:get_item_at(x, y)
  local previous = core.last_active_view or core.root_view:get_primary_node().active_view
  if previous and previous ~= self then
    core.set_active_view(previous)
  end
  if item and command.is_valid(item.command) then
    command.perform(item.command)
  end
  return true
end


function ActivityBar:on_mouse_moved(px, py, ...)
  if not self.visible then return end
  ActivityBar.super.on_mouse_moved(self, px, py, ...)
  self.hovered_item = nil
  local item = self:get_item_at(px, py)
  if item then
    self.hovered_item = item
    local binding = keymap.get_binding(item.command)
    local text = item.label or command.prettify_name(item.command)
    core.status_view:show_tooltip(binding and { text, style.dim, "  ", binding } or { text })
    self.tooltip = true
    return true
  end
  if self.tooltip then
    core.status_view:remove_tooltip()
    self.tooltip = false
  end
  return false
end


function ActivityBar:on_mouse_left()
  if self.tooltip then
    core.status_view:remove_tooltip()
    self.tooltip = false
  end
  self.hovered_item = nil
end


return ActivityBar
