local buf = vim.api.nvim_get_current_buf()

local function open_pdf()
	local bufname = vim.api.nvim_buf_get_name(buf)
	local root = vim.fs.root(buf, { ".git" }) or vim.fn.fnamemodify(bufname, ":p:h")
	local stem = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t:r")
	local pdf = root .. "/build/" .. stem .. ".pdf"
	if vim.fn.filereadable(pdf) == 0 then
		vim.notify("PDF not found: " .. pdf, vim.log.levels.WARN, { title = "Typst" })
		return
	end
	vim.fn.jobstart({ "xdg-open", pdf }, { detach = true })
end
vim.api.nvim_buf_create_user_command(buf, "TypstOpenPdf", open_pdf, { desc = "Open compiled tpst PDF" })
vim.keymap.set("n", "<F4>", open_pdf, { buffer = buf, silent = true, desc = "Open typst PDF" })

vim.api.nvim_create_user_command("ToggleTypstMath", function()
	local cfg = Snacks.image.config
	cfg.math.enabled = not cfg.math.enabled

	vim.cmd("edit")
	vim.notify(
		"Typst math rendering: " .. (cfg.math.enabled and "on" or "off"),
		vim.log.levels.INFO,
		{ title = "Typst" }
	)
end, { desc = "Toggle Typst Inline Math Rendering" })

vim.keymap.set("i", "<M-b>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local next_char = line:sub(col + 1, col + 1)

	if next_char == "*" then
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	else
		vim.api.nvim_put({ "**" }, "c", true, true)
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end
end, { buffer = buf, desc = "Bold" })
vim.keymap.set("i", "<M-i>", function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local next_char = line:sub(col + 1, col + 1)

	if next_char == "_" then
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	else
		vim.api.nvim_put({ "__" }, "c", true, true)
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end
end, { buffer = buf, desc = "Italic" })

Snacks.image.config.enabled = false

vim.opt_local.spell = true
vim.opt_local.spelllang = { "en" }

-- Typst-Preview
vim.pack.add({
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})
require("typst-preview").setup({
	open_cmd = "helium-browser %s --new-window",
	preview_on_save = true,
	invert_colors = "never",
})
