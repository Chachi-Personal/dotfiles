-- Which-key
vim.pack.add({ "https://github.com/folke/which-key.nvim" })
require("which-key").setup({})
vim.keymap.set({ "n" }, "<leader>?", function()
	require("which-key").show({ gloabl = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
require("which-key").add({
	{ "<leader>f", group = "Find", icon = { icon = "󰍉", color = "blue" } },
	{ "<leader>b", group = "Buffers", icon = { icon = "󰓩", color = "blue" } },
	{ "<leader>x", group = "List", icon = { icon = "󰝖", color = "red" } },
	{ "<leader>l", group = "LSP", icon = { icon = "󰒋", color = "cyan" } },
	{ "<leader>o", group = "Obsidian", icon = { icon = "󱞁", color = "cyan" } },
	{ "<leader>p", group = "Pack", icon = { icon = "󰏖", color = "yellow" } },
	{ "<leader>s", group = "Spell", icon = { icon = "󰓆", color = "yellow" } },
	{ "<leader>r", group = "Restart", icon = { icon = "󰑓", color = "red" } },
	{ "<leader>t", group = "Terminal" },
	{ "<leader>g", group = "GitSigns" },
	{ "<leader>a", group = "AI" },
})
