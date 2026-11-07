-- Dimmed Monokai theme.

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1E1F1C" }
style.background2 = { common.color "#181915" }
style.background3 = { common.color "#181915" }
style.text = { common.color "#B0B0A8" }
style.caret = { common.color "#F8F8F0" }
style.accent = { common.color "#F8F8F2" }
style.dim = { common.color "#5E6052" }
style.divider = { common.color "#181915" }
style.selection = { common.color "#49483E" }
style.line_number = { common.color "#75715E" }
style.line_number2 = { common.color "#B0B0A8" }
style.line_highlight = { common.color "#2D2E2A" }
style.scrollbar = { common.color "#53534F" }
style.scrollbar2 = { common.color "#5E6052" }

style.syntax["normal"] = { common.color "#B0B0A8" }
style.syntax["symbol"] = { common.color "#B0B0A8" }
style.syntax["comment"] = { common.color "#75715E" }
style.syntax["keyword"] = { common.color "#F92672" }
style.syntax["keyword2"] = { common.color "#F92672" }
style.syntax["number"] = { common.color "#AE81FF" }
style.syntax["literal"] = { common.color "#E6DB74" }
style.syntax["string"] = { common.color "#E6DB74" }
style.syntax["operator"] = { common.color "#F92672" }
style.syntax["function"] = { common.color "#A6E22E" }

return style
