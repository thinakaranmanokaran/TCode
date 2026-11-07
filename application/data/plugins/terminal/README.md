# Terminal

An integrated terminal for T Code, backed by the built-in `terminal` module.

## Requirements

- **Windows**: Windows 10 version 1809 or newer (ConPTY). On older versions
  the terminal view displays an error instead of starting a shell; the rest of
  T Code is unaffected.
- **Linux / macOS / FreeBSD**: a POSIX PTY (`forkpty`), provided by `libutil`
  where the platform keeps it in a separate library.

## Opening the terminal

| Shortcut | Command | Description |
|---|---|---|
| ``ctrl+` `` | `terminal:toggle-tab` | Show or hide the terminal tab |
| ``ctrl+shift+` `` | `terminal:open-tab` | Open a new terminal tab |
| `alt+t` | `terminal:toggle-drawer` | Toggle the bottom drawer |
| `shift+alt+t` | `terminal:swap-drawer` | Open the drawer and swap focus |
| `ctrl+shift+w` | `terminal:close-tab` | Close the focused terminal tab/drawer |
| `cmd+c` / `cmd+v` | `terminal:copy` / `terminal:paste` | Copy/paste on macOS |

Inside the terminal, most `ctrl+<key>` combinations are sent to the shell.
Use the configured inversion key (`shift` by default) together with `ctrl` to
run the corresponding T Code command instead, e.g. `ctrl+shift+n`.

## Terminal tabs

`terminal:open-tab` opens the terminal as a full-pane tab in the editor area,
next to your files. Terminals use the normal tab bar, so selecting another tab
switches away from the terminal and closing the tab closes that terminal.

``ctrl+` `` toggles the terminal tab: it shows the terminal, or returns to the
previous file tab when the terminal is active. The bottom drawer is still
available with `alt+t` or from the Terminal menu. The tab-bar `+` button shows
a profile menu when a terminal tab is active:

```text
Windows PowerShell
Command Prompt
bash
──────────────
Configure Default Profile
```

Choosing a profile opens a new full-pane terminal tab. It does not split the
editor area.

## Terminal header

The terminal view has a compact icon header:

```text
[ terminal  PowerShell v ]  [ + ]  [ clear ]  [ x ]
```

- **Profile button** opens the profile menu.
- **`+`** opens a new terminal tab.
- **Clear** clears the screen and scrollback.
- **`x`** closes the terminal.

## Commands

All commands are available from the command palette:

- `terminal:toggle-tab`
- `terminal:toggle-drawer`
- `terminal:swap-drawer`
- `terminal:open-tab`
- `terminal:focus`
- `terminal:execute`
- `terminal:select-profile`
- `terminal:restart`
- `terminal:copy`
- `terminal:paste`
- `terminal:clear`
- `terminal:close-tab`

`terminal:execute` opens a prompt and sends the entered text to the terminal
followed by a newline, making it easy to use as a build/run command launcher.

## Configuration

The defaults live in `config.plugins.terminal`:

```lua
local config = require "core.config"

config.plugins.terminal = {
  -- Shell to launch. Defaults to $SHELL, %COMSPEC%, or sh/cmd.exe.
  -- shell = "/bin/zsh",
  -- Extra shell arguments.
  arguments = {},
  -- Additional profiles. These override detected profiles by name.
  profiles = {
    { name = "PowerShell", shell = "powershell.exe", arguments = { "-NoLogo" } },
    { name = "WSL", shell = "wsl.exe" },
  },
  -- Profile selected when no profile was used before.
  default_profile = "PowerShell",
  -- Reuse the last used profile on startup.
  use_last_profile = true,
  -- Show the terminal profile/action header.
  show_header = true,
  -- Extra environment variables; values may be functions.
  environment = {},
  -- TERM advertised to the shell.
  term = "xterm-256color",
  -- Number of lines kept in the scrollback buffer.
  scrollback_limit = 10000,
  -- Height of the drawer in pixels.
  drawer_height = 300,
  -- Font used for the terminal; must be monospaced.
  -- font = renderer.font.load(DATADIR .. "/fonts/JetBrainsMono-Regular.ttf", 15 * SCALE),
  -- Minimum foreground/background contrast ratio (0 disables adjustment).
  minimum_contrast_ratio = 3,
  -- Inversion key for sending ctrl shortcuts to T Code instead of the shell.
  inversion_key = "shift",
}
```

Detected profiles include PowerShell, Windows PowerShell, Command Prompt,
and bash on Windows (including Git for Windows installations outside the
default location), and the login shell plus bash/zsh/fish/sh on POSIX systems.
Missing shells are reported when selected. WSL is not detected automatically
because `wsl.exe` exists even when WSL is not installed; add it with a profile:

```lua
config.plugins.terminal = {
  profiles = {
    { name = "WSL", shell = "C:\\Windows\\System32\\wsl.exe" },
  },
}
```

The last profile is stored in `<USERDIR>/terminal.lua`; set
`use_last_profile = false` to always start with `default_profile`.

To disable the plugin entirely:

```lua
config.plugins.terminal = false
```

## Notes and limitations

- The terminal emulates `xterm-256color`, including the alternate screen,
  scrollback, mouse tracking, bracketed paste, and UTF-8 output.
- Wide characters and emoji are rendered using the font's glyph widths; cell
  alignment may differ slightly from other terminals for ambiguous-width
  characters.
- Selection coordinates are cell-based. Combining characters may not align
  perfectly when copying.
- IME composition is forwarded through T Code's normal text-input path.
- The terminal keeps the shell process alive when the drawer is hidden. Use
  `terminal:close-tab` to terminate it.

## Manual test checklist

Use this when changing the terminal backend or view:

1. Open the drawer with ``ctrl+` ``, run `echo hello`, and verify output.
2. Resize the drawer and the window; run `stty size` and compare with the
   terminal status bar item.
3. Run `vim`, `less`, or `htop` to exercise the alternate screen, cursor
   positioning, and mouse mode.
4. Select text with the mouse, press `ctrl+shift+c`, and paste it into another
   document.
5. Press `ctrl+c` while `sleep 100` is running; verify the process is
   interrupted rather than copied to the clipboard.
6. Press `ctrl+d` to exit the shell and verify the view closes cleanly.
7. Open and close 20 terminal tabs; check that no child processes or file
   descriptors remain.
8. On Windows, repeat with `cmd.exe` and PowerShell; on Linux/macOS repeat
   with `bash`, `zsh`, and `dash` where available.
