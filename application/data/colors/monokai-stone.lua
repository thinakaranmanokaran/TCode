-- Bearded Theme Monokai Stone
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#2A2D33" }
style.background2 = { common.color "#25282d" }
style.background3 = { common.color "#25282d" }
style.text = { common.color "#dee0e4" }
style.caret = { common.color "#9AA2A6" }
style.accent = { common.color "#9AA2A6" }
style.dim = { common.color "#c3c6cc" }
style.divider = { common.color "#1c1e22" }
style.selection = { common.color "#ffd8664d" }
style.line_number = { common.color "#6f778780" }
style.line_number2 = { common.color "#989eaa" }
style.line_highlight = { common.color "#3639414d" }
style.scrollbar = { common.color "#dee0e426" }
style.scrollbar2 = { common.color "#dee0e440" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#a9dc76" }
style.warn = { common.color "#ffd866" }
style.error = { common.color "#fc6a67" }

style.syntax["normal"] = { common.color "#c3c6cc" }
style.syntax["symbol"] = { common.color "#c3c6cc" }
style.syntax["comment"] = { common.color "#656b78" }
style.syntax["keyword"] = { common.color "#ffd866" }
style.syntax["keyword2"] = { common.color "#ab9df2" }
style.syntax["number"] = { common.color "#fc6a67" }
style.syntax["literal"] = { common.color "#fc6a67" }
style.syntax["string"] = { common.color "#a9dc76" }
style.syntax["operator"] = { common.color "#ffd866" }
style.syntax["function"] = { common.color "#78dce8" }

return style
