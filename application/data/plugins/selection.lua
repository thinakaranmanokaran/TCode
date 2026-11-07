-- mod-version:4
local core = require "core"
local common = require "core.common"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"
local style = require "core.style"
local translate = require "core.doc.translate"

config.plugins.selection = common.merge({
  -- "ctrl" or "alt"; controls the modifier used with click to add a cursor.
  multicursor_modifier = "ctrl",
}, config.plugins.selection)


local function selection_snapshot(doc)
  local result = {}
  for i = 1, #doc.selections do
    result[i] = doc.selections[i]
  end
  return result
end


local function selections_equal(a, b)
  if not a or not b or #a ~= #b then return false end
  for i = 1, #a do
    if a[i] ~= b[i] then return false end
  end
  return true
end


local function expand_range(doc, line1, col1, line2, col2)
  -- Normalize a selection ending at the start of a line.
  if line2 > line1 and col2 == 1 then
    line2 = line2 - 1
    col2 = #doc.lines[line2]
  end

  if line1 == line2 and col1 == col2 then
    local l1, c1 = translate.start_of_word(doc, line1, col1)
    local l2, c2 = translate.end_of_word(doc, l1, c1)
    return l1, c1, l2, c2
  end

  local full_lines = col1 == 1 and col2 >= #doc.lines[line2]
  if not full_lines then
    return line1, 1, line2, #doc.lines[line2]
  end

  local first, last = line1, line2
  while first > 1 and not doc.lines[first - 1]:match("^%s*$") do
    first = first - 1
  end
  while last < #doc.lines and not doc.lines[last + 1]:match("^%s*$") do
    last = last + 1
  end

  if first == line1 and last == line2 then
    return 1, 1, #doc.lines, #doc.lines[#doc.lines]
  end
  return first, 1, last, #doc.lines[last]
end


local function expand_selection(dv)
  local doc = dv.doc
  local current = selection_snapshot(doc)
  local history = dv.selection_history
  if not history or not selections_equal(dv.selection_last, current) then
    history = {}
    dv.selection_history = history
  end
  history[#history + 1] = current

  local ranges = {}
  for idx, line1, col1, line2, col2 in doc:get_selections(true) do
    local l1, c1, l2, c2 = expand_range(doc, line1, col1, line2, col2)
    ranges[#ranges + 1] = { idx, l1, c1, l2, c2 }
  end
  for _, r in ipairs(ranges) do
    doc:set_selections(r[1], r[2], r[3], r[4], r[5])
  end
  doc:merge_cursors()
  dv.selection_last = selection_snapshot(doc)
  dv:scroll_to_make_visible(doc:get_selection(true))
  core.redraw = true
end


local function shrink_selection(dv)
  local doc = dv.doc
  local current = selection_snapshot(doc)
  local history = dv.selection_history
  if not history or #history == 0 or not selections_equal(dv.selection_last, current) then
    dv.selection_history = nil
    dv.selection_last = nil
    return
  end

  doc.selections = table.remove(history)
  doc:merge_cursors()
  doc.last_selection = common.clamp(doc.last_selection or 1, 1, math.max(1, #doc.selections / 4))
  dv.selection_last = selection_snapshot(doc)
  dv:scroll_to_make_visible(doc:get_selection(true))
  core.redraw = true
end


local function line_selections(doc)
  local result = {}
  for idx, line1, col1, line2, col2 in doc:get_selections(true) do
    if line2 > line1 and col2 == 1 then
      line2 = line2 - 1
      col2 = #doc.lines[line2]
    end
    result[#result + 1] = {
      idx = idx,
      line1 = line1,
      col1 = col1,
      line2 = line2,
      col2 = col2,
    }
  end
  table.sort(result, function(a, b)
    return a.line1 > b.line1 or (a.line1 == b.line1 and a.col1 > b.col1)
  end)
  return result
end


local function ensure_trailing_newline(doc, line)
  if line >= #doc.lines then
    doc:insert(line, math.huge, "\n")
  end
end


local function copy_lines(dv, direction)
  local doc = dv.doc
  local selections = line_selections(doc)
  for _, selection in ipairs(selections) do
    ensure_trailing_newline(doc, selection.line2)
  end
  for _, selection in ipairs(selections) do
    local text = doc:get_text(selection.line1, 1, selection.line2 + 1, 1)
    local line_count = selection.line2 - selection.line1 + 1
    if direction == "up" then
      doc:insert(selection.line1, 1, text)
      doc:set_selections(selection.idx,
        selection.line1 + line_count, selection.col1,
        selection.line2 + line_count, selection.col2)
    else
      doc:insert(selection.line2 + 1, 1, text)
      doc:set_selections(selection.idx,
        selection.line1, selection.col1,
        selection.line2, selection.col2)
    end
  end
  doc:merge_cursors()
  core.redraw = true
end


local function position_after_text(line, col, text)
  for i = 1, #text do
    if text:sub(i, i) == "\n" then
      line, col = line + 1, 1
    else
      col = col + 1
    end
  end
  return line, col
end


local function duplicate_selection(dv)
  local doc = dv.doc
  local selections = line_selections(doc)
  for _, selection in ipairs(selections) do
    ensure_trailing_newline(doc, selection.line2)
  end
  for _, selection in ipairs(selections) do
    local text = doc:get_text(selection.line1, selection.col1, selection.line2, selection.col2)
    if text == "" then
      local line_text = doc:get_text(selection.line1, 1, selection.line2 + 1, 1)
      doc:insert(selection.line2 + 1, 1, line_text)
      doc:set_selections(selection.idx,
        selection.line1, selection.col1,
        selection.line2, selection.col2)
    else
      local line2, col2 = position_after_text(selection.line2, selection.col2, text)
      doc:insert(selection.line2, selection.col2, text)
      doc:set_selections(selection.idx, selection.line2, selection.col2, line2, col2)
    end
  end
  doc:merge_cursors()
  core.redraw = true
end


local function add_cursors_to_line_ends(dv)
  local doc = dv.doc
  local targets = {}
  local seen = {}
  for _, selection in ipairs(line_selections(doc)) do
    for line = selection.line1, selection.line2 do
      local col = #doc.lines[line]
      local key = line .. ":" .. col
      if not seen[key] then
        seen[key] = true
        targets[#targets + 1] = { line = line, col = col }
      end
    end
  end
  table.sort(targets, function(a, b)
    return a.line < b.line or (a.line == b.line and a.col < b.col)
  end)
  if #targets == 0 then return end

  doc:set_selection(targets[1].line, targets[1].col)
  for i = 2, #targets do
    doc:add_selection(targets[i].line, targets[i].col)
  end
  doc:merge_cursors()
  core.redraw = true
end


local function add_next_occurrence(dv)
  if not dv.doc:has_selection() then
    command.perform("doc:select-word")
  end
  command.perform("find-replace:select-add-next")
end


local function add_previous_occurrence(dv)
  if not dv.doc:has_selection() then
    command.perform("doc:select-word")
  end
  command.perform("find-replace:select-add-previous")
end


local function select_all_occurrences(dv)
  if not dv.doc:has_selection() then
    command.perform("doc:select-word")
  end
  command.perform("find-replace:select-add-all")
end


local function remove_binding(stroke, cmd)
  local bindings = keymap.map[stroke]
  if bindings then
    for i = #bindings, 1, -1 do
      if bindings[i] == cmd then
        table.remove(bindings, i)
      end
    end
    if #bindings == 0 then
      keymap.map[stroke] = nil
    end
  end
  local reverse = keymap.reverse_map[cmd]
  if reverse then
    for i = #reverse, 1, -1 do
      if reverse[i] == stroke then
        table.remove(reverse, i)
      end
    end
  end
end


local function set_multicursor_modifier(modifier)
  remove_binding("ctrl+1lclick", "doc:split-cursor")
  remove_binding("alt+1lclick", "doc:split-cursor")
  keymap.add({ [modifier .. "+1lclick"] = "doc:split-cursor" })
  config.plugins.selection.multicursor_modifier = modifier
end


command.add("core.docview", {
  ["selection:expand"] = expand_selection,
  ["selection:shrink"] = shrink_selection,
  ["selection:copy-line-up"] = function(dv) copy_lines(dv, "up") end,
  ["selection:copy-line-down"] = function(dv) copy_lines(dv, "down") end,
  ["selection:duplicate"] = duplicate_selection,
  ["selection:add-cursors-to-line-ends"] = add_cursors_to_line_ends,
  ["selection:add-next-occurrence"] = add_next_occurrence,
  ["selection:add-previous-occurrence"] = add_previous_occurrence,
  ["selection:select-all-occurrences"] = select_all_occurrences,
})


command.add(nil, {
  ["selection:toggle-multicursor-modifier"] = function()
    local modifier = config.plugins.selection.multicursor_modifier == "ctrl" and "alt" or "ctrl"
    set_multicursor_modifier(modifier)
    core.status_view:show_message("i", style.text,
      "Multi-cursor: " .. (modifier == "ctrl" and "Ctrl" or "Alt") .. "+Click")
    core.redraw = true
  end,
  ["selection:toggle-column-mode"] = function()
    config.selection_column_mode = not config.selection_column_mode
    core.status_view:show_message("i", style.text,
      "Column Selection Mode: " .. (config.selection_column_mode and "On" or "Off"))
    core.redraw = true
  end,
})


keymap.add({
  ["shift+alt+right"] = "selection:expand",
  ["shift+alt+left"] = "selection:shrink",
  ["shift+alt+up"] = "selection:copy-line-up",
  ["shift+alt+down"] = "selection:copy-line-down",
  ["shift+alt+i"] = "selection:add-cursors-to-line-ends",
})

keymap.add({
  ["ctrl+d"] = "selection:add-next-occurrence",
  ["ctrl+shift+l"] = "selection:select-all-occurrences",
}, true)

set_multicursor_modifier(config.plugins.selection.multicursor_modifier)

return {}
