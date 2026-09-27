vim.schedule(function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		format_on_save = function(bufnr)
			if vim.b[bufnr].autoformat == false then
				return nil
			end
			return { timeout_ms = 1000, lsp_fallback = true }
		end,
	})
end)
