vim.api.nvim_create_autocmd("FileType", {
	pattern = { "nix" },
	group = vim.api.nvim_create_augroup("Lang_Nix", { clear = true }),
	once = true,
	callback = function()
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				-- statix and deadnix may not be in Mason registry; install via your system package manager
				for _, p in ipairs({ "nixd" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end
		vim.lsp.enable("nixd")
	end,
})
