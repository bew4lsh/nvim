return {
  {
    "jpalardy/vim-slime",
    config = function()
      -- Slime configuration
      vim.g.slime_target = "wezterm" -- Change to your target (wezterm, tmux, etc.)
      vim.g.slime_paste_file = vim.fn.expand("$HOME/.slime_paste")
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_default_config = {
        socket_name = "default",
        target_pane = ".2",
        pane_direction = "right",
        -- slime_python_ipython = 1,
      }
      -- function _EscapeText_python(text)
      --   if vim.g.slime_config_defaults["python_ipython"] == 1 and #vim.split(text, "\n") > 1 then
      --     return { "%cpaste -q\n", vim.g.slime_config_defaults["dispatch_ipython_pause"], text, "--\n" }
      --   else
      --     local empty_lines_pat = "(^|\n)\zs(s*\n+)+"
      --     local no_empty_lines = vim.fn.substitute(text, empty_lines_pat, "", "g")
      --     local dedent_pat = "(^|\n)\zs" .. vim.fn.matchstr(no_empty_lines, "^s*")
      --     local dedented_lines = vim.fn.substitute(no_empty_lines, dedent_pat, "", "g")
      --     local except_pat = [[\(elif\|else\|except\|finally\)\@!]]
      --     local add_eol_pat = "\ns[^\n]+\n\zs\ze(" .. except_pat .. [[\S\|$\)]]
      --     return vim.fn.substitute(dedented_lines, add_eol_pat, "\n", "g")
      --   end
      -- end
      -- Set up which-key keybinding for vim-slime
      local wk = require("which-key")
      wk.add({
        {
          { "<leader>t", group = "Slime" },
          { "<leader>ts", "<cmd>SlimeSend<cr>", desc = "Send to Slime", mode = { "n", "v" } },
          { "<leader>tc", "<cmd>SlimeConfig<cr>", desc = "Configure Slime", mode = { "n", "v" } },
        },
      })
    end,
  },
}
