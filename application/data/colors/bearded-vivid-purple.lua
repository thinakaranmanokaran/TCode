-- Bearded Theme Vivid Purple
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#171131" }
style.background2 = { common.color "#130e29" }
style.background3 = { common.color "#130e29" }
style.text = { common.color "#c7bfe8" }
style.caret = { common.color "#A680FF" }
style.accent = { common.color "#A680FF" }
style.dim = { common.color "#a699db" }
style.divider = { common.color "#0c091a" }
style.selection = { common.color "#ffb6384d" }
style.line_number = { common.color "#4c38a380" }
style.line_number2 = { common.color "#7360c8" }
style.line_highlight = { common.color "#2018444d" }
style.scrollbar = { common.color "#c7bfe826" }
style.scrollbar2 = { common.color "#c7bfe840" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#42DD76" }
style.warn = { common.color "#FFB638" }
style.error = { common.color "#D62C2C" }

style.syntax["normal"] = { common.color "#a699db" }
style.syntax["symbol"] = { common.color "#a699db" }
style.syntax["comment"] = { common.color "#44338f" }
style.syntax["keyword"] = { common.color "#FFB638" }
style.syntax["keyword2"] = { common.color "#A95EFF" }
style.syntax["number"] = { common.color "#D62C2C" }
style.syntax["literal"] = { common.color "#D62C2C" }
style.syntax["string"] = { common.color "#42DD76" }
style.syntax["operator"] = { common.color "#FFB638" }
style.syntax["function"] = { common.color "#28A9FF" }

return style
