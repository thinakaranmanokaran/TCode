# Resources

This folder contains resources that is used for building or packaging the project.

### Build

- `cross/*.txt`: Meson [cross files][1] for cross-compiling T Code on other platforms.

### Packaging

- `release-notes.md`: T Code release note template, used with `envsubst`.
- `icons/icon.{icns,ico,inl,rc}`: T Code application icon in various formats.
- `icons/tcode.svg`: T Code icon for Linux application launchers.
- `linux/dev.thinakaran.tcode.desktop`: Desktop file for Linux desktops.
- `linux/dev.thinakaran.tcode.metainfo.xml.in`: AppStream metadata (installed to `share/metainfo/`).
- `linux/tcode.1`: Man page (installed to `share/man/man1/` on Linux installable).
- `linux/debian/control.in`: Debian `.deb` control file template.
- `linux/tcode.spec.in`: RPM spec template.
- `portable/README.txt`: README shipped at the root of portable archives.
- `installable/README.txt`: README shipped inside the installable archive.
- `macos/background.png`: Background image for packaging macOS DMGs.
- `macos/background@2x.png`: HiDPI image for packaging macOS DMGs.
- `macos/background.tiff`: TIFF image for packaging macOS DMGs.
- `macos/Info.plist.in`: Template for generating `info.plist` on macOS. See `macos/macos-retina-display.md` for details.
- `macos/tcode-dmg.py`: Configuration options for dmgbuild for packaging macOS DMGs.
- `windows/`: version/manifest resource files for `tcode.exe`.

### Development

- `include/lite_xl_plugin_api.h`: Native plugin API header. See the contents of `lite_xl_plugin_api.h` for more details.

### macOS DMG covers

The DMG files uses `macos/background.tiff` as the background, which is created from
`macos/background.png` and `macos/background@2x.png` with the following command:

```sh
tiffutil -cathidpicheck macos/background.png macos/background@2x.png -out macos/background.tiff
```

`macos/background@2x.png` should be double the size of `macos/background.png` with 144 PPI.
You can set the PPI by running:

```sh
sips -s dpiWidth 144 -s dpiHeight 144 macos/background@2x.png
```

`sips` and `tiffutil` are available by default on macOS.

### Other Files

- `shell.html`: A shell file for use with WASM builds.


[1]: https://mesonbuild.com/Cross-compilation.html
