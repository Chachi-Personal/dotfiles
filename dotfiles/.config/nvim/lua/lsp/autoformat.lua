-- none-ls (null-ls) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LSP_NoneLS", { clear = true }),
	once = true,
	callback = function()
		-- tools.lua or lsp/completion.lua
		vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
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
	end,
})
