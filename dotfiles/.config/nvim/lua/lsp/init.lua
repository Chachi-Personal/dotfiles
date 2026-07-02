local langs_dir = vim.fn.stdpath("config") .. "/lua/lsp/langs"
for _, file in ipairs(vim.fn.glob(langs_dir .. "/*.lua", false, true)) do
	local modname = vim.fn.fnamemodify(file, ":t:r") -- Get filename without extension
	require("lsp.langs." .. modname)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client.name == "marksman" then
			local clients = vim.lsp.get_clients({ bufnr = args.buf })
			for _, c in ipairs(clients) do
				if c.name == "obsidian-ls" then
					client.server_capabilities.definitionProvider = false
					break
				end
			end
			-- obsidina-ls may not have attached yet; defer a second check
			vim.defer_fn(function()
				local deferred_clients = vim.lsp.get_clients({ bufnr = args.buf })
				for _, c in ipairs(deferred_clients) do
					if c.name == "obsidian-ls" then
						client.server_capabilities.definitionProvider = false
						break
					end
				end
			end, 500)
		end

		local map = vim.keymap.set
		local s = function(desc)
			return { silent = true, buffer = args.buf, desc = desc }
		end

		local function get_url_under_cursor()
			local line = vim.fn.getline(".")
			-- Match markdown link [label](url) — grab the URL part
			local url = line:match("%[.-%]%((.-)%)")
			if not url then
				-- Fall back to word under cursor (bare URL)
				url = vim.fn.expand("<cfile>")
			end
			if url and url:match("^https?://") then
				return url
			end
			return nil
		end

		map("n", "gd", function()
			local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
			local url = get_url_under_cursor()
			if #clients > 0 and not url then
				vim.lsp.buf.definition()
			elseif url then
				vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			else
				vim.lsp.buf.definition()
			end
		end, s("Go to definition / Open URL"))

		-- Navigation
		-- map("n", "gd", vim.lsp.buf.definition, s("Go to definition"))
		map("n", "gy", vim.lsp.buf.type_definition, s("Go to type definition"))
		map("n", "gK", vim.lsp.buf.signature_help, s("Signature help"))

		-- <leader>l group
		map("n", "<leader>la", vim.lsp.buf.code_action, s("LSP code action"))
		map("n", "<leader>lA", function()
			vim.lsp.buf.code_action({ context = { only = { "source" } } })
		end, s("LSP source action"))
		map("n", "<leader>lr", vim.lsp.buf.rename, s("Rename symbol"))
		map("n", "<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, s("Format buffer"))
		map("n", "<leader>lh", vim.lsp.buf.signature_help, s("Signature help"))
		map("n", "<leader>li", "<Cmd>checkhealth vim.lsp<CR>", s("LSP information (checkhealth)"))
		map("n", "<leader>ld", vim.diagnostic.open_float, s("Hover diagnostics"))

		-- CodeLens
		map("n", "<leader>ll", vim.lsp.codelens.refresh, s("CodeLens refresh"))
		map("n", "<leader>lL", vim.lsp.codelens.run, s("CodeLens run"))

		-- Inlay hints
		map("n", "<leader>uh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
		end, s("Toggle inlay hints (buffer)"))
		map("n", "<leader>uH", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, s("Toggle inlay hints (global)"))

		-- Visual mode
		map("x", "<leader>la", vim.lsp.buf.code_action, s("LSP code action"))
		map("x", "<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, s("Format selection"))

		map("n", "<leader>lG", vim.lsp.buf.workspace_symbol, s("Search workspace symbols"))

		-- Autoformat toggle (simple flag approach)
		map("n", "<leader>uf", function()
			vim.b.autoformat = not (vim.b.autoformat ~= false)
			vim.notify("Autoformat " .. (vim.b.autoformat and "enabled" or "disabled") .. " (buffer)")
		end, s("Toggle autoformat"))
	end,
})
