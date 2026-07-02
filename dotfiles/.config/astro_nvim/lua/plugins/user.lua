---@type LazySpec
return {
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "h-hg/fcitx.nvim",
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
      },
      scroll = {
        enabled = true,
      },
    },
    keys = {
      { "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
      { "<C-p>", function() require("snacks").picker.files() end, desc = "Smart Find Files" },
      { "<Leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<Leader>f.", function() require("snacks").scratch.select() end, desc = "Toggle Scratch Buffer" },

      ---: GitHub Cli :---
      { "<leader>gi", function() require("snacks").picker.gh_issue() end, desc = "GitHub Issues (open)" },
      {
        "<leader>gI",
        function() require("snacks").picker.gh_issue { state = "all" } end,
        desc = "GitHub Issues (all)",
      },
      { "<leader>gp", function() require("snacks").picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      {
        "<leader>gP",
        function() require("snacks").picker.gh_pr { state = "all" } end,
        desc = "GitHub Pull Requests (all)",
      },

      ---: Git Browse :---
      { "<leader>gw", function() require("snacks").gitbrowse() end, desc = "Open active repo in the browser" },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })

      -- include the default astronvim config that calls the setup call
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { vim.fn.stdpath "config" .. "/snippets" },
      }
    end,
  },
  {
    "toppair/peek.nvim",
    lazy = true,
    build = "deno task --quiet build:fast",
    opts = {
      app = { "brave", "--new-window" },
    },
    keys = {
      {
        "<f3>",
        function()
          if not vim.g.peek_open then
            require("peek").open()
            vim.notify("Peek opened", vim.log.levels.INFO, { title = "Markdown Preview" })
          else
            require("peek").close()
            vim.notify("Peek closed", vim.log.levels.INFO, { title = "Markdown Preview" })
          end
          vim.g.peek_open = not vim.g.peek_open
        end,
        mode = "n",
        ft = { "markdown" },
      },
    },
  },
}
