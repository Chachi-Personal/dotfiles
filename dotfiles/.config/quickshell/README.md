# Start Quickshell in configuration folder
qs -p ~/.config/ml4w-quickshell &

# Toggle Settings App
qs -p ~/.config/ml4w-quickshell ipc call settings toggle

# Toggle Welcome App
qs -p ~/.config/ml4w-quickshell ipc call welcome toggle

2. Cross-App Launching

In your Welcome App, you can make the "Dotfiles Settings" button actually trigger the Settings window via IPC rather than launching a whole new process. In your WelcomeWindow.qml button's onClicked:
QML

onClicked: {
    // This tells the background daemon to show the other window
    Quickshell.execute(["qs", "-p", Quickshell.env("HOME") + "/.config/ml4w-quickshell", "ipc", "call", "settings", "open"])
}

# WaybarApp — waybar clone (ml4w-glass)

Quickshell recreation of the waybar ml4w-glass theme (three glass islands,
matugen colors via CustomTheme/Theme.qml). One bar per monitor via Variants in
shell.qml; outputs listed in Waybar.compactOutputs (DP-7/DP-9) get the reduced
module set, all others the full one.

Modules: appmenu, hyprland workspaces (per output), clock, updates, pulseaudio,
bluetooth, network, battery, hardware drawer (disk/cpu/mem), tools drawer
(cliphist/hypridle/hyprshade/power-profiles), tray, swaync bell, power menu.

IPC (same target/settings file as the old StatusbarApp, so the SidebarApp
switch keeps working; enabled state persists in ~/.config/ml4w/settings/statusbar.json):

    qs ipc call statusbar toggle    # show/hide
    qs ipc call statusbar enable
    qs ipc call statusbar disable
    qs ipc call statusbar reload    # re-read settings + re-check updates
    qs ipc call statusbar panel audio|bluetooth|network   # toggle a dropdown

The audio, bluetooth and network modules are fully native (Pipewire,
Quickshell.Bluetooth, Quickshell.Networking) — clicking them melts a dropdown
panel out of the right island (volume + output device picker, device
connect/disconnect, wifi list with inline password prompt) instead of
launching external apps. The dropdown closes when you click any other window.

To replace waybar with it, comment out the waybar launch in
~/.config/hypr/conf/autostart.lua and `killall waybar`.
