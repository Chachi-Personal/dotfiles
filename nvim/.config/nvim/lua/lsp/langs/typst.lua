vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typst" },
	group = vim.api.nvim_create_augroup("Lang_Typst", { clear = true }),
	once = true,
	callback = function()
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				local okp, pkg = pcall(reg.get_package, "tinymist")
				if okp and not pkg:is_installed() then
					pkg:install()
				end
			end)
		end
		vim.lsp.enable("tinymist")
	end,
})
