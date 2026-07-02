local lazy_packages = require("plugins.lazy_packages")
lazy_packages.register("obsidian.nvim")
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	-- Hyprland config files don't have a standard filetype; match by filename
	pattern = { "/home/chachi/Vault/*.md" },
	group = vim.api.nvim_create_augroup("ObsidianVault", { clear = true }),
	once = true,
	callback = function()
		-- vim.opt.conceallevel = 1
		vim.pack.add({
			{
				src = "https://github.com/obsidian-nvim/obsidian.nvim",
				version = vim.version.range("*"), -- use latest release, remove to use latest commit
			},
		})
		require("obsidian").setup({
			legacy_commands = false,
			workspaces = {
				{
					name = "main",
					path = "~/Vault",
				},
			},
			notes_subdir = "Unsorted",
			new_notes_location = "notes_subdir",
			note_id_func = require("obsidian.builtin").title_id, -- FIXME: No id, but use file name
			daily_notes = {
				enabled = true,
				folder = "Calendar/Daily",
				template = "Atlas/Templates/Daily",
				default_tags = {},
			},
			ui = { enable = false },
			attachments = {
				folder = "Attachments",
			},
			checkbox = {
				enabled = false,
			},
		})

		local map = function(k, cmd, desc)
			vim.keymap.set("n", k, "<cmd>" .. cmd .. "<CR>", { silent = true, desc = desc })
		end

		map("<leader>odd", "Obsidian dailies", "Calendar")
		map("<leader>odl", "Obsidian today", "Calendar today")
		map("<leader>odj", "Obsidian tomorrow", "Calendar tomorrow")
		map("<leader>odk", "Obsidian yesterday", "Calendar yesterday")
		map("<leader>ob", "Obsidian backlinks", "Backlinks")
		map("<leader>oc", "Obsidian check", "Check")
		map("<leader>ol", "Obsidian links", "Links")
		map("<leader>on", "Obsidian new", "New Note")
		map("<leader>oN", "Obsidian new_from_template", "New Note from Template")
		map("<leader>or", "Obsidian rename", "Rename")
		map("<leader>of", "Obsidian search", "Search")
		map("<leader>ot", "Obsidian tags", "Tags")
		map("<leader>oT", "Obsidian toc", "TOC")
	end,
})
local obsidian_vault = "/home/chachi/Vault/"
local obsidian_home = "/home/chachi/Vault/Home.md"

vim.api.nvim_create_user_command("ObsidianHome", function()
	if vim.fn.filereadable(obsidian_home) == 0 then
		vim.notify("obsidian: could not find home file", vim.log.levels.ERROR)
		return
	end
	vim.cmd("edit " .. obsidian_home)
end, { desc = "Open home file" })
vim.keymap.set("n", "<leader>oh", "<Cmd>ObsidianHome<CR>", { desc = "Home Note" })

-- Helper: run obsidian CLI adn return trimmed output
local function obs(cmd)
	return vim.fn.trim(vim.fn.system("obsidian " .. cmd .. " 2>/dev/null"))
end

local function vault_path(relative)
	return obsidian_vault .. relative
end

-- vim.api.nvim_create_user_command("ObsidianDaily", function()
-- 	local path = vault_path(obs("daily:path"))
-- 	-- local relative_path = vim.fn.trim(vim.fn.system("obsidian daily:path 2>/dev/null"))
--
-- 	if path == obsidian_vault then
-- 		vim.notify("obsidian: could not resolve daily note path", vim.log.levels.ERROR)
-- 		return
-- 	end
--
-- 	-- Create the file if it doesn't exist yet (no app launch needed)
-- 	if vim.fn.filereadable(path) == 0 then
-- 		local dir = vim.fn.fnamemodify(path, ":h")
-- 		vim.fn.mkdir(dir, "p")
-- 		local f = io.open(path, "w")
-- 		if f then
-- 			f:write("# " .. vim.fn.fnamemodify(path, ":t:r") .. "\n\n")
-- 			f:close()
-- 		end
-- 	end
--
-- 	vim.cmd("edit " .. vim.fn.fnameescape(path))
-- end, { desc = "Open today's Obsidian daily note" })
--
-- -- Fuzzy search note names and open in Neovim
-- vim.api.nvim_create_user_command("ObsidianFind", function()
-- 	local output = obs("files")
-- 	local files = vim.split(output, "\n", { trimempty = true })
--
-- 	require("snacks.picker").pick({
-- 		items = vim.tbl_map(function(f)
-- 			return { text = f, file = vault_path(f) }
-- 		end, files),
-- 		format = "text",
-- 		confirm = function(picker, item)
-- 			picker:close()
-- 			if item then
-- 				vim.cmd("edit " .. vim.fn.fnameescape(item.file))
-- 			end
-- 		end,
-- 	})
-- end, { desc = "Find and open Obsidian note" })
--
-- -- Search note content and open matching file FIXME:
-- vim.api.nvim_create_user_command("ObsidianSearch", function(opts)
-- 	local query = opts.args ~= "" and opts.args or vim.fn.input("Search vault: ")
-- 	if query == "" then
-- 		return
-- 	end
--
-- 	local output = obs("search query=" .. vim.fn.shellescape(query) .. " format=json")
-- 	local ok, results = pcall(vim.json.decode, output)
-- 	if not ok or not results then
-- 		vim.notify("obsidian: no results for: " .. query, vim.log.levels.WARN)
-- 		return
-- 	end
--
-- 	require("snacks.picker").pick({
-- 		items = vim.tbl_map(function(r)
-- 			return { text = r.path, file = vault_path(r.path) }
-- 		end, results),
-- 		format = "text",
-- 		confirm = function(picker, item)
-- 			picker:close()
-- 			if item then
-- 				vim.cmd("edit " .. vim.fn.fnameescape(item.file))
-- 			end
-- 		end,
-- 	})
-- end, { desc = "Search Obsidian vault content" })
--
-- -- FIXME:
-- vim.api.nvim_create_user_command("ObsidianNew", function(opts)
-- 	local name = opts.args ~= "" and opts.args or vim.fn.input("Note name: ")
-- 	if name == "" then
-- 		return
-- 	end
--
-- 	-- Creates via CLI (respects vault folder settings), then open in Neovim
-- 	local path = vault_path(obs("create name=" .. vim.fn.shellescape(name)))
-- 	-- daily:path style: CLI may just print the relative path after create
-- 	-- Fallback: resolve by name
-- 	if vim.fn.filereadable(path) == 0 then
-- 		path = vault_path(obs("file file=" .. vim.fn.shellescape(name)))
-- 	end
-- 	if path ~= obsidian_vault and vim.fn.filereadable(path) == 1 then
-- 		vim.cmd("edit " .. vim.fn.fnameescape(path))
-- 	else
-- 		vim.notify("obsidian: could not create or find: " .. name, vim.log.levels.ERROR)
-- 	end
-- end, { desc = "Create new Obsidian note" })
--
-- vim.api.nvim_create_user_command("ObsidianBacklinks", function()
-- 	local current = vim.fn.expand("%:p"):gsub(obsidian_vault, "")
-- 	local output = obs("backlinks path=" .. vim.fn.shellescape(current) .. " format=tsv")
-- 	local items = {}
-- 	for _, line in ipairs(vim.split(output, "\n", { trimempty = true })) do
-- 		table.insert(items, { text = line, file = vault_path(line) })
-- 	end
--
-- 	if #items == 0 then
-- 		vim.notify("No backlinks found for this note", vim.log.levels.INFO)
-- 		return
-- 	end
--
-- 	require("snacks.picker").pick({
-- 		items = items,
-- 		format = "text",
-- 		confirm = function(picker, item)
-- 			picker:close()
-- 			if item then
-- 				vim.cmd("edit " .. vim.fn.fnameescape(item.file))
-- 			end
-- 		end,
-- 	})
-- end, { desc = "Show backlinks to current note" })
--

-- map("<leader>od", "ObsidianDaily", "Daily note")
-- map("<leader>of", "ObsidianFind", "Find note")
-- map("<leader>os", "ObsidianSearch", "Search vault")
-- map("<leader>on", "ObsidianNew", "New note")
-- map("<leader>ot", "ObsidianTags", "Browse tags")
-- map("<leader>ob", "ObsidianBacklinks", "Backlinks")
-- map("<leader>ok", "ObsidianTasks", "Daily tasks")
