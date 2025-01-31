-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- This file is automatically loaded by lazyvim.config.init

vim.api.nvim_set_keymap(
  "n",
  "<leader>tt",
  ":lua ToggleMarkdownTodo()<CR>",
  { noremap = true, silent = true, desc = "Toggle Markdown Todo" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>yq",
  ":QalcYank *<CR>",
  { noremap = true, silent = true, desc = "Copy Qalc Result" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>tn",
  ":NewObsidianTodoMulti<CR>",
  { noremap = true, silent = true, desc = "New Todo Item" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>te",
  ":EditObsidianTodoMulti<CR>",
  { noremap = true, silent = true, desc = "New Todo Item" }
)

-- Dial.nvim
vim.keymap.set("n", "<C-z>", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("v", "<C-z>", function()
  require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)

--------------------------------------------------------------------------------
-- open_floating_window(lines)
--   Creates a floating window with scratch buffer.
--   Returns: (buf, win)
--------------------------------------------------------------------------------
local function open_floating_window(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 60
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    row = row,
    col = col,
    width = width,
    height = height,
  })
  return buf, win
end

local function parse_tags(line)
  -- Look for: - [ ] ... or - [x] ... or - [-] ... or - [/] ...
  local check, rest = line:match("^%-%s*%[([ xX/%-])%]%s*(.-)$")
  if not check then
    return nil -- not a recognizable TODO line
  end

  -- Normalize uppercase X to lowercase x
  if check == "X" then
    check = "x"
  end

  local tags = { _extra = {} }

  -- Grab all bracketed segments, e.g. [priority:: High], [completion:: 2025-01-28]
  local bracketed = {}
  for bracket_text in rest:gmatch("%[[^%]]-%]") do
    table.insert(bracketed, bracket_text)
  end

  -- Remove bracketed text from `rest` => the "core" title
  local core_text = rest
  for _, bt in ipairs(bracketed) do
    core_text = core_text:gsub(vim.pesc(bt), "")
  end
  core_text = vim.trim(core_text)

  for _, bt in ipairs(bracketed) do
    local k, v = bt:match("^%[(.-)::%s*(.-)%]$")
    if k and v then
      k = vim.trim(k)
      v = vim.trim(v)

      if
        k == "priority"
        or k == "due"
        or k == "est"
        or k == "proj"
        or k == "type"
        or k == "hours_actual"
        or k == "initiated" -- NEW
        or k == "completion" -- NEW
      then
        tags[k] = v
      else
        table.insert(tags._extra, bt)
      end
    else
      table.insert(tags._extra, bt)
    end
  end

  return check, core_text, tags
end

-- This pattern breaks the string into two captures:
--   1) Everything up to (and including) the *last* colon
--   2) Everything after that colon (captured by (.-)$)
-- We then return just the second capture (trimmed).
local function parse_line_for_value(s)
  -- This finds the position of the *last* colon in the string
  local last_colon_pos = s:match(".*(): ")

  -- If no colon is found, return empty
  if not last_colon_pos then
    return ""
  end

  -- Take everything after that colon, trimmed
  return vim.trim(s:sub(last_colon_pos + 1))
end

local function build_todo_line(check, title, tags)
  -- We allow recognized statuses: " ", "x", "/", "-"
  local recognized = { [" "] = true, ["x"] = true, ["/"] = true, ["-"] = true }
  if not recognized[check] then
    check = " "
  end

  local line = string.format("- [%s] %s", check, title)

  -- Insert known tags in a desired order
  if tags.priority and tags.priority ~= "" then
    line = line .. string.format(" [priority:: %s]", tags.priority)
  end
  if tags.due and tags.due ~= "" then
    line = line .. string.format(" [due:: %s]", tags.due)
  end
  if tags.est and tags.est ~= "" then
    line = line .. string.format(" [est:: %s]", tags.est)
  end
  if tags.proj and tags.proj ~= "" then
    line = line .. string.format(" [proj:: %s]", tags.proj)
  end
  if tags.type and tags.type ~= "" then
    line = line .. string.format(" [type:: %s]", tags.type)
  end
  if tags.hours_actual and tags.hours_actual ~= "" then
    line = line .. string.format(" [hours_actual:: %s]", tags.hours_actual)
  end

  -- NEW: add initiated/completion
  if tags.initiated and tags.initiated ~= "" then
    line = line .. string.format(" [initiated:: %s]", tags.initiated)
  end
  if tags.completion and tags.completion ~= "" then
    line = line .. string.format(" [completion:: %s]", tags.completion)
  end

  -- Reattach any unknown bracketed tags
  if tags._extra then
    for _, unknown_tag in ipairs(tags._extra) do
      line = line .. " " .. unknown_tag
    end
  end

  return line
end

function ToggleMarkdownTodo()
  local line = vim.fn.getline(".")
  local now = os.date("%Y-%m-%d %H:%M") -- e.g. "2025-01-28 17:45"

  -- Parse the current line's fields (checkmark, tags, etc.)
  local check, core_text, tags = parse_tags(line or "")
  if not check then
    vim.notify("No recognizable TODO on this line.", vim.log.levels.WARN)
    return
  end

  local new_check = check

  -- Decide the next status
  if check == " " then
    -- [ ] --> [-]
    new_check = "-"
    tags.completion = "" -- no completion time yet
    tags.initiated = now -- record that we've begun work
  elseif check == "-" then
    -- [-] --> [/]
    new_check = "/"
    tags.completion = ""
    -- If we somehow didn't have initiated set, set it now
    if not tags.initiated or tags.initiated == "" then
      tags.initiated = now
    end
  elseif check == "/" then
    -- [/] --> [x] (done)
    new_check = "x"
    tags.completion = now -- record completion
    -- keep tags.initiated (so we know when it was started)
  elseif check == "x" then
    -- [x] --> [ ] (re-open it)
    new_check = " "
    tags.initiated = "" -- clear started
    tags.completion = "" -- clear completion
  end

  -- Rebuild the line with the new status & updated tags
  local new_line = build_todo_line(new_check, core_text, tags)
  vim.fn.setline(".", new_line)
end

local function insert_obsidian_todo_multi()
  local original_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()

  local check = " " -- default to [ ]
  local title = ""
  local tags = {
    priority = "",
    due = "",
    est = "",
    proj = "",
    type = "Task",
    hours_actual = "",
    initiated = "",
    completion = "",
    _extra = {},
  }

  -- Lines for the floating window
  local input_lines = {
    "Task Title: " .. title,
    "Priority (Lowest|Low|Medium|High|Highest): " .. tags.priority,
    "Due date (YYYY-MM-DD): " .. tags.due,
    "Hours estimate: " .. tags.est,
    "Project: " .. tags.proj,
    "Type (Call|Chat|Task): " .. tags.type,
    "Hours Actual: " .. tags.hours_actual,
    -- Show initiated/completion if desired:
    "Initiated (YYYY-MM-DD HH:MM): " .. tags.initiated,
    "Completion (YYYY-MM-DD HH:MM): " .. tags.completion,
    "[x, /, -, or ' ' for checkmark]: " .. check,
    "",
    "Instructions:",
    "  • Edit each line as needed",
    "  • Press <Enter> to confirm, or <q> to cancel",
  }

  local buf, win = open_floating_window(input_lines)

  local function on_confirm()
    local user_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local new_title = parse_line_for_value(user_lines[1])
    local new_priority = parse_line_for_value(user_lines[2])
    local new_due = parse_line_for_value(user_lines[3])
    local new_est = parse_line_for_value(user_lines[4])
    local new_proj = parse_line_for_value(user_lines[5])
    local new_type = parse_line_for_value(user_lines[6]) or "Task"
    local new_hours_actual = parse_line_for_value(user_lines[7])
    local new_initiated = parse_line_for_value(user_lines[8])
    local new_completion = parse_line_for_value(user_lines[9])
    local new_check = parse_line_for_value(user_lines[10])

    -- Store in tags
    tags.priority = new_priority
    tags.due = new_due
    tags.est = new_est
    tags.proj = new_proj
    tags.type = (new_type == "") and "Task" or new_type
    tags.hours_actual = new_hours_actual
    tags.initiated = new_initiated
    tags.completion = new_completion

    local todo_line = build_todo_line(new_check, new_title, tags)

    vim.api.nvim_set_current_win(original_win)
    local cursor_pos = vim.api.nvim_win_get_cursor(original_win)
    local insert_line = cursor_pos[1]
    vim.api.nvim_buf_set_lines(original_buf, insert_line, insert_line, false, { todo_line })

    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  local function on_cancel()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  vim.keymap.set("n", "<CR>", on_confirm, { buffer = buf, nowait = true, noremap = true, silent = true })
  vim.keymap.set("n", "q", on_cancel, { buffer = buf, nowait = true, noremap = true, silent = true })
end

local function edit_obsidian_todo_multi()
  local original_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()

  local cursor_line = vim.api.nvim_win_get_cursor(original_win)[1]
  local line_text = vim.api.nvim_buf_get_lines(original_buf, cursor_line - 1, cursor_line, false)[1]

  -- Parse existing line
  local check, core_text, tags = parse_tags(line_text or "")
  if not check then
    vim.notify("No recognizable TODO on this line.", vim.log.levels.WARN)
    return
  end

  -- Defaults
  tags.priority = tags.priority or ""
  tags.due = tags.due or ""
  tags.est = tags.est or ""
  tags.proj = tags.proj or ""
  tags.type = tags.type or "Task"
  tags.hours_actual = tags.hours_actual or ""
  tags.initiated = tags.initiated or ""
  tags.completion = tags.completion or ""

  local input_lines = {
    "Task Title: " .. core_text,
    "Priority (Lowest|Low|Medium|High|Highest): " .. tags.priority,
    "Due date (YYYY-MM-DD): " .. tags.due,
    "Hours estimate: " .. tags.est,
    "Project: " .. tags.proj,
    "Type (Call|Chat|Task): " .. tags.type,
    "Hours Actual: " .. tags.hours_actual,
    "Initiated (YYYY-MM-DD HH:MM): " .. tags.initiated,
    "Completion (YYYY-MM-DD HH:MM): " .. tags.completion,
    "[x, /, -, or ' ' for checkmark]: " .. check,
    "",
    "Instructions:",
    "  • Edit each line as needed",
    "  • Press <Enter> to confirm changes, or <q> to cancel",
  }

  local buf, win = open_floating_window(input_lines)

  local function on_confirm()
    local user_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local new_title = parse_line_for_value(user_lines[0 + 1])
    local new_priority = parse_line_for_value(user_lines[1 + 1])
    local new_due = parse_line_for_value(user_lines[2 + 1])
    local new_est = parse_line_for_value(user_lines[3 + 1])
    local new_proj = parse_line_for_value(user_lines[4 + 1])
    local new_type = parse_line_for_value(user_lines[5 + 1]) or "Task"
    local new_hours_actual = parse_line_for_value(user_lines[6 + 1])
    local new_initiated = parse_line_for_value(user_lines[7 + 1])
    local new_completion = parse_line_for_value(user_lines[8 + 1])
    local new_check = parse_line_for_value(user_lines[9 + 1])

    tags.priority = new_priority
    tags.due = new_due
    tags.est = new_est
    tags.proj = new_proj
    tags.type = (new_type == "") and "Task" or new_type
    tags.hours_actual = new_hours_actual
    tags.initiated = new_initiated
    tags.completion = new_completion

    local new_line = build_todo_line(new_check, new_title, tags)

    vim.api.nvim_set_current_win(original_win)
    vim.api.nvim_buf_set_lines(original_buf, cursor_line - 1, cursor_line, false, { new_line })

    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  local function on_cancel()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  vim.keymap.set("n", "<CR>", on_confirm, { buffer = buf, nowait = true, noremap = true, silent = true })
  vim.keymap.set("n", "q", on_cancel, { buffer = buf, nowait = true, noremap = true, silent = true })
end

vim.api.nvim_create_user_command("EditObsidianTodoMulti", edit_obsidian_todo_multi, {})
vim.api.nvim_create_user_command("NewObsidianTodoMulti", insert_obsidian_todo_multi, {})
