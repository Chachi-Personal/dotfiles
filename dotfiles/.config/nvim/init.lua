vim.loader.enable()

-- Set Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core Plugins
require("core.options")
require("core.keymaps")
require("core.whichkey")
require("core.snacks")
require("core.autocmds")

require("ui")

-- Lsp Plugins
require("lsp.mason")
require("lsp")
require("lsp.completion")
require("lsp.dap")
require("lsp.autoformat")

-- Plugins
require("plugins")
