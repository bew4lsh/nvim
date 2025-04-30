return {
  {
    "bew4lsh/Fetter",
    dependencies = {
      -- Add dependencies if needed
    },
    keys = {
      -- Example key mapping integration
      { "<leader>tt", "<cmd>FetterToggle<cr>", desc = "Toggle Task" },
      { "<leader>tn", "<cmd>FetterNew<cr>", desc = "New Task" },
      { "<leader>te", "<cmd>FetterEdit<cr>", desc = "Edit Task" },
      { "<leader>tf", "<cmd>FetterFilter<cr>", desc = "Filter Tasks" },
      { "<leader>ts", "<cmd>FetterStats<cr>", desc = "Task Statistics" },
    },
    opts = {
      -- Your configuration options
      tags = {
        priority = true,
        due = true,
        est = true,
        proj = true,
      },
      ui = {
        width = 60,
        border = "rounded",
      },
    },
  },
}
