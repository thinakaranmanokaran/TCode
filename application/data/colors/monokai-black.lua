-- Bearded Theme Monokai Black
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#141414" }
style.background2 = { common.color "#0e0e0e" }
style.background3 = { common.color "#0e0e0e" }
style.text = { common.color "#c7c7c7" }
style.caret = { common.color "#8f8f8f" }
style.accent = { common.color "#8f8f8f" }
style.dim = { common.color "#adadad" }
style.divider = { common.color "#050505" }
style.selection = { common.color "#ffd8664d" }
style.line_number = { common.color "#61616180" }
style.line_number2 = { common.color "#878787" }
style.line_highlight = { common.color "#2121214d" }
style.scrollbar = { common.color "#c7c7c726" }
style.scrollbar2 = { common.color "#c7c7c740" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#a9dc76" }
style.warn = { common.color "#ffd866" }
style.error = { common.color "#fc6a67" }

style.syntax["normal"] = { common.color "#adadad" }
style.syntax["symbol"] = { common.color "#adadad" }
style.syntax["comment"] = { common.color "#545454" }
style.syntax["keyword"] = { common.color "#ffd866" }
style.syntax["keyword2"] = { common.color "#ab9df2" }
style.syntax["number"] = { common.color "#fc6a67" }
style.syntax["literal"] = { common.color "#fc6a67" }
style.syntax["string"] = { common.color "#a9dc76" }
style.syntax["operator"] = { common.color "#ffd866" }
style.syntax["function"] = { common.color "#78dce8" }

return style
