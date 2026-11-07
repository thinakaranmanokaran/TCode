-- Bearded Theme Black & Amethyst
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#111418" }
style.background2 = { common.color "#0c0f11" }
style.background3 = { common.color "#0c0f11" }
style.text = { common.color "#bec6d0" }
style.caret = { common.color "#a85ff1" }
style.accent = { common.color "#a85ff1" }
style.dim = { common.color "#a0acbb" }
style.divider = { common.color "#040506" }
style.selection = { common.color "#c7910c4d" }
style.line_number = { common.color "#505f7280" }
style.line_number2 = { common.color "#73849c" }
style.line_highlight = { common.color "#1c20274d" }
style.scrollbar = { common.color "#bec6d026" }
style.scrollbar2 = { common.color "#bec6d040" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#00a884" }
style.warn = { common.color "#d4770c" }
style.error = { common.color "#E35535" }

style.syntax["normal"] = { common.color "#a0acbb" }
style.syntax["symbol"] = { common.color "#a0acbb" }
style.syntax["comment"] = { common.color "#475262" }
style.syntax["keyword"] = { common.color "#c7910c" }
style.syntax["keyword2"] = { common.color "#a85ff1" }
style.syntax["number"] = { common.color "#E35535" }
style.syntax["literal"] = { common.color "#E35535" }
style.syntax["string"] = { common.color "#00a884" }
style.syntax["operator"] = { common.color "#c7910c" }
style.syntax["function"] = { common.color "#11B7D4" }

return style
