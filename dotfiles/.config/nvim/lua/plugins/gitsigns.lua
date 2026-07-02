local map = vim.keymap.set

vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup({})

-- Gitsigns (set in gitsigns.lua on_attach, but global fallbacks here)
map("n", "<leader>gl", function()
	require("gitsigns").blame_line()
end, { desc = "View git blame" })

map("n", "<leader>gL", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "View full git blame" })

map("n", "<leader>go", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview git hunk" })

map("n", "<leader>gr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset git hunk" })

map("n", "<leader>gR", function()
	require("gitsigns").reset_buffer()
end, { desc = "Reset git buffer" })

map("n", "<leader>gs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage/unstage hunk" })

map("n", "<leader>gS", function()
	require("gitsigns").stage_buffer()
end, { desc = "Stage git buffer" })

map("n", "<leader>gd", function()
	require("gitsigns").diffthis()
end, { desc = "View git diff" })

map("n", "]g", function()
	require("gitsigns").nav_hunk("next")
end, { desc = "Next git hunk" })

map("n", "[g", function()
	require("gitsigns").nav_hunk("prev")
end, { desc = "Previous git hunk" })

map("n", "]G", function()
	require("gitsigns").nav_hunk("last")
end, { desc = "Last git hunk" })

map("n", "[G", function()
	require("gitsigns").nav_hunk("first")
end, { desc = "First git hunk" })
