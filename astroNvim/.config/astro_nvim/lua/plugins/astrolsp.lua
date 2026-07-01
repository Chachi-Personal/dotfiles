-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = { -- Configuration table of features provided by AstroLSP
      inlay_hints = false, -- enable/disable inlay hints on start
    },
    formatting = { -- customize lsp formatting options
      timeout_ms = 1000, -- default format timeout
    },
    servers = {}, -- enable servers that you already have installed without mason
    config = {},
    handlers = {},
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    mappings = {
      n = {},
    },
    on_attach = function(client, bufnr) end,
  },
}
