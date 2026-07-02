local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local defer = vim.schedule

-- Treesitter — eager (syntax highlighting needed immediately)
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/windwp/nvim-ts-autotag",
})
-- Install parsers explicitly (replaces ensure_installed)
require("nvim-treesitter")
	.install({
		"lua",
		"python",
		"typescript",
		"javascript",
		"tsx",
		"rust",
		"c",
		"cpp",
		"bash",
		"nix",
		"markdown",
		"markdown_inline",
		"html",
		"css",
		"typst",
		"regex",
	})
	:wait() -- wait = install synchronously on first run

-- Blade (Laravel) — custom parser, new API (get_parser_configs is gone)
vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		require("nvim-treesitter.parsers").blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				branch = "main",
			},
			tier = 2,
		}
	end,
})

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

-- Highlighting is now native — enable via autocmd
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TS_Highlight", { clear = true }),
	callback = function(ev)
		local ok = pcall(vim.treesitter.start, ev.buf)
		if not ok then
			return
		end -- no parser for this filetype, silently skip
	end,
})

-- Indentation via native treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TS_Indent", { clear = true }),
	callback = function(ev)
		local ok = pcall(function()
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end)
	end,
})

-- Textobjects (still configured via the plugin)
require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
		},
	},
	move = {
		enable = true,
		set_jumps = true,
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
	},
})

-- nvim-ts-autotag unchanged
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = true,
	},
})

-- Autopairs — on file open
au({ "BufReadPre", "BufNewFile" }, {
	group = aug("LazyLoad_Autopairs", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")
		local ts_conds = require("nvim-autopairs.ts-conds")

		npairs.setup({
			map_cr = true,
			check_ts = true,
			ignored_next_char = [=[[%w%%%'%[%\"%.%`]]=], -- removed %$ from default
		})

		npairs.add_rules({
			Rule("$", "$", { "typst", "markdown" }):with_move(function(opts)
				return opts.char == "$"
			end),
			Rule("*", "*", { "typst" }):with_pair(function()
				local node = vim.treesitter.get_node({ ignore_injections = false })
				local blocked = { math = true, math_group = true, formula = true, group = true, attach = true }

				while node do
					if blocked[node:type()] then
						return false
					end
					node = node:parent()
				end
				return true
			end),
		})

		npairs.add_rules({
			Rule(" ", " ", "typst"):with_pair(function(opts)
				local pair = opts.line:sub(opts.col - 1, opts.col)
				return pair == "$$"
			end):with_del(cond.none()),
			Rule("$ ", " $", "typst")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == "$"
				end)
				:with_del(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local context = opts.line:sub(col - 1, col + 2)
					return context == "$  $"
				end)
				:use_key("$"),
		})

		local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
		for _, bracket in ipairs(brackets) do
			npairs.add_rules({
				Rule(" ", " ", "-markdown"):with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({ bracket[1] .. bracket[2] }, pair)
				end):with_del(cond.none()),
				Rule(bracket[1] .. " ", " " .. bracket[2])
					:with_pair(cond.none())
					:with_move(function(opts)
						return opts.char == bracket[2]
					end)
					:with_del(function(opts)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local context = opts.line:sub(col - 1, col + 2)
						return vim.tbl_contains({ bracket[1] .. "  " .. bracket[2] }, context)
					end)
					:use_key(bracket[2]),
			})
		end
	end,
})

-- Surround, Flash, better-escape — deferred (were VeryLazy)
defer(function()
	vim.pack.add({
		"https://github.com/kylechui/nvim-surround",
		"https://github.com/folke/flash.nvim",
	})
	require("nvim-surround").setup({})
	require("flash").setup({})
	local map = vim.keymap.set

	map("n", "zk", function()
		require("flash").jump()
	end, { desc = "Flash" })
end)

-- Guess indent — on file open
au({ "BufReadPre", "BufNewFile" }, {
	group = aug("LazyLoad_Indent", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/nmac427/guess-indent.nvim" })
		require("guess-indent").setup({})
	end,
})

-- -- Smart splits — deferred
-- defer(function()
-- 	vim.pack.add({ "https://github.com/mrjones2014/smart-splits.nvim" })
-- 	require("smart-splits").setup({})
-- end)
--
defer(function()
	vim.pack.add({
		"https://github.com/aserowy/tmux.nvim",
	})
	require("tmux").setup()
end)
