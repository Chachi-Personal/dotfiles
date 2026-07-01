local map = vim.keymap.set

-- ─── General ──────────────────────────────────────────────────────────────────
-- restart
map("n", "<leader>re", "<cmd>:restart<CR>", { desc = "Restart Neovim (:restart)", silent = true })

map("n", "<C-s>", "<cmd>silent! update! | redraw<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>silent! update! | redraw<CR>", { desc = "Save" })
map("v", "<C-s>", "<Esc><cmd>silent! update! | redraw<CR>", { desc = "Save" })

-- Plugin management (vim.pack)
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>", { silent = true, desc = "Update plugins" })
map("n", "<leader>px", "<cmd>PackCheck<CR>", { silent = true, desc = "Clean plugins" })

map("n", "<leader>R", function()
	local old = vim.fn.expand("%")
	local new = vim.fn.input("Rename: ", old)
	if new ~= "" and new ~= old then
		vim.cmd("saveas " .. new)
		vim.fn.delete(old)
		vim.cmd("redraw!")
	end
end, { desc = "Rename file" })

-- Make cursor stay in palce when concattinating with J
map("n", "J", "mzJ`z")

-- Line Swapping
map("n", "<A-j>", "<cmd>m .+1<CR>==")
map("n", "<A-k>", "<cmd>m .-2<CR>==")
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi")
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi")
map("v", "<A-j>", ":m '>+1<CR><CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR><CR>gv=gv")

-- Comments
map("n", "<C-_>", "gcc", { remap = true })
map("n", "<C-/>", "gcc", { remap = true })
map("v", "<C-_>", "gc", { remap = true })
map("v", "<C-/>", "gc", { remap = true })

-- ctrl c as escape
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

-- Unmaps Q in normal mode
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>U", function()
	vim.cmd.packadd("nvim.undotree") -- loads the builtin plugin on first use
	require("undotree").open()
end, { desc = "Toggle Undo Tree" })

-- Navigation
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Splits
map("n", "|", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "\\", "<Cmd>split<CR>", { desc = "Horizontal split" })

-- ─── Diagnostics / quickfix ───────────────────────────────────────────────────
map("n", "<leader>xq", "<Cmd>copen<CR>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<Cmd>lopen<CR>", { desc = "Location list" })

-- ─── Diagnostics (global — no LSP needed) ────────────────────────────────────
map("n", "gl", vim.diagnostic.open_float, { desc = "Hover diagnostics" })
map("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })
map("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
map("n", "[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous warning" })
map("n", "]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Next warning" })

-- ─── Buffers ──────────────────────────────────────────────────────────────────
map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
local function smart_bdelete(force)
	local cmd = force and "bdelete!" or "bdelete"
	local cur = vim.api.nvim_get_current_buf()

	-- Get all listed, normal (non-qf) buffers
	local listed = vim.fn.getbufinfo({ buflisted = 1 })
	local normal_bufs = {}
	for _, b in ipairs(listed) do
		if vim.bo[b.bufnr].buftype == "" then
			table.insert(normal_bufs, b.bufnr)
		end
	end

	if #normal_bufs <= 1 then
		-- This is the last normal buffer: just quit
		vim.cmd("qall")
		return
	end

	-- Switch to next buffer first, then delete the old one
	vim.cmd("bnext")
	-- If bnext landed on the same buffer (edge case), try bprevious
	if vim.api.nvim_get_current_buf() == cur then
		vim.cmd("bprevious")
	end

	pcall(function()
		vim.cmd(cmd .. " " .. cur)
	end)
end
map("n", "<leader>c", function()
	smart_bdelete(false)
end, { desc = "Close buffer" })
map("n", "<leader>C", function()
	smart_bdelete(true)
end, { desc = "Force close buffer" })
map("n", "<leader>bc", function() -- close all except current
	local cur = vim.fn.bufnr()
	for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if b.bufnr ~= cur then
			vim.cmd("bdelete " .. b.bufnr)
		end
	end
end, { desc = "Close all except current" })
map("n", "<leader>bC", "<Cmd>%bdelete<CR>", { desc = "Close all buffers" })

-- ─── Tabs ─────────────────────────────────────────────────────────────────────
map("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })

-- ─── Window navigation (plain — use smart-splits if you add that plugin) ──────
map("n", "<C-H>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-J>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-K>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-L>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Resize split up" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Resize split down" })
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Resize split left" })
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Resize split right" })

-- Terminal window nav
map("t", "<C-H>", "<Cmd>wincmd h<CR>", { desc = "Terminal left" })
map("t", "<C-J>", "<Cmd>wincmd j<CR>", { desc = "Terminal down" })
map("t", "<C-K>", "<Cmd>wincmd k<CR>", { desc = "Terminal up" })
map("t", "<C-L>", "<Cmd>wincmd l<CR>", { desc = "Terminal right" })

-- Yank as text/html
-- In normal/visual mode: <leader>ch = "copy as html-mime for Perplexity"
map({ "n", "v" }, "<leader>y", function()
	local text = vim.fn.getreg("+")
	vim.fn.system({ "wl-copy", "--type", "text/html" }, text)
end, { desc = "Copy clipboard as text/html MIME" })

-- ─── Spell ────────────────────────────────────────────────────────────────────
map("n", "<leader>sa", "zg", { desc = "Spell: add word to dictionary" })
map("n", "<leader>sx", "zw", { desc = "Spell: mark word as bad" })
map("n", "<leader>s?", "z=", { desc = "Spell: show suggestions" })
map("n", "]s", "]s", { desc = "Spell: next misspelled word" })
map("n", "[s", "[s", { desc = "Spell: prev misspelled word" })
