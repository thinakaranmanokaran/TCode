-- mod-version:4 --priority:-1
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local style = require "core.style"

local THEMES = {
  -- Bearded Theme family
  { name = "bearded-theme-vivid-black", label = "Vivid Black", category = "bearded" },
  { name = "bearded-vivid-light", label = "Vivid Light", category = "bearded" },
  { name = "bearded-vivid-purple", label = "Vivid Purple", category = "bearded" },
  { name = "bearded-arc", label = "Arc", category = "bearded" },
  { name = "bearded-arc-blueberry", label = "Arc Blueberry", category = "bearded" },
  { name = "bearded-oceanic", label = "Oceanic", category = "bearded" },
  { name = "bearded-solarized-light", label = "Solarized Light", category = "bearded" },
  { name = "bearded-black-amethyst", label = "Black & Amethyst", category = "bearded" },
  { name = "bearded-black-gold", label = "Black & Gold", category = "bearded" },
  { name = "bearded-milkshake-mint", label = "Milkshake Mint", category = "bearded" },

  -- Monokai family
  { name = "monokai", label = "Monokai", category = "monokai" },
  { name = "monokai-classic", label = "Classic", category = "monokai" },
  { name = "monokai-sublime", label = "Sublime", category = "monokai" },
  { name = "monokai-pro", label = "Pro", category = "monokai" },
  { name = "monokai-dimmed", label = "Dimmed", category = "monokai" },
  { name = "monokai-terra", label = "Terra", category = "monokai" },
  { name = "monokai-metallian", label = "Metallian", category = "monokai" },
  { name = "monokai-stone", label = "Stone", category = "monokai" },
  { name = "monokai-black", label = "Black", category = "monokai" },
  { name = "monokai-reversed", label = "Reversed", category = "monokai" },

  { name = "default", label = "Default" },
}

local state_file = USERDIR .. PATHSEP .. "theme.lua"

local function find_theme(name)
  for _, theme in ipairs(THEMES) do
    if theme.name == name then
      return theme
    end
  end
end

local function theme_label(name)
  local theme = find_theme(name)
  return theme and theme.label or name
end

local function save_theme(name)
  local fp = io.open(state_file, "w")
  if not fp then return end
  fp:write("return ", string.format("%q", name), "\n")
  fp:close()
end

local function blend_color(background, foreground, amount)
  if not background or not foreground then return nil end
  return {
    math.floor(background[1] * (1 - amount) + foreground[1] * amount),
    math.floor(background[2] * (1 - amount) + foreground[2] * amount),
    math.floor(background[3] * (1 - amount) + foreground[3] * amount),
    255,
  }
end

local function load_theme_colors(name)
  core.reload_module("colors.default")
  if name ~= "default" then
    local ok = pcall(core.reload_module, "colors." .. name)
    if not ok then
      name = "default"
    end
  end
  -- Keep secondary UI (menu bar, Explorer header, inactive tabs, icons)
  -- subdued instead of using the primary text color.
  local amount = 0.35
  if style.background then
    local luminance = style.background[1] * 0.299
      + style.background[2] * 0.587
      + style.background[3] * 0.114
    if luminance > 128 then
      amount = 0.6
    end
  end
  style.dim = blend_color(style.background, style.text, amount) or style.dim
  -- Keep dialogs (About, unsaved changes, errors) in the theme's palette
  -- instead of the legacy red nag bar.
  style.nagbar = blend_color(style.background, style.text, 0.10) or style.nagbar
  style.nagbar_text = style.text or style.nagbar_text
  -- Use the active theme for the welcome watermark and menu-bar mark.
  style.logo_color = blend_color(style.background, style.text, amount * 0.5)
    or style.text or style.logo_color
  style.logo_text_color = style.accent or style.text or style.logo_text_color
  return name
end

local function apply_theme(name)
  name = load_theme_colors(name)
  local theme = find_theme(name)
  config.theme = name
  config.theme_category = theme and theme.category or nil
  config.theme_preview = nil
  core.redraw = true
end

local function preview_theme(name)
  if config.theme_preview == name then return end
  load_theme_colors(name)
  config.theme_preview = name
  core.status_view:show_message("i", style.text, "Preview: " .. theme_label(name))
  core.redraw = true
end

local function revert_preview()
  if not config.theme_preview then return end
  local confirmed = config.theme or "default"
  config.theme_preview = nil
  load_theme_colors(confirmed)
  core.status_view:show_message("i", style.text, "Theme: " .. theme_label(confirmed))
  core.redraw = true
end

local function set_theme(name)
  apply_theme(name)
  save_theme(config.theme)
  core.status_view:show_message("i", style.text, "Theme: " .. theme_label(config.theme))
end

local function theme_items(category)
  local items = {}
  for _, theme in ipairs(THEMES) do
    if theme.category == category then
      table.insert(items, {
        text = (config.theme == theme.name and "* " or "  ") .. theme.label,
        on_hover = function()
          preview_theme(theme.name)
        end,
        command = function()
          set_theme(theme.name)
        end,
      })
    end
  end
  items.on_close = revert_preview
  return items
end

local function show_category(category)
  core.add_thread(function()
    coroutine.yield(0)
    local mouse = core.root_view.mouse
    core.root_view.context_menu:show(mouse.x, mouse.y, theme_items(category))
  end)
end

command.add(nil, {
  ["theme:menu-bearded"] = function() show_category("bearded") end,
  ["theme:menu-monokai"] = function() show_category("monokai") end,
  ["theme:default"] = function() set_theme("default") end,
  ["theme:select"] = function(name)
    if name then set_theme(name) end
  end,
})

local theme = "bearded-theme-vivid-black"
local ok, saved = pcall(dofile, state_file)
if ok and type(saved) == "string" and find_theme(saved) then
  theme = saved
end
apply_theme(theme)

config.themes = THEMES
config.theme_menu = theme_items

return {}
