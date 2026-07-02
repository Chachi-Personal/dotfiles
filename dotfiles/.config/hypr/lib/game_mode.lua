local M = {}

-- Path constants (mirrors the shell script)
local cache_dir = os.getenv("HOME") .. "/.cache/ml4w/hyprland-dotfiles"
local flag_file = os.getenv("HOME") .. "/.config/ml4w/settings/gamemode-enabled"
local wpauto_cache = cache_dir .. "/wallpaper-automation"
local wpauto_restart = cache_dir .. "/restart-wpauto"
local wpauto_script = os.getenv("HOME") .. "/.config/ml4w/scripts/ml4w-wallpaper-automation"

-- Helper: check if a file exists
local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- Derive actual state from the flag file, not from a variable.
-- This survives config reloads correctly.
local function is_active()
	return file_exists(flag_file)
end

M.toggle = function()
	if is_active() then
		-- ── DEACTIVATE ────────────────────────────────────────────────────

		-- Resume wallpaper automation if it was stopped
		if file_exists(wpauto_restart) then
			os.remove(wpauto_restart)
			hl.exec_cmd(wpauto_script .. " &")
		end

		-- Reload config — restores decoration.lua / animation.lua / window.lua
		hl.exec_cmd("hyprctl reload")

		os.remove(flag_file)

		hl.exec_cmd("notify-send -a 'System' -i joystick 'Gamemode deactivated' 'Animations and blur are now enabled.'")
	else
		-- ── ACTIVATE ──────────────────────────────────────────────────────

		-- Stop wallpaper automation if running
		if file_exists(wpauto_cache) then
			io.open(wpauto_restart, "w"):close() -- touch
			hl.exec_cmd(wpauto_script)
		end

		hl.config({
			animations = { enabled = false },
			decoration = {
				rounding = 0,
				rounding_power = 2,
				active_opacity = 1.0,
				inactive_opacity = 1.0,
				fullscreen_opacity = 1.0,
				shadow = { enabled = false },
				blur = { enabled = false },
			},
			general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
		})

		-- Write the flag file
		io.open(flag_file, "w"):close()

		hl.exec_cmd("notify-send -a 'System' -i joystick 'Gamemode activated' 'Animations and blur are now disabled.'")
	end
end

return M
