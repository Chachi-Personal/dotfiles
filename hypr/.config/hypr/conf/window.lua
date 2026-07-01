hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 1,
		col = {
			active_border = { colors = { require("colors").primary, require("colors").on_primary }, angle = 90 },
			inactive_border = require("colors").on_primary,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "scrolling",
		snap = {
			enabled = true,
		},
	},
})
