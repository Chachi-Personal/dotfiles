-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    filetypes = {},
    options = {
      opt = { -- vim.opt.<key>
        wildignorecase = true, -- ignore case in search patterns
        scrolloff = 10,
        -- jump = {},
      },
      g = {
        -- python3_host_prog = vim.fn.expand "$CONDA_PREFIX/bin/python",
      },
    },
    mappings = {
      n = {
        J = { "mzJ`z" }, -- make cursor stay when concattinating with J

        ["<C-_>"] = { "gcc", desc = "Toggle Comment", remap = true }, -- (ctrl+/) to comment
        ["<C-/>"] = { "gcc", desc = "Toggle Comment", remap = true }, -- (ctrl+/) to comment
      },
      i = {
        -- NOTE better undo breaks --
        ["<Space>"] = { "<Space><C-g>u" },
        [","] = { ",<C-g>u" },
        ["."] = { ".<C-g>u" },
        ["!"] = { "!<C-g>u" },
        ["?"] = { "?<C-g>u" },

        ["<C-s>"] = { "<Esc><cmd>silent! update! | redraw<CR>" },
      },
      v = {
        ["<C-_>"] = { "gc", desc = "Toggle Comment", remap = true },
        ["<C-/>"] = { "gc", desc = "Toggle Comment", remap = true },
      },
    },
  },
}
