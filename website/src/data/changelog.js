export const releases = [
  {
    version: "2.1.7",
    label: "T Code 2.1.7",
    date: "2026",
    tag: "Current",
    summary:
      "The T Code release: a native menu bar, activity bar, integrated terminal, live theme previews, and a full desktop workflow.",
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
];
