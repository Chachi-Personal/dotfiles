local map = vim.keymap.set

-- Snacks — eager (dashboard, notifs, etc.)
vim.pack.add({ "https://github.com/folke/snacks.nvim" })
require("snacks").setup({
	bigfile = { enabled = true },
	image = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	statuscolumn = { enabled = true },
	picker = { enabled = true },
	scroll = { enabled = false },
	scratch = { enabled = true },
	gitbrowse = { enabled = true },
	word = { enabled = true },
})

-- Pickers
map("n", "<C-p>", function()
	Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent files" })

-- ─── Snacks picker (replaces Telescope/fzf-lua in your setup) ─────────────────
map("n", "<C-P>", function()
	Snacks.picker.smart()
end, { desc = "Smart find files" })

map("n", "<leader><Space>", function()
	Snacks.picker.smart()
end, { desc = "Smart find files" })

map("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find files" })

map("n", "<leader>fF", function()
	Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find all files" })

map("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find git files" })

map("n", "<leader>fw", function()
	Snacks.picker.grep()
end, { desc = "Find words" })

map("n", "<leader>fW", function()
	Snacks.picker.grep({ hidden = true, ignored = true })
end, { desc = "Find words (all files)" })

map("n", "<leader>fc", function()
	Snacks.picker.grep_word()
end, { desc = "Find word under cursor" })

map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Find buffers" })

map("n", "<leader>fo", function()
	Snacks.picker.recent()
end, { desc = "Find old files" })

map("n", "<leader>fO", function()
	Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Find old files (cwd)" })

map("n", "<leader>fl", function()
	Snacks.picker.lines()
end, { desc = "Find lines" })

map("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Find help" })

map("n", "<leader>fk", function()
	Snacks.picker.keymaps()
end, { desc = "Find keymaps" })

map("n", "<leader>fC", function()
	Snacks.picker.commands()
end, { desc = "Find commands" })

map("n", "<leader>fm", function()
	Snacks.picker.man()
end, { desc = "Find man" })

map("n", "<leader>fn", function()
	Snacks.picker.notifications()
end, { desc = "Find notifications" })

map("n", "<leader>f'", function()
	Snacks.picker.marks()
end, { desc = "Find marks" })

map("n", "<leader>fu", function()
	Snacks.picker.undo()
end, { desc = "Find undo history" })

map("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Find projects" })

map("n", "<leader>fs", function()
	Snacks.picker.smart()
end, { desc = "Find buffers/recent/files" })

map("n", "<leader>f<CR>", function()
	Snacks.picker.resume()
end, { desc = "Resume previous search" })

map("n", "<leader>fa", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config files" })

map("n", "<leader>fT", function()
	Snacks.picker.todo_comments()
end, { desc = "Find TODOs" })

map("n", "<leader>ft", function()
	Snacks.picker.colorschemes()
end, { desc = "Find themes" })

map("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Toggle scratch buffer" })

map("n", "<leader>f.", function()
	Snacks.scratch()
end, { desc = "Toggle scratch buffer" })

-- ─── Git ──────────────────────────────────────────────────────────────────────
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

map("n", "<leader>gc", function()
	Snacks.picker.git_log()
end, { desc = "Git commits (repo)" })

map("n", "<leader>gC", function()
	Snacks.picker.git_log_file()
end, { desc = "Git commits (file)" })

map("n", "<leader>gb", function()
	Snacks.picker.git_branches()
end, { desc = "Git branches" })

map("n", "<leader>gt", function()
	Snacks.picker.git_status()
end, { desc = "Git status" })

map("n", "<leader>gT", function()
	Snacks.picker.git_stash()
end, { desc = "Git stash" })

map("n", "<leader>go", function()
	Snacks.gitbrowse()
end, { desc = "Git browse (open)" })
-- GitHub CLI pickers

map("n", "<leader>gi", function()
	Snacks.picker.gh_issue()
end, { desc = "GitHub issues (open)" })

map("n", "<leader>gI", function()
	Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub issues (all)" })

map("n", "<leader>gp", function()
	Snacks.picker.gh_pr()
end, { desc = "GitHub PRs (open)" })

map("n", "<leader>gP", function()
	Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub PRs (all)" })

map("n", "<leader>lD", function()
	Snacks.picker.diagnostics()
end, { desc = "Search diagnostics" })
map("n", "<leader>ls", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Search symbols" })
map("n", "<leader>lS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
map("n", "<leader>lR", function()
	Snacks.picker.lsp_references()
end, { desc = "Search references" })
map("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Toggle Zen Mode" })
map("n", "<leader>Z", function()
	Snacks.zen.zoom()
end, { desc = "Toggle Zen Zoom" })
