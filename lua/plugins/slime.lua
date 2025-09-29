return {
  {
    "jpalardy/vim-slime",
    config = function()
      -- Slime configuration
      vim.g.slime_target = "wezterm" -- Change to your target (wezterm, tmux, etc.)
      vim.g.slime_paste_file = vim.fn.expand("$HOME/.slime_paste")
      
      -- Option 2: Try experimental bracketed paste with custom sequences
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_pre_send = "\027[200~"   -- ESC[200~ in octal (bracketed paste start)
      vim.g.slime_post_send = "\027[201~"  -- ESC[201~ in octal (bracketed paste end)
      
      -- Option 3: If Option 2 fails, comment out the above and uncomment below
      -- This uses the paste file approach with explicit preservation settings
      -- vim.g.slime_preserve_curpos = 0
      -- vim.g.slime_python_ipython = 1
      -- vim.g.slime_dispatch_ipython_pause = 100  -- milliseconds
      
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
      -- local wk = require("which-key")
      -- wk.add({
      --   { "<leader>s", group = "Slime" },
      --   { "<leader>ss", "<cmd>SlimeSend<cr>", desc = "Send to Slime", mode = { "n", "v" } },
      --   { "<leader>sc", "<cmd>SlimeConfig<cr>", desc = "Configure Slime", mode = { "n", "v" } },
      -- })
    end,
  },
}
