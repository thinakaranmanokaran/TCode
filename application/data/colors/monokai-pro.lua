-- Monokai Pro inspired theme.

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#2D2A2E" }
style.background2 = { common.color "#221F22" }
style.background3 = { common.color "#221F22" }
style.text = { common.color "#FCFCFA" }
style.caret = { common.color "#FFD866" }
style.accent = { common.color "#FFD866" }
style.dim = { common.color "#727072" }
style.divider = { common.color "#19181A" }
style.selection = { common.color "#5B595C" }
style.line_number = { common.color "#727072" }
style.line_number2 = { common.color "#C1C0C0" }
style.line_highlight = { common.color "#3A383B" }
style.scrollbar = { common.color "#5B595C" }
style.scrollbar2 = { common.color "#727072" }

style.syntax["normal"] = { common.color "#FCFCFA" }
style.syntax["symbol"] = { common.color "#FCFCFA" }
style.syntax["comment"] = { common.color "#727072" }
style.syntax["keyword"] = { common.color "#FF6188" }
style.syntax["keyword2"] = { common.color "#FF6188" }
style.syntax["number"] = { common.color "#AB9DF2" }
style.syntax["literal"] = { common.color "#FFD866" }
style.syntax["string"] = { common.color "#FFD866" }
style.syntax["operator"] = { common.color "#FF6188" }
style.syntax["function"] = { common.color "#A9DC76" }

return style
