-- Bearded Theme Monokai Metallian
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1e212b" }
style.background2 = { common.color "#191c24" }
style.background3 = { common.color "#191c24" }
style.text = { common.color "#d0d3de" }
style.caret = { common.color "#98a2b5" }
style.accent = { common.color "#98a2b5" }
style.dim = { common.color "#b2b8c9" }
style.divider = { common.color "#111319" }
style.selection = { common.color "#ffd8664d" }
style.line_number = { common.color "#5d668580" }
style.line_number2 = { common.color "#858daa" }
style.line_highlight = { common.color "#282d3a4d" }
style.scrollbar = { common.color "#d0d3de26" }
style.scrollbar2 = { common.color "#d0d3de40" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#a9dc76" }
style.warn = { common.color "#ffd866" }
style.error = { common.color "#fc6a67" }

style.syntax["normal"] = { common.color "#b2b8c9" }
style.syntax["symbol"] = { common.color "#b2b8c9" }
style.syntax["comment"] = { common.color "#535b75" }
style.syntax["keyword"] = { common.color "#ffd866" }
style.syntax["keyword2"] = { common.color "#ab9df2" }
style.syntax["number"] = { common.color "#fc6a67" }
style.syntax["literal"] = { common.color "#fc6a67" }
style.syntax["string"] = { common.color "#a9dc76" }
style.syntax["operator"] = { common.color "#ffd866" }
style.syntax["function"] = { common.color "#78dce8" }

return style
