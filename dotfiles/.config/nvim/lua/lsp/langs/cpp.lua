local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("clangd_extensions.nvim")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
	group = vim.api.nvim_create_augroup("Lang_Cpp", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({
			"https://github.com/p00f/clangd_extensions.nvim",
		})
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				for _, p in ipairs({ "clangd", "clang-format" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end
		vim.lsp.enable("clangd")
		local oke, ext = pcall(require, "clangd_extensions")
		if oke then
			ext.setup({})
		end
	end,
})
