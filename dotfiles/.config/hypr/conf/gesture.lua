hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- hl.gesture({
-- 	fingers = 3,
-- 	direction = "vertical",
-- 	action = "scroll_move",
-- 	scale = 0.9,
-- })

hl.gesture({
	fingers = 4,
	direction = "pinchin",
	action = function()
		hl.dispatch(hl.dsp.window.fullscreen({ action = "set" }))
	end,
})
-- Fullscreen off
hl.gesture({
	fingers = 4,
	direction = "pinchout",
	action = function()
		hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
	end,
})
-- gestures {
--   workspace_swipe_distance = 500
--   workspace_swipe_invert = true
--   workspace_swipe_min_speed_to_force = 30
--   workspace_swipe_cancel_ratio = 0.5
--   workspace_swipe_create_new = true
--   workspace_swipe_forever = true
-- }
--
-- gesture = 3, horizontal, workspace
