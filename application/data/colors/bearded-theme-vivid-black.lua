-- Theme by @xStormyy on GitHub
-- Original color scheme: https://github.com/BeardedBear/bearded-theme
-- Adapted from lite-xl/lite-xl-colors (MIT).

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#141417" }
style.syntax["normal"] = { common.color "#c8c8c8" }
style.syntax["symbol"] = { common.color "#c8c8c8" }
style.syntax["comment"] = { common.color "#555555" }
style.syntax["keyword"] = { common.color "#28A9FF" }
style.syntax["keyword2"] = { common.color "#E66DFF" }
style.syntax["keyword3"] = { common.color "#FF00FF" }
style.syntax["number"] = { common.color "#FF7135" }
style.syntax["literal"] = { common.color "#FFB638" }
style.syntax["string"] = { common.color "#42DD76" }
style.syntax["operator"] = { common.color "#c8c8c8" }
style.syntax["function"] = { common.color "#FFB638" }

style.caret = { common.color "#FFB638" }
style.line_highlight = { common.color "#aaaaaa0d" }
style.selection = { common.color "#aaaaaa40" }
style.guide = { common.color "#55555530" }
style.guide_highlighting = { common.color "#555555bb" }

style.lint = {}
style.lint.info = { common.color "#28A9FF" }
style.lint.hint = { common.color "#42DD76" }
style.lint.warning = { common.color "#FFB638" }
style.lint.error = { common.color "#D62C2C" }

style.background2 = { common.color "#0f0f11" }
style.background3 = { common.color "#0f0f11" }
style.text = { common.color "#afafafCC" }
style.accent = style.caret
style.divider = { common.color "#060607" }
style.line_number = { common.color "#55555590" }
style.line_number2 = { common.color "#555555" }

return style
