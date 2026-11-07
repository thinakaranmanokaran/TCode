# Scripts

Various scripts and configurations used to configure, build, and package T Code.

### Build

- **build.sh**:             Runs meson in a standard way across platforms.
  - `--production`          Release + LTO + strip + hardening, no git suffix.
  - `--portable`           Portable (flat: exe + `data/` + `doc/`).
  - `--installable`        Production installable (FHS on Linux, `.app` on macOS,
                            InnoSetup payload on Windows).
  - `--strip`, `--destdir`, `--prefix` control binary stripping and staging.
  - `--forcefallback`       Static deps via Meson wraps (hermetic builds).
- **install.sh**:           Install a just-built staging tree or a dist archive.
- **install-dependencies.sh**: Install build deps (apt/dnf/pacman/brew/MSYS2).

### Package (production installable + portable)

- **package.sh**:           Builds **both** installable + portable artifacts
                            for the current platform into `application/dist/`
                            (+ `SHA256SUMS` + `manifest.json`).
                            ```sh
                            bash application/scripts/package.sh --production
                            bash application/scripts/package.sh --only-portable
                            bash application/scripts/package.sh --only-installable
                            ```
- **package-portable.sh**:  Portable only (wrapper over `package.sh`).
- **package-installable.sh**: Installable only; `--format deb|rpm` for Linux
                            native packages (best-effort, needs `dpkg-deb` /
                            `rpmbuild`).
- **package-appimage.sh**:  [AppImage][2] builder (Linux).
- **package-innosetup.sh**: Creates a 32/64 bit [InnoSetup][3] installer package (Windows).
- **package-appdmg.sh**:    Create a macOS DMG image using [dmgbuild][1] (via `package.sh`).

### Utility

- **common.sh**:                 Common functions used by other scripts.
- **fontello-config.json**:      Used by the icons generator.
- **generate_header.sh**:        Generates a header file for native plugin API
- **keymap-generator**:          Generates a JSON file containing the keymap
- **generate-release-notes.sh**: Generates a release note for T Code releases.

[1]: https://github.com/dmgbuild/dmgbuild
[2]: https://docs.appimage.org/
[3]: https://jrsoftware.org/isinfo.php
