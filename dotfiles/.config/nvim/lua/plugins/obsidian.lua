vim.schedule(function()
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
end)
