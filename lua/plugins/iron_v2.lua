return {
  "Vigemus/iron.nvim",
  keys = {
    { "<leader>rs", "<cmd>IronRepl<cr>", desc = "Start REPL", mode = { "n" } },
    { "<leader>rr", "<cmd>IronRestart<cr>", desc = "Restart REPL", mode = { "n" } },
    { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus REPL", mode = { "n" } },
    { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL", mode = { "n" } },
    -- Add which-key compatible keymaps here
  },
  config = function()
    local iron = require("iron.core")
    local wk = require("which-key")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          ps1 = {
            command = { "pwsh" },
          },
          sh = {
            command = { "zsh" },
          },
          py = {
            command = "python3",
          },
        },
        repl_open_cmd = require("iron.view").right(80),
      },
      keymaps = {
        -- You can keep the original keymaps here if needed
        visual_send = "<leader>rc",
        send_file = "<leader>ra",
        send_line = "<leader>rl",
        send_mark = "<leader>rm",
        -- mark_visual = "<leader>rc",
        remove_mark = "<leader>rd",
        interrupt = "<leader>r<leader>",
        exit = "<leader>rq",
        clear = "<leader>rl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })
    -- Register which-key mappings
    wk.add({
      {
        { "<leader>r", group = "REPL" },
        { "<leader>rs", "<cmd>IronRepl<cr>", desc = "Start repl" },
        { "<leader>rr", "<cmd>IronRestart<cr>", desc = "Restart repl" },
        { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide repl" },
        { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus repl" },
        { "<leader>rl", desc = "Clear repl" },
        { "<leader>rc", desc = "Visual Send", mode = { "v" } },
        { "<leader>ra", desc = "Send File", mode = { "n" } },
        { "<leader>rl", desc = "Send Line", mode = { "n" } },
        { "<leader>rm", desc = "Send Mark", mode = { "n" } },
        { "<leader>rd", desc = "Remove Mark", mode = { "n" } },
        { "<leader>r<leader>", desc = "Interrupt", mode = { "n" } },
        { "<leader>rq", desc = "Exit", mode = { "n" } },
        { "<leader>rl", desc = "Clear", mode = { "n" } },
      },
    })
  end,
}
