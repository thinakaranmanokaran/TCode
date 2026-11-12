// Intent pages for the "lightweight code editor for ..." cluster. Each page
// has unique copy; do not turn these into doorway pages with swapped keywords.

export const useCases = [
  {
    slug: "windows",
    metaTitle: "Lightweight Code Editor for Windows 10 & 11 — T Code",
    metaDescription:
      "T Code is a lightweight code editor for Windows 10 and 11. About 5 MB, a native menu bar, an integrated ConPTY terminal, and a portable build.",
    eyebrow: "Windows · lightweight editor",
    title: "A lightweight code editor for Windows.",
    sub: "T Code is a small native editor for Windows 10 and 11, with a portable build, an installer, a menu bar, and a real terminal.",
    intro: [
      "Windows has no shortage of code editors. The problem is that many of them bring a browser runtime, a background update service, and an account system along for the ride. T Code is built in C and Lua and ships as a small native application.",
      "The Windows build includes a portable zip and an installer. You can run it from a folder, put it on a USB drive, or add it to the Start menu and PATH. There is no account to create and no subscription.",
    ],
    sections: [
      {
        title: "Small enough to keep around",
        paragraphs: [
          "The Windows executable is about 4.7 MB. The portable zip is about 2.6 MB. That is small enough to download on a slow connection and small enough to keep on a machine that is already short on space.",
          "The editor still includes the parts you use every day: a native menu bar, an activity bar, an integrated terminal with tabs and shell profiles, project search, multi-cursor editing, and 24 themes with live preview.",
        ],
      },
      {
        title: "A real Windows terminal",
        paragraphs: [
          "The integrated terminal uses ConPTY on Windows. Open it as a drawer or a full-pane tab, keep several sessions, and switch between PowerShell, Command Prompt, and other profiles without leaving the editor.",
          "This is the difference between an editor that happens to run on Windows and an editor that is built for the way Windows development actually works. You can run your tests, start a dev server, and use Git in the same window as your code.",
        ],
      },
      {
        title: "Portable or installed",
        paragraphs: [
          "The portable build runs from any folder. Create a folder named user next to tcode.exe and T Code keeps settings, plugins, and themes there, so the whole setup can travel on a USB drive.",
          "The installer adds T Code to the Start menu and can add it to PATH. Both builds are available from the latest GitHub release, and both are MIT licensed.",
        ],
      },
    ],
    faq: [
      {
        q: "Does T Code run on Windows 10?",
        a: "Yes. T Code supports Windows 10 and Windows 11. The integrated terminal uses ConPTY, which is available on modern Windows 10 builds and Windows 11.",
      },
      {
        q: "Is there a portable Windows build?",
        a: "Yes. The portable zip runs from a folder without an installer. A user folder next to tcode.exe keeps settings, plugins, and themes inside that folder.",
      },
      {
        q: "How big is the Windows download?",
        a: "The portable zip for T Code 2.1.7 is about 2.6 MB, and the executable is about 4.7 MB. Sizes vary slightly by release.",
      },
      {
        q: "Does T Code need an account or a subscription?",
        a: "No. T Code is free, open source, and MIT licensed. There is no account, subscription, or paid tier.",
      },
    ],
  },
  {
    slug: "linux",
    metaTitle: "Lightweight Code Editor for Linux — T Code",
    metaDescription:
      "T Code is a lightweight code editor for Linux with a portable tarball, AppImage, real PTY terminal, native menus, and a 5 MB footprint.",
    eyebrow: "Linux · lightweight editor",
    title: "A lightweight code editor for Linux.",
    sub: "A portable tarball, an AppImage, a real PTY terminal, and no Electron runtime. T Code is built for x86_64 Linux desktops.",
    intro: [
      "Linux developers have excellent choices: Vim, Neovim, Emacs, Kate, Gedit, and a long list of others. T Code is for the part of the spectrum that wants a small graphical editor with a terminal in the same window.",
      "The Linux build ships as a portable tarball and an AppImage. It runs on x86_64 systems with X11 or Wayland. There is no Electron runtime, no bundled browser, and no account.",
    ],
    sections: [
      {
        title: "Portable by default",
        paragraphs: [
          "The tarball runs from a folder. The AppImage is a single executable you can make executable with chmod +x and run. Neither requires a system-wide installation or a package manager.",
          "If you want to keep settings and plugins with the application, create a user folder next to the binary. The whole setup can live on a USB drive or in a home directory without touching the rest of the system.",
        ],
      },
      {
        title: "A terminal that belongs in the editor",
        paragraphs: [
          "The integrated terminal uses a real PTY on Linux. Open it as a drawer or a full-pane tab, use multiple sessions, and switch shell profiles without leaving the editor.",
          "T Code also includes project search, multi-cursor editing, native menus, an activity bar, and 24 themes. The point is not to replace a full IDE; it is to keep the common local workflow in one small window.",
        ],
      },
      {
        title: "No browser runtime",
        paragraphs: [
          "T Code uses a C core for rendering and input, with Lua for the editor and plugins. That is why the application is small and why memory use stays predictable compared with Electron-based editors.",
          "The plugin API is compatible with mod-version 4, and color themes are single Lua files. If you already use Lite XL plugins or themes, many of them will work with T Code without changes.",
        ],
      },
    ],
    faq: [
      {
        q: "Does T Code support Wayland?",
        a: "Yes. The Linux build is intended for x86_64 systems running X11 or Wayland. Check the release notes for the current build details.",
      },
      {
        q: "Is there an AppImage?",
        a: "Yes. The latest release includes a portable tarball and an AppImage. Make the AppImage executable with chmod +x and run it.",
      },
      {
        q: "Can I use Lite XL plugins and themes?",
        a: "T Code keeps compatibility with the mod-version 4 plugin API and the single-file Lua theme format, so many Lite XL plugins and themes work with T Code.",
      },
      {
        q: "How big is the Linux download?",
        a: "The Linux portable tarball is a few megabytes. The exact size is listed on the latest GitHub release page.",
      },
    ],
  },
  {
    slug: "macos",
    metaTitle: "Lightweight Code Editor for macOS — T Code",
    metaDescription:
      "T Code is a lightweight code editor for macOS with a universal build for Apple Silicon and Intel, a DMG, a portable archive, and a 5 MB footprint.",
    eyebrow: "macOS · lightweight editor",
    title: "A lightweight code editor for macOS.",
    sub: "A universal build for Apple Silicon and Intel Macs, packaged as a DMG or a portable archive. Small, native, and terminal-ready.",
    intro: [
      "macOS has a strong tradition of native editors, from BBEdit to Nova to CodeEdit. T Code takes a different route: one small C and Lua core that also runs on Windows and Linux, packaged as a universal macOS application.",
      "The macOS build includes a DMG for drag-to-Applications installation and a portable archive for running from a folder. Both are universal builds for Apple Silicon and Intel Macs.",
    ],
    sections: [
      {
        title: "Universal and small",
        paragraphs: [
          "The universal build means one download works on both Apple Silicon and Intel Macs. The application is small enough to keep in a Applications folder without thinking about disk space.",
          "T Code does not bundle Electron, a browser engine, or a Node runtime. The editor uses a C core for rendering and input, with Lua for the editor and plugins.",
        ],
      },
      {
        title: "Native menus and a terminal",
        paragraphs: [
          "T Code has a native menu bar, an activity bar, an integrated terminal with tabs and shell profiles, project search, multi-cursor editing, and 24 themes with live preview.",
          "The terminal is useful for local development without switching to a separate Terminal window. You can run tests, start a dev server, and use Git in the same window as your code.",
        ],
      },
      {
        title: "Choose the package that fits",
        paragraphs: [
          "The DMG is the simplest installation: open it, drag T Code into Applications, and run it. The portable archive is for people who want to keep the editor and its settings in a specific folder.",
          "If you want to keep settings and plugins with the application, create a user folder next to the binary. That makes the setup easy to back up or move between machines.",
        ],
      },
    ],
    faq: [
      {
        q: "Does T Code run on Apple Silicon?",
        a: "Yes. The macOS build is universal, so it runs natively on Apple Silicon and Intel Macs.",
      },
      {
        q: "Is there a DMG?",
        a: "Yes. The latest release includes a macOS DMG and a portable archive. Drag T Code.app into Applications when using the DMG.",
      },
      {
        q: "Does T Code work on older macOS versions?",
        a: "Check the latest release notes for the current minimum macOS version. The project targets modern macOS releases and ships a universal binary.",
      },
      {
        q: "Is T Code free on macOS?",
        a: "Yes. T Code is free, open source, and MIT licensed on every platform. There is no account or subscription.",
      },
    ],
  },
  {
    slug: "low-end-pc",
    metaTitle: "Lightweight Code Editor for a Low-End PC (4 GB RAM)",
    metaDescription:
      "T Code is a lightweight code editor for low-end PCs and 4 GB RAM laptops. No Electron, a 5 MB footprint, fast startup, and a built-in terminal.",
    eyebrow: "Low-end PCs · lightweight editor",
    title: "A lightweight code editor for a low-end PC.",
    sub: "If your laptop has 4 GB of RAM and a few years behind it, the editor should not be the application that brings it to a crawl.",
    intro: [
      "Modern editors can be wonderful and still be the heaviest thing on an older laptop. A browser runtime, an extension host, a language server, and a sync client can turn a simple edit into a memory negotiation.",
      "T Code is built for the other end of the spectrum: a small native editor that opens quickly, uses a predictable amount of memory, and still gives you a terminal, project search, themes, and multi-cursor editing.",
    ],
    sections: [
      {
        title: "Why Electron editors feel heavy",
        paragraphs: [
          "Electron-based editors bundle Chromium and Node. That is a reasonable engineering choice for a platform with a huge extension ecosystem, but it also means the editor carries a browser-sized baseline before you open a file.",
          "On a modern machine with 16 GB or 32 GB of RAM, that baseline is easy to ignore. On a 4 GB laptop, it competes with the browser, the terminal, and the language server you actually need.",
        ],
      },
      {
        title: "What T Code keeps",
        paragraphs: [
          "T Code uses a C core for rendering and input, with Lua for the editor and plugins. There is no Electron runtime and no bundled browser. The Windows executable is about 4.7 MB, and the portable zip is about 2.6 MB.",
          "The editor still includes a real terminal with tabs and shell profiles, project search, a native menu bar, an activity bar, multi-cursor editing, and 24 themes. The point is not to strip away the workflow; it is to remove the runtime tax.",
        ],
      },
      {
        title: "Be honest about the limits",
        paragraphs: [
          "A lightweight editor is not a full IDE. If your work depends on a debugger, remote containers, notebooks, or a large language-server stack, T Code may not replace your main editor. Plugins can add some of that, but they also add memory and startup cost.",
          "The best setup on a low-end machine is usually a small editor for local editing plus optional external tools for heavy work. T Code is designed to be the small editor in that arrangement.",
        ],
      },
    ],
    faq: [
      {
        q: "Is T Code good for a 4 GB RAM laptop?",
        a: "T Code is designed to be small and to avoid an Electron runtime, which makes it a better fit for low-RAM machines than browser-based editors. Actual memory use depends on the project, plugins, and terminal sessions.",
      },
      {
        q: "Does T Code have a debugger?",
        a: "T Code focuses on fast local editing, a terminal, project search, and plugins. It is not a full IDE with a first-class debugger or remote-container workflow.",
      },
      {
        q: "Can I use T Code on an old Windows laptop?",
        a: "T Code supports Windows 10 and 11. If your machine is below the supported Windows version, check the release notes before installing.",
      },
      {
        q: "How can I keep memory use low?",
        a: "Keep the number of plugins and terminal sessions modest, close unused projects, and prefer external language tooling only when you need it.",
      },
    ],
  },
  {
    slug: "portable",
    metaTitle: "Portable Code Editor for a USB Drive — T Code",
    metaDescription:
      "T Code is a portable code editor for Windows, macOS, and Linux. Keep settings, plugins, and themes in a user folder and carry the editor on a USB drive.",
    eyebrow: "Portable · lightweight editor",
    title: "A portable code editor for a USB drive.",
    sub: "Put the editor, your settings, your themes, and your plugins in one folder. No installer, no account, no cloud sync.",
    intro: [
      "Portable software is useful when you move between machines, work on a locked-down computer, or simply want your editor to live in one folder you can back up. T Code supports portable mode on every platform.",
      "The idea is simple: keep the editor and a user folder together. Settings, plugins, and themes stay inside that folder instead of scattering across the system.",
    ],
    sections: [
      {
        title: "How portable mode works",
        paragraphs: [
          "Download the portable archive for your platform and extract it to a folder. Create a folder named user next to the tcode executable. T Code will load and store settings, plugins, and themes in that folder.",
          "On Windows, that means a folder next to tcode.exe. On Linux and macOS, it means a folder next to the binary or application. Move the whole directory and your setup moves with it.",
        ],
      },
      {
        title: "What travels with you",
        paragraphs: [
          "Your editor preferences, key bindings, plugins, and themes live in the user folder. The editor itself is small: about a 2.6 MB portable zip on Windows and a few megabytes on Linux and macOS.",
          "Because there is no account or cloud sync, nothing is uploaded. That is useful for privacy, for offline machines, and for setups where you do not want a vendor account attached to your editor.",
        ],
      },
      {
        title: "Portable does not mean identical",
        paragraphs: [
          "You still need the right binary for each operating system. A Windows executable will not run on macOS, and a macOS application will not run on Linux. Keep one folder per platform if you move between operating systems.",
          "Some plugins may depend on external tools or platform-specific paths. Test your plugin set on the target machine before you rely on it for a work trip.",
        ],
      },
    ],
    faq: [
      {
        q: "How do I make T Code portable?",
        a: "Extract the portable build and create a folder named user next to the tcode executable. Settings, plugins, and themes will stay in that folder.",
      },
      {
        q: "Does portable mode work on Windows, macOS, and Linux?",
        a: "Yes. The release includes portable packages for Windows, Linux, and macOS. Use the package that matches the operating system.",
      },
      {
        q: "Does T Code sync settings to the cloud?",
        a: "No. Portable mode stores settings locally in the user folder. There is no account or cloud sync.",
      },
      {
        q: "Can I run T Code from a USB drive?",
        a: "Yes. The portable build is designed to run from a folder, including a USB drive. Performance depends on the drive and the operating system.",
      },
    ],
  },
  {
    slug: "under-10mb",
    metaTitle: "Code Editor Under 10 MB — T Code",
    metaDescription:
      "A code editor under 10 MB: T Code ships a 4.7 MB executable and a 2.6 MB portable zip, with a terminal, native menus, and 24 themes.",
    eyebrow: "Under 10 MB · lightweight editor",
    title: "A code editor under 10 MB.",
    sub: "T Code's Windows executable is about 4.7 MB. The portable zip is about 2.6 MB. No Electron, no browser engine, no account.",
    intro: [
      "A code editor under 10 MB sounds like a constraint from another era. It is still possible when the editor does not bundle a browser runtime, a Node runtime, an extension host, and an auto-updater.",
      "T Code is a small native editor with an integrated terminal, native menus, 24 themes, multi-cursor editing, and a Lua plugin layer. The base download is comfortably under 10 MB.",
    ],
    sections: [
      {
        title: "What fits in 10 MB",
        paragraphs: [
          "The Windows executable is about 4.7 MB. The portable zip is about 2.6 MB. That includes the editor binary, the bundled themes, and the core resources needed to start editing.",
          "The base download does not include a browser engine, a JavaScript runtime, a language server, or a cloud sync client. Those are the components that usually push an editor into the hundreds of megabytes.",
        ],
      },
      {
        title: "What you give up",
        paragraphs: [
          "A small editor cannot ship every language server, debugger, and framework integration in the box. T Code relies on plugins and external tools for the features that go beyond editing, search, and terminal work.",
          "If you need a full IDE with remote development, notebooks, and a marketplace of extensions, a larger editor may be the right tool. The under-10-MB category is for people who want the core editing workflow to stay small.",
        ],
      },
      {
        title: "How to verify the size",
        paragraphs: [
          "Download the latest release and check the archive or executable size on your own machine. The size can vary slightly by version, platform, and build options.",
          "For a like-for-like comparison, measure the download package rather than the installed folder. A compressed zip and an installed application tell different stories.",
        ],
      },
    ],
    faq: [
      {
        q: "Is T Code really under 10 MB?",
        a: "The Windows executable is about 4.7 MB and the portable zip is about 2.6 MB for version 2.1.7. Sizes vary slightly by release and platform.",
      },
      {
        q: "Why are other editors so much larger?",
        a: "Many editors bundle Chromium, Node, an extension host, and update services. Those components add a large baseline before you install a single plugin.",
      },
      {
        q: "Does a small editor lack features?",
        a: "It lacks some platform features, but T Code still includes a terminal, project search, multi-cursor editing, native menus, 24 themes, and a Lua plugin API.",
      },
      {
        q: "Which package should I download?",
        a: "Use the portable zip if you want to run from a folder. Use the installer if you want Start menu integration and an optional PATH entry.",
      },
    ],
  },
];

export const useCaseLinks = useCases.map((useCase) => ({
  path: `/lightweight-code-editor/${useCase.slug}`,
  title: useCase.title,
  description: useCase.metaDescription,
}));
