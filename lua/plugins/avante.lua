return {
  "yetone/avante.nvim",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "openai",
    auto_suggestions_provider = "openai",

    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20241022",
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },

      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "o4-mini",
        timeout = 30000, -- timeout is *not* part of the body, so it stays here
        extra_request_body = {
          max_completion_tokens = 4096,
        },
      },
    },

    dual_boost = {
      enabled = false,
      first_provider = "openai",
      second_provider = "claude",
      prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      timeout = 60000,
    },

    behaviour = { ... },
    mappings = { ... },
    hints = { enabled = false },
    windows = { ... },
    highlights = { ... },
    diff = { ... },
  },
  build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false", -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  web_search_engine = {
    provider = "tavily", -- tavily, serpapi, google, kagi, brave, or searxng
    proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
  },
}
