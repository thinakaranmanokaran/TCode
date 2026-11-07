# T Code

A lightweight text editor written in Lua, adapted from [Lite XL].

**Author:** [Thinakaran Manokaran](https://thinakaran.dev/)

**Website:** https://thinakaran.dev/

T Code keeps the small, fast, and extensible design of Lite XL while adding a
VS Code-style menu bar and activity bar, an integrated terminal, a theme picker
with live previews, word wrap, a Selection menu, tab and Explorer context menus,
and native file/folder dialogs.

## Overview

T Code is derived from [Lite XL], which in turn is derived from [lite]. It is a
lightweight text editor written mostly in Lua — practical, pretty, *small* and
fast, easy to modify and extend, or to use without doing either.

T Code includes:

- An integrated terminal (`Terminal: Toggle Terminal`, ``ctrl+` ``) with
  full-pane terminal tabs and automatic shell profile detection.
- A VS Code-style top menu bar with File, Edit, Selection, View, Go, Run,
  Terminal, and Help menus.
- A vertical activity bar for the Explorer, project search, terminal, command
  palette, and settings.
- A tab bar with a new-tab button, tab actions menu, and file-tab context menu.
- An Explorer header and context menu with New File/Folder, Refresh, Collapse
  All, reveal/open actions, cut/copy/paste, rename, delete, and more.
- 10 Bearded Theme variations and 10 Monokai variations, plus the Default theme.
  Hover a theme to preview it; click to apply and save it.
- Word wrap (`Alt+Z`), a Selection menu, multi-cursor tools, and column selection.
- Native Open File / Open Project Folder dialogs by default.

## Customization

Additional functionality can be added through plugins available in the
[plugins repository] or the [Lite XL plugins repository]. Additional color
themes can be found in the [colors repository].

## Repository Layout

The editor's source code, runtime data, resources, scripts, and build files live
under [`application/`](application/), including build output. Project-level
files such as this README, the license, the changelog, and CI configuration stay
at the repository root. Build commands are still run from the root, for example
`meson setup application/build`.

The showcase website lives in [`website/`](website/). It is a React + Vite
static site with build-time pre-rendering and its own build/deploy pipeline; see
[`website/README.md`](website/README.md) for commands and configuration.

## Quick Build Guide

To compile T Code yourself, install the following dependencies with your package
manager or manually:

- Meson (>= 0.63)
- Ninja
- SDL3
- PCRE2
- FreeType2
- Lua 5.4
- A working C compiler (GCC / Clang / MSVC)

SDL3, PCRE2, FreeType2, and Lua will be downloaded by Meson if
`--wrap-mode=forcefallback` or `--wrap-mode=default` is specified.

On Linux, install the SDL3 X11 and/or Wayland development packages for your
distribution. On macOS, install a recent bash via Homebrew before running the
build script.

### Building

You can use `application/scripts/build.sh` to set up and build T Code:

```sh
$ bash application/scripts/build.sh --help
```

### Production installable + portable builds

`application/` ships production **installable** and **portable** builds.

- **Portable**: flat relocatable layout (`tcode` / `tcode.exe` + `data/` + `doc/`).
  Unzip and run. Create a `user/` folder next to the binary for portable config.
- **Installable**: FHS layout on Linux (`bin/` + `share/tcode/` + desktop/icon/man),
  `.app` bundle on macOS, InnoSetup installer on Windows.

Build both for the current platform (outputs in `application/dist/` with
`SHA256SUMS` + `manifest.json`):

```sh
# Production (release + LTO + strip + hardening), both kinds
bash application/scripts/package.sh --production
```

Or one kind at a time:

```sh
bash application/scripts/package-portable.sh --production     # portable only
bash application/scripts/package-installable.sh --production  # installable only
```

Or run Meson directly:

```sh
# Portable (flat)
meson setup --buildtype=release -Dportable=true --prefix / application/build
meson compile -C application/build
DESTDIR="$(pwd)/application/build/tcode" meson install --skip-subprojects -C application/build

# Installable (Linux FHS)
meson setup --buildtype=release -Dportable=false --prefix /usr/local application/build
meson compile -C application/build
DESTDIR="$(pwd)/application/build/install" meson install --skip-subprojects -C application/build
```

To build a macOS bundle:

```sh
meson setup --buildtype=release --Dbundle=true --prefix / application/build
meson compile -C application/build
DESTDIR="$(pwd)/application/T Code.app" meson install --skip-subprojects -C application/build
```

The package is relocatable to any prefix, and the prefix option only affects
where the application is installed.

## Portable Mode

To run T Code in portable mode, create a `user` folder next to `tcode.exe`
(or the `tcode` binary). T Code will load and store configuration and plugins
in that folder.

## Linux Installation

Unzip the portable package and run `tcode` from its directory. To install
the installable package:

```sh
sudo tar -xzf application/dist/tcode-*-linux-installable.tar.gz -C /
```

User install (no sudo) or from a just-built tree:

```sh
bash application/scripts/install.sh --from-build --user
```

To add T Code to your application launcher, the installable package already
installs `application/resources/linux/dev.thinakaran.tcode.desktop`,
the icon, metainfo (`share/metainfo/`) and man page (`share/man/man1/tcode.1`).

## Contributing

Plugins and color themes can be contributed to the upstream
[Lite XL plugins repository]. Pull requests that improve T Code itself are
welcome.

## Licenses

T Code is free software; you can redistribute it and/or modify it under the
terms of the MIT license. See [LICENSE] for details.

See the [licenses] file for details on licenses used by the required
dependencies and upstream projects.

**Copyright © 2026 Thinakaran Manokaran.**

T Code is based on Lite XL and lite; their copyright notices are preserved in
the [licenses] file.

[Lite XL]:                     https://github.com/lite-xl/lite-xl
[lite]:                        https://github.com/rxi/lite
[plugins repository]:          https://github.com/rxi/lite-plugins
[Lite XL plugins repository]:  https://github.com/lite-xl/lite-xl-plugins
[colors repository]:           https://github.com/lite-xl/lite-xl-colors
[LICENSE]:                     LICENSE
[licenses]:                    application/licenses/licenses.md
