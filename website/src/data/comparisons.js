// Comparison pages use one data shape so the page component stays small.
// Keep claims factual and link to the competitor's official site. Sizes marked
// "measured" come from official release assets checked on 2026-11-12.

export const comparisons = [
  {
    slug: "sublime-text-vs-t-code",
    competitor: "Sublime Text",
    competitorUrl: "https://www.sublimetext.com/",
    metaTitle: "Sublime Text vs T Code — Which Lightweight Editor Wins?",
    metaDescription:
      "Compare Sublime Text and T Code: license, download size, terminal, themes, plugins, and the workflow each lightweight editor is best at.",
    eyebrow: "Comparison · Sublime Text vs T Code",
    title: "Sublime Text vs T Code: which lightweight editor wins?",
    sub: "Both editors are fast and keyboard-friendly. The difference is what comes in the box, what you pay, and how much you want to assemble yourself.",
    intro: [
      "Sublime Text is one of the editors that proved a native, fast text editor could feel better than a full IDE. T Code starts from a similar idea: keep the core small, make the editor responsive, and let power come from plugins rather than a bundled browser runtime.",
      "They are not the same product. Sublime Text is a mature, paid, proprietary editor with a large package ecosystem. T Code is a free, MIT-licensed editor built on a C and Lua core, with a native menu bar and an integrated terminal in the box. This comparison is about which trade-off fits your work.",
    ],
    rows: [
      ["License", "Proprietary; paid license with a free evaluation", "MIT; free and open source"],
      ["Core", "Native C++", "C core + Lua"],
      ["Platforms", "Windows, macOS, Linux", "Windows, macOS, Linux"],
      ["Windows download", "About 22 MB installer (Build 4215)", "About 2.6 MB portable zip; 4.7 MB binary"],
      ["Integrated terminal", "Not built in; available through packages", "Built in with tabs and shell profiles"],
      ["Menu bar", "Native-style menus", "Native menu bar + activity bar"],
      ["Themes", "Packages and color schemes", "24 built in + third-party themes"],
      ["Plugins", "Package Control ecosystem", "Mod-version 4 Lua plugins"],
      ["Multi-cursor", "Yes", "Yes"],
    ],
    sections: [
      {
        title: "Where Sublime Text wins",
        paragraphs: [
          "Sublime Text is more polished than a small editor has any right to be. Its rendering is fast, its command palette and Goto Anything workflows are excellent, and its package ecosystem has had years to solve common editing problems. If you want a paid editor that feels finished, Sublime is still one of the safest choices.",
          "The package ecosystem is the real advantage. LSP clients, Git integrations, terminal packages, formatters, and language-specific tooling are all available through Package Control. You will spend time configuring it, but the result can be a very personal and very fast editing environment.",
        ],
      },
      {
        title: "Where T Code wins",
        paragraphs: [
          "T Code is free and open source, and it ships the desktop workflow that many Sublime users assemble from packages: a native menu bar, an activity bar, an integrated terminal with tabs and shell profiles, Explorer and tab context menus, multi-cursor tools, and 24 themes with live preview.",
          "The footprint is also smaller. The Windows portable zip is about 2.6 MB and the executable is about 4.7 MB. T Code does not bundle Electron, a browser engine, or a Node runtime. The plugin API is Lua-based and compatible with the mod-version 4 ecosystem, so the editor stays hackable without becoming a platform.",
        ],
      },
      {
        title: "The honest trade-off",
        paragraphs: [
          "Sublime Text has the deeper package ecosystem and the more mature editing surface. T Code has the smaller download, the integrated terminal, and the MIT license. If your workflow depends on a specific Sublime package, switching means giving something up.",
          "If you mostly edit local files, run commands in a terminal, search a project, and switch themes, T Code gives you those actions without a marketplace or a license fee. That is a narrower promise, but it is a useful one.",
        ],
      },
    ],
    migrationTitle: "Migrating from Sublime Text",
    migration: [
      "The first thing to map is your package list. Terminal packages have a direct equivalent in T Code's built-in terminal. LSP and formatter packages usually become external tools plus a Lua plugin. Syntax definitions and color schemes are the easiest to replace because T Code bundles 24 themes and supports third-party Lua themes.",
      "Keybindings are the second migration project. T Code uses a familiar desktop shortcut set, but it is not a Sublime clone. Budget an afternoon for the shortcuts you use most, then decide whether the built-in terminal and the smaller footprint are worth the change.",
    ],
    verdict:
      "Choose Sublime Text if you want the most polished paid editing experience and you are comfortable assembling your workflow from packages. Choose T Code if you want a free, open-source, terminal-first editor with a tiny footprint and a native desktop workflow out of the box.",
    bestForCompetitor:
      "Professional developers who value a mature package ecosystem, polished editing, and a one-time paid license.",
    bestForTcode:
      "Developers who want a free, MIT-licensed editor with a built-in terminal and a very small download.",
    updated: "2026-11-12",
  },
  {
    slug: "notepad-plus-plus-vs-t-code",
    competitor: "Notepad++",
    competitorUrl: "https://notepad-plus-plus.org/",
    metaTitle: "Notepad++ vs T Code — Lightweight Editors Compared",
    metaDescription:
      "Compare Notepad++ and T Code: platform support, download size, terminal, themes, plugins, and which tiny editor fits Windows or cross-platform work.",
    eyebrow: "Comparison · Notepad++ vs T Code",
    title: "Notepad++ vs T Code: which tiny editor fits your desk?",
    sub: "Notepad++ is a Windows institution. T Code is a cross-platform editor with a terminal in the box. The right answer depends on where you work.",
    intro: [
      "Notepad++ has been the default recommendation for a fast Windows text editor for two decades. It is small, native, free, and good at the job. T Code borrows the same principle — keep the editor light — but adds a cross-platform desktop workflow and an integrated terminal.",
      "This is not a knock on Notepad++. If you need a Windows-only editor for quick edits, it is still excellent. The comparison is about the shape of the workflow around the text buffer.",
    ],
    rows: [
      ["License", "GPL", "MIT"],
      ["Platforms", "Windows only", "Windows, macOS, Linux"],
      ["Windows download", "About 7 MB installer; 8.4 MB portable zip (8.9.9.1)", "About 2.6 MB portable zip; 4.7 MB binary"],
      ["Core", "C++ with Scintilla", "C core + Lua"],
      ["Integrated terminal", "No; available through plugins", "Built in with tabs and shell profiles"],
      ["Menu bar", "Native Win32 menus", "Native menu bar + activity bar"],
      ["Themes", "Configurable; community themes", "24 built in + third-party themes"],
      ["Plugins", "Large Windows plugin ecosystem", "Mod-version 4 Lua plugins"],
      ["Multi-cursor", "Limited or plugin-based", "Yes"],
    ],
    sections: [
      {
        title: "Where Notepad++ wins",
        paragraphs: [
          "Notepad++ is a Windows-native application that feels at home on Windows. It starts quickly, handles large text files well, and has a plugin ecosystem built around the things Windows users actually do: compare files, run macros, edit hex, and add language support.",
          "It is also incredibly familiar. Generations of developers have used it as their first editor or as the tool they keep on every Windows machine. That familiarity is a feature, and the price is hard to argue with.",
        ],
      },
      {
        title: "Where T Code wins",
        paragraphs: [
          "T Code runs on Windows, macOS, and Linux. It adds a native menu bar, an activity bar, an integrated terminal with tabs and shell profiles, live theme previews, and modern Explorer and tab actions. Those are not features you have to hunt for in a plugin manager.",
          "The cross-platform story matters if you switch operating systems or work with a mixed team. The same editor, the same theme format, and the same Lua plugin API are available on all three platforms. The Windows portable zip is also smaller than the Notepad++ portable zip we measured.",
        ],
      },
      {
        title: "The honest trade-off",
        paragraphs: [
          "Notepad++ has a much longer history, a larger Windows plugin ecosystem, and a level of Windows integration that a cross-platform editor will not match. T Code is younger, and its plugin ecosystem is smaller.",
          "If you only work on Windows and your workflow is already built around Notepad++ plugins, staying put is reasonable. If you want a terminal, themes, and the same editor on every platform, T Code is the more complete desktop workflow.",
        ],
      },
    ],
    migrationTitle: "Migrating from Notepad++",
    migration: [
      "Most Notepad++ workflows map cleanly: syntax highlighting, project search, macros, and quick edits are all covered. The bigger change is the terminal. If you currently keep a separate Command Prompt or Windows Terminal window open, moving that work into T Code is the main workflow shift.",
      "Notepad++ plugins are Windows-specific, so they do not carry over. Before switching, list the plugins you actually use and check whether T Code has a built-in equivalent, a Lua plugin, or an external tool. If a plugin is essential and has no replacement, stay on Notepad++ for that work.",
    ],
    verdict:
      "Choose Notepad++ for a familiar, Windows-only quick-edit tool with a mature plugin ecosystem. Choose T Code if you want a cross-platform editor with a built-in terminal and a modern desktop workflow.",
    bestForCompetitor:
      "Windows users who want a familiar, tiny editor for quick edits, macros, and file comparison.",
    bestForTcode:
      "Developers who work across Windows, macOS, and Linux and want a terminal in the same window.",
    updated: "2026-11-12",
  },
  {
    slug: "zed-vs-t-code",
    competitor: "Zed",
    competitorUrl: "https://zed.dev/",
    metaTitle: "Zed vs T Code — Speed, Features, and Trade-offs",
    metaDescription:
      "Compare Zed and T Code: architecture, download size, AI and collaboration features, terminal, plugins, and which fast editor fits your workflow.",
    eyebrow: "Comparison · Zed vs T Code",
    title: "Zed vs T Code: two ideas of a fast editor",
    sub: "Zed is a GPU-accelerated IDE with AI and collaboration built in. T Code is a 5 MB editor with a terminal and a Lua plugin layer. Both care about speed.",
    intro: [
      "Zed and T Code both reject the idea that a code editor has to feel like a browser. Zed does it with a GPU-accelerated Rust UI and a modern collaboration layer. T Code does it with a small C core, Lua for the editor, and a deliberate refusal to bundle a browser runtime.",
      "The products are aiming at different jobs. Zed is building a platform for collaborative, AI-assisted development. T Code is trying to be a fast local editor that stays small and understandable.",
    ],
    rows: [
      ["License", "Open-source core; paid AI features", "MIT"],
      ["Platforms", "macOS and Linux desktop builds", "Windows, macOS, Linux"],
      ["Core", "Rust + GPUI", "C core + Lua"],
      ["Download", "About 91 MB Linux x86_64 archive (v1.28.1)", "About 2.6 MB Windows portable zip"],
      ["Integrated terminal", "Yes", "Yes, with tabs and shell profiles"],
      ["AI and collaboration", "Built-in AI and multiplayer editing", "Not a focus"],
      ["Extensions", "Growing extension ecosystem", "Mod-version 4 Lua plugins"],
      ["Themes", "Built-in themes", "24 built in + third-party themes"],
    ],
    sections: [
      {
        title: "Where Zed wins",
        paragraphs: [
          "Zed is a modern IDE, not just a text editor. It has a GPU-accelerated interface, language server support, a built-in terminal, collaborative editing, and optional AI features. If your team wants to edit together or you want AI assistance without assembling a stack of extensions, Zed is built for that.",
          "The Rust and GPUI architecture is also genuinely fast. Zed feels responsive in a way that Electron editors often do not, and it has become a credible native alternative for developers who want modern IDE features without VS Code.",
        ],
      },
      {
        title: "Where T Code wins",
        paragraphs: [
          "T Code is dramatically smaller. The Windows portable zip is about 2.6 MB and the executable is about 4.7 MB, compared with a Zed Linux archive in the tens of megabytes. T Code also supports Windows, which is not the primary desktop target for Zed's current releases.",
          "The editor is intentionally simpler. There is no account, no AI service, and no collaboration layer. The plugin API is compatible with the mod-version 4 Lua ecosystem, and the 24 themes are bundled rather than downloaded. If you want a small editor you can inspect and extend, that simplicity is the point.",
        ],
      },
      {
        title: "The honest trade-off",
        paragraphs: [
          "Zed has the stronger feature platform: AI, collaboration, LSP, and a modern GPU UI. T Code has the smaller footprint, the Windows build, and the Lua plugin model.",
          "If you need AI or multiplayer editing, Zed is the more direct choice. If you want a tiny local editor with a terminal and you do not need a platform, T Code is the lighter tool.",
        ],
      },
    ],
    migrationTitle: "Migrating from Zed",
    migration: [
      "If you use Zed for AI or multiplayer editing, T Code is not a replacement. Those features are part of Zed's platform, not something a small editor can bolt on without adding the services and accounts that make the platform heavy. Keep Zed if those workflows are central to your day.",
      "If you use Zed mainly as a fast local editor, the migration is mostly about expectations. T Code has a terminal, menus, themes, and Lua plugins, but it does not have Zed's extension depth or GPU-rendered interface. Try the portable build on a real project and compare the parts you actually use.",
    ],
    verdict:
      "Choose Zed if you want a modern, GPU-accelerated IDE with AI and collaboration on macOS or Linux. Choose T Code if you want a tiny cross-platform editor with a terminal, Windows support, and a Lua plugin layer.",
    bestForCompetitor:
      "Teams that want AI assistance, collaborative editing, and a modern native IDE on macOS or Linux.",
    bestForTcode:
      "Developers who want a very small editor, Windows support, and a terminal without an account or AI layer.",
    updated: "2026-11-12",
  },
  {
    slug: "vim-vs-t-code",
    competitor: "Vim / Neovim",
    competitorUrl: "https://neovim.io/",
    metaTitle: "Vim vs T Code — Terminal Editor vs Desktop Editor",
    metaDescription:
      "Compare Vim/Neovim and T Code: modal editing, GUI menus, terminal workflow, plugins, download size, and which editor fits your habits.",
    eyebrow: "Comparison · Vim / Neovim vs T Code",
    title: "Vim vs T Code: terminal editor or desktop editor?",
    sub: "Vim and Neovim are keyboard-first editors that live in the terminal. T Code is a GUI editor that brings the terminal into the same window. The habits decide.",
    intro: [
      "Vim and Neovim are not just editors; they are a way of thinking about text. Modal editing, composable commands, and a terminal-first workflow make them incredibly efficient for people who have invested the time. T Code takes the opposite approach: visible menus, mouse support, and a GUI that makes the editor discoverable on day one.",
      "Both can be small. Both can be extended. The question is whether you want to live in a terminal workflow or a desktop window.",
    ],
    rows: [
      ["License", "Vim license; Neovim is Apache-2.0", "MIT"],
      ["Interface", "Terminal, modal editing", "GUI with menus, mouse, and modal-free editing"],
      ["Platforms", "Cross-platform", "Windows, macOS, Linux"],
      ["Download", "About 12.6 MB Neovim Windows zip (v0.12.6)", "About 2.6 MB Windows portable zip"],
      ["Integrated terminal", "The terminal is the environment", "Built in with tabs and shell profiles"],
      ["Plugins", "Vimscript and Lua ecosystem", "Mod-version 4 Lua plugins"],
      ["Learning curve", "Steep", "Moderate"],
      ["Themes", "Large ecosystem", "24 built in + third-party themes"],
    ],
    sections: [
      {
        title: "Where Vim and Neovim win",
        paragraphs: [
          "Vim and Neovim are everywhere. They run over SSH, inside containers, on servers with no GUI, and on machines where installing a desktop application is not an option. The modal editing model is incredibly efficient once it becomes muscle memory.",
          "Neovim in particular has a thriving Lua plugin ecosystem, built-in LSP support, and a terminal that is already part of the workflow. If you spend most of your day in a terminal, Vim or Neovim keeps you there.",
        ],
      },
      {
        title: "Where T Code wins",
        paragraphs: [
          "T Code is a GUI editor with visible menus, a mouse, and a native desktop window. That makes it easier to learn and easier to use for people who do not want to memorize a new editing language. The integrated terminal means you can still run commands without leaving the editor.",
          "The editor is also small: about a 2.6 MB portable zip and a 4.7 MB executable on Windows. It keeps the Lite XL plugin model, so Lua extensibility is available without adopting a terminal-first workflow.",
        ],
      },
      {
        title: "The honest trade-off",
        paragraphs: [
          "Vim and Neovim have the larger plugin ecosystem and the stronger terminal-native story. T Code has the lower learning curve and a more conventional desktop interface.",
          "If you already live in Vim or Neovim, switching to a GUI editor is probably a downgrade in muscle memory. If you want a small editor that feels like a desktop app and still gives you a terminal, T Code is the easier starting point.",
        ],
      },
    ],
    migrationTitle: "Migrating from Vim or Neovim",
    migration: [
      "The hard part is muscle memory. T Code is not modal by default and does not try to imitate Vim's command language. If you have years of Vim habits, a GUI editor can feel slower until you remap the actions you use most or use a Vim-emulation plugin if one is available.",
      "The easy part is the terminal. T Code keeps a terminal in the same window, so you do not lose the command-line workflow entirely. If you use Neovim mainly for local editing and a terminal, try T Code for a week; if you live over SSH, Neovim remains the more natural choice.",
    ],
    verdict:
      "Choose Vim or Neovim if you want a keyboard-first editor that works everywhere, including servers and remote sessions. Choose T Code if you want a GUI editor with menus, a mouse, and an integrated terminal in a small package.",
    bestForCompetitor:
      "Developers who work over SSH, live in a terminal, and have invested in modal editing.",
    bestForTcode:
      "Developers who want a discoverable desktop editor with a terminal and a tiny footprint.",
    updated: "2026-11-12",
  },
  {
    slug: "codeedit-vs-t-code",
    competitor: "CodeEdit",
    competitorUrl: "https://www.codeedit.app/",
    metaTitle: "CodeEdit vs T Code — macOS Editors Compared",
    metaDescription:
      "Compare CodeEdit and T Code: platform support, native macOS design, download size, terminal, themes, and which open-source editor fits your workflow.",
    eyebrow: "Comparison · CodeEdit vs T Code",
    title: "CodeEdit vs T Code: which open-source editor fits?",
    sub: "CodeEdit is a native macOS editor built in Swift. T Code is a cross-platform editor built in C and Lua. Both are open source and both care about a native feel.",
    intro: [
      "CodeEdit is an open-source project building a native macOS code editor with Swift and AppKit. That makes it feel at home on a Mac in a way that cross-platform editors often do not. T Code takes a different route: one small C and Lua core that runs on Windows, macOS, and Linux.",
      "If you only work on a Mac and want a native, Xcode-adjacent editor, CodeEdit is worth a look. If you want the same editor on every platform and a very small download, T Code is the broader tool.",
    ],
    rows: [
      ["License", "Open source", "MIT"],
      ["Platforms", "macOS only", "Windows, macOS, Linux"],
      ["Core", "Swift and AppKit", "C core + Lua"],
      ["Download", "About 36 MB DMG (v0.3.6)", "About 3 MB macOS archive; 4.7 MB Windows binary"],
      ["Native macOS feel", "Yes, built for macOS", "Native desktop, cross-platform"],
      ["Integrated terminal", "Yes", "Yes, with tabs and shell profiles"],
      ["Extensions", "Growing extension system", "Mod-version 4 Lua plugins"],
      ["Themes", "Built-in themes", "24 built in + third-party themes"],
    ],
    sections: [
      {
        title: "Where CodeEdit wins",
        paragraphs: [
          "CodeEdit is designed for macOS from the ground up. Swift and AppKit give it the platform's conventions, and the project is aiming at the kind of native development experience that Mac users expect from an editor built for their OS.",
          "It is also open source and community-driven. If you want to contribute to a macOS-native editor, or you want an editor that feels like part of the Mac rather than a port, CodeEdit's direction is appealing.",
        ],
      },
      {
        title: "Where T Code wins",
        paragraphs: [
          "T Code runs on Windows, macOS, and Linux. The download is much smaller — about 3 MB for the macOS archive we checked, compared with a 36 MB CodeEdit DMG — and the editor keeps the same 24 themes, terminal, and Lua plugin model across platforms.",
          "The cross-platform consistency is the advantage. If you use a Mac at home and Windows or Linux at work, T Code gives you the same editor and the same configuration model on each machine.",
        ],
      },
      {
        title: "The honest trade-off",
        paragraphs: [
          "CodeEdit has the stronger native macOS story and a Swift-based extension direction. T Code has the smaller footprint and the broader platform coverage.",
          "If macOS is the only environment you care about, CodeEdit is the more Mac-native choice. If you need one editor across platforms, T Code is the more practical one.",
        ],
      },
    ],
    migrationTitle: "Migrating from CodeEdit",
    migration: [
      "If you only work on a Mac, the migration is optional. CodeEdit's native AppKit interface is a real advantage on macOS, and its Swift-based extension direction may fit your workflow better than a Lua plugin layer. T Code is the better choice when you need the same editor on Windows or Linux.",
      "Test the cross-platform parts before committing: theme files, keybindings, terminal profile, and any external tools you use. T Code keeps the same core on every platform, but your plugins and shell configuration still need to work on each machine.",
    ],
    verdict:
      "Choose CodeEdit if you want a native, open-source macOS editor built with Swift. Choose T Code if you want a tiny open-source editor that runs on Windows, macOS, and Linux with the same workflow.",
    bestForCompetitor:
      "macOS developers who want a native Swift/AppKit editor and a growing open-source community.",
    bestForTcode:
      "Developers who use more than one operating system and want a very small, consistent editor.",
    updated: "2026-11-12",
  },
];

export const comparisonLinks = [
  {
    path: "/compare/vs-code-vs-t-code",
    title: "VS Code vs T Code",
    description:
      "A fair comparison of the Electron platform and the 5 MB native editor: size, runtime, extensions, debugging, and the workflows each one owns.",
  },
  {
    path: "/compare/lite-xl-vs-t-code",
    title: "Lite XL vs T Code",
    description:
      "Same C and Lua core, different desktop defaults. Compare the menu bar, terminal, themes, and plugin compatibility.",
  },
  ...comparisons.map((comparison) => ({
    path: `/compare/${comparison.slug}`,
    title: `${comparison.competitor} vs T Code`,
    description: comparison.metaDescription,
  })),
];
