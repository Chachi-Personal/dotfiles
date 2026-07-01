local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("rustaceanvim")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "rust" },
	group = vim.api.nvim_create_augroup("Lang_Rust", { clear = true }),
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/mrcjkb/rustaceanvim" })
		local ok, reg = pcall(require, "mason-registry")
		if ok then
			reg.refresh(function()
				for _, p in ipairs({ "rust-analyzer", "codelldb" }) do
					local okp, pkg = pcall(reg.get_package, p)
					if okp and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end
		-- rustaceanvim sets up rust_analyzer itself; don't call vim.lsp.enable("rust_analyzer")
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set(
						"n",
						"<leader>rr",
						"<Cmd>RustLsp runnables<CR>",
						{ buffer = bufnr, desc = "Rust runnables" }
					)
					vim.keymap.set(
						"n",
						"<leader>rd",
						"<Cmd>RustLsp debuggables<CR>",
						{ buffer = bufnr, desc = "Rust debuggables" }
					)
				end,
			},
		}
	end,
})
