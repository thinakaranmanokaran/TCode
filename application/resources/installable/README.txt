T Code — Installable build
==========================

Linux (FHS)
-----------
Extract and install to the default prefix:
  sudo tar -xzf tcode-*-linux-installable.tar.gz -C /
  # files land in /usr/local/bin/tcode, /usr/local/share/tcode/, ...
  # the desktop entry + icon + man page are installed too.

User install (no sudo):
  tar -xzf tcode-*-linux-installable.tar.gz -C /tmp/tcode-install
  mkdir -p ~/.local/bin ~/.local/share
  cp /tmp/tcode-install/usr/local/bin/tcode ~/.local/bin/
  cp -r /tmp/tcode-install/usr/local/share/tcode ~/.local/share/
  cp /tmp/tcode-install/usr/local/share/applications/*.desktop ~/.local/share/applications/ 2>/dev/null
  cp /tmp/tcode-install/usr/local/share/icons/hicolor/scalable/apps/tcode.svg ~/.local/share/icons/hicolor/scalable/apps/ 2>/dev/null
  export PATH="$HOME/.local/bin:$PATH"

Or build/install from source:
  bash application/scripts/install.sh --from-build
  sudo bash application/scripts/install.sh --from-build --prefix /usr/local

Windows
-------
Run the InnoSetup installer (tcode-*-windows-setup.exe). It adds T Code
to the Start menu, optionally to PATH, and registers Open with T Code.

macOS
-----
Copy `T Code.app` to /Applications (or drag from the DMG).

License: MIT (see share/doc/tcode/licenses.md)
