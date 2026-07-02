---@type vim.lsp.Config
return {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_markers = { ".git" },
	settings = {
		exportPdf = "onSave",
		outputPath = "$root/build/$name",
		formatterMode = "typstyle",
		formatterPrintwidth = 80,
	},
}
