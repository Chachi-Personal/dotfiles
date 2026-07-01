hl.config({
	decoration = {
		rounding = 10,
		rounding_power = 4,
		active_opacity = 1.0,
		inactive_opacity = 0.9,
		fullscreen_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 32,
			render_power = 2,
			color = "rgba(00000050)",
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 4,
			new_optimizations = true,
			ignore_opacity = true,
			xray = true,
			vibrancy = 0.1696,
			-- popups = true,
			-- popups_ignorealpha = 0.2,
			-- input_methods = true,
		},
	},
})
