export const features = [
  {
    slug: "integrated-terminal",
    number: "01",
    category: "Workflow",
    title: "The terminal is already open.",
    description:
      "A real terminal lives inside the editor, with tabs, shell profiles, and the keyboard shortcuts you already know.",
    specs: [
      { label: "Shortcut", value: "Ctrl + `" },
      { label: "Shells", value: "PowerShell · CMD · bash · zsh" },
      { label: "Platforms", value: "Windows · Linux · macOS" },
    ],
    details: [
      {
        label: "What it does",
        body: "T Code ships a built-in terminal backed by a real PTY on POSIX and ConPTY on Windows. Open it as a drawer or a full-pane tab, keep several sessions, and switch profiles without leaving the editor.",
      },
      {
        label: "Why it matters",
        body: "No alt-tabbing. No context switch. Run your tests, dev server, and Git commands where your code already is.",
      },
    ],
    image: "/images/screenshots/terminal-drawer.webp",
    imageAlt: "T Code with the integrated terminal drawer open below a JavaScript file",
    visual: "screenshot",
    href: "/features#integrated-terminal",
  },
  {
    slug: "native-menus",
    number: "02",
    category: "Interface",
    title: "Native menus, not browser menus.",
    description:
      "A VS Code-style menu bar and activity bar built for a desktop editor — File, Edit, Selection, View, Go, Run, Terminal, Help.",
    specs: [
      { label: "Menus", value: "File · Edit · Selection · View · Go · Run · Terminal · Help" },
      { label: "Activity bar", value: "Explorer · Search · Terminal · Commands · Settings" },
      { label: "Behaviour", value: "Hover to switch menus" },
    ],
    details: [
      {
        label: "What it does",
        body: "Every action has a visible home. Open menus on hover, pin them with a click, and move across the bar without relearning a single shortcut.",
      },
      {
        label: "Why it matters",
        body: "The editor should be discoverable on day one and fast by day ten. Menus and shortcuts are not opposites here.",
      },
    ],
    image: "/images/screenshots/file-menu.webp",
    imageAlt: "T Code native File menu open over a JavaScript project",
    visual: "screenshot",
    href: "/features#native-menus",
  },
  {
    slug: "themes",
    number: "03",
    category: "Craft",
    title: "24 themes. Live preview.",
    description:
      "Ten Bearded variations, ten Monokai variations, and four classics. Hover to preview, click to keep.",
    specs: [
      { label: "Themes", value: "24 bundled" },
      { label: "Families", value: "Bearded · Monokai · Classic" },
      { label: "Preview", value: "Live on hover" },
    ],
    details: [
      {
        label: "What it does",
        body: "Open the File menu, hover a theme, and the entire editor updates immediately. Click to apply it and T Code remembers it on the next launch.",
      },
      {
        label: "Why it matters",
        body: "A theme is not a preference checkbox. It changes how your eyes feel after eight hours of code.",
      },
    ],
    image: "/images/screenshots/theme-menu.webp",
    imageAlt: "T Code theme picker with Bearded theme variations",
    visual: "screenshot",
    href: "/themes",
  },
  {
    slug: "multi-cursor",
    number: "04",
    category: "Editing",
    title: "Multi-cursor that respects your hands.",
    description:
      "Expand selection, add cursors, select every occurrence, and switch to column selection without a plugin.",
    specs: [
      { label: "Shortcut", value: "Ctrl + Alt + Click" },
      { label: "Selection", value: "Expand · shrink · select all occurrences" },
      { label: "Lines", value: "Copy · move · duplicate" },
    ],
    details: [
      {
        label: "What it does",
        body: "The Selection menu gathers the editing tools you use most: expand and shrink selection, line-end cursors, next and previous occurrence, and a configurable multi-cursor modifier.",
      },
      {
        label: "Why it matters",
        body: "Big edits should be one gesture, not ten repetitive ones. Multi-cursor is a first-class feature here, not an afterthought.",
      },
    ],
    image: "/images/screenshots/selection-menu.webp",
    imageAlt: "T Code Selection menu showing multi-cursor and column selection options",
    visual: "screenshot",
    href: "/features#multi-cursor",
  },
  {
    slug: "explorer",
    number: "05",
    category: "Navigation",
    title: "Explorer and tabs with power tools.",
    description:
      "New file, rename, reveal, copy path, split, pin, reopen closed tabs — the small actions you do every day.",
    specs: [
      { label: "Explorer", value: "Create · rename · delete · reveal" },
      { label: "Tabs", value: "Split · pin · reopen · move" },
      { label: "Search", value: "Find in folder + project search" },
    ],
    details: [
      {
        label: "What it does",
        body: "Right-click any file or folder for a focused context menu. Use the Explorer header for new files, folders, refresh, and collapse all. Keep terminal tabs in the same tab bar.",
      },
      {
        label: "Why it matters",
        body: "Most editor friction is tiny. A missing rename or a hidden close action costs more attention than it should.",
      },
    ],
    image: "/images/screenshots/explorer-menu.webp",
    imageAlt: "T Code Explorer context menu with file and folder actions",
    visual: "screenshot",
    href: "/features#explorer",
  },
  {
    slug: "performance",
    number: "06",
    category: "Performance",
    title: "Five megabytes. Zero waiting.",
    description:
      "A C core, Lua extensibility, and no Electron runtime. T Code opens before you finish deciding what to edit.",
    specs: [
      { label: "Windows binary", value: "5.0 MB" },
      { label: "Core", value: "C + Lua" },
      { label: "Runtime", value: "No Electron · no bundled browser" },
    ],
    details: [
      {
        label: "What it does",
        body: "T Code uses a small C core for rendering, input, and the filesystem, with Lua for the editor and plugins.",
      },
      {
        label: "Why it matters",
        body: "Fast software is not a luxury. It is the difference between opening the editor and opening a browser-sized application.",
      },
    ],
    image: "/images/screenshots/editor.webp",
    imageAlt: "T Code editing a JavaScript file with syntax highlighting",
    visual: "specs",
    href: "/features#performance",
  },
  {
    slug: "plugins",
    number: "07",
    category: "Ecosystem",
    title: "Plugins. T Code polish.",
    description:
      "Keep the plugin ecosystem and color themes you already use, then add a native terminal, menus, and a modern workflow.",
    specs: [
      { label: "Compatibility", value: "Mod-version 4 plugins" },
      { label: "Themes", value: "24 bundled + third-party themes" },
      { label: "License", value: "MIT" },
    ],
    details: [
      {
        label: "What it does",
        body: "T Code stays compatible with the mod-version 4 plugin API. Drop a plugin into your user module or install it with lpm.",
      },
      {
        label: "Why it matters",
        body: "You do not have to choose between a small editor and an ecosystem. T Code offers both.",
      },
    ],
    image: "/images/screenshots/editor.webp",
    imageAlt: "T Code with a project open in the explorer",
    visual: "plugins",
    href: "/features#plugins",
  },
];

export const featureFacts = [
  { value: "7", label: "native workflow upgrades" },
  { value: "24", label: "ready-made themes" },
  { value: "5 MB", label: "Windows download" },
  { value: "MIT", label: "free and open source" },
];
