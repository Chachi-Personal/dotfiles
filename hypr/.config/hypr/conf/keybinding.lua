-- Configuration
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Helper functions
local bind = hl.bind
local mod = function(key)
	return mainMod .. " + " .. key
end
local modShift = function(key)
	return "SUPER + SHIFT + " .. key
end
local modAlt = function(key)
	return "SUPER + ALT + " .. key
end
local modControl = function(key)
	return "SUPER + CTRL + " .. key
end
local altShift = function(key)
	return "ALT + SHIFT + " .. key
end
local alt = function(key)
	return "ALT + " .. key
end

local exec = function(cmd)
	return hl.dsp.exec_cmd(cmd)
end
local HYPRSCRIPTS = "~/.config/hypr/scripts"

-- Applications
local TERMINAL = "kitty"
local BROWSER = "LIBVA_DRIVER_NAME=iHD helium-browser"
local TOR_BROWSER = "brave --tor"
local LAUNCHER = "~/.config/hypr/scripts/launcher.sh"
local CALC = "~/.config/ml4w/settings/calculator.sh"
local WALLPAPER = "~/.config/ml4w/scripts/ml4w-wallpaper-app"

-- Applications
bind(mod("RETURN"), exec(TERMINAL), { description = "Open terminal" })
bind(mod("KP_ENTER"), exec(TERMINAL), { description = "Open terminal" })
bind(mod("EQUAL"), exec(CALC), { description = "Open calculator" })
bind(mod("W"), exec(BROWSER), { description = "Open browser" })
bind(mod("E"), exec(TERMINAL .. " -e yazi"), { description = "Open filemanager" })
bind(mod("D"), exec(LAUNCHER), { description = "Open application launcher" })
bind(modShift("W"), exec(BROWSER .. " --incognito"), { description = "Open browser in incognito mode" })
bind(modShift("D"), exec(CALC), { description = "Open calculator" })
bind(modShift("RETURN"), exec(TERMINAL .. " -e yazi"), { description = "Open filemanager" })
bind(modShift("KP_ENTER"), exec(TERMINAL .. " -e yazi"), { description = "Open filemanager" })
bind(altShift("W"), exec(TOR_BROWSER), { description = "Open browser in tor mode" })
--
-- # Display
--
bind(modShift("mouse_down"), function()
	hl.config({
		cursor = {
			zoom_factor = hl.get_config("cursor:zoom_factor") + 0.5,
		},
	})
end, { mouse = true, description = "Increease display zoom" })
bind(modShift("mouse_up"), function()
	hl.config({
		cursor = {
			zoom_factor = hl.get_config("cursor:zoom_factor") - 0.5,
		},
	})
end, { mouse = true, description = "Decrease display zoom" })
bind(modShift("Z"), function()
	hl.config({
		cursor = {
			zoom_factor = 1,
		},
	})
end, { desc = "Reset display zoom" })
-- bind = $mainMod SHIFT, mouse_down, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}") # Increase display zoom
-- bind = $mainMod SHIFT, mouse_up, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}") # Decrease display zoom
-- bind = $mainMod SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1 # Reset display zoom
--

-- # Workspaces
local move_to_workspace = function(workspace)
	local win = hl.get_active_window()
	hl.dispatch(hl.dsp.focus({ workspace = workspace, on_current_monitor = true }))
	hl.dispatch(hl.dsp.window.move({ workspace = workspace, window = win }))
end
for i = 1, 10, 1 do
	bind(mod(tostring(i % 10)), function()
		hl.dispatch(hl.dsp.focus({ workspace = i, on_current_monitor = true }))
	end, { description = "Focus workspace " .. tostring(i) })
	bind(modShift(tostring(i % 10)), function()
		move_to_workspace(i)
	end, { description = "Move active window to workspace " .. tostring(i) })
end

-- # Windows
bind(mod("Q"), hl.dsp.window.close(), { description = "Quit window" })

bind(modShift("Q"), hl.dsp.window.kill(), { description = "Quit active window and all open instances" })
bind(
	mod("F"),
	hl.dsp.window.fullscreen({ mode = "fullscreen" }),
	{ description = "Toggle active window to fullscreen" }
)
bind(mod("M"), function()
	-- hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
	hl.dispatch(hl.dsp.layout("colresize +conf"))
	hl.dispatch(hl.dsp.layout("focus l"))
	hl.dispatch(hl.dsp.layout("focus r"))
end, { description = "Toggle monocle layout" })

bind(mod("T"), hl.dsp.window.float(), { description = "Toggle active window floating" })
local move_or_cycle = function(direction)
	local layout = hl.get_config("general.layout")
	if layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cyclenext"))
	elseif layout == "scrolling" then
		hl.dispatch(hl.dsp.focus({ direction = direction }))
		-- hl.dispatch(hl.dsp.layout("focus " .. direction))
	else
		hl.notification.create({
			text = "Unconfigured action for this layout",
			duration = 2000,
		})
	end
end
bind(mod("H"), function()
	move_or_cycle("l")
end, { description = "Focus left window" })
bind(mod("J"), function()
	move_or_cycle("d")
end, { description = "Focus down window" })
bind(mod("K"), function()
	move_or_cycle("u")
end, { description = "Focus up window" })
bind(mod("L"), function()
	move_or_cycle("r")
end, { description = "Focus right window" })
bind(modShift("H"), hl.dsp.window.swap({ direction = "l" }), { description = "Swap with left window" })
bind(modShift("J"), hl.dsp.window.swap({ direction = "d" }), { description = "Swap with down window" })
bind(modShift("K"), hl.dsp.window.swap({ direction = "u" }), { description = "Swap with up window" })
bind(modShift("L"), hl.dsp.window.swap({ direction = "r" }), { description = "Swap with right window" })
bind(altShift("H"), hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
bind(altShift("L"), hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
bind(altShift("K"), hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
bind(altShift("J"), hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })
bind(mod("mouse:272"), hl.dsp.window.drag(), { mouse = true, description = "Move" })
bind(mod("mouse:273"), hl.dsp.window.resize(), { mouse = true, description = "Resize" })
-- bind(alt("Tab"), function()
-- 	hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
-- 	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "bottom" }))
-- end, { repeating = true })
--
-- # Actions
bind("PRINT", exec(HYPRSCRIPTS .. "/screenshot.sh"), { description = "Take a screenshot" })
bind(modShift("S"), exec("grimblast --notify copy area"), { description = "Copy area to clipboard" })
bind(altShift("S"), hl.dsp.exec_cmd('grim -g "$(slurp)" - | tesseract stdin stdout -l chi_sim | wl-copy'))

bind(mod("S"), hl.dsp.exec_cmd("/usr/bin/env -C /home/chachi/Videos/tools/sub_extract uv run speak.py"))
bind(alt("S"), hl.dsp.exec_cmd("/usr/bin/env -C /home/chachi/Videos/tools/sub_extract uv run ocr-screenshot.py --tts"))
bind(
	modAlt("F"),
	exec(HYPRSCRIPTS .. "/screenshot.sh --instant"),
	{ description = "Take an instant full-screen screenshot" }
)
bind(
	modAlt("S"),
	exec(HYPRSCRIPTS .. "/screenshot.sh --instant-area"),
	{ description = "Take an instant area screenshot" }
)
bind(mod("X"), exec("qs ipc call power toggle"), { description = "Start Power Menu" })
bind(mod("N"), exec(WALLPAPER .. " --random"), { description = "Change the wallpaper" })
bind(modShift("N"), exec(WALLPAPER), { description = "Open wallpaper selector" })
-- bind(modControl("K"), require("lib.keybindings").show, { description = "Show keybindings" })
bind(modShift("B"), exec("~/.config/waybar/launch.sh"))
bind(modControl("B"), exec("~/.config/waybar/toggle.sh"))
bind(modShift("R"), function()
	hl.dispatch(exec("hyprctl reload"))
	require("lib.notifications").notify({ title = "Hyprland", message = "Config reloaded" })
end)
-- ML4W
bind(modControl("S"), exec("qs ipc call sidebar toggle"), { description = "Open ML4W Sidebar widget" })

-- # Fn keys
bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), { description = "Increase brightness by 5%" })
bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { description = "Reduce brightness by 5%" })
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { description = "Reduce volume by 5%" })
bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ description = "Increase volume by 5%" }
)
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { description = "Toggle mute" })
bind(
	"XF86AudioMicMute",
	exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ description = "Toggle microphone mute" }
)
bind("XF86AudioPlay", exec("playerctl play-pause"), { description = "Toggle play/pause" })
bind("XF86AudioPause", exec("playerctl pause"), { description = "Toggle play/pause" })
bind("XF86AudioNext", exec("playerctl next"), { description = "Play next track" })
bind("XF86AudioPrev", exec("playerctl previous"), { description = "Play previous track" })

bind("XF86Calculator", exec("~/.config/ml4w/settings/calculator.sh"), { description = "Open calculator" })
-- bind("XF86Lock", exec("hyprlock"), { description = "Open screenlock" })
--
bind(
	"code:238",
	exec("brightnessctl -d smc::kbd_backlight s +10"),
	{ description = "Increase keyboard backlight brightness" }
)
bind(
	"code:237",
	exec("brightnessctl -d smc::kbd_backlight s 10-"),
	{ description = "Decrease keyboard backlight brightness" }
)

-- bind = SUPER, mouse:277, exec, notify-send "MX forward button pressed"
bind("mouse:277", hl.dsp.window.kill())

bind(mod("G"), require("lib.game_mode").toggle)

local submap = require("lib.submap")
submap.create(alt("R"), "resize", function()
	-- Set repeating binds for resizing the active window.
	bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
end)
submap.create(alt("Z"), "zoom", function()
	bind("mouse_down", function()
		hl.config({
			cursor = {
				zoom_factor = hl.get_config("cursor:zoom_factor") + 0.5,
			},
		})
	end, { mouse = true, description = "Increease display zoom" })
	bind("mouse_up", function()
		hl.config({
			cursor = {
				zoom_factor = hl.get_config("cursor:zoom_factor") - 0.5,
			},
		})
	end, { mouse = true, description = "Decrease display zoom" })
end)
