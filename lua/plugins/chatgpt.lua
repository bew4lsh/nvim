return {
  {
    "jackMort/ChatGPT.nvim",
    keys = {
      { "<leader>cg", "<cmd>ChatGPT<cr>", desc = "Chat GPT" },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstructions<cr>", desc = "Edit with instructions", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<cr>", desc = "Edit with instructions", mode = { "n", "v" } },
      { "<leader>cy", "<cmd>ChatGPTRun grammar_correction<cr>", desc = "Edit with instructions", mode = { "n", "v" } },
      { "<leader>ci", "<cmd>ChatGPTRun clarify_idea<cr>", desc = "Clarify Idea", mode = { "n", "v" } },
    },
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        chat = {
          keymaps = {
            close = "<C-c>",
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
            -- cycle_modes = "<C-f>",
            next_message = "<C-j>",
            prev_message = "<C-k>",
            select_session = "<Space>",
            rename_session = "r",
            delete_session = "d",
            draft_message = "<C-r>",
            edit_message = "e",
            delete_message = "d",
            toggle_settings = "<C-o>",
            toggle_sessions = "<C-p>",
            toggle_help = "<C-h>",
            toggle_message_role = "<C-r>",
            toggle_system_role_open = "<C-s>",
            stop_generating = "<C-x>",
            send_file_content = "<C-f>", -- New keybinding
          },
        },
        actions_paths = { "C:/Users/william.j.walsh/AppData/Local/nvim/lua/plugins/chatgpt_actions.json" },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
