local defer = vim.schedule -- shorthand for deferred loading

-- Colorscheme — must load eagerly
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/xiyaowong/transparent.nvim",
	"https://github.com/nvim-mini/mini.icons",
})

vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/stevearc/aerial.nvim",
})
vim.cmd.colorscheme("tokyonight-night")

-- Transparent background
require("transparent").setup({ extra_groups = { "NormalFloat" } })

-- Icons (needed by many plugins — load eagerly)
require("mini.icons").setup({})
require("mini.icons").mock_nvim_web_devicons()

-- Statusline
require("aerial").setup({
	backends = { "lsp", "treesitter", "markdown" },
	attach_mode = "global",
})

local colors = require("tokyonight.colors").setup()
local mode_colors = {
	n = colors.blue,
	i = colors.green,
	v = colors.purple,
	["\x16"] = colors.purple, -- Visual block (^V)
	V = colors.purple,
	c = colors.orange,
	s = colors.orange,
	S = colors.orange,
	["\x13"] = colors.orange, -- Select block
	R = colors.red,
	r = colors.red,
	["!"] = colors.red,
	t = colors.red,
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	buffer_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) == 1
	end,
	screen_width = function(min_w)
		return function()
			return vim.o.columns > min_w
		end
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
	diff_mode = function()
		return vim.o.diff == true
	end,
	-- ... other conditions
}

local config = {
	options = {
		-- Disable sections and component separators
		globalstatus = true,
		icons_enabled = true,
		component_separators = "",
		section_separators = "",
		theme = {
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {
			{
				function()
					return " "
				end,
				color = function()
					return { bg = mode_colors[vim.fn.mode()] or colors.blue, fg = colors.bg }
				end,
				padding = { left = 1, right = 1 },
			},
			{
				"branch",
				icon = "",
				color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
			},
			{
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.screen_width(80),
			},
			{
				"diagnostics",
				sources = { "nvim_lsp", "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.cyan },
				},
				always_visible = false,
				on_click = function()
					-- vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
					vim.diagnostic.setqflist()
					vim.cmd("copen")
				end,
			},
			{
				function()
					return "%="
				end,
			},
			{
				function()
					local reg = vim.fn.reg_recording()
					if reg ~= "" then
						return "@" .. reg
					end
					return ""
				end,
				color = { fg = colors.orange, gui = "bold" },
				cond = function()
					return vim.fn.reg_recording() ~= ""
				end,
			},
		},
		lualine_x = {
			{ "obsidian_component" },
			{ "lsp_status" },
			{ "encoding" },
			{ "filetype" },
			{
				"location",
				color = { fg = colors.fg_dark },
				cond = conditions.buffer_not_empty,
			},
		},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	winbar = {
		lualine_c = {
			{
				"aerial",
				sep = "  ", -- separator between symbols
				sep_icon = "  ", -- separator between symbol icons
				depth = nil, -- nil = full depth
				dense = false, -- skip icons, only show names
				dense_sep = ".",
				colored = true,
			},
		},
		-- lualine_x = {
		-- 	{ "filename", path = 1 },
		-- },
	},
	inactive_winbar = {
		lualine_c = {},
		lualine_x = {
			{ "filename", path = 1 },
		},
	},
	-- extensions = { "aerial", "quickfix" },
}

require("lualine").setup(config)

vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		require("lualine").refresh()
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		require("lualine").refresh()
	end,
})

require("bufferline").setup({
	options = {
		mode = "buffers",
		numbers = "none",
		close_command = function(n)
			vim.cmd("bdelete " .. n)
		end,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(_, _, diag)
			local icons = { error = " ", warning = " " }
			local ret = (diag.error and icons.error .. diag.error or "")
				.. (diag.warning and icons.warning .. diag.warning or "")
			return vim.trim(ret)
		end,
		offsets = {
			{ filetype = "neo-tree", text = "Explorer", highlight = "Directory" },
		},
		show_buffer_close_icons = true,
		show_close_icon = false,
		separator_style = "slant", -- or "thin", "padded_slant", "slope"
	},
})

vim.keymap.set("n", "<leader>bb", "<CMD>BufferLinePick<CR>", { desc = "Select buffer from tabline" })
vim.keymap.set("n", "<leader>bd", "<CMD>BufferLinePickClose<CR>", { desc = "Close buffer from tabline" })
-- <Leader>b\: Pick a buffer from tabline and open in horizontal split
vim.keymap.set("n", "<Leader>b\\", function()
	-- Store current buffer, trigger pick, then split with the new current buffer
	local cur = vim.api.nvim_get_current_buf()
	vim.cmd("BufferLinePick")
	-- BufferLinePick is synchronous — after it returns, current buf has changed
	local picked = vim.api.nvim_get_current_buf()
	if picked ~= cur then
		-- Restore original buffer in current window, then split with picked
		vim.api.nvim_win_set_buf(0, cur)
		vim.cmd("split")
		vim.api.nvim_win_set_buf(0, picked)
	end
end, { desc = "Horizontal split buffer from tabline" })
-- <Leader>b|: Pick a buffer from tabline and open in vertical split
vim.keymap.set("n", "<Leader>b|", function()
	local cur = vim.api.nvim_get_current_buf()
	vim.cmd("BufferLinePick")
	local picked = vim.api.nvim_get_current_buf()
	if picked ~= cur then
		vim.api.nvim_win_set_buf(0, cur)
		vim.cmd("vsplit")
		vim.api.nvim_win_set_buf(0, picked)
	end
end, { desc = "Vertical split buffer from tabline" })

-- Noice
vim.pack.add({
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/folke/noice.nvim",
})
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
	presets = { bottom_search = true, command_palette = true },
})

-- Highlight colors (#0ff, rgb(), etc.) — on file open
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("LazyLoad_Colors", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })
		require("nvim-highlight-colors").setup({ render = "background" })
	end,
})
