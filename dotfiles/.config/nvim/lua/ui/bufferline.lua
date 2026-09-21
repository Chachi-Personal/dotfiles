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
