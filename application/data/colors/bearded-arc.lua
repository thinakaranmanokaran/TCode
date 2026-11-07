-- Bearded Theme Arc
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1c2433" }
style.background2 = { common.color "#181f2c" }
style.background3 = { common.color "#181f2c" }
style.text = { common.color "#d0d7e4" }
style.caret = { common.color "#8196b5" }
style.accent = { common.color "#8196b5" }
style.dim = { common.color "#afbbd2" }
style.divider = { common.color "#11161f" }
style.selection = { common.color "#eacd614d" }
style.line_number = { common.color "#526a9680" }
style.line_number2 = { common.color "#7d91b8" }
style.line_highlight = { common.color "#2530434d" }
style.scrollbar = { common.color "#d0d7e426" }
style.scrollbar2 = { common.color "#d0d7e440" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#3CEC85" }
style.warn = { common.color "#FF955C" }
style.error = { common.color "#E35535" }

style.syntax["normal"] = { common.color "#afbbd2" }
style.syntax["symbol"] = { common.color "#afbbd2" }
style.syntax["comment"] = { common.color "#4a5e84" }
style.syntax["keyword"] = { common.color "#EACD61" }
style.syntax["keyword2"] = { common.color "#B78AFF" }
style.syntax["number"] = { common.color "#E35535" }
style.syntax["literal"] = { common.color "#E35535" }
style.syntax["string"] = { common.color "#3CEC85" }
style.syntax["operator"] = { common.color "#EACD61" }
style.syntax["function"] = { common.color "#69C3FF" }

return style
