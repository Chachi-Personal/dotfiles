local defer = vim.schedule
local au = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup
local map = vim.keymap.set

local lazy_packages = require("plugins.lazy_packages")

-- Todo comments — on file open
au({ "BufReadPre", "BufNewFile" }, {
	group = aug("LazyLoad_Todo", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })
		require("todo-comments").setup({})
	end,
})

-- Yazi — on command (CmdUndefined lazy load)
au("CmdUndefined", {
	group = aug("LazyLoad_Yazi", { clear = true }),
	pattern = "Yazi*",
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/mikavilpas/yazi.nvim" },
			{ src = "https://github.com/nvim-lua/plenary.nvim" },
		})
		require("yazi").setup({})
	end,
})
map({ "n", "v" }, "<C-n>", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })
map({ "n", "v" }, "<leader>-", "<Cmd>Yazi<CR>", { desc = "Yazi (current file)" })
lazy_packages.register("yazi.nvim")
lazy_packages.register("plenary.nvim")

-- ─── Toggleterm ───────────────────────────────────────────────────────────────
lazy_packages.register("toggleterm.nvim")
au("CmdUndefined", {
	group = aug("LazyLoad_Toggleterm", { clear = true }),
	pattern = { "ToggleTerm", "TermExec" },
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })
		require("toggleterm").setup({ direction = "float", float_opts = { border = "rounded" } })
	end,
})
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

-- fcitx (IME) — eager (input method, must be always active)
vim.pack.add({ "https://github.com/h-hg/fcitx.nvim" })
