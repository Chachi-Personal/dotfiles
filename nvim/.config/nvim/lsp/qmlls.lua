return {
	cmd = { "qmlls6" },
	filetypes = { "qml", "qmljs" },
	root_markers = { "qmldir", "qmlls.json", ".git" },
	-- root_dir = function(fname)
	-- 	return vim.fs.dirname(vim.fs.find({ "qmldir", "qmlls.json", ".git" }, { upward = true, path = fname })[1])
	-- end,
}
