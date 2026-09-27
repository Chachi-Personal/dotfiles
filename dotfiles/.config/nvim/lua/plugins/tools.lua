local defer = vim.schedule
local map = vim.keymap.set

-- Yazi — on command (CmdUndefined lazy load)
defer(function()
	require("yazi").setup({})
	map({ "n", "v" }, "<C-n>", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })
	map({ "n", "v" }, "<leader>-", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })
end)
