-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- This file is automatically loaded by lazyvim.config.init

function ToggleMarkdownTodo()
  local line = vim.fn.getline(".")
  if line:match("%- %[% %]") then
    line = line:gsub("%- %[% %]", "- [-]", 1)
  elseif line:match("%- %[%-%]") then
    line = line:gsub("%- %[%-%]", "- [x]", 1)
  elseif line:match("%- %[x%]") then
    line = line:gsub("%- %[x%]", "- [ ]", 1)
  end
  vim.fn.setline(".", line)
end

vim.api.nvim_set_keymap("n", "<leader>t", ":lua ToggleMarkdownTodo()<CR>", { noremap = true, silent = true })
