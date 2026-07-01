hl.window_rule({
	name = "download-dialogue",
	match = { class = "xdg-desktop-partal-gtk" },
	float = true,
})

hl.window_rule({
	name = "wechat",
	match = { class = "wechat" },
	float = true,
	pin = true,
})

hl.window_rule({
	name = "wechat-vid",
	match = { initial_title = "^WeChat$", initial_class = "^$", xwayland = 1 },
	size = { 440, 820 },
	float = true,
	pin = true,
})

hl.window_rule({
	name = "borderless on maximized",
	match = { fullscreen = true },
	border_size = 0,
})

-- Pavucontrol
hl.window_rule({
	name = "pavucontrol",
	match = { class = "org.pulseaudio.pavucontrol" },
	float = true,
	center = true,
	size = "700 600",
})

-- Waypaper
hl.window_rule({
	name = "waypaper",
	match = { class = "waypaper" },
	float = true,
	center = true,
	pin = true,
	size = "900 700",
})

-- Newelle
hl.window_rule({
	name = "newelle",
	match = { class = "io.github.qwersyk.Newelle" },
	float = true,
	center = true,
	pin = true,
	size = "1000 700",
})

-- Blueman Manager
hl.window_rule({
	name = "blueman-manager",
	match = { class = "blueman-manager" },
	float = true,
	center = true,
	size = "800 600",
})

-- Blueberry
hl.window_rule({
	name = "blueberry",
	match = { class = "blueberry.py" },
	float = true,
	center = true,
	size = "800 600",
})

-- nwg-look
hl.window_rule({
	name = "nwg-look",
	match = { class = "nwg-look" },
	float = true,
	center = true,
	size = "700 600",
})

-- nwg-displays
hl.window_rule({
	name = "nwg-displays",
	match = { class = "nwg-displays" },
	float = true,
	center = true,
	size = "900 600",
})

-- System Mission Center
hl.window_rule({
	name = "missioncenter",
	match = { class = "io.missioncenter.MissionCenter" },
	float = true,
	center = true,
	pin = true,
	size = "900 600",
})

-- Gnome Calculator
hl.window_rule({
	name = "gnome-calculator",
	match = { class = "org.gnome.Calculator" },
	float = true,
	center = true,
	size = "700 600",
})

-- Hyprland Share Picker
hl.window_rule({
	name = "hyprland-share-picker",
	match = { class = "hyprland-share-picker" },
	float = true,
	pin = true,
	center = true,
	size = "600 400",
})

-- nm-connection-editor
hl.window_rule({
	name = "nm-connection-editor",
	match = { class = "nm-connection-editor" },
	float = true,
	center = true,
	size = "800 700",
})

-- Picture-in-Picture
hl.window_rule({
	name = "Picture in Picture",
	match = { initial_title = ".*(?i)picture.in.picture.*" },
	float = true,
	pin = true,
})

hl.window_rule({
	name = "dotfiles",
	match = { class = "dotfiles-floating" },
	float = true,
	center = true,
	size = "1000 700",
})

-- hl.window_rule({
-- 	name = "Meeting Popup",
-- 	match = { title = "^(Meet - bzh-dgyo-wkm)$" },
-- 	float = true,
-- })

-- Chrome hosted popups
hl.window_rule({
	match = { initial_class = "chrome-.*-Default" },
	float = true,
	center = true,
	-- size = { 943, 1006 },
})

hl.window_rule({
	name = "helium-signin",
	match = {
		class = "helium",
		title = "Sign in - Google Accounts - Helium",
	},
	float = true,
})

-- tile Canvas, Outlook, and MS Teams
hl.window_rule({
	match = { initial_title = "Canvas|Outlook \\(PWA\\)|Microsoft Teams \\(PWA\\)" },
	float = false,
})

hl.window_rule({
	name = "Gnome Calendar",
	match = { class = "org.gnome.Calendar" },
	float = true,
	center = true,
	size = "900 600",
})

-- ML4W Floating
hl.window_rule({
	name = "dotfiles-floating",
	match = { class = "dotfiles-floating" },
	float = true,
	center = true,
	size = "1000 700",
})

-- ML4W Sidepad
hl.window_rule({
	name = "dotfiles-sidepad",
	match = { class = "dotfiles-sidepad" },
	float = true,
	pin = true,
	center = true,
	size = "1000 700",
})
-- ML4W Welcome App
hl.window_rule({
	name = "ml4w-welcome-app",
	match = { title = "ML4W Welcome" },
	float = true,
	center = true,
	pin = true,
	size = "700 600",
})

-- ML4W Settings App
hl.window_rule({
	name = "ml4w-settings-app",
	match = { title = "ML4W Dotfiles Settings" },
	float = true,
	center = true,
	pin = true,
	size = "900 600",
})

hl.window_rule({
	name = "OpenGL App",
	match = { title = "^(OpenGL App)$" },
	float = true,
})

hl.window_rule({
	name = "TTS Window",
	match = { class = "mpv", title = "tts" },
	suppress_event = "fullscreen",
	float = true,
	size = { 100, 50 },
	move = { 10, 10 },
})

hl.window_rule({
	name = "Local Send",
	match = { class = "localsend", title = "LocalSend" },
	float = true,
	size = { 500, 680 },
})

hl.window_rule({
	name = "Pyplots",
	match = { class = "Matplotlib" },
	float = true,
	center = true,
})
