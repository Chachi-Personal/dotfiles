-- Enable UI 2
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = { "cmd", "msg", "pager" }, -- "cmd" removed: cmdline is owned by noice.nvim
		dialog = { height = 0.5 },
		msg = { height = 0.5 },
		pager = { height = 0.9 },
	},
})

local defer = vim.schedule -- shorthand for deferred loading

-- Colorscheme — must load eagerly
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/xiyaowong/transparent.nvim",
	"https://github.com/nvim-mini/mini.icons",

	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/stevearc/aerial.nvim",

	{
		src = "https://github.com/rachartier/tiny-cmdline.nvim",
		-- config = function()
		-- 	vim.o.cmdheight = 0
		-- 	require("tiny-cmdline").setup()
		-- end,
	},
})

vim.cmd.colorscheme("tokyonight-night")
require("transparent").setup({ extra_groups = { "NormalFloat" } })

require("mini.icons").setup({})
require("mini.icons").mock_nvim_web_devicons()

require("ui.statusline")
require("ui.bufferline")

-- ——— Lazy Loaded pluggins
-- Highlight colors (#0ff, rgb(), etc.) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LazyLoad_Colors", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })
		vim.schedule(function()
			require("nvim-highlight-colors").setup({ render = "background" })
		end)
	end,
})
