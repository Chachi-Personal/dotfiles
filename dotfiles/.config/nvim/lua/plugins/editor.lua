local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local defer = vim.schedule

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
defer(function()
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
end)

-- Surround, Flash, better-escape — deferred (were VeryLazy)
defer(function()
	require("nvim-surround").setup({})
	require("flash").setup({})
	local map = vim.keymap.set

	map("n", "zk", function()
		require("flash").jump()
	end, { desc = "Flash" })
end)

-- Guess indent — on file open
defer(function()
	require("guess-indent").setup({})
	-- setup() lands after the triggering buffer's BufReadPost, so its
	-- autocmd missed it — detect once for the first buffer of the session.
	require("guess-indent").set_from_buffer(0, true, true)
end)

-- -- Smart splits — deferred
defer(function()
	require("smart-splits").setup({
		ignored_buftypes = { "nofile", "quickfix", "prompt" },
		ignored_filetypes = { "NvimTree" },
		default_amount = 3,
		at_edge = "wrap",
		float_win_behavior = "previous",
		move_cursor_same_row = false,
		cursor_follows_swapped_bufs = false,
		ignored_events = { "BufEnter", "WinEnter" },
		multiplexer_integration = "tmux", -- tmux
		disable_multiplexer_nav_when_zoomed = true,
		kitty_password = nil,
		zellij_move_focus_or_tab = false,
		log_level = "info",
		setup = function() end,
		set_default_multiplexer = function() end,
	})
	local map = vim.keymap.set
	map("n", "<leader><A-h>", require("smart-splits").resize_left, { desc = "Resize pane left" })
	map("n", "<leader><A-j>", require("smart-splits").resize_down, { desc = "Resize pane down" })
	map("n", "<leader><A-k>", require("smart-splits").resize_up, { desc = "Resize pane up" })
	map("n", "<leader><A-l>", require("smart-splits").resize_right, { desc = "Resize pane right" })

	map("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left pane" })
	map("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to below pane" })
	map("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to above pane" })
	map("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right pane" })

	map("n", "<leader><leader>h", require("smart-splits").swap_buf_left, { desc = "Swap buf left" })
	map("n", "<leader><leader>j", require("smart-splits").swap_buf_down, { desc = "Swap buf down" })
	map("n", "<leader><leader>k", require("smart-splits").swap_buf_up, { desc = "Swap buf up" })
	map("n", "<leader><leader>l", require("smart-splits").swap_buf_right, { desc = "Swap buf right" })
end)
