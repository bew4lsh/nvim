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

function ToggleMarkdownTodo()
  local line = vim.fn.getline(".")
  local today = os.date("%Y-%m-%d")

  -- Helper to remove any existing [completion:: ...] tag
  local function strip_completion_tag(str)
    return str:gsub("%[completion::.-%]", ""):gsub("%s+$", "")
  end

  if line:match("%- %[% %]") then
    -- [ ] => [-]
    line = line:gsub("%- %[% %]", "- [-]", 1)
    -- Remove any old completion tag if present
    line = strip_completion_tag(line)
  elseif line:match("%- %[%-%]") then
    -- [-] => [x], mark done, append [completion:: ...] at line end
    line = strip_completion_tag(line)
    line = line:gsub("%- %[%-%]", "- [x]", 1)
    line = line .. " [completion:: " .. today .. "]"
  elseif line:match("%- %[x%]") then
    -- [x] => [ ], revert to undone and remove completion tag
    line = line:gsub("%- %[x%]", "- [ ]", 1)
    line = strip_completion_tag(line)
  end

  vim.fn.setline(".", line)
end

--------------------------------------------------------------------------------
-- parse_tags(line)
--   Extracts:
--     - checkmark: one of " ", "x", "/", "-" (or uppercase "X")
--     - core text
--     - bracketed tags (priority, due, est, proj, plus unknown extras)
--------------------------------------------------------------------------------
local function parse_tags(line)
  -- Example recognized forms:
  --   - [ ] Title ...
  --   - [x] Title ...
  --   - [-] Title ...
  --   - [/] Title ...
  --
  -- Pattern: ^-%s*%[([ xX/%-])%]%s*(.-)$
  --   1) a dash + optional spaces
  --   2) a bracketed status capturing any single char from {space, x, X, /, -}
  --   3) everything else after that
  local check, rest = line:match("^%-%s*%[([ xX/%-])%]%s*(.-)$")
  if not check then
    return nil -- not recognized as a TODO line
  end

  -- Normalize uppercase X to lowercase x
  if check == "X" then
    check = "x"
  end

  -- We'll store known tags in a table
  local tags = {
    _extra = {}, -- for unknown bracketed tags
  }

  -- Example rest: "My Task [priority:: High] [due:: 2025-01-01] [proj:: MyProj] [foo:: bar]"
  -- We’ll find bracketed segments like "[priority:: High]"
  local bracketed = {}
  for bracket_text in rest:gmatch("%[[^%]]-%]") do
    table.insert(bracketed, bracket_text)
  end

  -- Remove bracketed text from `rest` to isolate the "core" title
  local core_text = rest
  for _, bt in ipairs(bracketed) do
    core_text = core_text:gsub(vim.pesc(bt), "")
  end
  core_text = vim.trim(core_text)

  -- Parse each bracketed piece to see if it's one of our known keys
  for _, bt in ipairs(bracketed) do
    -- pattern: "[something:: value]"
    local k, v = bt:match("^%[(.-)::%s*(.-)%]$")
    if k and v then
      k = vim.trim(k)
      v = vim.trim(v)
      if k == "priority" or k == "due" or k == "est" or k == "proj" then
        tags[k] = v
      else
        table.insert(tags._extra, bt)
      end
    else
      -- Not matching "key:: val", treat as unknown bracket
      table.insert(tags._extra, bt)
    end
  end

  return check, core_text, tags
end

--------------------------------------------------------------------------------
-- build_todo_line(check, title, tags)
--   Rebuilds the line as:
--   - [<check>] <title> [priority:: ...] [due:: ...] [est:: ...] [proj:: ...] + any extras
--------------------------------------------------------------------------------
local function build_todo_line(check, title, tags)
  -- We allow recognized statuses: " ", "x", "/", "-"
  local recognized = { [" "] = true, ["x"] = true, ["/"] = true, ["-"] = true }
  if not recognized[check] then
    check = " " -- default to incomplete if it's unrecognized
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

  -- Reattach any unknown bracketed tags
  if tags._extra then
    for _, unknown_tag in ipairs(tags._extra) do
      line = line .. " " .. unknown_tag
    end
  end

  return line
end

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

--------------------------------------------------------------------------------
-- parse_line_for_value("Label: value")
--------------------------------------------------------------------------------
local function parse_line_for_value(s)
  local idx = s:find(":")
  if idx then
    return vim.trim(s:sub(idx + 1))
  end
  return ""
end
--------------------------------------------------------------------------------
-- NEW TODO
--------------------------------------------------------------------------------
local function insert_obsidian_todo_multi()
  local original_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()

  -- Defaults
  local check = " " -- i.e. [ ]
  local title = ""
  local tags = {
    priority = "",
    due = "",
    est = "",
    proj = "",
    _extra = {},
  }

  -- Prepare lines for the floating window
  local input_lines = {
    "Task Title: " .. title,
    "Priority (Lowest|Low|Medium|High|Highest): " .. tags.priority,
    "Due date (YYYY-MM-DD): " .. tags.due,
    "Hours estimate: " .. tags.est,
    "Project: " .. tags.proj,
    "[x, /, -, or ' ' for checkmark]: " .. check,
    "",
    "Instructions:",
    "  • Edit each line as needed",
    "  • Press <Enter> to confirm, or <Esc> to cancel",
  }

  local buf, win = open_floating_window(input_lines)

  local function on_confirm()
    local user_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local new_title = parse_line_for_value(user_lines[1])
    local new_priority = parse_line_for_value(user_lines[2])
    local new_due = parse_line_for_value(user_lines[3])
    local new_est = parse_line_for_value(user_lines[4])
    local new_proj = parse_line_for_value(user_lines[5])
    local new_check = parse_line_for_value(user_lines[6])

    tags.priority = new_priority
    tags.due = new_due
    tags.est = new_est
    tags.proj = new_proj

    local todo_line = build_todo_line(new_check, new_title, tags)

    -- Insert into the original buffer
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
  vim.keymap.set("n", "<Esc>", on_cancel, { buffer = buf, nowait = true, noremap = true, silent = true })

  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("NewObsidianTodoMulti", insert_obsidian_todo_multi, {})
--------------------------------------------------------------------------------
-- EDIT EXISTING TODO
--------------------------------------------------------------------------------
local function edit_obsidian_todo_multi()
  local original_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()

  -- 1) Grab line under cursor
  local cursor_line = vim.api.nvim_win_get_cursor(original_win)[1]
  local line_text = vim.api.nvim_buf_get_lines(original_buf, cursor_line - 1, cursor_line, false)[1]

  -- 2) Parse
  local check, core_text, tags = parse_tags(line_text or "")
  if not check then
    vim.notify("No recognizable TODO on this line.", vim.log.levels.WARN)
    return
  end

  -- Provide defaults if missing
  tags.priority = tags.priority or ""
  tags.due = tags.due or ""
  tags.est = tags.est or ""
  tags.proj = tags.proj or ""

  -- 3) Create a scratch buffer with pre-filled fields
  local input_lines = {
    "Task Title: " .. core_text,
    "Priority (Lowest|Low|Medium|High|Highest): " .. tags.priority,
    "Due date (YYYY-MM-DD): " .. tags.due,
    "Hours estimate: " .. tags.est,
    "Project: " .. tags.proj,
    "[x, /, -, or ' ' for checkmark]: " .. check,
    "",
    "Instructions:",
    "  • Edit each line as needed",
    "  • Press <Enter> to confirm changes, or <Esc> to cancel",
  }

  local buf, win = open_floating_window(input_lines)

  local function on_confirm()
    local user_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local new_title = parse_line_for_value(user_lines[1])
    local new_priority = parse_line_for_value(user_lines[2])
    local new_due = parse_line_for_value(user_lines[3])
    local new_est = parse_line_for_value(user_lines[4])
    local new_proj = parse_line_for_value(user_lines[5])
    local new_check = parse_line_for_value(user_lines[6])

    tags.priority = new_priority
    tags.due = new_due
    tags.est = new_est
    tags.proj = new_proj

    local new_line = build_todo_line(new_check, new_title, tags)

    -- Replace line in the original buffer
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
  vim.keymap.set("n", "<Esc>", on_cancel, { buffer = buf, nowait = true, noremap = true, silent = true })

  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("EditObsidianTodoMulti", edit_obsidian_todo_multi, {})
