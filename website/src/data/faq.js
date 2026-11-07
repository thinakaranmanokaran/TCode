export const faqs = [
  {
    question: "What is T Code?",
    answer:
      "T Code is a free, open-source code editor for Windows, Linux, and macOS. It is a lightweight editor built with a C core and Lua, adapted from Lite XL, with a native menu bar, integrated terminal, themes, and a modern desktop workflow.",
  },
  {
    question: "Is T Code free?",
    answer:
      "Yes. T Code is released under the MIT license and is free to download, use, and modify. There is no account, subscription, or paid tier.",
  },
  {
    question: "Which platforms does T Code support?",
    answer:
      "T Code supports Windows 10 and later, modern Linux distributions (x86_64), and macOS on Apple Silicon and Intel Macs. Portable and installer packages are available for Windows, portable and AppImage packages for Linux, and portable and DMG packages for macOS.",
  },
  {
    question: "How big is T Code?",
    answer:
      "The current Windows executable is about 5 MB. The editor does not bundle a browser runtime, so it starts quickly and uses far less disk space than Electron-based editors.",
  },
  {
    question: "Does T Code have an integrated terminal?",
    answer:
      "Yes. T Code includes a real terminal backed by a PTY on POSIX systems and ConPTY on Windows. You can open it as a drawer or a full-pane tab, use multiple sessions, and switch between PowerShell, Command Prompt, bash, zsh, and other profiles.",
  },
  {
    question: "Can I use Lite XL plugins and themes?",
    answer:
      "T Code keeps compatibility with the Lite XL plugin API and mod-version 4 plugins. You can also use Lite XL color themes alongside the 24 themes bundled with T Code.",
  },
  {
    question: "Is T Code portable?",
    answer:
      "Yes. The portable builds run from a folder without an installer. Create a folder named user next to tcode.exe to keep settings and plugins inside that folder, and carry the whole directory with you.",
  },
  {
    question: "How do I build T Code from source?",
    answer:
      "Install Meson, Ninja, a C compiler, and the SDL3 development libraries, then run meson setup application/build from the repository root, followed by meson compile -C application/build. Dependencies such as Lua, PCRE2, and FreeType can be downloaded automatically with Meson wrap mode.",
  },
  {
    question: "Does T Code support word wrap and multi-cursor?",
    answer:
      "Yes. Toggle word wrap with Alt+Z, and use the Selection menu for expand/shrink selection, next and all occurrences, line-end cursors, and column selection. The multi-cursor click modifier is configurable.",
  },
  {
    question: "Who makes T Code?",
    answer:
      "T Code is created by Thinakaran Manokaran, also known as Dheena, a full-stack developer from Thanjavur, Tamil Nadu, India. He builds web, mobile, and desktop tools and maintains T Code on top of the Lite XL codebase.",
  },
];
