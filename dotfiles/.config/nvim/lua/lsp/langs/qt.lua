vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	pattern = { "*.qml" },
	group = vim.api.nvim_create_augroup("Lang_Qt", { clear = true }),
	once = true,
	callback = function()
		vim.lsp.enable("qmlls")
	end,
})
