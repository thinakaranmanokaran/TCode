export const releases = [
  {
    version: "2.1.7",
    label: "T Code 2.1.7",
    date: "2026",
    tag: "Current",
    summary:
      "The T Code release: a native menu bar, activity bar, integrated terminal, live theme previews, and a full desktop workflow on top of Lite XL 2.1.7.",
    groups: [
      {
        title: "T Code workflow",
        items: [
          "Rebranded the editor as T Code with new icons, a T Code window title, and updated application metadata.",
          "Added a VS Code-style top menu bar with File, Edit, Selection, View, Go, Run, Terminal, and Help menus.",
          "Added a vertical activity bar for Explorer, project search, terminal, command palette, and settings.",
          "Added an integrated terminal with tabs, shell profiles, ConPTY on Windows, and PTY on POSIX.",
          "Added live theme previews for 10 Bearded and 10 Monokai variations.",
          "Added a Selection menu with expand/shrink selection, line-end cursors, occurrence selection, and column selection.",
          "Added Explorer and tab context menus, new-tab actions, and reopen-closed-tab support.",
          "Added native Open File and Open Project Folder dialogs.",
        ],
      },
      {
        title: "Fixes",
        items: [
          "Kept dialogs and message bars in the active theme palette.",
          "Fixed terminal focus reporting sending a stray NUL byte.",
          "Derived a muted secondary color from each theme for menus and inactive tabs.",
          "Removed empty separators from filtered context menus.",
        ],
      },
    ],
  },
  {
    version: "2.1.7 (Lite XL)",
    label: "Lite XL 2.1.7",
    date: "2024-12-05",
    tag: "Base",
    summary:
      "The upstream Lite XL release that T Code builds on. It fixes macOS scaling, comment handling, and overscroll, and improves Windows path handling.",
    groups: [
      {
        title: "Features",
        items: [
          "Allow / for path suggestions on Windows.",
          "Check item type before creating input text in the treeview.",
        ],
      },
      {
        title: "Fixes",
        items: [
          "Return state when tokenizing plaintext syntaxes.",
          "Scale font pixel size in RENDERER mode.",
          "Prevent overscroll when the document view is too small.",
          "Fix process stdout and stderr completion checks.",
        ],
      },
    ],
  },
  {
    version: "2.1.6",
    label: "Lite XL 2.1.6",
    date: "2024-11-29",
    tag: "Base",
    summary:
      "A Lite XL release with CUDA syntax highlighting, macOS icon improvements, renderer performance work, and quality-of-life fixes.",
    groups: [
      {
        title: "Features",
        items: [
          "Added CUDA syntax highlighting.",
          "Added a macOS-specific application icon.",
          "Improved project search with status, horizontal scrolling, and ellipsis.",
        ],
      },
      {
        title: "Fixes",
        items: [
          "Correctly free SDL textures and renderers.",
          "Improved multi-type handling in delimited patterns.",
          "Fixed AppImage packaging.",
        ],
      },
    ],
  },
  {
    version: "2.1.5",
    label: "Lite XL 2.1.5",
    date: "2024-10-01",
    tag: "Base",
    summary:
      "An upstream Lite XL release with performance work, plugin API updates, and a long list of editor fixes that T Code inherits.",
    groups: [
      {
        title: "Highlights",
        items: [
          "Renderer and glyph cache improvements.",
          "Plugin API and documentation updates.",
          "Treeview, project search, and terminal improvements.",
        ],
      },
    ],
  },
];
