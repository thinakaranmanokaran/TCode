local core = require "core"
local common = require "core.common"
local command = require "core.command"
local keymap = require "core.keymap"
local style = require "core.style"
local View = require "core.view"

local border_width = 1
local divider_width = 1
local divider_padding = 5
local DIVIDER = {}

---An item in the context menu.
---
---If the command predicate fails, it won't be included in the menu.
---@see core.command.command
---@class core.contextmenu.item
---@field text string
---@field info string? Text displayed on the right side of the menu.
---@field command string|fun(...)

---Definition of the context menu properties.
---
---@class core.contextmenu.contextdetails
---@field items core.contextmenu.item[] Array of items to show
---@field x integer? Context menu origin x coordinate. Defaults to the mouse position.
---@field y integer? Context menu origin y coordinate. Defaults to the mouse position.

---A context menu.
---@class core.contextmenu : core.view
---@field visible boolean
---@field selected number
---@field position core.view.position
---@field current_scale number
local ContextMenu = View:extend()

function ContextMenu:__tostring() return "ContextMenu" end

---A unique value representing the divider in a context menu.
ContextMenu.DIVIDER = DIVIDER

---Creates a new context menu.
function ContextMenu:new()
  self.visible = false
  self.selected = -1
  self.height = 0
  self.position = { x = 0, y = 0 }
  self.current_scale = SCALE
  self.submenu = nil
  self.suppressed_submenu_parent = nil
end

local function get_item_size(item)
  local lw, lh
  if item == DIVIDER then
    lw = 0
    lh = divider_width + divider_padding * SCALE * 2
  else
    lw = style.font:get_width(item.text)
    if item.info then
      lw = lw + style.padding.x + style.font:get_width(item.info)
    end
    if item.submenu or item.get_submenu then
      lw = lw + style.padding.x + style.font:get_width(">")
    end
    lh = style.font:get_height() + style.padding.y
  end
  return lw, lh
end

local function update_items_size(items, update_binding)
  local width, height = 0, 0
  for _, item in ipairs(items) do
    if update_binding and item ~= DIVIDER then
      item.info = keymap.get_binding(item.command)
    end
    local lw, lh = get_item_size(item)
    width = math.max(width, lw)
    height = height + lh
  end
  width = width + style.padding.x * 2
  items.width, items.height = width, height
end

local function prepare_items(items, ...)
  local items_list = { width = 0, height = 0, arguments = { ... }, on_close = items.on_close }
  for _, item in ipairs(items) do
    if item and (not item.command or type(item.command) == "function"
        or item.submenu or item.get_submenu
        or command.is_valid(item.command, ...)) then
      if item == DIVIDER then
        -- Skip leading and consecutive dividers.
        if #items_list > 0 and items_list[#items_list] ~= DIVIDER then
          table.insert(items_list, item)
        end
      else
        table.insert(items_list, item)
      end
    end
  end
  -- Remove trailing dividers left by filtered commands.
  while #items_list > 0 and items_list[#items_list] == DIVIDER do
    table.remove(items_list)
  end
  return items_list
end

---Shows the context menu.
---@param x number
---@param y number
---@param items table
---@return boolean # If true, the context menu is shown.
function ContextMenu:show(x, y, items, ...)
  local items_list = prepare_items(items, ...)

  if #items_list > 0 then
    self.menubar_menu = nil
    self:close_submenu()
    self.suppressed_submenu_parent = nil
    self.items = items_list
    update_items_size(self.items, true)
    local w, h = self.items.width, self.items.height

    -- by default the box is opened on the right and below
    x = common.clamp(x, 0, core.root_view.size.x - w - style.padding.x)
    y = common.clamp(y, 0, core.root_view.size.y - h)

    self.position.x, self.position.y = x, y
    self.visible = true
    core.set_active_view(self)
    core.request_cursor("arrow")
    return true
  end
  return false
end

function ContextMenu:close_submenu()
  if self.submenu then
    local items = self.submenu.items
    self.submenu = nil
    if items and items.on_close then
      items.on_close()
    end
  end
end


function ContextMenu:open_submenu(item, item_x, item_y, item_w, item_h, pin)
  if self.submenu and self.submenu.parent == item then
    if pin then
      self.submenu.pinned = true
    end
    return
  elseif self.submenu then
    self:close_submenu()
  end

  local source = item.get_submenu and item.get_submenu() or item.submenu
  if not source then return end

  local items = prepare_items(source, table.unpack(self.items.arguments))
  if #items == 0 then return end
  update_items_size(items, true)

  local x = item_x + item_w + 1
  if x + items.width > core.root_view.size.x then
    x = self.position.x - items.width - 1
  end
  x = common.clamp(x, 0, math.max(0, core.root_view.size.x - items.width))
  local y = common.clamp(item_y, 0, math.max(0, core.root_view.size.y - items.height))

  self.submenu = {
    items = items,
    x = x,
    y = y,
    width = items.width,
    height = items.height,
    selected = -1,
    parent = item,
    pinned = pin or false,
  }
  self.suppressed_submenu_parent = nil
end


function ContextMenu:each_submenu_item()
  if not self.submenu then return function() end end
  local x, y, w = self.submenu.x, self.submenu.y, self.submenu.width
  local oy = y
  return coroutine.wrap(function()
    for i, item in ipairs(self.submenu.items) do
      local _, lh = get_item_size(item)
      if y - oy > self.submenu.height then break end
      coroutine.yield(i, item, x, y, w, lh)
      y = y + lh
    end
  end)
end


function ContextMenu:get_item_rect(index)
  for i, _, x, y, w, h in self:each_item() do
    if i == index then return x, y, w, h end
  end
end


function ContextMenu:get_submenu_item_selected()
  if not self.submenu then return nil end
  return self.submenu.items[self.submenu.selected]
end


function ContextMenu:is_point_inside(px, py)
  if not self.visible then return false end
  if px >= self.position.x and px < self.position.x + self.items.width
      and py >= self.position.y and py < self.position.y + self.height then
    return true
  end
  if self.submenu then
    local sx, sy = self.submenu.x, self.submenu.y
    if px >= sx and px < sx + self.submenu.width
        and py >= sy and py < sy + self.submenu.height then
      return true
    end
  end
  return false
end


---Hides the context menu.
function ContextMenu:hide()
  self:close_submenu()
  self.suppressed_submenu_parent = nil
  self.visible = false
  self.items = nil
  self.menubar_menu = nil
  self.selected = -1
  self.height = 0
  if core.active_view == self then
    core.set_active_view(core.last_active_view)
  end
  core.request_cursor(core.active_view.cursor)
end

---Returns an iterator that iterates over each context menu item and their dimensions.
---@return fun(): number, core.contextmenu.item, number, number, number, number
function ContextMenu:each_item()
  local x, y, w = self.position.x, self.position.y, self.items.width
  local oy = y
  return coroutine.wrap(function()
    for i, item in ipairs(self.items) do
      local _, lh = get_item_size(item)
      if y - oy > self.height then break end
      coroutine.yield(i, item, x, y, w, lh)
      y = y + lh
    end
  end)
end

function ContextMenu:on_mouse_pressed(button, x, y, clicks)
  if not self.visible then return false end
  local menu_bar = core.menu_bar
  if menu_bar and menu_bar.visible and menu_bar:get_menu_at(x, y) then
    menu_bar:on_mouse_pressed(button, x, y, clicks or 1)
    return true
  end
  if button == "left" then
    if self.submenu then
      local clicked
      for i, item, ix, iy, iw, ih in self:each_submenu_item() do
        if x >= ix and x < ix + iw and y >= iy and y < iy + ih then
          clicked = item
          break
        end
      end
      if clicked then
        if clicked.command then
          if core.active_view == self then
            core.set_active_view(core.last_active_view)
          end
          self:on_selected(clicked, self.submenu.items.arguments)
        end
        self:hide()
        return true
      end
    end

    local clicked, cx, cy, cw, ch
    for i, item, ix, iy, iw, ih in self:each_item() do
      if x >= ix and x < ix + iw and y >= iy and y < iy + ih then
        clicked = item
        cx, cy, cw, ch = ix, iy, iw, ih
        break
      end
    end
    if clicked then
      if clicked.submenu or clicked.get_submenu then
        if self.submenu and self.submenu.parent == clicked then
          if self.submenu.pinned then
            self:close_submenu()
            self.suppressed_submenu_parent = clicked
          else
            self.submenu.pinned = true
          end
        else
          self:open_submenu(clicked, cx, cy, cw, ch, true)
        end
        return true
      end
      if clicked.command then
        if core.active_view == self then
          core.set_active_view(core.last_active_view)
        end
        self:on_selected(clicked)
      end
    end
  end
  self:hide()
  return true
end

function ContextMenu:on_mouse_released(button, x, y)
  if not self.visible then return false end
  return true
end

---Event handler for mouse movements.
---@param px any
---@param py any
---@return boolean # true if the event is caught.
function ContextMenu:on_mouse_moved(px, py)
  if not self.visible then return false end

  if self.submenu then
    local old = self.submenu.selected
    self.submenu.selected = -1
    for i, item, x, y, w, h in self:each_submenu_item() do
      if px > x and px <= x + w and py > y and py <= y + h then
        self.submenu.selected = i
        if old ~= i and item and item.on_hover then
          item.on_hover(item)
        end
        break
      end
    end
    if self.submenu.selected ~= -1 then
      core.request_cursor("arrow")
      return true
    end
  end

  local old_main = self.selected
  self.selected = -1
  local hovered, hx, hy, hw, hh
  for i, item, x, y, w, h in self:each_item() do
    if px > x and px <= x + w and py > y and py <= y + h then
      self.selected = i
      hovered, hx, hy, hw, hh = item, x, y, w, h
      break
    end
  end

  if self.suppressed_submenu_parent
      and (not hovered or hovered ~= self.suppressed_submenu_parent) then
    self.suppressed_submenu_parent = nil
  end

  if self.submenu and self.submenu.pinned then
    core.request_cursor("arrow")
    return true
  end

  if hovered then
    if old_main ~= self.selected and hovered.on_hover then
      hovered.on_hover(hovered)
    end
    if hovered.submenu or hovered.get_submenu then
      if hovered ~= self.suppressed_submenu_parent then
        if not self.submenu or self.submenu.parent ~= hovered then
          self:open_submenu(hovered, hx, hy, hw, hh)
        end
      end
    elseif self.submenu then
      self:close_submenu()
    end
    core.request_cursor("arrow")
  elseif self.submenu then
    self:close_submenu()
  end
  return true
end

---Event handler for when the selection is confirmed.
---@param item core.contextmenu.item
function ContextMenu:on_selected(item, arguments)
  arguments = arguments or self.items.arguments
  if type(item.command) == "string" then
    command.perform(item.command, table.unpack(arguments))
  else
    item.command(table.unpack(arguments))
  end
end

local function change_value(value, change)
  return value + change
end

---Selects the the previous item.
function ContextMenu:focus_previous()
  self.selected = (self.selected == -1 or self.selected == 1) and #self.items or change_value(self.selected, -1)
  if self:get_item_selected() == DIVIDER then
    self.selected = change_value(self.selected, -1)
  end
end

---Selects the next item.
function ContextMenu:focus_next()
  self.selected = (self.selected == -1 or self.selected == #self.items) and 1 or change_value(self.selected, 1)
  if self:get_item_selected() == DIVIDER then
    self.selected = change_value(self.selected, 1)
  end
end

---Gets the currently selected item.
---@return core.contextmenu.item|nil
function ContextMenu:get_item_selected()
  return (self.items or {})[self.selected]
end

---@type fun(self: table, k: string, dest: number, rate?: number, name?: string)
ContextMenu.move_towards = View.move_towards

---Event handler for content update.
function ContextMenu:update()
  if self.visible then
    self:move_towards("height", self.items.height, nil, "contextmenu")
    if self.current_scale ~= SCALE then
      update_items_size(self.items)
      if self.submenu then
        update_items_size(self.submenu.items)
        self.submenu.width = self.submenu.items.width
        self.submenu.height = self.submenu.items.height
      end
      self.current_scale = SCALE
    end
  end
end

---Draws the context menu.
---
---This wraps `ContextMenu:draw_context_menu()`.
---@see core.contextmenu.draw_context_menu
function ContextMenu:draw()
  if not self.visible then return end
  if not self.items then return end
  local bx, by, bw, bh = self.position.x, self.position.y, self.items.width, self.height

  renderer.draw_rect(
    bx - border_width,
    by - border_width,
    bw + (border_width * 2),
    bh + (border_width * 2),
    style.divider
  )
  renderer.draw_rect(bx, by, bw, bh, style.background3)

  for i, item, x, y, w, h in self:each_item() do
    if item == DIVIDER then
      renderer.draw_rect(x, y + divider_padding * SCALE, w, divider_width, style.divider)
    else
      if i == self.selected then
        renderer.draw_rect(x, y, w, h, style.selection)
      end

      common.draw_text(style.font, style.text, item.text, "left", x + style.padding.x, y, w, h)
      if item.submenu or item.get_submenu then
        common.draw_text(style.font, style.dim, ">", "right", x, y, w - style.padding.x, h)
      elseif item.info then
        common.draw_text(style.font, style.dim, item.info, "right", x, y, w - style.padding.x, h)
      end
    end
  end

  if self.submenu then
    local sx, sy = self.submenu.x, self.submenu.y
    local sw, sh = self.submenu.width, self.submenu.height
    renderer.draw_rect(
      sx - border_width,
      sy - border_width,
      sw + (border_width * 2),
      sh + (border_width * 2),
      style.divider
    )
    renderer.draw_rect(sx, sy, sw, sh, style.background3)

    for i, item, x, y, w, h in self:each_submenu_item() do
      if item == DIVIDER then
        renderer.draw_rect(x, y + divider_padding * SCALE, w, divider_width, style.divider)
      else
        if i == self.submenu.selected then
          renderer.draw_rect(x, y, w, h, style.selection)
        end
        common.draw_text(style.font, style.text, item.text, "left", x + style.padding.x, y, w, h)
        if item.info then
          common.draw_text(style.font, style.dim, item.info, "right", x, y, w - style.padding.x, h)
        end
      end
    end
  end
end


return ContextMenu
