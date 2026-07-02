---@type vim.lsp.Config
return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php", "blade" },
	root_markers = { "composer.json", ".git" },
	settings = {
		intelephense = {
			stubs = {
				"apache",
				"bcmath",
				"Core",
				"curl",
				"date",
				"dom",
				"fileinfo",
				"json",
				"mbstring",
				"openssl",
				"PDO",
				"pdo_mysql",
				"session",
				"standard",
				"tokenizer",
				"xml",
				"zip",
				"zlib",
				"laravel",
			},
			files = {
				maxSize = 5000000,
			},
		},
	},
}
