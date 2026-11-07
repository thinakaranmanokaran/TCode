-- mod-version:4
local core = require "core"
local common = require "core.common"
local command = require "core.command"
local style = require "core.style"
local keymap = require "core.keymap"
local View = require "core.view"

local ICON_NEW_FILE = "\u{ea7f}"
local ICON_OPEN_FILE = "\u{ea94}"
local ICON_SAVE = "\u{eb4b}"
local ICON_SEARCH = "\u{ea6d}"
local ICON_NEW_FOLDER = "\u{ea80}"
local ICON_COLLAPSE_ALL = "\u{eac5}"
local ICON_REFRESH = "\u{eb37}"
local ICON_TERMINAL = "\u{ea85}"
local ICON_MENU = "\u{eb94}"
local ICON_SETTINGS = "\u{eaf8}"

local ToolbarView = View:extend()

function ToolbarView:__tostring() return "ToolbarView" end

function ToolbarView:new(options)
  options = options or {}
  ToolbarView.super.new(self)
  self.visible = true
  self.init_size = true
  self.tooltip = false
  self.toolbar_font = style.codicon_big_font
  self.title = options.title
  self.align = options.align or "left"
  self.toolbar_commands = options.commands or {
    {symbol = ICON_NEW_FILE, command = "core:new-doc"},
    {symbol = ICON_OPEN_FILE, command = "core:open-file"},
    {symbol = ICON_SAVE, command = "doc:save"},
    {symbol = ICON_SEARCH, command = "core:find-file"},
    {symbol = ICON_NEW_FILE, command = "treeview:new-file-at-root"},
    {symbol = ICON_NEW_FOLDER, command = "treeview:new-folder-at-root"},
    {symbol = ICON_COLLAPSE_ALL, command = "treeview:collapse-all"},
    {symbol = ICON_REFRESH, command = "treeview:refresh"},
    {symbol = ICON_SEARCH, command = "project-search:find"},
    {symbol = ICON_TERMINAL, command = "terminal:toggle-drawer"},
    {symbol = ICON_MENU, command = "core:find-command"},
    {symbol = ICON_SETTINGS, command = "core:open-user-module"},
  }
  local max_per_row = options.max_per_row or 6
  self.rows = math.max(1, math.ceil(#self.toolbar_commands / max_per_row))
  self.columns = math.ceil(#self.toolbar_commands / self.rows)
end


function ToolbarView:update()
  local icon_h = self.toolbar_font:get_height()
  local dest_size = self.visible
    and (self.rows * icon_h + (self.rows - 1) * style.padding.y + style.padding.y * 2)
    or 0
  if self.init_size then
    self.size.y = dest_size
    self.init_size = nil
  else
    self:move_towards(self.size, "y", dest_size)
  end
  ToolbarView.super.update(self)
end


function ToolbarView:toggle_visible()
  self.visible = not self.visible
  if self.tooltip then
    core.status_view:remove_tooltip()
    self.tooltip = false
  end
  self.hovered_item = nil
end

function ToolbarView:get_icon_width()
  local max_width = 0
  for i,v in ipairs(self.toolbar_commands) do max_width = math.max(max_width, (v.font or self.toolbar_font):get_width(v.symbol)) end
  return max_width
end

function ToolbarView:each_item()
  local icon_h, icon_w = self.toolbar_font:get_height(), self:get_icon_width()
  local toolbar_spacing = icon_w / 2
  local row_height = icon_h + style.padding.y
  local columns = self.columns
  local ox, oy = self:get_content_offset()
  local total_w = columns * icon_w + (columns - 1) * toolbar_spacing
  local base_x = self.align == "right"
    and (self.size.x - style.padding.x - total_w)
    or style.padding.x
  local index = 0
  local iter = function()
    index = index + 1
    if index <= #self.toolbar_commands then
      local col = (index - 1) % columns
      local row = math.floor((index - 1) / columns)
      local dx = base_x + (icon_w + toolbar_spacing) * col
      local dy = style.padding.y + row_height * row
      if dx + icon_w > self.size.x then return end
      return self.toolbar_commands[index], ox + dx, oy + dy, icon_w, icon_h
    end
  end
  return iter
end


function ToolbarView:get_min_width()
  local icon_w = self:get_icon_width()
  local space = icon_w / 2
  local width = 2 * style.padding.x + (icon_w + space) * self.columns - space
  if self.title then
    width = width + style.font:get_width(self.title) + style.padding.x * 2
  end
  return width
end


function ToolbarView:draw()
  if not self.visible then return end
  self:draw_background(style.background2)

  if self.title then
    local ox, oy = self:get_content_offset()
    local icon_h = self.toolbar_font:get_height()
    common.draw_text(style.font, style.dim, self.title:upper(), nil,
      ox + style.padding.x, oy + style.padding.y, 0, icon_h)
  end

  for item, x, y, w, h in self:each_item() do
    local color = item == self.hovered_item and command.is_valid(item.command) and style.text or style.dim
    common.draw_text(item.font or self.toolbar_font, color, item.symbol, nil, x, y, 0, h)
  end

  renderer.draw_rect(self.position.x, self.position.y + self.size.y - style.divider_size,
    self.size.x, style.divider_size, style.divider)
end


function ToolbarView:on_mouse_pressed(button, x, y, clicks)
  if not self.visible then return end
  local caught = ToolbarView.super.on_mouse_pressed(self, button, x, y, clicks)
  if caught then return caught end
  core.set_active_view(core.last_active_view)
  if self.hovered_item and command.is_valid(self.hovered_item.command) then
    command.perform(self.hovered_item.command)
  end
  return true
end


function ToolbarView:on_mouse_left()
  ToolbarView.super.on_mouse_left(self)
  if self.tooltip then
    core.status_view:remove_tooltip()
    self.tooltip = false
  end
  self.hovered_item = nil
end


function ToolbarView:on_mouse_moved(px, py, ...)
  if not self.visible then return end
  ToolbarView.super.on_mouse_moved(self, px, py, ...)
  self.hovered_item = nil
  local x_min, x_max, y_min, y_max = self.size.x, 0, self.size.y, 0
  for item, x, y, w, h in self:each_item() do
    x_min, x_max = math.min(x, x_min), math.max(x + w, x_max)
    y_min, y_max = y, y + h
    if px > x and py > y and px <= x + w and py <= y + h then
      self.hovered_item = item
      local binding = keymap.get_binding(item.command)
      local name = item.label or command.prettify_name(item.command)
      core.status_view:show_tooltip(binding and { name, style.dim, "  ", binding } or { name })
      self.tooltip = true
      return
    end
  end
  if self.tooltip and not (px > x_min and px <= x_max and py > y_min and py <= y_max) then
    core.status_view:remove_tooltip()
    self.tooltip = false
  end
end

-- This toolbar view is not plugged into the treeview anymore. The Explorer
-- header in treeview.lua provides the file and folder actions.

return ToolbarView
