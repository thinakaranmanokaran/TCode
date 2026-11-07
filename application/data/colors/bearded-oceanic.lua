-- Bearded Theme Oceanic
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1a2b34" }
style.background2 = { common.color "#16252d" }
style.background3 = { common.color "#16252d" }
style.text = { common.color "#cddde6" }
style.caret = { common.color "#97c892" }
style.accent = { common.color "#97c892" }
style.dim = { common.color "#acc6d4" }
style.divider = { common.color "#101a20" }
style.selection = { common.color "#f6cc734d" }
style.line_number = { common.color "#4d7f9a80" }
style.line_number2 = { common.color "#78a4bc" }
style.line_highlight = { common.color "#2339454d" }
style.scrollbar = { common.color "#cddde626" }
style.scrollbar2 = { common.color "#cddde640" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#97c892" }
style.warn = { common.color "#DC8255" }
style.error = { common.color "#ee5d75" }

style.syntax["normal"] = { common.color "#acc6d4" }
style.syntax["symbol"] = { common.color "#acc6d4" }
style.syntax["comment"] = { common.color "#467188" }
style.syntax["keyword"] = { common.color "#f6cc73" }
style.syntax["keyword2"] = { common.color "#978dd6" }
style.syntax["number"] = { common.color "#B4552D" }
style.syntax["literal"] = { common.color "#B4552D" }
style.syntax["string"] = { common.color "#97c892" }
style.syntax["operator"] = { common.color "#f6cc73" }
style.syntax["function"] = { common.color "#5fb2df" }

return style
