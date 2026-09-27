vim.loader.enable()

-- Set Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core Plugins
require("core.options")
require("core.keymaps")
require("core.autocmds")

require("ui")

-- Lsp Plugins
require("lsp")

-- Plugins
require("plugins")
