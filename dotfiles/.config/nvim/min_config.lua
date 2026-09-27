vim.o.autocomplete = true
vim.o.autocompletedelay = 80
vim.o.completeopt = "menu,menuone,noselect,popup,fuzzy,preselect"
vim.o.complete = "o,.^5,w^3"
vim.o.pumborder = "rounded"
vim.o.pummaxwidth = 50
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	end,
})
