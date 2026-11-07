T Code — Portable build
======================

Run tcode.exe (Windows) or ./tcode (Linux/macOS) from this folder.
No installer needed.

Portable mode
-------------
Create a folder named `user` next to the binary. T Code will load and
store settings, plugins, and themes in that folder. Carry the whole
directory on a USB drive and your setup travels with you.

Without a `user` folder, settings live in the default user directory
(%LOCALAPPDATA%\tcode on Windows, ~/.config/tcode on Linux/macOS,
or $LITE_USERDIR if set).

System requirements
-------------------
- Windows 10 (1809+) / Linux x86_64 (X11 or Wayland) / macOS 10.11+ (11+ on Apple Silicon)
- SDL3 runtime is statically linked; no extra dependencies.

Plugin / theme dirs
-------------------
- user/plugins/  user/colors/  user/fonts/
- data/plugins/  data/colors/  data/fonts/  (bundled defaults)

Report issues: https://github.com/thinakaranmanokaran/tcode
License: MIT (see doc/licenses.md)
