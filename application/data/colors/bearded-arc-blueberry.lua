-- Bearded Theme Arc Blueberry
-- Generated from the Bearded Theme color scheme.
local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#111422" }
style.background2 = { common.color "#0d101b" }
style.background3 = { common.color "#0d101b" }
style.text = { common.color "#bcc1dc" }
style.caret = { common.color "#8eb0e6" }
style.accent = { common.color "#8eb0e6" }
style.dim = { common.color "#9aa2cb" }
style.divider = { common.color "#07080e" }
style.selection = { common.color "#eacd614d" }
style.line_number = { common.color "#44508880" }
style.line_number2 = { common.color "#6673b3" }
style.line_highlight = { common.color "#1a1e334d" }
style.scrollbar = { common.color "#bcc1dc26" }
style.scrollbar2 = { common.color "#bcc1dc40" }
style.scrollbar_track = { common.color "rgba(0,0,0,0)" }
style.good = { common.color "#3CEC85" }
style.warn = { common.color "#FF955C" }
style.error = { common.color "#E35535" }

style.syntax["normal"] = { common.color "#9aa2cb" }
style.syntax["symbol"] = { common.color "#9aa2cb" }
style.syntax["comment"] = { common.color "#3c4776" }
style.syntax["keyword"] = { common.color "#EACD61" }
style.syntax["keyword2"] = { common.color "#B78AFF" }
style.syntax["number"] = { common.color "#E35535" }
style.syntax["literal"] = { common.color "#E35535" }
style.syntax["string"] = { common.color "#3CEC85" }
style.syntax["operator"] = { common.color "#EACD61" }
style.syntax["function"] = { common.color "#69C3FF" }

return style
