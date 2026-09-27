local defer = vim.schedule
local map = vim.keymap.set

defer(function()
	require("todo-comments").setup({})
end)

-- Yazi — on command (CmdUndefined lazy load)
defer(function()
	require("yazi").setup({})
	map({ "n", "v" }, "<C-n>", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })
	map({ "n", "v" }, "<leader>-", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })
end)

-- ─── Toggleterm ───────────────────────────────────────────────────────────────
defer(function()
	require("toggleterm").setup({ direction = "float", float_opts = { border = "rounded" } })
	map("n", "<F7>", "<Cmd>execute v:count . 'ToggleTerm'<CR>", { desc = "Toggle terminal" })
	map("t", "<F7>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
	map("n", "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm float" })
	map("n", "<leader>th", "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", { desc = "ToggleTerm horizontal" })
	map("n", "<leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "ToggleTerm vertical" })
	map("n", "<leader>tn", function()
		local Terminal = require("toggleterm.terminal").Terminal
		Terminal:new({ cmd = "node", hidden = true, direction = "float" }):toggle()
	end, { desc = "ToggleTerm node" })
	map("n", "<leader>tp", function()
		local Terminal = require("toggleterm.terminal").Terminal
		Terminal:new({ cmd = "python3", hidden = true, direction = "float" }):toggle()
	end, { desc = "ToggleTerm python" })
end)
