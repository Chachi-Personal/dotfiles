-- lua/plugins/init.lua
-- local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
--
-- for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
-- 	local name = file:match("^(.+)%.lua$")
-- 	if name and name ~= "init" then
-- 		require("plugins." .. name)
-- 	end
-- end

vim.pack.add({
	"https://github.com/coder/claudecode.nvim",
	"https://github.com/folke/snacks.nvim",

	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/windwp/nvim-ts-autotag",

	"https://github.com/windwp/nvim-autopairs",

	"https://github.com/kylechui/nvim-surround",
	"https://github.com/folke/flash.nvim",

	"https://github.com/nmac427/guess-indent.nvim",

	"https://github.com/smart-splits-nvim/smart-splits.nvim",

	"https://github.com/obsidian-nvim/obsidian.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/nvim-lua/plenary.nvim",

	"https://github.com/h-hg/fcitx.nvim",

	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/fang2hou/blink-copilot" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("^2") },
	{ src = "https://github.com/iurimateus/luasnip-latex-snippets.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" }, -- lua_ls devtools

	"https://github.com/mfussenegger/nvim-dap",

	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",

	"https://github.com/stevearc/conform.nvim",
})

require("plugins.editor")
require("plugins.completion")
require("plugins.formatter")
require("plugins.snacks")
require("plugins.ai")
require("plugins.debug")
require("plugins.tools")
require("plugins.xingshu")

-- require("plugins.obsidian")
