local opt = vim.opt

opt.termguicolors = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.inccommand = "split"

-- UI
opt.signcolumn = "yes:1"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 10
opt.winborder = "rounded" -- new in 0.12: rounded window borders

opt.undofile = true

-- misc
-- vim.opt.guicursor = ""
opt.updatetime = 100
opt.colorcolumn = "0"
opt.clipboard:append("unnamedplus")
opt.mouse = "a"
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
opt.foldlevelstart = 99
vim.o.cmdheight = 0

-- Native autocomplete (new in 0.12, replaces nvim-cmp for basic use)
opt.completeopt = { "menuone", "popup", "noinsert" }
-- opt.autocomplete = true  -- enable if you want fully native completion
