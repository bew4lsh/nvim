return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  -- Configure LazyVim to load gruvbox
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  { "rktjmp/lush.nvim" },
  -- { "nyoom-engineering/oxocarbon.nvim", opts = { background = "dark" } },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      local fm = require("fluoromachine")

      fm.setup({
        transparent = false,
        plugins = {
          neotree = true,
        },
        overrides = {
          ["@type"] = { italic = true, bold = false },
          ["@function"] = { italic = false, bold = false },
          ["@comment"] = { italic = true },
          ["@keyword"] = { italic = false },
          ["@constant"] = { italic = false, bold = false },
          ["@variable"] = { italic = true },
          ["@field"] = { italic = true },
          ["@parameter"] = { italic = true },
        },
        glow = false,
        theme = "delta",
        colors = function(_, color)
          local darken = color.darken
          local lighten = color.lighten
          local blend = color.blend
          local shade = color.shade
          local tint = color.tint
          return {
            bg = "#190920",
            bgdark = darken("#190920", 20),
            cyan = "#49eaff",
            red = "#ff006f",
            yellow = "#56ff75",
            orange = "#663173",
            pink = "#c4276e",
            purple = "#9544f7",
          }
        end,
      })
      vim.cmd.colorscheme("fluoromachine")
    end,
  },
  { "shaunsingh/moonlight.nvim" },
  { "olivercederborg/poimandres.nvim" },
  { "JoosepAlviste/palenightfall.nvim" },
  { "xero/miasma.nvim" },
  { "yonlu/omni.vim" },
  { "shrikecode/kyotonight.vim" },
  { "numToStr/Sakura.nvim" },
  { "luisiacc/the-matrix.nvim" },
  { "Scysta/pink-panic.nvim" },
  {
    "catppuccin/nvim",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
