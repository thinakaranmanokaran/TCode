-- Bearded Theme Monokai Reversed
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#12141a" }
style.background2 = { common.color "#171921" }
style.background3 = { common.color "#171921" }
style.text = { common.color "#c6cad7" }
style.caret = { common.color "#98a2b5" }
style.accent = { common.color "#98a2b5" }
style.dim = { common.color "#a9aec1" }
style.divider = { common.color "#0a0b0f" }
style.selection = { common.color "#ffd8664d" }
style.line_number = { common.color "#515a7480" }
style.line_number2 = { common.color "#737e9e" }
style.line_highlight = { common.color "#1c20294d" }
style.scrollbar = { common.color "#c6cad726" }
style.scrollbar2 = { common.color "#c6cad740" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#a9dc76" }
style.warn = { common.color "#ffd866" }
style.error = { common.color "#fc6a67" }

style.syntax["normal"] = { common.color "#a9aec1" }
style.syntax["symbol"] = { common.color "#a9aec1" }
style.syntax["comment"] = { common.color "#4c526b" }
style.syntax["keyword"] = { common.color "#ffd866" }
style.syntax["keyword2"] = { common.color "#ab9df2" }
style.syntax["number"] = { common.color "#fc6a67" }
style.syntax["literal"] = { common.color "#fc6a67" }
style.syntax["string"] = { common.color "#a9dc76" }
style.syntax["operator"] = { common.color "#ffd866" }
style.syntax["function"] = { common.color "#78dce8" }

return style
