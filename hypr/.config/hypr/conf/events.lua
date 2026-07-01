hl.on("window.fullscreen", function()
	if hl.get_config("general.layout") == "monocle" then
		return
	end
	hl.dispatch(hl.dsp.layout("focus r"))
	hl.dispatch(hl.dsp.layout("focus l"))
end)

hl.on("window.urgent", function(win)
	hl.dispatch(hl.dsp.focus({ window = win }))
end)

hl.on("config.reloaded", function()
	-- Cleanup gamemode flag file on config reload, in case it was left there
	-- by a previous instance of Hyprland that had gamemode enabled
	local flag_file = os.getenv("HOME") .. "/.config/ml4w/settings/gamemode-enabled"
	local f = io.open(flag_file, "r")
	if f then
		f:close()
		os.remove(flag_file)
	end
end)
