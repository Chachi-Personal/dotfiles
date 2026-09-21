-- Xingshu practice applet, developed in its own repo.
--
-- Loaded off runtimepath rather than through vim.pack: vim.pack git-clones even
-- a file:// source, so working-tree edits would not be picked up.
local repo = vim.fn.expand("~/Documents/code/projects/xingshu-practice")

if vim.uv.fs_stat(repo) then
	vim.opt.runtimepath:prepend(repo)
	require("xingshu").setup({})
	vim.keymap.set("n", "<leader>x", "<Cmd>Xingshu<CR>", { desc = "Xingshu practice" })
end
