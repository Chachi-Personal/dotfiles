local buf = vim.api.nvim_get_current_buf()

local function run_c_file()
	local filepath = vim.api.nvim_buf_get_name(buf)
	if filepath == "" then
		vim.notify("Buffer has no file path", vim.log.levels.WARN)
		return
	end

	-- Ensure toggleterm is loaded and set up
	vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })
	require("toggleterm").setup({ direction = "float", float_opts = { border = "rounded" } })

	local dir = vim.fn.fnamemodify(filepath, ":p:h")
	local stem = vim.fn.fnamemodify(filepath, ":t:r")
	local outfile = dir .. "/" .. stem

	-- Save the file first
	vim.cmd("silent! write")

	local ok, Terminal = pcall(function()
		return require("toggleterm.terminal").Terminal
	end)
	if not ok then
		vim.notify("toggleterm not loaded", vim.log.levels.ERROR)
		return
	end

	local cmd = string.format(
		"cd %s && g++ %s -o %s -lm && echo '\\n--- Running ---\\n' && ./%s; echo '\\n[Exit: '$?']'",
		vim.fn.shellescape(dir),
		vim.fn.shellescape(filepath),
		vim.fn.shellescape(stem),
		vim.fn.shellescape(stem)
	)

	Terminal:new({
		cmd = cmd,
		direction = "float",
		float_opts = { border = "rounded" },
		close_on_exit = false, -- keep open so you can read output
		on_exit = function(t, job, code)
			if code == 0 then
				return
			end
			vim.schedule(function()
				vim.notify("Compilation/run failed (exit " .. code .. ")", vim.log.levels.ERROR)
			end)
		end,
	}):toggle()
end

vim.keymap.set("n", "<F5>", run_c_file, { buffer = buf, silent = true, desc = "Compile & run C file" })
vim.api.nvim_buf_create_user_command(buf, "CRun", run_c_file, { desc = "Compile & run C file" })
