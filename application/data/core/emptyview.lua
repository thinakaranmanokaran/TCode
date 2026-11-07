local core = require "core"
local style = require "core.style"
local keymap = require "core.keymap"
local common = require "core.common"
local command = require "core.command"
local View = require "core.view"

---@class core.emptyview : core.view
---@field super core.view
local EmptyView = View:extend()

function EmptyView:__tostring() return "EmptyView" end

function EmptyView:get_name()
  return "Get Started"
end

function EmptyView:get_filename()
  return ""
end

EmptyView.commands = {
  { text = "Open Terminal", command = "terminal:open-tab" },
  { text = "Show All Commands", command = "core:find-command" },
  { text = "Find File", command = "core:find-file" },
  { text = "Open File", command = "core:open-file" },
  { text = "Open Folder", command = "core:open-project-folder" },
}

local KEY_NAMES = {
  ctrl = "Ctrl",
  shift = "Shift",
  alt = "Alt",
  altgr = "AltGr",
  cmd = "Cmd",
  meta = "Meta",
  super = "Super",
  ["return"] = "Enter",
  enter = "Enter",
  escape = "Esc",
  backspace = "Backspace",
  delete = "Del",
  insert = "Ins",
  pageup = "Page Up",
  pagedown = "Page Down",
  space = "Space",
  tab = "Tab",
  home = "Home",
  ["end"] = "End",
}

local function key_label(key)
  local mapped = KEY_NAMES[key:lower()]
  if mapped then
    return mapped
  end
  if #key == 1 then
    return key:upper()
  end
  return key:gsub("^%l", string.upper)
end

local function split_binding(binding)
  local keys = {}
  for key in binding:gmatch("[^+]+") do
    keys[#keys + 1] = key_label(key)
  end
  return keys
end

local function draw_rounded_rect(x, y, w, h, radius, color)
  if w <= 0 or h <= 0 then return end
  radius = math.max(0, math.min(radius, math.floor(math.min(w, h) / 2)))
  if radius <= 0 then
    renderer.draw_rect(x, y, w, h, color)
    return
  end
  renderer.draw_rect(x + radius, y, w - radius * 2, h, color)
  renderer.draw_rect(x, y + radius, w, h - radius * 2, color)
end

local function draw_keycap(label, x, y, w, h)
  local border = math.max(1, common.round(1 * SCALE))
  local radius = math.max(1, common.round(2 * SCALE))
  draw_rounded_rect(x, y, w, h, radius, style.dim)
  draw_rounded_rect(
    x + border, y + border,
    w - border * 2, h - border * 2,
    math.max(0, radius - border),
    style.line_highlight
  )
  common.draw_text(style.font, style.text, label, "center", x, y, w, h)
end

function EmptyView:on_mouse_moved(x, y)
  local hovered = nil
  for i, rect in ipairs(self.row_rects or {}) do
    if x >= rect.x and x < rect.x + rect.w
      and y >= rect.y and y < rect.y + rect.h then
      hovered = i
      break
    end
  end
  if hovered ~= self.hovered_row then
    self.hovered_row = hovered
    core.redraw = true
  end
  core.request_cursor(hovered and "hand" or nil)
  return hovered ~= nil
end

function EmptyView:on_mouse_left()
  if self.hovered_row then
    self.hovered_row = nil
    core.redraw = true
  end
end

function EmptyView:on_mouse_pressed(button, x, y, clicks)
  if button == "left" then
    for _, rect in ipairs(self.row_rects or {}) do
      if x >= rect.x and x < rect.x + rect.w
        and y >= rect.y and y < rect.y + rect.h then
        command.perform(rect.command)
        return true
      end
    end
  end
  return false
end

local function with_opacity(color, opacity)
  return {
    color[1], color[2], color[3],
    (color[4] or 255) * opacity,
  }
end

function EmptyView:draw()
  self:draw_background(style.background)

  local cx = self.position.x + self.size.x / 2
  local cy = self.position.y + self.size.y / 2

  local rows = {}
  for _, item in ipairs(self.commands) do
    local binding = keymap.get_binding(item.command)
    if binding then
      rows[#rows + 1] = {
        text = item.text,
        command = item.command,
        keys = split_binding(binding),
      }
    end
  end

  local key_height = style.font:get_height() + math.ceil(8 * SCALE)
  local row_height = key_height + math.ceil(8 * SCALE)
  local list_width = math.min(440 * SCALE, self.size.x - style.padding.x * 4)
  local list_height = row_height * #rows
  local logo_size = style.logo and math.min(
    300 * SCALE,
    self.size.x * 0.42,
    self.size.y * 0.46
  ) or 0
  local gap = logo_size > 0 and math.ceil(30 * SCALE) or 0
  local total_height = logo_size + gap + list_height
  local top = cy - total_height / 2

  if style.logo and logo_size > 0 then
    local opacity = style.logo_opacity or 1
    renderer.draw_image(
      style.logo,
      cx - logo_size / 2,
      top,
      logo_size,
      logo_size,
      with_opacity(style.logo_color, opacity)
    )
    if style.logo_glyph then
      renderer.draw_image(
        style.logo_glyph,
        cx - logo_size / 2,
        top,
        logo_size,
        logo_size,
        with_opacity(style.logo_text_color, opacity)
      )
    end
    top = top + logo_size + gap
  end

  local list_left = cx - list_width / 2
  local key_gap = math.ceil(5 * SCALE)
  local plus_width = style.font:get_width("+") + key_gap * 2
  local key_padding = math.ceil(12 * SCALE)
  self.row_rects = {}

  for i, row in ipairs(rows) do
    local y = top + (i - 1) * row_height
    self.row_rects[i] = {
      x = list_left,
      y = y,
      w = list_width,
      h = row_height,
      command = row.command,
    }

    if self.hovered_row == i then
      renderer.draw_rect(list_left, y, list_width, row_height, style.line_highlight)
    end

    local text_y = y + (row_height - style.font:get_height()) / 2
    local text_color = self.hovered_row == i and style.accent or style.text
    renderer.draw_text(style.font, row.text, list_left, text_y, text_color)

    local widths = {}
    local keys_width = 0
    for j, key in ipairs(row.keys) do
      widths[j] = style.font:get_width(key) + key_padding
      keys_width = keys_width + widths[j]
      if j > 1 then
        keys_width = keys_width + plus_width
      end
    end

    local key_x = list_left + list_width - keys_width
    local key_y = y + (row_height - key_height) / 2
    for j, key in ipairs(row.keys) do
      if j > 1 then
        common.draw_text(style.font, style.dim, "+", "center",
          key_x, key_y, plus_width, key_height)
        key_x = key_x + plus_width
      end
      draw_keycap(key, key_x, key_y, widths[j], key_height)
      key_x = key_x + widths[j]
    end
  end
end

return EmptyView
