-- Bearded Theme Vivid Light
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#f4f4f4" }
style.background2 = { common.color "#ebebeb" }
style.background3 = { common.color "#ebebeb" }
style.text = { common.color "#181818" }
style.caret = { common.color "#7e7e7e" }
style.accent = { common.color "#7e7e7e" }
style.dim = { common.color "#000000" }
style.divider = { common.color "#cecece" }
style.selection = { common.color "#d487004d" }
style.line_number = { common.color "#c1c1c1" }
style.line_number2 = { common.color "#686868" }
style.line_highlight = { common.color "#e5e5e580" }
style.scrollbar = { common.color "#18181826" }
style.scrollbar2 = { common.color "#18181840" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#42DD76" }
style.warn = { common.color "#FFB638" }
style.error = { common.color "#D62C2C" }

style.syntax["normal"] = { common.color "#000000" }
style.syntax["symbol"] = { common.color "#000000" }
style.syntax["comment"] = { common.color "#8a8a8a" }
style.syntax["keyword"] = { common.color "#d48700" }
style.syntax["keyword2"] = { common.color "#9c45ff" }
style.syntax["number"] = { common.color "#D62C2C" }
style.syntax["literal"] = { common.color "#D62C2C" }
style.syntax["string"] = { common.color "#00ac39" }
style.syntax["operator"] = { common.color "#d48700" }
style.syntax["function"] = { common.color "#0099ff" }

return style
