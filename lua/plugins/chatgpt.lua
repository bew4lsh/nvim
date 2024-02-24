return {
  {
    "jackMort/ChatGPT.nvim",
    keys = {
      { "<leader>cg", "<cmd>ChatGPT<cr>", desc = "Chat GPT" },
    },
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
