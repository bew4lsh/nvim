return {
  {
    "bew4lsh/Fetter",
    dependencies = {
      -- Add dependencies if needed
    },
    ft = { "markdown" }, -- Only load for markdown files
    keys = {
      -- Core task management
      { "<leader>tt", "<cmd>FetterToggle<cr>", desc = "Toggle Task" },
      { "<c-t>", "<cmd>FetterToggle<cr>", desc = "Toggle Task" },
      { "<leader>tS", "<cmd>FetterToggleWithSubtasks<cr>", desc = "Toggle with Subtasks" },
      { "<leader>tn", "<cmd>FetterNew<cr>", desc = "New Task" },
      { "<leader>te", "<cmd>FetterEdit<cr>", desc = "Edit Task" },
      { "<leader>tf", "<cmd>FetterFilter<cr>", desc = "Filter Tasks" },
      { "<leader>ts", "<cmd>FetterStats<cr>", desc = "Task Statistics" },

      -- Batch operations
      { "<leader>tb", "<cmd>FetterBatchSelect<cr>", desc = "Toggle Batch Selection" },
      { "<leader>tm", "<cmd>FetterBatchMenu<cr>", desc = "Batch Operations Menu" },

      -- Conversion
      { "<leader>tc", "<cmd>FetterConvert<cr>", desc = "Convert to Task" },
      { "<leader>tC", "<cmd>FetterConvertVisual<cr>", mode = "v", desc = "Convert Selected to Tasks" },

      -- Project management
      { "<leader>tp", "<cmd>FetterProjects<cr>", desc = "Project Dashboard" },
      { "<leader>tP", "<cmd>FetterProjectNew<cr>", desc = "Create New Project" },

      -- Recurring tasks
      { "<leader>tr", "<cmd>FetterSetRecurrence<cr>", desc = "Set Task Recurrence" },
      { "<leader>tR", "<cmd>FetterProcessRecurring<cr>", desc = "Process Recurring Tasks" },

      -- Templates
      { "<leader>tT", "<cmd>FetterUseTemplate<cr>", desc = "Use Task Template" },
      { "<leader>tl", "<cmd>FetterTemplates<cr>", desc = "Template Dashboard" },

      -- Dependencies
      { "<leader>td", "<cmd>FetterShowDependencies<cr>", desc = "Show Task Dependencies" },
      { "<leader>tD", "<cmd>FetterDependencies<cr>", desc = "Dependency Dashboard" },

      -- Reports
      { "<leader>tE", "<cmd>FetterReports<cr>", desc = "Report Menu" },
      { "<leader>tc", "<cmd>FetterCompletedReport<cr>", desc = "Completed Tasks Report" },
      { "<leader>tg", "<cmd>FetterTimeReport<cr>", desc = "Time Tracking Report" },
      { "<leader>ti", "<cmd>FetterInProgress<cr>", desc = "In-Progress Tasks Report" },
    },
    opts = {
      -- Your configuration options
      tags = {
        priority = true,
        due = true,
        est = true,
        proj = true,
        type = true,
        hours_actual = true,
        initiated = true,
        completion = true,
        recur = true,
        id = true,
        depends = true,
      },
      ui = {
        width = 60,
        border = "rounded",
      },
      -- Automatic filetype detection is handled by lazy.nvim's ft parameter
    },
  },
}
