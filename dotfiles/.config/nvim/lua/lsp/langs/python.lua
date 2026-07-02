local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("venv-selector.nvim")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	group = vim.api.nvim_create_augroup("Lang_Python", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/linux-cultist/venv-selector.nvim" })
		vim.lsp.enable("basedpyright")
		vim.lsp.enable("ruff")

		vim.schedule(function()
			local ok, reg = pcall(require, "mason-registry")
			if not ok then
				return
			end
			reg.refresh(function()
				for _, p in ipairs({ "basedpyright", "ruff", "debugpy" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end)

		vim.schedule(function()
			local oks, sel = pcall(require, "venv-selector")
			if oks then
				sel.setup({})
			end
		end)
	end,
})
