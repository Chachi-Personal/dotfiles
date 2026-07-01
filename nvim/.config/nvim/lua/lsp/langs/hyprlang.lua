local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("hyprland-vim-syntax")
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	-- Hyprland config files don't have a standard filetype; match by filename
	pattern = { "*/hypr/*.conf", "hyprland.conf", "hyprlock.conf", "hypridle.conf" },
	group = vim.api.nvim_create_augroup("Lang_Hyprlang", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/theRealCarneiro/hyprland-vim-syntax" })
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				local okp, pkg = pcall(reg.get_package, "hyprls")
				if okp and not pkg:is_installed() then
					pkg:install()
				end
			end)
		end
		vim.bo.filetype = "hyprlang"
		vim.lsp.enable("hyprls")
	end,
})
