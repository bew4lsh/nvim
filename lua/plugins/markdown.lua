-- ~/.config/nvim/lua/plugins/render-markdown.lua
return {
  {
    -- ⬅ make sure the repo string matches the one used by LazyVim
    "MeanderingProgrammer/render-markdown.nvim",

    -- 1)  EITHER: just override options
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      code = { sign = true, width = "block", right_pad = 1 },
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰋑  ", "  ", "󰋕  ", "󰋕  ", "󰋕  ", "󰋕  " },
        signs = { " " },
        width = "full",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      checkbox = {
        enabled = true,
        right_pad = 1,
        unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
        checked = { icon = "✔️ ", highlight = "RenderMarkdownChecked", scope_highlight = "@markup.italic" },
        custom = {
          cancelled = {
            raw = "[-]",
            rendered = "⊘ ",
            highlight = "RenderMarkdownTodo",
            scope_highlight = "@markup.strikethrough",
          },
          todo = {
            raw = "[/]",
            rendered = "↗ ",
            highlight = "RenderMarkdownTodo",
            scope_highlight = "@markup.strong",
          },
        },
      },
    },
  },
}
