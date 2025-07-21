return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
      { "<leader>gvf", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle File Panel" },
      { "<leader>gvF", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
    },
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>gv", group = "diffview" },
      })
    end,
  },
}
