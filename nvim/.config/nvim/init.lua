vim.loader.enable()

-- Enable UI 2
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	},
})

-- Set Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core Plugins
require("core.options")
require("core.keymaps")
require("core.ui")
require("core.whichkey")
require("core.snacks")
require("core.autocmds")

-- Lsp Plugins
require("lsp.mason")
require("lsp")
require("lsp.completion")
require("lsp.dap")

-- Plugins
require("plugins")
