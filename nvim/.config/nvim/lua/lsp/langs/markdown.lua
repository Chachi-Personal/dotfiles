local lazy_packages = require("plugins.lazy_packages")

lazy_packages.register("render-markdown.nvim")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	group = vim.api.nvim_create_augroup("Lang_Markdown", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				for _, p in ipairs({ "marksman", "prettier" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end
		vim.lsp.enable("marksman")
		local ok, rm = pcall(require, "render-markdown")
		if ok then
			rm.setup({
				preset = "obsidian",
				code = {
					enabled = true,
					render_modes = true,
					border = "thin",
				},
				checkbox = {
					render_modes = true,
				},
				callout = {
					multi_column = {
						raw = "[!multi-column|no-wrap]",
						rendered = "󰘦 Multi Column No Wrap",
						highlight = "RenderMarkdownInfo",
						category = "obsidian",
					},
					blank_container = {
						raw = "[!blank-container|min-0]",
						rendered = "                         ",
						highlight = "RenderMarkdownInfo",
						category = "obsidian",
					},
				},
			})
		end
		local ok, luasnip = pcall(require, "luasnip")
		if ok then
			luasnip.config.set_config({
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})

			-- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets/" })
		end
	end,
})
