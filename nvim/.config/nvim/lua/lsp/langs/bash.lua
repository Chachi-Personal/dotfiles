local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("bash-language-server")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh", "bash" },
	group = vim.api.nvim_create_augroup("Lang_Bash", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/bash-lsp/bash-language-server" })
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				for _, p in ipairs({ "bash-language-server", "shfmt" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end
		vim.lsp.enable("bashls")
	end,
})
