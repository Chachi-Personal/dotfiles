vim.opt_local.spell = true
vim.opt_local.spelllang = { "en" }

vim.schedule(function()
	local win = vim.api.nvim_get_current_win()
	vim.wo[win].foldmethod = "expr"
	vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo[win].foldlevel = 99
	vim.wo[win].foldenable = true
	vim.wo[win].foldtext = ""

	-- Soft wrap: display-only, no actual line breaks inserted
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true -- break at word boundaries, not mid-word
	vim.opt_local.breakindent = true -- preserve indent on wrapped lines
	vim.opt_local.textwidth = 0 -- disable hard wrapping (no \n inserted)
	-- vim.opt_local.colorcolumn = "80" -- optional: visual 80-char guide

	-- Navigate visual (wrapped) lines with j/k
	-- When a count is given (e.g. 5j), use real lines so relative numbers still work
	vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { buffer = true, expr = true, silent = true })
	vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { buffer = true, expr = true, silent = true })
	vim.keymap.set("v", "j", "v:count == 0 ? 'gj' : 'j'", { buffer = true, expr = true, silent = true })
	vim.keymap.set("v", "k", "v:count == 0 ? 'gk' : 'k'", { buffer = true, expr = true, silent = true })
end)
