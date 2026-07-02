require("full-border"):setup()
require("zoxide"):setup({
	update_db = true,
})
require("simple-mtpfs"):setup({})

-- require("git"):setup()
-- require("starship"):setup()
--
-- require("bookmarks"):setup({
-- 	last_directory = {
-- 		enable = true,
-- 		persist = true,
-- 	},
-- 	persist = "vim",
-- 	desc_format = "parent",
-- 	file_pick_mode = "parent",
-- 	notify = {
-- 		enable = true,
-- 		timeout = 1,
-- 		message = {
-- 			new = "New bookmark '<key>' -> '<folder>'",
-- 			delete = "Deleted bookmark '<key>' -> '<folder>'",
-- 			update = "Updated bookmark '<key>' -> '<folder>'",
-- 		},
-- 	},
-- })
--

-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
