-- ~/.config/hypr/lib/keybindings.lua
local M = {}

-- Bitmask → modifier string
local function decode_modmask(mask)
	local mods = {}
	if mask & 64 ~= 0 then
		mods[#mods + 1] = "SUPER"
	end
	if mask & 8 ~= 0 then
		mods[#mods + 1] = "ALT"
	end
	if mask & 4 ~= 0 then
		mods[#mods + 1] = "CTRL"
	end
	if mask & 1 ~= 0 then
		mods[#mods + 1] = "SHIFT"
	end
	return table.concat(mods, " + ")
end

-- Key name prettification
local key_map = {
	XF86AudioRaiseVolume = "FN_VOLUME_UP",
	XF86AudioLowerVolume = "FN_VOLUME_DOWN",
	XF86AudioMicMute = "FN_MIC_MUTE",
	XF86AudioMute = "FN_MUTE",
	XF86AudioPlay = "FN_PLAY",
	XF86AudioPause = "FN_PAUSE",
	XF86AudioNext = "FN_NEXT_TRACK",
	XF86AudioPrev = "FN_PREV_TRACK",
	XF86AudioStop = "FN_STOP",
	XF86MonBrightnessUp = "FN_BRIGHTNESS_UP",
	XF86MonBrightnessDown = "FN_BRIGHTNESS_DOWN",
	XF86Calculator = "FN_CALCULATOR",
	XF86Sleep = "FN_SLEEP",
	XF86Rfkill = "FN_AIRPLANE_MODE",
	["mouse:272"] = "MOUSE_LEFT",
	["mouse:273"] = "MOUSE_RIGHT",
	RETURN = "ENTER",
	KP_ENTER = "ENTER",
}

local function prettify_key(key)
	return key_map[key] or key
end

-- Build "SUPER + SHIFT + F" style combo string
local function build_combo(modmask, key)
	local mods = decode_modmask(modmask)
	local pretty = prettify_key(key)
	if mods ~= "" then
		return mods .. " + " .. pretty
	end
	return pretty
end

-- Parse hyprctl -j binds and return formatted lines
function M.get_formatted_binds()
	hl.exec_cmd("hyprctl -j binds > /tmp/binds.json") --io.popen("hyprctl -j binds")
	local handle = nil
	if not handle then
		hl.notification.create({ text = "Failed to retrieve keybinds", duration = 3000 })
		return {}
	end
	local raw = handle:read("*a")
	handle:close()

	-- naive JSON array parser: extract each bind object's fields
	local lines = {}
	for block in raw:gmatch("{(.-)%s*}") do
		local modmask = tonumber(block:match('"modmask"%s*:%s*(%d+)'))
		local key = block:match('"key"%s*:%s*"([^"]*)"')
		local desc = block:match('"description"%s*:%s*"([^"]*)"')

		if modmask and key and desc and desc ~= "" then
			local combo = build_combo(modmask, key)
			lines[#lines + 1] = combo .. "\t" .. desc
		end
	end
	return lines
end

-- Launch the keybindings picker
function M.show()
	local binds = M.get_formatted_binds()
	if #binds == 0 then
		hl.notification.create({ text = "No keybinds found", duration = 3000 })
		return
	end

	-- Build newline-separated input string
	local input = table.concat(binds, "\n")

	-- Escape single quotes in input for shell
	input = input:gsub("'", "'\\''")

	-- Read launcher preference
	local lf = io.open(os.getenv("HOME") .. "/.config/ml4w/settings/launcher")
	local launcher = lf and lf:read("*l") or "rofi"
	if lf then
		lf:close()
	end

	if launcher == "walker" then
		-- walker expects "combo:desc" format
		local walker_input = input:gsub("\t", ":")
		hl.exec_cmd(
			"bash -c 'echo \\'"
				.. walker_input
				.. "\\' | "
				.. os.getenv("HOME")
				.. '/.config/walker/launch.sh -d -N -H -p "Search Keybinds"\''
		)
	else
		hl.exec_cmd(
			"bash -c 'echo \\'"
				.. input
				.. "\\' | "
				.. 'rofi -dmenu -i -eh 2 -replace -p "Keybinds" '
				.. "-config ~/.config/rofi/config-compact.rasi'"
		)
	end
end

return M
