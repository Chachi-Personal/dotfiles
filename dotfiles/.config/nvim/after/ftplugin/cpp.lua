local buf = vim.api.nvim_get_current_buf()

local function run_c_file()
	local filepath = vim.api.nvim_buf_get_name(buf)
	if filepath == "" then
		vim.notify("Buffer has no file path", vim.log.levels.WARN)
		return
	end

	local dir = vim.fn.fnamemodify(filepath, ":p:h")
	local stem = vim.fn.fnamemodify(filepath, ":t:r")
	local outfile = dir .. "/" .. stem

	-- Save the file first
	vim.cmd("silent! write")

	local cmd = string.format(
		"g++ %s -o %s -lm && echo '\\n--- Running ---\\n' && ./%s; echo '\\n[Exit: '$?']'",
		vim.fn.shellescape(filepath),
		vim.fn.shellescape(stem),
		vim.fn.shellescape(stem)
	)

	local term = Snacks.terminal.open(cmd, {
		cwd = dir,
		auto_close = false, -- keep open so you can read output
		win = { position = "float", border = "rounded", width = 0.8, height = 0.8 },
	})
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = term.buf,
		once = true,
		callback = function()
			local code = vim.v.event.status
			if code == 0 then
				return
			end
			vim.schedule(function()
				vim.notify("Compilation/run failed (exit " .. code .. ")", vim.log.levels.ERROR)
			end)
		end,
	})
end

vim.keymap.set("n", "<F5>", run_c_file, { buffer = buf, silent = true, desc = "Compile & run C file" })
vim.api.nvim_buf_create_user_command(buf, "CRun", run_c_file, { desc = "Compile & run C file" })
