local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("claudecode.nvim")

vim.pack.add({
	{ src = "https://github.com/coder/claudecode.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
})

require("claudecode").setup({
	log_level = "warn", -- quieter than the default "info"
	focus_after_send = true, -- jump into the terminal right after sending
	diff_opts = {
		layout = "vertical",
		keep_terminal_focus = true, -- stay in the terminal when a diff opens
		on_new_file_reject = "close_window", -- don't leave empty buffers on reject
	},
	terminal = {
		provider = "snacks", -- you already load snacks.nvim
	},
})

local map = vim.keymap.set

-- Session control
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Claude: toggle" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude: focus terminal" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Claude: resume session" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Claude: continue last session" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Claude: select model" })

-- Send context to Claude
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Claude: add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude: send selection" })
-- In a file tree (nvim-tree / neo-tree / oil), add the file/dir under the cursor
map("n", "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>", { desc = "Claude: add tree file" })

-- Review Claude's proposed edits (when a diff is open)
map("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude: deny diff" })

-- When quitting the last file window, don't let Claude's terminal keep Neovim
-- alive: close it too so Neovim exits cleanly.
local function is_claude_win(win)
	local buf = vim.api.nvim_win_get_buf(win)
	if vim.bo[buf].buftype ~= "terminal" then
		return false
	end
	return vim.api.nvim_buf_get_name(buf):lower():find("claude") ~= nil
end

vim.api.nvim_create_autocmd("QuitPre", {
	group = vim.api.nvim_create_augroup("claude_autoquit", { clear = true }),
	callback = function()
		-- Only consider normal (non-floating) windows.
		local wins = vim.tbl_filter(function(w)
			return vim.api.nvim_win_get_config(w).relative == ""
		end, vim.api.nvim_list_wins())

		local claude_wins = vim.tbl_filter(is_claude_win, wins)

		-- The window being quit is still present here, so when exactly one
		-- non-Claude window remains it's the one closing — drop Claude too.
		if #claude_wins > 0 and (#wins - #claude_wins) == 1 then
			for _, w in ipairs(claude_wins) do
				vim.api.nvim_win_close(w, true)
			end
		end
	end,
})
