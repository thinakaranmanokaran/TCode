-- mod-version:4
local core = require "core"
local config = require "core.config"
local command = require "core.command"
local style = require "core.style"
local common = require "core.common"
local View = require "core.view"
local keymap = require "core.keymap"
local StatusView = require "core.statusview"
local ContextMenu = require "core.contextmenu"

local terminal_native = require "terminal"

local ICON_TERMINAL = "\u{ea85}"
local ICON_ADD = "\u{ea60}"
local ICON_CLEAR_ALL = "\u{eabf}"
local ICON_CLOSE = "\u{ea76}"
local ICON_CHEVRON_DOWN = "\u{eab4}"


local default_shell =  os.getenv("SHELL") or (PLATFORM == "Windows" and os.getenv("COMSPEC")) or (PLATFORM == "Windows" and "c:\\windows\\system32\\cmd.exe" or "sh")
local default_config = {
  -- outputs a terminal.log file of all the output of your shell
  debug = false,
  -- the TERM to present as.
  term = "xterm-256color",
  -- pressing this key and ctrl will allow normal commands to be run that start with ctrl (ctrl+n, ctrl+w, etc..) while using the terminal
  -- set to nil to disable entirely
  inversion_key = "shift",
  -- lua pattern for escape sequences to ignore. nil to target all escapes to terminal. example value would be "ctrl%+[nwpf]"
  omit_escapes = nil,
  -- the default shell to boot up in
  shell = default_shell,
  -- the arguments to pass to your shell
  arguments = { },
  -- additional terminal profiles; these override detected profiles by name
  profiles = { },
  -- the profile used when no profile is specified
  default_profile = nil,
  -- restore the last used profile on startup
  use_last_profile = true,
  -- show the terminal header with profile and action buttons
  show_header = true,
  -- the environmental variable to set on shell instantiation
  environment = { 
    PWD = function() return core.root_project and core.root_project().path or "." end,
  },
  -- the amount of time between line scrolling when we're dragging offscreen
  scrolling_speed = 0.01,
  -- the newline character to use
  -- We set ICRNL, so that this is translated to `\n` at input time... but this seems to be necessary. `micro`
  -- doesn't allow you to newline if you don't set it to `\r`.
  newline = ((config.plugins.terminal.shell or default_shell):lower():find("cmd.exe") and "\r\n" or "\r"),
  -- the backspace character to use
  backspace = "\x7F",
  -- the delete character to use
  delete = "\x1B[3~",
  -- the amount of lines you can emit before we start cutting them off
  scrollback_limit = 10000,
  -- the default height of the console drawer
  drawer_height = 300,
  -- the default console font. non-monsospace is unsupported
  font = style.code_font,
  -- padding around the edges of the terminal
  padding = { x = 0, y = 0 },
  -- default background color if not explicitly set by the shell
  background = style.background or { common.color "#000000" },
  -- default text color if not explicitly by the shell
  text = style.syntax and style.syntax.normal or { common.color "#FFFFFF" },
  -- show bold text in bright colors
  bold_text_in_bright_colors = true,
  -- set to 0 to disable color adjustments based on background
  minimum_contrast_ratio = 3,
  colors = {
    -- You can customize these without many repercussions.
    [  0] = { common.color "#000000" }, [  1] = { common.color "#aa0000" }, [  2] = { common.color "#44aa44" }, [  3] = { common.color "#aa5500" }, [  4] = { common.color "#0039aa" },
    [  5] = { common.color "#aa22aa" }, [  6] = { common.color "#1a92aa" }, [  7] = { common.color "#aaaaaa" }, [  8] = { common.color "#777777" }, [  9] = { common.color "#ff8787" },
    [ 10] = { common.color "#4ce64c" }, [ 11] = { common.color "#ded82c" }, [ 12] = { common.color "#295fcc" }, [ 13] = { common.color "#cc58cc" }, [ 14] = { common.color "#4ccce6" },
    [ 15] = { common.color "#ffffff" },
    -- You can't customize these without repercussions.
    [ 16] = { common.color "#000000" }, [ 17] = { common.color "#00005f" }, [ 18] = { common.color "#000087" }, [ 19] = { common.color "#0000af" },
    [ 20] = { common.color "#0000d7" }, [ 21] = { common.color "#0000ff" }, [ 22] = { common.color "#005f00" }, [ 23] = { common.color "#005f5f" }, [ 24] = { common.color "#005f87" },
    [ 25] = { common.color "#005faf" }, [ 26] = { common.color "#005fd7" }, [ 27] = { common.color "#005fff" }, [ 28] = { common.color "#008700" }, [ 29] = { common.color "#00875f" },
    [ 30] = { common.color "#008787" }, [ 31] = { common.color "#0087af" }, [ 32] = { common.color "#0087d7" }, [ 33] = { common.color "#0087ff" }, [ 34] = { common.color "#00af00" },
    [ 35] = { common.color "#00af5f" }, [ 36] = { common.color "#00af87" }, [ 37] = { common.color "#00afaf" }, [ 38] = { common.color "#00afd7" }, [ 39] = { common.color "#00afff" },
    [ 40] = { common.color "#00d700" }, [ 41] = { common.color "#00d75f" }, [ 42] = { common.color "#00d787" }, [ 43] = { common.color "#00d7af" }, [ 44] = { common.color "#00d7d7" },
    [ 45] = { common.color "#00d7ff" }, [ 46] = { common.color "#00ff00" }, [ 47] = { common.color "#00ff5f" }, [ 48] = { common.color "#00ff87" }, [ 49] = { common.color "#00ffaf" },
    [ 50] = { common.color "#00ffd7" }, [ 51] = { common.color "#00ffff" }, [ 52] = { common.color "#5f0000" }, [ 53] = { common.color "#5f005f" }, [ 54] = { common.color "#5f0087" },
    [ 55] = { common.color "#5f00af" }, [ 56] = { common.color "#5f00d7" }, [ 57] = { common.color "#5f00ff" }, [ 58] = { common.color "#5f5f00" }, [ 59] = { common.color "#5f5f5f" },
    [ 60] = { common.color "#5f5f87" }, [ 61] = { common.color "#5f5faf" }, [ 62] = { common.color "#5f5fd7" }, [ 63] = { common.color "#5f5fff" }, [ 64] = { common.color "#5f8700" },
    [ 65] = { common.color "#5f875f" }, [ 66] = { common.color "#5f8787" }, [ 67] = { common.color "#5f87af" }, [ 68] = { common.color "#5f87d7" }, [ 69] = { common.color "#5f87ff" },
    [ 70] = { common.color "#5faf00" }, [ 71] = { common.color "#5faf5f" }, [ 72] = { common.color "#5faf87" }, [ 73] = { common.color "#5fafaf" }, [ 74] = { common.color "#5fafd7" },
    [ 75] = { common.color "#5fafff" }, [ 76] = { common.color "#5fd700" }, [ 77] = { common.color "#5fd75f" }, [ 78] = { common.color "#5fd787" }, [ 79] = { common.color "#5fd7af" },
    [ 80] = { common.color "#5fd7d7" }, [ 81] = { common.color "#5fd7ff" }, [ 82] = { common.color "#5fff00" }, [ 83] = { common.color "#5fff5f" }, [ 84] = { common.color "#5fff87" },
    [ 85] = { common.color "#5fffaf" }, [ 86] = { common.color "#5fffd7" }, [ 87] = { common.color "#5fffff" }, [ 88] = { common.color "#870000" }, [ 89] = { common.color "#87005f" },
    [ 90] = { common.color "#870087" }, [ 91] = { common.color "#8700af" }, [ 92] = { common.color "#8700d7" }, [ 93] = { common.color "#8700ff" }, [ 94] = { common.color "#875f00" },
    [ 95] = { common.color "#875f5f" }, [ 96] = { common.color "#875f87" }, [ 97] = { common.color "#875faf" }, [ 98] = { common.color "#875fd7" }, [ 99] = { common.color "#875fff" },
    [100] = { common.color "#878700" }, [101] = { common.color "#87875f" }, [102] = { common.color "#878787" }, [103] = { common.color "#8787af" }, [104] = { common.color "#8787d7" },
    [105] = { common.color "#8787ff" }, [106] = { common.color "#87af00" }, [107] = { common.color "#87af5f" }, [108] = { common.color "#87af87" }, [109] = { common.color "#87afaf" },
    [110] = { common.color "#87afd7" }, [111] = { common.color "#87afff" }, [112] = { common.color "#87d700" }, [113] = { common.color "#87d75f" }, [114] = { common.color "#87d787" },
    [115] = { common.color "#87d7af" }, [116] = { common.color "#87d7d7" }, [117] = { common.color "#87d7ff" }, [118] = { common.color "#87ff00" }, [119] = { common.color "#87ff5f" },
    [120] = { common.color "#87ff87" }, [121] = { common.color "#87ffaf" }, [122] = { common.color "#87ffd7" }, [123] = { common.color "#87ffff" }, [124] = { common.color "#af0000" },
    [125] = { common.color "#af005f" }, [126] = { common.color "#af0087" }, [127] = { common.color "#af00af" }, [128] = { common.color "#af00d7" }, [129] = { common.color "#af00ff" },
    [130] = { common.color "#af5f00" }, [131] = { common.color "#af5f5f" }, [132] = { common.color "#af5f87" }, [133] = { common.color "#af5faf" }, [134] = { common.color "#af5fd7" },
    [135] = { common.color "#af5fff" }, [136] = { common.color "#af8700" }, [137] = { common.color "#af875f" }, [138] = { common.color "#af8787" }, [139] = { common.color "#af87af" },
    [140] = { common.color "#af87d7" }, [141] = { common.color "#af87ff" }, [142] = { common.color "#afaf00" }, [143] = { common.color "#afaf5f" }, [144] = { common.color "#afaf87" },
    [145] = { common.color "#afafaf" }, [146] = { common.color "#afafd7" }, [147] = { common.color "#afafff" }, [148] = { common.color "#afd700" }, [149] = { common.color "#afd75f" },
    [150] = { common.color "#afd787" }, [151] = { common.color "#afd7af" }, [152] = { common.color "#afd7d7" }, [153] = { common.color "#afd7ff" }, [154] = { common.color "#afff00" },
    [155] = { common.color "#afff5f" }, [156] = { common.color "#afff87" }, [157] = { common.color "#afffaf" }, [158] = { common.color "#afffd7" }, [159] = { common.color "#afffff" },
    [160] = { common.color "#d70000" }, [161] = { common.color "#d7005f" }, [162] = { common.color "#d70087" }, [163] = { common.color "#d700af" }, [164] = { common.color "#d700d7" },
    [165] = { common.color "#d700ff" }, [166] = { common.color "#d75f00" }, [167] = { common.color "#d75f5f" }, [168] = { common.color "#d75f87" }, [169] = { common.color "#d75faf" },
    [170] = { common.color "#d75fd7" }, [171] = { common.color "#d75fff" }, [172] = { common.color "#d78700" }, [173] = { common.color "#d7875f" }, [174] = { common.color "#d78787" },
    [175] = { common.color "#d787af" }, [176] = { common.color "#d787d7" }, [177] = { common.color "#d787ff" }, [178] = { common.color "#d7af00" }, [179] = { common.color "#d7af5f" },
    [180] = { common.color "#d7af87" }, [181] = { common.color "#d7afaf" }, [182] = { common.color "#d7afd7" }, [183] = { common.color "#d7afff" }, [184] = { common.color "#d7d700" },
    [185] = { common.color "#d7d75f" }, [186] = { common.color "#d7d787" }, [187] = { common.color "#d7d7af" }, [188] = { common.color "#d7d7d7" }, [189] = { common.color "#d7d7ff" },
    [190] = { common.color "#d7ff00" }, [191] = { common.color "#d7ff5f" }, [192] = { common.color "#d7ff87" }, [193] = { common.color "#d7ffaf" }, [194] = { common.color "#d7ffd7" },
    [195] = { common.color "#d7ffff" }, [196] = { common.color "#ff0000" }, [197] = { common.color "#ff005f" }, [198] = { common.color "#ff0087" }, [199] = { common.color "#ff00af" },
    [200] = { common.color "#ff00d7" }, [201] = { common.color "#ff00ff" }, [202] = { common.color "#ff5f00" }, [203] = { common.color "#ff5f5f" }, [204] = { common.color "#ff5f87" },
    [205] = { common.color "#ff5faf" }, [206] = { common.color "#ff5fd7" }, [207] = { common.color "#ff5fff" }, [208] = { common.color "#ff8700" }, [209] = { common.color "#ff875f" },
    [210] = { common.color "#ff8787" }, [211] = { common.color "#ff87af" }, [212] = { common.color "#ff87d7" }, [213] = { common.color "#ff87ff" }, [214] = { common.color "#ffaf00" },
    [215] = { common.color "#ffaf5f" }, [216] = { common.color "#ffaf87" }, [217] = { common.color "#ffafaf" }, [218] = { common.color "#ffafd7" }, [219] = { common.color "#ffafff" },
    [220] = { common.color "#ffd700" }, [221] = { common.color "#ffd75f" }, [222] = { common.color "#ffd787" }, [223] = { common.color "#ffd7af" }, [224] = { common.color "#ffd7d7" },
    [225] = { common.color "#ffd7ff" }, [226] = { common.color "#ffff00" }, [227] = { common.color "#ffff5f" }, [228] = { common.color "#ffff87" }, [229] = { common.color "#ffffaf" },
    [230] = { common.color "#ffffd7" }, [231] = { common.color "#ffffff" }, [232] = { common.color "#080808" }, [233] = { common.color "#121212" }, [234] = { common.color "#1c1c1c" },
    [235] = { common.color "#262626" }, [236] = { common.color "#303030" }, [237] = { common.color "#3a3a3a" }, [238] = { common.color "#444444" }, [239] = { common.color "#4e4e4e" },
    [240] = { common.color "#585858" }, [241] = { common.color "#626262" }, [242] = { common.color "#6c6c6c" }, [243] = { common.color "#767676" }, [244] = { common.color "#808080" },
    [245] = { common.color "#8a8a8a" }, [246] = { common.color "#949494" }, [247] = { common.color "#9e9e9e" }, [248] = { common.color "#a8a8a8" }, [249] = { common.color "#b2b2b2" },
    [250] = { common.color "#bcbcbc" }, [251] = { common.color "#c6c6c6" }, [252] = { common.color "#d0d0d0" }, [253] = { common.color "#dadada" }, [254] = { common.color "#e4e4e4" },
    [255] = { common.color "#eeeeee" }
  },
}
local function set_config_default_values(c) for _, v in ipairs(c) do if v.path then v.default = default_config[v.path] end end return c end
-- configuration for the settings GUI (do not modify)
default_config.config_spec = set_config_default_values {
  name = "Terminal",
  {
    label = "Background Color",
    description = "The color of the terminal background (when not overridden by the shell).",
    path = "background", type = "COLOR"
  },
  {
    label = "Text Color",
    description = "The color of the text (when not overridden by the shell).",
    path = "text", type = "COLOR"
  },
  {
    label = "Show Bold Text In Bright Colors",
    description = "Display emboldened text with brighter colors.",
    path = "bold_text_in_bright_colors", type = "TOGGLE"
  },
  {
    label = "Minimum Contrast Ratio",
    description = "Minimum contrast between the text and background color (set to 0 to disable auto color adjustment).",
    path = "minimum_contrast_ratio", type = "NUMBER"
  },
  {
    label = "Terminal Drawer Height",
    description = "Height of the terminal drawer (in pixels).",
    path = "drawer_height", type = "NUMBER"
  },
  {
    label = "Inversion Key",
    description = "The key to press in combination with CTRL to send the shortcut to T Code instead of the terminal.",
    path = "inversion_key", type = "STRING",
  },
  {
    label = "Omit Shortcuts",
    description = "A Lua pattern of shortcuts to pass to T Code instead of the terminal.",
    path = "omit_escapes", type = "STRING"
  },
  {
    label = "Scrolling speed",
    description = "The amount of time to scroll a line when selecting text offscreen.",
    path = "scrolling_speed", type = "NUMBER"
  },
  {
    label = "Shell",
    description = "Absolute path to the shell for the terminal.",
    path = "shell", type = "STRING"
  },
  {
    label = "Shell Arguments",
    description = "Extra arguments to pass to the shell.",
    path = "arguments", type = "LIST_STRINGS"
  },
  {
    label = "Terminal Type",
    description = "The type to terminal to appear as (sets the $TERM environment variable).",
    path = "term", type = "STRING"
  },
  {
    label = "Scrollback Buffer Size",
    description = "Number of lines to store for scrolling in the terminal.",
    path = "scrollback_limit", type = "NUMBER"
  },
  {
    label = "Change Other Options",
    description = "For other options such as the color palette, you can change them in the user module.",
    icon = "PLATFORM", type = "BUTTON", on_click = "core:open-user-module", path = "",
  }
}
config.plugins.terminal = common.merge(default_config, config.plugins.terminal)
if not config.plugins.terminal.bold_font then config.plugins.terminal.bold_font = config.plugins.terminal.font:copy(config.plugins.terminal.font:get_size(), { smoothing = true }) end

local function file_exists(path)
  return path and path ~= "" and system.get_file_info(path) ~= nil
end

local function detect_profiles()
  local profiles = {}
  local function add(name, shell, args, options)
    if shell and shell ~= "" then
      local profile = {
        name = name,
        shell = shell,
        arguments = args or {},
      }
      for k, v in pairs(options or {}) do
        profile[k] = v
      end
      table.insert(profiles, profile)
    end
  end

  if PLATFORM == "Windows" then
    local program_files = os.getenv("ProgramFiles") or "C:\\Program Files"
    local program_files_x86 = os.getenv("ProgramFiles(x86)") or "C:\\Program Files (x86)"
    local local_app_data = os.getenv("LOCALAPPDATA") or ""
    local system_root = os.getenv("SystemRoot") or "C:\\Windows"

    local pwsh = program_files .. "\\PowerShell\\7\\pwsh.exe"
    if file_exists(pwsh) then
      add("PowerShell", pwsh, { "-NoLogo" })
    end

    local windows_powershell = system_root .. "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
    if file_exists(windows_powershell) then
      add("Windows PowerShell", windows_powershell, { "-NoLogo" })
    end

    add("Command Prompt", os.getenv("COMSPEC") or "cmd.exe")

    local bash_path
    local git_bash_paths = {
      program_files .. "\\Git\\bin\\bash.exe",
      program_files_x86 .. "\\Git\\bin\\bash.exe",
      local_app_data .. "\\Programs\\Git\\bin\\bash.exe",
    }
    for _, path in ipairs(git_bash_paths) do
      if file_exists(path) then
        bash_path = path
        break
      end
    end

    -- Git for Windows can be installed anywhere. Find git.exe on PATH and
    -- derive the adjacent bin/bash.exe.
    if not bash_path then
      for entry in (os.getenv("PATH") or ""):gmatch("[^;]+") do
        local dir = entry:gsub('^"(.*)"$', "%1"):gsub("[/\\]+$", "")
        if file_exists(dir .. "\\git.exe") then
          local root = dir
          local lower = dir:lower()
          if lower:match("[/\\]cmd$") or lower:match("[/\\]bin$") then
            root = dir:sub(1, #dir - 4)
          end
          local path = root .. "\\bin\\bash.exe"
          if file_exists(path) then
            bash_path = path
            break
          end
        end
      end
    end

    -- Also accept bash.exe directly on PATH, skipping the System32 shim,
    -- which is the WSL launcher.
    if not bash_path then
      for entry in (os.getenv("PATH") or ""):gmatch("[^;]+") do
        local dir = entry:gsub('^"(.*)"$', "%1"):gsub("[/\\]+$", "")
        local path = dir .. "\\bash.exe"
        local lower = path:lower()
        if file_exists(path)
          and not lower:find("\\windows\\system32\\", 1, true)
          and not lower:find("\\windows\\syswow64\\", 1, true) then
          bash_path = path
          break
        end
      end
    end

    -- MSYS2 and Cygwin installations.
    if not bash_path then
      for _, path in ipairs({
        "C:\\msys64\\usr\\bin\\bash.exe",
        "C:\\msys32\\usr\\bin\\bash.exe",
        "C:\\cygwin64\\bin\\bash.exe",
        "C:\\cygwin\\bin\\bash.exe",
      }) do
        if file_exists(path) then
          bash_path = path
          break
        end
      end
    end

    if bash_path then
      -- Prefer Git's launcher wrapper, which sets up the MSYS environment.
      local git_root = bash_path:match("^(.*)[/\\]usr[/\\]bin[/\\]bash%.exe$")
      if git_root then
        local wrapper = git_root .. "\\bin\\bash.exe"
        if file_exists(wrapper) then
          bash_path = wrapper
        end
      end
      add("bash", bash_path, { "--login" }, { newline = "\r" })
    end

    -- wsl.exe is present on every Windows install, even when WSL is not
    -- installed, so it is not added automatically. Users who want it can add
    -- a profile with shell = "C:\\Windows\\System32\\wsl.exe".
  else
    local login_shell = os.getenv("SHELL")
    if login_shell and login_shell ~= "" then
      add(common.basename(login_shell), login_shell)
    end
    local candidates = {
      { "/bin/bash", "bash" },
      { "/bin/zsh", "zsh" },
      { "/usr/bin/fish", "fish" },
      { "/bin/sh", "sh" },
    }
    for _, candidate in ipairs(candidates) do
      if file_exists(candidate[1]) then
        add(candidate[2], candidate[1])
      end
    end
  end

  return profiles
end

local function merge_profile(target, source)
  for k, v in pairs(source) do
    target[k] = v
  end
end

local function add_profile(list, map, profile)
  if not profile.name or not profile.shell then return end
  profile.arguments = profile.arguments or {}
  profile.environment = profile.environment or {}
  local existing = map[profile.name]
  if existing then
    merge_profile(existing, profile)
  else
    table.insert(list, profile)
    map[profile.name] = profile
  end
end

local function build_profiles()
  local list, map = {}, {}
  for _, profile in ipairs(detect_profiles()) do
    add_profile(list, map, profile)
  end

  -- Keep the legacy single-shell configuration available as "Default".
  local legacy = {
    name = "Default",
    shell = config.plugins.terminal.shell,
    arguments = config.plugins.terminal.arguments,
    environment = config.plugins.terminal.environment,
    cwd = config.plugins.terminal.cwd,
  }
  local legacy_is_detected = false
  for _, profile in ipairs(list) do
    if profile.shell == legacy.shell then
      legacy_is_detected = true
      break
    end
  end
  if not legacy_is_detected then
    add_profile(list, map, legacy)
  end

  local user_profiles = config.plugins.terminal.profiles or {}
  if user_profiles[1] then
    for _, profile in ipairs(user_profiles) do
      add_profile(list, map, profile)
    end
  else
    for name, profile in pairs(user_profiles) do
      if type(profile) == "table" then
        profile.name = profile.name or name
        add_profile(list, map, profile)
      end
    end
  end

  return list, map
end

local profile_list, profile_map = build_profiles()
if #profile_list == 0 then
  add_profile(profile_list, profile_map, {
    name = "Default",
    shell = config.plugins.terminal.shell or default_shell,
  })
end

local default_profile = config.plugins.terminal.default_profile
if not default_profile or not profile_map[default_profile] then
  default_profile = nil
  if PLATFORM == "Windows" then
    if profile_map["PowerShell"] then
      default_profile = "PowerShell"
    elseif profile_map["Windows PowerShell"] then
      default_profile = "Windows PowerShell"
    elseif profile_map["Command Prompt"] then
      default_profile = "Command Prompt"
    end
  else
    local login_shell = os.getenv("SHELL")
    for _, profile in ipairs(profile_list) do
      if login_shell and profile.shell == login_shell then
        default_profile = profile.name
        break
      end
    end
  end
  default_profile = default_profile or profile_list[1].name
end

local function get_profile(name)
  return (name and profile_map[name]) or profile_map[default_profile] or profile_list[1]
end

local function resolve_cwd(cwd)
  if type(cwd) == "function" then
    cwd = cwd()
  end
  if not cwd or cwd == "project" then
    cwd = core.root_project().path
  end
  return cwd
end

local function apply_profile(base, name)
  local profile = get_profile(name)
  return common.merge(base, {
    shell = profile.shell or base.shell,
    arguments = profile.arguments or base.arguments,
    environment = common.merge(base.environment, profile.environment or {}),
    cwd = resolve_cwd(profile.cwd or base.cwd),
    term = profile.term or base.term,
    newline = profile.newline or base.newline,
    profile_name = profile.name,
  })
end

local state_file = USERDIR .. PATHSEP .. "terminal.lua"
local state = {}
do
  local ok, saved = pcall(dofile, state_file)
  if ok and type(saved) == "table" then
    state = saved
  end
end

local function save_state()
  local fp = io.open(state_file, "w")
  if not fp then return end
  fp:write("return ", common.serialize(state), "\n")
  fp:close()
end

local function evaluate_environment(environment)
  local result = common.merge(environment, {})
  for k, v in pairs(result) do
    result[k] = type(v) == "function" and (v() or "") or v
  end
  return result
end

local function prepare_environment(environment)
  local result = evaluate_environment(environment)
  if PLATFORM == "Windows" then
    local entries = {}
    for k, v in pairs(common.merge(terminal_native.getenv(), result)) do
      table.insert(entries, tostring(k) .. "=" .. tostring(v))
    end
    return table.concat(entries, "\0") .. "\0\0"
  end
  return result
end


-- contrast functions pulled from https://github.com/xtermjs/xterm.js/blob/99df13b085aecb051f1373c5b7f8e819c4f41442/src/common/Color.ts#L285.
local function contrastRatio(l1, l2)
  if l1 < l2 then return (l2 + 0.05) / (l1 + 0.05) end
  return (l1 + 0.05) / (l2 + 0.05)
end

local function relativeLuminance(color)
  local rs = color[1] / 255
  local gs = color[2] / 255
  local bs = color[3] / 255
  local rr = rs <= 0.03928 and rs / 12.92 or (((rs + 0.055) / 1.055) ^ 2.4)
  local rg = gs <= 0.03928 and gs / 12.92 or (((gs + 0.055) / 1.055) ^ 2.4)
  local rb = bs <= 0.03928 and bs / 12.92 or (((bs + 0.055) / 1.055) ^ 2.4)
  return rr * 0.2126 + rg * 0.7152 + rb * 0.0722
end

local function reduceLuminance(bg, fg, ratio)
  local bgL = relativeLuminance(bg)
  local cr = contrastRatio(relativeLuminance(fg), bgL)
  local nFg = { table.unpack(fg) }
  while cr < ratio and (nFg[1] > 0 or nFg[2] > 0 or nFg[3] > 0) do
    -- Reduce by 10% until the ratio is hit
    nFg[1] = nFg[1] - math.max(0, math.ceil(nFg[1] * 0.1))
    nFg[2] = nFg[2] - math.max(0, math.ceil(nFg[2] * 0.1))
    nFg[3] = nFg[3] - math.max(0, math.ceil(nFg[3] * 0.1))
    cr = contrastRatio(relativeLuminance(nFg), bgL)
  end
  return nFg
end

local function increaseLuminance(bg, fg, ratio)
  local bgL = relativeLuminance(bg)
  local nFg = { table.unpack(fg) }
  local cr = contrastRatio(relativeLuminance(nFg), bgL)
  while cr < ratio and (nFg[1] < 0xFF or nFg[2] < 0xFF or nFg[3] < 0xFF) do
    -- Increase by 10% until the ratio is hit
    nFg[1] = math.min(0xFF, nFg[1] + math.ceil((255 - nFg[1]) * 0.1))
    nFg[2] = math.min(0xFF, nFg[2] + math.ceil((255 - nFg[2]) * 0.1))
    nFg[3] = math.min(0xFF, nFg[3] + math.ceil((255 - nFg[3]) * 0.1))
    cr = contrastRatio(relativeLuminance(nFg), bgL)
  end
  return nFg
end

local function ensureContrastRatio(bg, fg, ratio)
  local bgL = relativeLuminance(bg)
  local fgL = relativeLuminance(fg)
  local cr = contrastRatio(bgL, fgL)
  if cr < ratio then
    if fgL < bgL then
      local resultA = reduceLuminance(bg, fg, ratio)
      local resultARatio = contrastRatio(bgL, relativeLuminance(resultA))
      if resultARatio < ratio then
        local resultB = increaseLuminance(bg, fg, ratio)
        local resultBRatio = contrastRatio(bgL, relativeLuminance(resultB))
        return resultARatio > resultBRatio and resultA or resultB
      end
      return resultA
    end
    local resultA = increaseLuminance(bg, fg, ratio)
    local resultARatio = contrastRatio(bgL, relativeLuminance(resultA))
    if resultARatio < ratio then
      local resultB = reduceLuminance(bg, fg, ratio)
      local resultBRatio = contrastRatio(bgL, relativeLuminance(resultB))
      return resultARatio > resultBRatio and resultA or resultB
    end
    return resultA
  end
  return fg
end



local TerminalView = View:extend()

TerminalView.profiles = profile_list
TerminalView.default_profile = default_profile

function TerminalView:get_name()
  local name = self.profile_name or (self.terminal and self.terminal:name()) or "Terminal"
  return (self.modified_since_last_focus and "* " or "") .. name
end
function TerminalView:supports_text_input() return true end

function TerminalView:new(options, profile_name)
  TerminalView.super.new(self)
  local config_options = common.merge(common.merge({}, config.plugins.terminal), options)
  config_options.padding = common.merge({ x = 0, y = 0 }, config_options.padding)

  local name = profile_name or (options and options.profile_name)
  if not name then
    if config.plugins.terminal.use_last_profile and state.last_profile and profile_map[state.last_profile] then
      name = state.last_profile
    else
      name = default_profile
    end
  end

  local resolved = apply_profile(config_options, name)
  resolved.environment = prepare_environment(resolved.environment)

  if profile_name and profile_map[profile_name] and config.plugins.terminal.use_last_profile then
    state.last_profile = profile_name
    save_state()
  end

  self.config_options = config_options
  self.size.y = resolved.drawer_height or 300
  self.options = resolved
  self.profile_name = resolved.profile_name
  self.cursor = "ibeam"
  self.scrollable = true
  self.last_size = { x = self.size.x, y = self.size.y }
  self.last_header_height = nil
  self.focused = false
  self.modified_since_last_focus = false
  self.spawn_error = nil
  self.closing = false
  self.mouse_x = 0
  self.mouse_y = 0
  self.header_height = 0
  self.header_hover = nil
end

function TerminalView:shift_selection_update()
  if not self.terminal then return false end
  local shifts = self.terminal:update()
  if shifts and not self.focused then self.modified_since_last_focus = true end
  if self.selection and shifts then
    self.selection[2] = self.selection[2] - shifts
    self.selection[4] = self.selection[4] - shifts
    if math.abs(math.min(self.selection[2], self.selection[4])) > self.options.scrollback_limit then
      self.selection = nil
    end
  end
  return shifts
end


function TerminalView:create_terminal(options)
  local ok, term, err = pcall(
    terminal_native.new,
    self.columns,
    self.lines,
    options.scrollback_limit,
    options.term,
    options.shell,
    options.arguments,
    options.environment,
    options.debug,
    options.cwd
  )
  if not ok then
    term, err = nil, term
  end
  return term, err
end


function TerminalView:start_routine()
  -- We make this weak so that any other method of closing the view gets caught up in the garbage collection and the coroutine doesn't count as a reference for gc purposes.
  local weak_table = { self = self }
  setmetatable(weak_table, { __mode = "v" })
  self.routine = self.routine or core.add_thread(function()
    while weak_table.self and weak_table.self.terminal do
      core.redraw = weak_table.self:shift_selection_update() or core.redraw
      coroutine.yield(1 / config.fps)
    end
  end)
end


function TerminalView:spawn()
  local term, err = self:create_terminal(self.options)
  if not term then
    self.spawn_error = err or "Failed to create terminal"
    core.error("Terminal: %s", self.spawn_error)
    if core.nag_view then
      core.nag_view:show("Terminal", self.spawn_error, { { text = "OK" } })
    end
    return false
  end
  self.terminal = term
  self.spawn_error = nil
  self.last_size = { x = self.size.x, y = self.size.y }
  self:start_routine()
  return true
end


function TerminalView:select_profile(name)
  local profile = get_profile(name)
  if not profile then return false end

  local resolved = apply_profile(self.config_options, profile.name)
  resolved.environment = prepare_environment(resolved.environment)
  local previous = self.terminal
  local term, err = self:create_terminal(resolved)
  if not term then
    self.spawn_error = err or "Failed to create terminal"
    core.error("Terminal: %s", self.spawn_error)
    if core.nag_view then
      core.nag_view:show("Terminal", self.spawn_error, { { text = "OK" } })
    end
    return false
  end

  if previous then
    previous:close()
  end
  self.options = resolved
  self.profile_name = resolved.profile_name
  self.terminal = term
  self.spawn_error = nil
  self.closing = false
  self.last_size = { x = self.size.x, y = self.size.y }
  self:start_routine()

  state.last_profile = profile.name
  save_state()
  core.redraw = true
  return true
end


function TerminalView:get_reopen_info()
  return {
    kind = "terminal",
    profile = self.options.profile_name,
  }
end


function TerminalView:clear()
  if self.terminal then
    self.terminal:clear()
    self:input(self.options.newline)
    core.redraw = true
  end
end


function TerminalView:get_header_height()
  if self.options.show_header == false or self.size.x < 240 * SCALE then return 0 end
  return style.font:get_height() + style.padding.y * 2
end


function TerminalView:get_header_button_rect(kind)
  local h = self.header_height
  if h <= 0 then return end
  local right = self.position.x + self.size.x - style.scrollbar_size
  local pad = style.padding.x
  local function width(text, f)
    return (f or style.codicon_font):get_width(text) + pad * 2
  end
  local close_w = width(ICON_CLOSE, style.codicon_font)
  local clear_w = width(ICON_CLEAR_ALL, style.codicon_font)
  local new_w = width(ICON_ADD, style.codicon_font)
  local controls_w = close_w + clear_w + new_w
  local max_profile_w = math.max(40 * SCALE, self.size.x - controls_w - pad * 4 - style.scrollbar_size)
  local profile_text_w = style.font:get_width(self.options.profile_name or "Profile")
  local profile_icon_w = style.codicon_font:get_width(ICON_TERMINAL) + style.codicon_font:get_width(ICON_CHEVRON_DOWN)
  local profile_w = math.min(profile_text_w + profile_icon_w + pad * 4, max_profile_w)

  if kind == "profile" then
    return self.position.x + style.padding.x, self.position.y, profile_w, h
  elseif kind == "close" then
    return right - close_w, self.position.y, close_w, h
  elseif kind == "clear" then
    return right - close_w - clear_w, self.position.y, clear_w, h
  elseif kind == "new" then
    return right - close_w - clear_w - new_w, self.position.y, new_w, h
  end
end


function TerminalView:get_header_button_at(x, y)
  if self.header_height <= 0 or y < self.position.y or y >= self.position.y + self.header_height then
    return nil
  end
  for _, kind in ipairs({ "profile", "new", "clear", "close" }) do
    local bx, by, bw, bh = self:get_header_button_rect(kind)
    if bx and x >= bx and x < bx + bw and y >= by and y < by + bh then
      return kind
    end
  end
  return "header"
end


function TerminalView:open_profile_menu()
  local x, y, w, h = self:get_header_button_rect("profile")
  if not x then return end
  local items = {}
  for _, profile in ipairs(profile_list) do
    local current = profile.name == self.options.profile_name
    table.insert(items, {
      text = (current and "* " or "  ") .. profile.name,
      command = function()
        self:select_profile(profile.name)
      end,
    })
  end
  core.root_view.context_menu:show(x, y + h, items)
end


function TerminalView:draw_header()
  if self.header_height <= 0 then return end
  local x, y, w, h = self.position.x, self.position.y, self.size.x, self.header_height
  renderer.draw_rect(x, y, w, h, style.background2)
  renderer.draw_rect(x, y + h - style.divider_size, w, style.divider_size, style.divider)

  local function draw_icon_button(kind, symbol)
    local bx, by, bw, bh = self:get_header_button_rect(kind)
    if not bx then return end
    local color = self.header_hover == kind and style.text or style.dim
    if self.header_hover == kind then
      renderer.draw_rect(bx, by, bw, bh, style.line_highlight)
    end
    common.draw_text(style.codicon_font, color, symbol, "center", bx, by, bw, bh)
  end

  local bx, by, bw, bh = self:get_header_button_rect("profile")
  if bx then
    local color = self.header_hover == "profile" and style.text or style.dim
    if self.header_hover == "profile" then
      renderer.draw_rect(bx, by, bw, bh, style.line_highlight)
    end
    local pad = style.padding.x
    local icon_w = style.codicon_font:get_width(ICON_TERMINAL)
    local chevron_w = style.codicon_font:get_width(ICON_CHEVRON_DOWN)
    common.draw_text(style.codicon_font, color, ICON_TERMINAL, nil, bx + pad, by, 0, bh)
    local text_x = bx + pad + icon_w + pad
    local text_w = math.max(0, bw - (text_x - bx) - chevron_w - pad * 2)
    core.push_clip_rect(text_x, by, text_w, bh)
    common.draw_text(style.font, color, self.options.profile_name or "Profile", nil, text_x, by, 0, bh)
    core.pop_clip_rect()
    common.draw_text(style.codicon_font, color, ICON_CHEVRON_DOWN, nil, bx + bw - pad - chevron_w, by, 0, bh)
  end

  draw_icon_button("new", ICON_ADD)
  draw_icon_button("clear", ICON_CLEAR_ALL)
  draw_icon_button("close", ICON_CLOSE)
end



function TerminalView:update()
  local font_size = self.options.font:get_size()
  self.header_height = self:get_header_height()
  if self.last_font_size and self.last_font_size ~= font_size and self.options.bold_font then
    self.options.bold_font:set_size(font_size)
  end

  if not self.terminal and self.spawn_error then
    return
  end

  if self.size.x > 0 and self.size.y > 0 then
    local need_resize = self.last_font_size ~= font_size
      or self.last_header_height ~= self.header_height
      or not self.terminal
      or self.last_size.x ~= self.size.x
      or self.last_size.y ~= self.size.y
    if need_resize then
      self.columns = math.max(math.floor((self.size.x - self.options.padding.x*2 - style.scrollbar_size) / self.options.font:get_width("W")), 1)
      self.lines = math.max(math.floor((self.size.y - self.header_height - self.options.padding.y*2) / self.options.font:get_height()), 1)
      if not self.terminal then
        self:spawn()
      elseif self.columns > 0 and self.lines > 0 then
        self.terminal:size(self.columns, self.lines)
        self.last_size = { x = self.size.x, y = self.size.y }
        self.last_header_height = self.header_height
      end
    end
  end

  if self.terminal then
    if self.deferred_input then
      self:input(self.deferred_input)
      self.deferred_input = nil
    end
    local exited = self.terminal:exited()
    if exited == false then
      self.cursor = "ibeam"
      if self.terminal:mouse_tracking_mode()
         or self.v_scrollbar.hovering.track
         or self.v_scrollbar.hovering.track then
        self.cursor = "arrow"
      end
      if (core.active_view == self and not self.focused) or (core.active_view ~= self and self.focused) then
        self.focused = core.active_view == self
        self.modified_since_last_focus = false
        self.terminal:focused(self.focused)
      end
      local x, y, mode = self.terminal:cursor()
      if mode == "blinking" then
        local T, t0 = config.blink_period, core.blink_start
        local ta, tb = core.blink_timer, system.get_time()
        if ((tb - t0) % T < T / 2) ~= ((ta - t0) % T < T / 2) then
          core.redraw = true
        end
        core.blink_timer = tb
      end
      if self.scrolling_offscreen and (not self.last_scroll_time or system.get_time() - self.last_scroll_time > self.options.scrolling_speed) then
        self.last_scroll_time = system.get_time()
        self.terminal:scrollback(self.terminal:scrollback() + self.scrolling_offscreen)
        core.redraw = true
      end
      local scrollback, total_scrollback = self.terminal:scrollback()
      local lh = self.options.font:get_height()
      -- 0 should be if we're at max scrollback. 1 should be if we're at 0 scrollback.
      self.v_scrollbar:set_size(self.position.x, self.position.y + self.header_height, self.size.x, self.size.y - self.header_height, self:get_scrollable_size())
      local percent = total_scrollback > 0 and (1.0 - (scrollback / total_scrollback)) or 1.0
      self.v_scrollbar:set_percent(common.clamp(percent, 0, 1))
      self.v_scrollbar:update()
    elseif not self.closing then
      self.closing = true
      core.add_thread(function()
        self:close()
      end)
    end
  end
  if self.size.x > 0 and self.size.y > 0 then
    self.last_font_size = font_size
    self.last_header_height = self.header_height
  end
end


function TerminalView:set_target_size(axis, value)
  if axis == "y" then
    self.size.y = value
    return true
  elseif axis == "x" then
    self.size.x = value
    return true
  end
end

function TerminalView:on_scale_change(new_scale, prev_scale)
  self.last_font_size = nil
  self.last_header_height = nil
  self.last_size = { x = 0, y = 0 }
end

function TerminalView:convert_color(int, target, should_bright)
  local attributes = int >> 24
  local type = (attributes & 0x7)
  if type == 0 then
    if target == "foreground" then return self.options.text, attributes end
    return self.options.background, attributes
  elseif type == 1 then
    if target == "foreground" then return self.options.background, attributes end
    return self.options.text, attributes
  elseif type == 2 then
    local index = (int >> 16) & 0xFF
    if index < 8 and should_bright and (((attributes >> 3) & 0x1) ~= 0) then index = index + 8 end
    return self.options.colors[index], attributes
  elseif type == 3 then
    return { ((int >> 16) & 0xFF), ((int >> 8) & 0xFF), ((int >> 0) & 0xFF), 255 }, attributes
  end
  if target == "foreground" then
    return self.options.text, attributes
  end
  return self.options.background, attributes
end

function TerminalView:sorted_selection()
  if not self.selection then return nil end
  local selection = { table.unpack(self.selection) }
  if selection[2] > selection[4] or (selection[2] == selection[4] and selection[1] > selection[3]) then
    selection = { selection[3], selection[4], selection[1], selection[2] }
  end
  return selection
end


local contrast_foreground = {}
local contrast_foreground_count = 0
function TerminalView:draw()
  if self.size.x <= 0 or self.size.y <= 0 then return end
  TerminalView.super.draw_background(self, self.options.background)
  self:draw_header()
  if self.terminal then
    local space_width = self.options.font:get_width(" ")

    local y = self.position.y + self.header_height + self.options.padding.y
    local lh = self.options.font:get_height()
    core.redraw = self:shift_selection_update() or core.redraw
    local cursor_x, cursor_y, mode = self.terminal:cursor()
    local scrollback = self.terminal:scrollback()


    local selection = self:sorted_selection()
    for line_idx, line in ipairs(self.terminal:lines()) do
      local x = self.position.x + self.options.padding.x
      local should_draw_cursor = false
      if mode ~= "hidden" and core.active_view == self and line_idx - 1 == cursor_y and scrollback == 0 then
        if mode == "blinking" then
          local T = config.blink_period
          if (core.blink_timer - core.blink_start) % T < T / 2 then
            should_draw_cursor = true
          end
        else
          should_draw_cursor = true
        end
      end
      local offset = 0
      local foreground, background, text_style
      for i = 1, #line, 2 do
        background = self:convert_color(line[i] & 0xFFFFFFFF, "background") or self.options.background
        foreground, text_style = self:convert_color(line[i] >> 32, "foreground", self.options.bold_text_in_bright_colors)
        foreground = foreground or self.options.text

        if config.plugins.terminal.minimum_contrast_ratio > 0 then
          if not contrast_foreground[line[i]] then
            if contrast_foreground_count >= 4096 then
              contrast_foreground = {}
              contrast_foreground_count = 0
            end
            contrast_foreground[line[i]] = ensureContrastRatio(background, foreground, config.plugins.terminal.minimum_contrast_ratio)
            contrast_foreground_count = contrast_foreground_count + 1
          end
          foreground = contrast_foreground[line[i]]
        end
        
        local font = (((text_style >> 3) & 0x1) ~= 0) and (self.options.bold_font or self.options.font) or self.options.font
        local text = line[i+1] or ""
        local length = text:ulen()
        local valid_utf8 = length ~= nil
        local subfunc, lengthfunc = string.usub, string.ulen
        if not valid_utf8 then
          length = #text
          lengthfunc = function(str) return #str end
          subfunc = string.sub
        end
        local idx = (line_idx - 1) - scrollback
        local sections = { { background, foreground, text } }
        if selection then
          if ((idx == selection[2] and selection[1] <= offset) or selection[2] < idx) and (selection[4] > idx or (idx == selection[4] and (selection[3] >= offset + length))) then -- overlaps all
            sections = { { foreground, background, text } }
          elseif (idx == selection[2] and idx == selection[4] and selection[1] > offset and selection[3] < offset + length) then -- overlaps in middle
            sections = { { background, foreground, subfunc(text, 1, selection[1] - offset) }, { foreground, background, subfunc(text, selection[1] - offset + 1, selection[3] - offset) }, { background, foreground, subfunc(text, selection[3] - offset + 1, length) } }
          elseif (selection[2] < idx or (idx == selection[2] and selection[1] <= offset)) and (idx == selection[4] and selection[3] < offset + length and selection[3] >= offset) then -- overlaps start
            sections = { { foreground, background, subfunc(text, 1, selection[3] - offset) }, { background, foreground, subfunc(text, selection[3] - offset + 1, length) } }
          elseif (idx == selection[2] and selection[1] < offset + length and selection[1] >= offset) and (selection[4] > idx or (selection[4] == idx and selection[3] >= offset + length)) then -- overlaps end
            sections = { { background, foreground, subfunc(text, 1, selection[1] - offset) }, { foreground, background, subfunc(text, selection[1] - offset + 1, length) } }
          end
        end
        -- split sections further, to insert an inverted bit for the cursor
        if should_draw_cursor and cursor_x >= offset and cursor_x < offset + length then
          local local_offset = offset
          for i,v in ipairs(sections) do
            local len = lengthfunc(v[3])
            if cursor_x >= local_offset and cursor_x < local_offset + len then
              sections[i] = nil
              local target = i
              if cursor_x ~= local_offset then
                table.insert(sections, target, { v[1], v[2], subfunc(v[3], 1, cursor_x - local_offset) })
                target = target + 1
              end
              table.insert(sections, target, { v[2], v[1], subfunc(v[3], cursor_x - local_offset + 1, cursor_x - local_offset + 1) })
              target = target + 1
              if cursor_x ~= local_offset + len - 1 then
                table.insert(sections, target, { v[1], v[2], subfunc(v[3], cursor_x - local_offset + 2) })
              end
              break
            end
            local_offset = local_offset + len
          end
        end
        for i, section in ipairs(sections) do
          if section then
            local background, foreground, text = table.unpack(section)
            local section_length = text:ulen() or #text
            if background and background ~= self.options.background then
              renderer.draw_rect(x, y, section_length*space_width, lh, background)
            end
            x = renderer.draw_text(font, text, x, y, foreground)
          end
        end
        offset = offset + length
      end
      y = y + lh
    end
  elseif self.spawn_error then
    local x = self.position.x + self.options.padding.x
    local y = self.position.y + self.header_height + self.options.padding.y
    renderer.draw_text(self.options.font, self.spawn_error, x, y, style.text)
  end
  TerminalView.super.draw_scrollbar(self)
end

function TerminalView:convert_coordinates(x, y)
  local w = self.options.font:get_width(" ")
  local col_exact = math.floor((x - self.position.x - self.options.padding.x) / w)
  local col_approx = common.round((x - self.position.x - self.options.padding.x) / w)
  local row = math.floor((y - self.position.y - self.header_height - self.options.padding.y) / self.options.font:get_height())
  return math.max(0, col_exact), math.max(0, row), math.max(0, col_approx)
end

function TerminalView:get_word_boundaries(col, row)
  if not self.terminal then return end
  for line_idx, line in ipairs(self.terminal:lines()) do
    if line_idx == row + 1 then
      local text = ""
      for i = 1, #line, 2 do
        text = text .. line[i+1]
      end
      local scrollback = self.terminal:scrollback()
      row = row - scrollback
      if text:sub(col + 1, col + 1):match("%s") then
        return col, row, col + 1, row
      end
      local next_space = text:find("%s", col + 1) or #text
      local last_space = 0
      local idx = text:reverse():find("%s", #text - col)
      if idx then
        last_space = (#text - idx) + 1
      end
      return last_space, row, next_space - 1, row
    end
  end
end

function TerminalView:on_mouse_pressed(button, x, y, clicks)
  local header_button = self:get_header_button_at(x, y)
  if header_button then
    if header_button == "profile" then
      self:open_profile_menu()
    elseif header_button == "new" then
      command.perform("terminal:open-tab", self.options.profile_name)
    elseif header_button == "clear" then
      self:clear()
    elseif header_button == "close" then
      self:close()
    end
    return true
  end
  if not self.terminal then return end
  local result = self.v_scrollbar:on_mouse_pressed(button, x, y, clicks)
  if result then
    if result ~= true then
      local _, total_scrollback = self.terminal:scrollback()
      self.terminal:scrollback(math.floor((1.0 - result) * total_scrollback))
    end
    return true
  end
  if button == "left" then
    local col, row = self:convert_coordinates(x, y)
    local inverted = config.plugins.terminal.inversion_key and keymap.modkeys[config.plugins.terminal.inversion_key]
    if not inverted and self.terminal:mouse_tracking_mode() == "x10" then
      self.terminal:input("\x1B[M" .. string.char(32) .. string.char(32 + col + 1) .. string.char(32 + row + 1) )
    elseif not inverted and self.terminal:mouse_tracking_mode() == "normal" then
      self.terminal:input("\x1B[M" .. string.char(32) .. string.char(32 + col + 1) .. string.char(32 + row + 1) )
    elseif not inverted and self.terminal:mouse_tracking_mode() == "sgr" then
      self.terminal:input("\x1B[<0;" .. (col+1) .. ";" .. (row+1) .. "M" )
    else
      if clicks % 4 == 1 then
        self.selection = nil
        self.pressing = true
      elseif clicks % 4 == 2 then
        local word = { self:get_word_boundaries(col, row) }
        if word[1] then
          self.word_selecting = word
          self.selection = { table.unpack(word) }
        end
      elseif clicks % 4 == 3 then
        local scrollback = self.terminal:scrollback()
        row = row - scrollback
        self.row_selecting = { 0, row, 0, row + 1 }
        self.selection = { 0, row, 0, row + 1 }
      end
    end
  end
end

function TerminalView:on_mouse_moved(x, y, dx, dy)
  local header_button = self:get_header_button_at(x, y)
  self.header_hover = header_button
  if header_button then return true end
  if not self.terminal then return end
  local result = self.v_scrollbar:on_mouse_moved(x, y, dx, dy)
  if result then
    if result ~= true then
      local _, total_scrollback = self.terminal:scrollback()
      self.terminal:scrollback(math.floor((1.0 - result) * total_scrollback))
    end
    return true
  end
  self.mouse_x = x
  self.mouse_y = y
  if self.pressing or self.word_selecting or self.row_selecting then
    if y < self.position.y then
      self.scrolling_offscreen = 1
    elseif y > self.position.y + self.size.y then
      self.scrolling_offscreen = -1
    else
      self.scrolling_offscreen = nil
    end
    local col, line, col_approx = self:convert_coordinates(x, y)
    local scrollback = self.terminal:scrollback()
    if not self.selection then self.selection = { col_approx, line - scrollback } end
    if not self.word_selecting and not self.row_selecting then
      self.selection[3] = col_approx
      self.selection[4] = line - scrollback
    elseif self.word_selecting then
      local col1, line1, col2, line2 = self:get_word_boundaries(col, line)
      if not col1 then
        self.selection[3] = col
        self.selection[4] = line - scrollback
      elseif self.word_selecting[2] > line1 or (self.word_selecting[2] == line1 and self.word_selecting[1] >= col1) then
        self.selection[1] = col1
        self.selection[2] = line1
        self.selection[3] = self.word_selecting[3]
        self.selection[4] = self.word_selecting[4]
      else
        self.selection[1] = self.word_selecting[1]
        self.selection[2] = self.word_selecting[2]
        self.selection[3] = col2
        self.selection[4] = line2
      end
    else
      self.selection[1] = 0
      self.selection[2] = math.min(self.row_selecting[2], line - scrollback)
      self.selection[3] = 0
      self.selection[4] = math.max(self.row_selecting[4], line - scrollback + 1)
    end
  end
end


function TerminalView:on_mouse_released(button, x, y)
  if self:get_header_button_at(x, y) then
    self.header_hover = nil
    return true
  end
  self.v_scrollbar:on_mouse_released(button, x, y)
  if button == "left" then
    self.pressing = false
    self.word_selecting = nil
    self.row_selecting = nil
    self.scrolling_offscreen = nil
    if not self.terminal then return end
    local col, row = self:convert_coordinates(x, y)
    if self.terminal:mouse_tracking_mode() == "normal" then
      self.terminal:input("\x1B[M" .. string.char(32 + 3) .. string.char(32 + col + 1) .. string.char(32 + row + 1) )
    elseif self.terminal:mouse_tracking_mode() == "sgr" then
      self.terminal:input("\x1B[<0;" .. (col+1) .. ";" .. (row+1) .. "m")
    end
  end
end


function TerminalView:on_mouse_left()
  self.header_hover = nil
  TerminalView.super.on_mouse_left(self)
end


function TerminalView:on_context_menu()
  return { items = {
    { text = "Copy",  command = "terminal:copy"  },
    { text = "Paste", command = "terminal:paste" },
    { text = "Clear", command = "terminal:clear" },
    ContextMenu.DIVIDER,
    { text = "Close", command = "terminal:close-tab" }
  } }, self
end


function TerminalView:get_scrollable_size()
  if not self.terminal then return self.size.y end
  local lh = self.options.font:get_height()
  local _, total_scrollback = self.terminal:scrollback()
  return total_scrollback * lh + math.max(0, self.size.y - self.header_height)
end


function TerminalView:input(text)
  if self.terminal then
    self.terminal:input(text)
    if self.terminal:scrollback() ~= 0 then self.terminal:scrollback(0) end
    self:shift_selection_update()
    core.redraw = true
    return true
  elseif not self.spawn_error then
    self.deferred_input = (self.deferred_input or "") .. text
  end
  return false
end

function TerminalView:on_text_input(text)
  return self:input(text)
end


function TerminalView:try_close(do_close)
  self.closing = true
  if self.terminal then
    self.terminal:close()
    self.terminal = nil
  end
  self.deferred_input = nil
  self.routine = nil
  if core.terminal_view == self then
    core.terminal_view = nil
    core.terminal_view_node = nil
    core.terminal_view_closed = nil
  end
  if do_close then do_close() end
end


function TerminalView:close()
  local node = core.root_view.root_node:get_node_for_view(self)
  if node then
    node:close_view(core.root_view.root_node, self)
  else
    self:try_close(function() end)
  end
end


function TerminalView:get_text(line1, col1, line2, col2)
  if not self.terminal then return "" end
  local full_buffer = {}
  for line_idx, line in ipairs(self.terminal:lines(line1, line2)) do
    local idx = line_idx - 1 + line1
    local offset = 0
    for i = 1, #line, 2 do
      local text = line[i + 1]
      local length = text:ulen()
      local usub = string.usub
      if length == nil then
        length = #text
        usub = string.sub
      end
      if idx == line1 and idx == line2 then
        if offset + length >= col1 and offset <= col2 then
          local s = math.max(col1 - offset, 0) + 1
          local e = math.min(col2 - offset, length)
          table.insert(full_buffer, usub(text, s, e))
        end
      elseif idx == line1 then
        if offset + length >= col1 then
          local s = math.max(col1 - offset, 0) + 1
          table.insert(full_buffer, usub(text, s, length))
        end
      elseif idx > line1 and idx < line2 then
        table.insert(full_buffer, text)
      elseif idx == line2 then
        if offset <= col2 then
          local e = math.min(col2 - offset, length)
          table.insert(full_buffer, usub(text, 1, e))
        end
      end
      offset = offset + length
    end
  end
  return table.concat(full_buffer)
end


command.add(function(amount)
  -- core.root_view.overlapping_view is not in any release yet (as of 2.1.3)
  local view = core.root_view.overlapping_view
                or (core.root_view.overlapping_node and core.root_view.overlapping_node.active_view)
                or core.active_view
  return (view and view:is(TerminalView)), view, amount
end, {
  ["terminal:scroll"] = function(view, amount)
    if not view.terminal then return end
    if view.terminal:mouse_tracking_mode() then
      local col, row = view:convert_coordinates(view.mouse_x, view.mouse_y)
      if view.terminal:mouse_tracking_mode() == "normal" then
        view.terminal:input("\x1B[M" .. string.char(amount > 0 and 64 or 65) .. string.char(32 + col + 1) .. string.char(32 + row + 1) )
      elseif view.terminal:mouse_tracking_mode() == "sgr" then
        view.terminal:input("\x1B[<" .. (amount > 0 and 64 or 65) .. ";" .. (col+1) .. ";" .. (row+1) .. "M" )
      end
    else
      view.accumulated_scroll = (view.accumulated_scroll or 0) + (amount or 1)
      if math.abs(view.accumulated_scroll) >= 1 then
        local delta = math.floor(view.accumulated_scroll + 0.5)
        view.terminal:scrollback(view.terminal:scrollback() + delta)
        view.accumulated_scroll = view.accumulated_scroll - math.floor(view.accumulated_scroll + 0.5)
      end
    end
  end
})


local active_terminal_predicate = function(...)
  return (core.active_view:is(TerminalView) and core.active_view.terminal), core.active_view, ...
end
command.add(active_terminal_predicate, {
  ["terminal:select-profile"] = function(view, name)
    if name then
      view:select_profile(name)
    else
      local profiles = {}
      for _, profile in ipairs(profile_list) do
        table.insert(profiles, profile.name)
      end
      core.command_view:enter("Terminal Profile", {
        submit = function(text)
          if text ~= "" then view:select_profile(text) end
        end,
        suggest = function(text)
          return common.fuzzy_match(profiles, text)
        end,
      })
    end
  end,
  ["terminal:restart"] = function(view)
    view:select_profile(view.options.profile_name)
  end,
  ["terminal:backspace"] = function(view) view:input(view.options.backspace) end,
  ["terminal:ctrl-backspace"] = function(view) view:input(view.options.backspace == "\b" and "\x7F" or "\b") end,
  ["terminal:alt-backspace"] = function(view) view:input("\x1B" .. view.options.backspace) end,
  ["terminal:insert"] = function(view) view:input("\x1B[2~") end,
  ["terminal:delete"] = function(view) view:input(view.options.delete) end,
  ["terminal:return"] = function(view) view:input(view.options.newline) end,
  ["terminal:enter"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOM" or view.options.newline) end,
  ["terminal:break"] = function(view) view:input("\x03") end,
  ["terminal:eof"] = function(view) view:input("\x04") end,
  ["terminal:suspend"] = function(view) view:input("\x1A") end,
  ["terminal:tab"] = function(view) view:input("\t") end,
  ["terminal:paste"] = function(view)
    if view.terminal:paste_mode() == "bracketed" then
      view:input("\x1B[200~" .. system.get_clipboard() .. "\x1B[201~")
    else
      view:input(system.get_clipboard())
    end
  end,
  ["terminal:page-up"] = function(view) view:input("\x1B[5~") end,
  ["terminal:page-down"] = function(view) view:input("\x1B[6~") end,
  ["terminal:scroll-up"] = function(view) view.terminal:scrollback(view.terminal:scrollback() + view.lines) end,
  ["terminal:scroll-down"] = function(view) view.terminal:scrollback(view.terminal:scrollback() - view.lines) end,
  ["terminal:scroll-to-end"] = function(view) view.terminal:scrollback(0) end,
  ["terminal:scroll-to-top"] = function(view) view.terminal:scrollback(view.options.scrollback_limit) end,
  ["terminal:up"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOA" or "\x1B[A") end,
  ["terminal:down"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOB" or "\x1B[B") end,
  ["terminal:left"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOD" or "\x1B[D") end,
  ["terminal:right"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOC" or "\x1B[C") end,
  ["terminal:jump-up"] = function(view) view:input("\x1B[1;5A") end,
  ["terminal:jump-down"] = function(view) view:input("\x1B[1;5B") end,
  ["terminal:jump-right"] = function(view) view:input("\x1B[1;5C") end,
  ["terminal:jump-left"] = function(view) view:input("\x1B[1;5D") end,
  ["terminal:home"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOH" or "\x1B[H") end,
  ["terminal:end"] = function(view) view:input(view.terminal:cursor_keys_mode() == "application" and "\x1BOF" or "\x1B[F") end,
  ["terminal:f1"]  = function(view) view:input("\x1BOP") end,
  ["terminal:f2"]  = function(view) view:input("\x1BOQ") end,
  ["terminal:f3"]  = function(view) view:input("\x1BOR") end,
  ["terminal:f4"]  = function(view) view:input("\x1BOS") end,
  ["terminal:f5"]  = function(view) view:input("\x1B[15~") end,
  ["terminal:f6"]  = function(view) view:input("\x1B[17~") end,
  ["terminal:f7"]  = function(view) view:input("\x1B[18~") end,
  ["terminal:f8"]  = function(view) view:input("\x1B[19~") end,
  ["terminal:f9"]  = function(view) view:input("\x1B[20~") end,
  ["terminal:f10"]  = function(view) view:input("\x1B[21~") end,
  ["terminal:f11"]  = function(view) view:input("\x1B[23~") end,
  ["terminal:f12"]  = function(view) view:input("\x1B[24~") end,
  ["terminal:escape"]  = function(view) view:input("\x1B") end,
  ["terminal:start"] = function(view) view:input("\x13") end,
  ["terminal:stop"] = function(view) view:input("\x11") end,
  ["terminal:cancel"] = function(view) view:input("\x18") end,
  ["terminal:start-of-heading"] = function(view) view:input("\x01") end,
  ["terminal:start-of-text"] = function(view) view:input("\x02") end,
  ["terminal:enquiry"] = function(view) view:input("\x05") end,
  ["terminal:acknowledge"] = function(view) view:input("\x06") end,
  ["terminal:bell"] = function(view) view:input("\x07") end,
  ["terminal:vertical-tab"] = function(view) view:input("\x0B") end,
  ["terminal:redraw"] = function(view) view:input("\x0C") end,
  ["terminal:carriage-feed"] = function(view) view:input("\x0D") end,
  ["terminal:shift-out"] = function(view) view:input("\x0E") end,
  ["terminal:shift-in"] = function(view) view:input("\x0F") end,
  ["terminal:data-line-escape"] = function(view) view:input("\x10") end,
  ["terminal:history"] = function(view) view:input("\x12") end,
  ["terminal:transpose"] = function(view) view:input("\x14") end,
  ["terminal:negative-acknowledge"] = function(view) view:input("\x15") end,
  ["terminal:synchronous-idel"] = function(view) view:input("\x16") end,
  ["terminal:end-of-transmission-block"] = function(view) view:input("\x17") end,
  ["terminal:end-of-medium"] = function(view) view:input("\x19") end,
  ["terminal:file-separator"] = function(view) view:input("\x1C") end,
  ["terminal:group-separator"] = function(view) view:input("\x1D") end,
  ["terminal:clear"] = function(view) view:clear() end,
  ["terminal:close-tab"] = function(view) view:close() end
});
if system.get_primary_selection then -- check for master vs. 2.1.7
  command.add(active_terminal_predicate, {
    ["terminal:primary-paste"] = function(view)
      if view.terminal:paste_mode() == "bracketed" then
        view:input("\x1B[200~" .. system.get_primary_selection() .. "\x1B[201~")
      else
        view:input(system.get_primary_selection())
      end
    end
  })
end

command.add(function()
  return core.active_view and core.active_view:is(TerminalView) and core.active_view.terminal and core.active_view.selection and #core.active_view.selection == 4
end, {
  ["terminal:copy"] = function()
    local selection = core.active_view:sorted_selection()
    system.set_clipboard(core.active_view:get_text(selection[2], selection[1], selection[4], selection[3]))
  end
})

local function toggle_drawer(open)
  if not core.terminal_view  then
    core.terminal_view = TerminalView(config.plugins.terminal)
  end
  if not core.terminal_view_node then
    core.terminal_view_node = core.root_view:get_active_node_default():split("down", core.terminal_view, { y = true }, true)
  end
  if open then
    core.terminal_view_node:resize("y", core.terminal_view_closed or core.terminal_view.size.y)
    core.terminal_view_closed = nil
  else
    core.terminal_view_closed = core.terminal_view.size.y
    core.terminal_view_node:resize("y", 0)
  end
end

local function is_terminal_tab(view)
  return view and view:is(TerminalView) and view ~= core.terminal_view
end


local function find_terminal_tab(node)
  if node and node.type == "leaf" then
    for _, view in ipairs(node.views) do
      if is_terminal_tab(view) then
        return view
      end
    end
  end
end


local function find_file_view(node)
  if node and node.type == "leaf" then
    local last = core.terminal_last_file_view
    if last and not is_terminal_tab(last)
      and core.root_view.root_node:get_node_for_view(last) == node then
      return last
    end
    for _, view in ipairs(node.views) do
      if not is_terminal_tab(view) then
        return view
      end
    end
  end
end


command.add(nil, {
  ["terminal:toggle-drawer"] = function()
    toggle_drawer(not core.terminal_view or core.terminal_view_closed ~= nil)
    if core.terminal_view_closed then
      if core.active_view == core.terminal_view then
        core.set_active_view(core.last_active_view or core.root_view:get_primary_node().active_view)
      end
    else
      core.set_active_view(core.terminal_view)
    end
  end,
  ["terminal:toggle-tab"] = function(profile)
    local active = core.active_view
    if active == core.terminal_view then
      command.perform("terminal:toggle-drawer")
      return
    end

    local node = core.root_view.root_node:get_node_for_view(active)
      or core.root_view:get_active_node_default()

    if is_terminal_tab(active) then
      local target = find_file_view(node)
      if target and target ~= active then
        core.set_active_view(target)
      else
        command.perform("core:new-doc")
      end
      return
    end

    -- Keep a single terminal visible: hide the drawer before showing a tab.
    if core.terminal_view and core.terminal_view_closed == nil then
      toggle_drawer(false)
    end

    local target = find_terminal_tab(node)
    if not target then
      local options = common.merge(config.plugins.terminal, { show_header = false })
      target = TerminalView(options, profile)
      node:add_view(target)
    else
      core.set_active_view(target)
    end

    if active and active ~= core.terminal_view and not is_terminal_tab(active) then
      core.terminal_last_file_view = active
    end
  end,
  ["terminal:swap-drawer"] = function()
    toggle_drawer(true)
    core.set_active_view(core.active_view == core.terminal_view and core.last_active_view or core.terminal_view)
  end,
  ["terminal:execute"] = function(text)
    local open_drawer = function(text)
      if not core.terminal_view then command.perform("terminal:toggle-drawer") end
      local target_view = core.active_view:is(TerminalView) and core.active_view or core.terminal_view
      if not target_view then return end
      target_view:input(text .. target_view.options.newline) 
    end
    if not text then
      core.command_view:enter("Execute Command", { submit = open_drawer })
    else
      open_drawer(text)
    end
  end,
  ["terminal:open-tab"] = function(profile)
    local active = core.active_view
    if active and active ~= core.terminal_view and not is_terminal_tab(active) then
      core.terminal_last_file_view = active
    end
    local options = common.merge(config.plugins.terminal, { show_header = false })
    local tv = TerminalView(options, profile)
    core.root_view:get_active_node_default():add_view(tv)
  end,
  ["terminal:open-at"] = function(path)
    local options = common.merge(config.plugins.terminal, { show_header = false, cwd = path })
    local tv = TerminalView(options)
    core.root_view:get_active_node_default():add_view(tv)
  end
})
command.add(function() return core.terminal_view and core.active_view ~= core.terminal_view end, {
  ["terminal:focus"] = function()
    if core.terminal_view_closed then command.perform("terminal:toggle-drawer") end
    core.set_active_view(core.terminal_view)
  end
})

if not core.status_view:get_item("terminal:info") then
  core.status_view:add_item({
    predicate = function()
      return core.active_view:is(TerminalView) and core.active_view.terminal
    end,
    name = "terminal:info",
    alignment = StatusView.Item.RIGHT,
    get_item = function()
      local dv = core.active_view
      local x, y = dv.terminal:size()
      return {
        style.text, style.codicon_font, ICON_TERMINAL,
        style.text, style.font, (dv.options.profile_name or dv.terminal:name() or dv.options.shell),
        style.dim, style.font, core.status_view.separator2,
        style.text, style.font, x .. "x" .. y
      }
    end
  })
end

-- add in the terminal metacommands not related to actually sending things to the terminal first
keymap.add({
  ["ctrl+`"] = "terminal:toggle-tab",
  ["ctrl+shift+`"] = "terminal:open-tab",
  ["alt+t"] = "terminal:toggle-drawer",
  ["shift+alt+t"] = "terminal:swap-drawer"
})
local keys = {
  ["return"] = "terminal:return",
  ["ctrl+return"] = "terminal:return",
  ["shift+return"] = "terminal:return",
  ["keypad enter"] = "terminal:return",
  ["ctrl+keypad enter"] = "terminal:return",
  ["shift+keypad enter"] = "terminal:return",
  ["enter"] = "terminal:enter",
  ["backspace"] = "terminal:backspace",
  ["shift+backspace"] = "terminal:backspace",
  ["delete"] = "terminal:delete",
  ["ctrl+backspace"] = "terminal:ctrl-backspace",
  ["alt+backspace"] = "terminal:alt-backspace",
  ["ctrl+shift+c"] = "terminal:copy",
  ["ctrl+shift+v"] = "terminal:paste",
  ["ctrl+shift+w"] = "terminal:close-tab",
  ["mclick"] = "terminal:primary-paste",
  ["wheel"] = "terminal:scroll",
  ["tab"] = "terminal:tab",
  ["pageup"] = "terminal:page-up",
  ["pagedown"] = "terminal:page-down",
  ["shift+pageup"] = "terminal:scroll-up",
  ["shift+pagedown"] = "terminal:scroll-down",
  ["shift+end"] = "terminal:scroll-to-end",
  ["shift+home"] = "terminal:scroll-to-top",
  ["up"] = "terminal:up",
  ["down"] = "terminal:down",
  ["left"] = "terminal:left",
  ["right"] = "terminal:right",
  ["ctrl+up"] = "terminal:jump-up",
  ["ctrl+down"] = "terminal:jump-down",
  ["ctrl+left"] = "terminal:jump-left",
  ["ctrl+right"] = "terminal:jump-right",
  ["alt+left"] = "terminal:jump-left",
  ["alt+right"] = "terminal:jump-right",
  ["home"] = "terminal:home",
  ["end"] = "terminal:end",
  ["f1"] = "terminal:f1",
  ["f2"] = "terminal:f2",
  ["f3"] = "terminal:f3",
  ["f4"] = "terminal:f4",
  ["f5"] = "terminal:f5",
  ["f6"] = "terminal:f6",
  ["f7"] = "terminal:f7",
  ["f8"] = "terminal:f8",
  ["f9"] = "terminal:f9",
  ["f10"] = "terminal:f10",
  ["f11"] = "terminal:f11",
  ["f12"] = "terminal:f12",
  ["escape"] = "terminal:escape",
  ["ctrl+a"] = "terminal:start-of-heading",
  ["ctrl+b"] = "terminal:start-of-text",
  ["ctrl+c"] = "terminal:break",
  ["ctrl+d"] = "terminal:eof",
  ["ctrl+e"] = "terminal:enquiry",
  ["ctrl+f"] = "terminal:acknowledge",
  ["ctrl+g"] = "terminal:bell",
  ["ctrl+h"] = "terminal:backspace",
  ["ctrl+i"] = "terminal:tab",
  ["ctrl+j"] = "terminal:return",
  ["ctrl+k"] = "terminal:vertical-tab",
  ["ctrl+l"] = "terminal:redraw",
  ["ctrl+m"] = "terminal:carriage-feed",
  ["ctrl+n"] = "terminal:shift-out",
  ["ctrl+o"] = "terminal:shift-in",
  ["ctrl+p"] = "terminal:data-line-escape",
  ["ctrl+q"] = "terminal:stop",
  ["ctrl+r"] = "terminal:history",
  ["ctrl+s"] = "terminal:start",
  ["ctrl+t"] = "terminal:transpose",
  ["ctrl+u"] = "terminal:negative-acknowledge",
  ["ctrl+v"] = "terminal:synchronous-idel",
  ["ctrl+w"] = "terminal:end-of-transmission-block",
  ["ctrl+x"] = "terminal:cancel",
  ["ctrl+y"] = "terminal:end-of-medium",
  ["ctrl+z"] = "terminal:suspend",
  ["ctrl+["] = "terminal:escape",
  ["ctrl+\\"] = "terminal:file-separator",
  ["ctrl+]"] = "terminal:group-separator"
}
local non_omitted_keys = {}
for k,v in pairs(keys) do if config.plugins.terminal.omit_escapes == nil or not k:find(config.plugins.terminal.omit_escapes) then non_omitted_keys[k] = v end end
keymap.add(non_omitted_keys)

if PLATFORM == "Mac OS X" then
  keymap.add({
    ["cmd+c"] = "terminal:copy",
    ["cmd+v"] = "terminal:paste",
    ["cmd+shift+w"] = "terminal:close-tab"
  })
end

if config.plugins.terminal.inversion_key then
  local settings = {}
  local commands = {}
  for i = string.byte('a'), string.byte('z') do
    local keymaps = {}
    for i,v in ipairs(keymap.map["ctrl+" .. string.char(i)] or {}) do
      if type(v) == 'string' and not v:find("terminal") then
        local original = v
        table.insert(keymaps, "terminal:" .. original)
        commands["terminal:" .. original] = function(...) command.perform(original, ...) end
      end
    end
    if #keymaps > 0 and not keymap.map["ctrl+" .. config.plugins.terminal.inversion_key .. "+" .. string.char(i)] then
      settings["ctrl+" .. config.plugins.terminal.inversion_key .. "+" .. string.char(i)] = keymaps
    end
  end
  command.add(active_terminal_predicate, commands)
  keymap.add(settings)
end

-- Make the generic tab-bar plus create a terminal when the active tab is a
-- terminal, while keeping the editor's normal new-document behaviour elsewhere.
local old_tabbar_new_tab = command.map["tabbar:new-tab"] and command.map["tabbar:new-tab"].perform
command.add(nil, {
  ["tabbar:new-tab"] = function(node, x, y)
    local view = (node and node.active_view) or core.active_view
    if view and view:is(TerminalView) then
      if x and y then
        local items = {}
        for _, profile in ipairs(profile_list) do
          table.insert(items, {
            text = profile.name,
            command = function()
              command.perform("terminal:open-tab", profile.name)
            end,
          })
        end
        table.insert(items, ContextMenu.DIVIDER)
        table.insert(items, {
          text = "Configure Default Profile",
          command = "core:open-user-module",
        })
        core.root_view.context_menu:show(x, y, items)
      else
        command.perform("terminal:open-tab", view.options.profile_name)
      end
    elseif old_tabbar_new_tab then
      old_tabbar_new_tab(node)
    else
      command.perform("core:new-doc")
    end
  end
})

return {
  class = TerminalView
}


