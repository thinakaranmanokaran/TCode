-- Bearded Theme Monokai Terra
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#262329" }
style.background2 = { common.color "#201e23" }
style.background3 = { common.color "#201e23" }
style.text = { common.color "#d9d6db" }
style.caret = { common.color "#b0a2a6" }
style.accent = { common.color "#b0a2a6" }
style.dim = { common.color "#bfbbc3" }
style.divider = { common.color "#171518" }
style.selection = { common.color "#ffd8664d" }
style.line_number = { common.color "#73697c80" }
style.line_number2 = { common.color "#9991a1" }
style.line_highlight = { common.color "#332f374d" }
style.scrollbar = { common.color "#d9d6db26" }
style.scrollbar2 = { common.color "#d9d6db40" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#a9dc76" }
style.warn = { common.color "#ffd866" }
style.error = { common.color "#fc6a67" }

style.syntax["normal"] = { common.color "#bfbbc3" }
style.syntax["symbol"] = { common.color "#bfbbc3" }
style.syntax["comment"] = { common.color "#665f6d" }
style.syntax["keyword"] = { common.color "#ffd866" }
style.syntax["keyword2"] = { common.color "#ab9df2" }
style.syntax["number"] = { common.color "#fc6a67" }
style.syntax["literal"] = { common.color "#fc6a67" }
style.syntax["string"] = { common.color "#a9dc76" }
style.syntax["operator"] = { common.color "#ffd866" }
style.syntax["function"] = { common.color "#78dce8" }

return style
