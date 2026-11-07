-- Bearded Theme Solarized Light
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#fdf6e3" }
style.background2 = { common.color "#f4edda" }
style.background3 = { common.color "#f4edda" }
style.text = { common.color "#000000" }
style.caret = { common.color "#2aa198" }
style.accent = { common.color "#2aa198" }
style.dim = { common.color "#000000" }
style.divider = { common.color "#ddd3b7" }
style.selection = { common.color "#cf9c014d" }
style.line_number = { common.color "#d5c8a6" }
style.line_number2 = { common.color "#887540" }
style.line_highlight = { common.color "#fbedc680" }
style.scrollbar = { common.color "#00000026" }
style.scrollbar2 = { common.color "#00000040" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#a5b82e" }
style.warn = { common.color "#e2ae10" }
style.error = { common.color "#f45645" }

style.syntax["normal"] = { common.color "#000000" }
style.syntax["symbol"] = { common.color "#000000" }
style.syntax["comment"] = { common.color "#8fa2a0" }
style.syntax["keyword"] = { common.color "#cf9c01" }
style.syntax["keyword2"] = { common.color "#666bd6" }
style.syntax["number"] = { common.color "#eb4937" }
style.syntax["literal"] = { common.color "#eb4937" }
style.syntax["string"] = { common.color "#819501" }
style.syntax["operator"] = { common.color "#cf9c01" }
style.syntax["function"] = { common.color "#2c97e3" }

return style
