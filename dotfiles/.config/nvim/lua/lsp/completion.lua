-- Register build hook for blink.cmp before vim.pack.add()
-- vim.api.nvim_create_autocmd("PackChanged", {
-- 	callback = function(ev)
-- 		local name = ev.data.spec.name
-- 		local kind = ev.data.kind
-- 		if name == "blink.cmp" and (kind == "install" or kind == "update") then
-- 			vim.notify("blink.cmp: building Rust binary...", vim.log.levels.INFO)
-- 			vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
-- 			vim.notify("blink.cmp: build complete", vim.log.levels.INFO)
-- 		end
-- 	end,
-- })
-- Core LSP infrastructure - loaded on first file open
-- Mason + blink.cmp loaded on first file open (replaces mason-lspconfig bridge)
-- Copilot — deferred (was loaded after blink.cmp)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LSP_Core", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/saghen/blink.lib" },
			{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
			{ src = "https://github.com/fang2hou/blink-copilot" },
			{ src = "https://github.com/zbirenbaum/copilot.lua" },
			{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("^2") },
			{ src = "https://github.com/iurimateus/luasnip-latex-snippets.nvim" },
			{ src = "https://github.com/folke/lazydev.nvim" }, -- lua_ls devtools
		})

		require("lazydev").setup({
			library = {
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		})
		-- require("lsp_signature").setup({
		-- 	hint_enable = false,
		-- 	handler_opts = { border = "rounded" },
		-- })
		require("copilot").setup({
			suggestion = { enabled = false }, -- blink handles UI
			panel = { enabled = false },
		})
		require("blink.cmp").setup({
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				-- Tab: cycle forward through list (text auto-inserts as you go)
				-- Also jumps to next snippet placeholder AFTER acceptance
				["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

				-- Enter: accept selected item (expands snippet if it is one)
				["<CR>"] = { "accept", "fallback" },

				-- Arrow keys as alternative navigation
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },

				-- Documentation scrolling
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				-- Signature help
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},
			completion = {
				list = {
					selection = {
						preselect = false, -- first item pre-selected when menu opens
						auto_insert = true, -- text changes as you Tab through the list
					},
					cycle = {
						from_bottom = true, -- Tab at bottom wraps to top
						from_top = true, -- S-Tab at top wraps to bottom
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					-- border = nil,
				},
				-- Don't re-trigger completions while inside a snippet
				trigger = {
					show_in_snippet = false,
				},
			},
			appearance = { use_nvim_cmp_as_default = false },
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 8,
						async = true,
					},
				},
			},
			signature = {
				enabled = true,
			},
		})
		require("luasnip").config.setup({
			enable_autosnippets = true,
		})
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets" },
		})
		local ft = vim.bo.filetype
		if ft ~= "" then
			require("luasnip.loaders.from_vscode").load_standalone({
				path = vim.fn.stdpath("config") .. "/snippets/" .. ft .. ".json",
				lazy = false,
			})
		end
		require("luasnip.loaders.from_snipmate").lazy_load()
		require("luasnip.loaders.from_lua").lazy_load()
	end,
})

-- none-ls (null-ls) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LSP_NoneLS", { clear = true }),
	once = true,
	callback = function()
		-- tools.lua or lsp/completion.lua
		vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
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
	end,
})
