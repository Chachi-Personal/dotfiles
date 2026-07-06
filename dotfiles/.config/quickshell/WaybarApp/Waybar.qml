pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.CustomTheme

// Shared state and constants for the waybar-clone bar. One instance serves
// every per-monitor WaybarWindow.
//
// The "enabled" flag lives in ~/.config/ml4w/settings/statusbar.json — the
// same file (and the same "statusbar" IPC target) the previous StatusbarApp
// used, so the SidebarApp switch keeps working unchanged.
Singleton {
    id: root

    // --- Look & feel -------------------------------------------------------

    // Several Font Awesome glyphs used by the waybar theme only exist in the
    // Solid style, which Qt's fontconfig fallback does not reach from Fira
    // Sans — icon-only labels set this family explicitly.
    readonly property string iconFontFamily: "Font Awesome 7 Free Solid"

    // label.module font-size from style.css.
    readonly property int fontSize: 14

    // Height of one glass island and of the whole bar strip (island + the
    // 10px CSS margin above and below it).
    readonly property int moduleHeight: 34
    readonly property int barHeight: 54

    // Outputs that get the reduced module set ("layer: top" block in the
    // waybar config). Every other output gets the full bar.
    readonly property var compactOutputs: ["DP-7", "DP-9"]

    // --- Enabled state ------------------------------------------------------

    property bool enabled: true

    FileView {
        id: settingsFile
        path: Quickshell.env("HOME") + "/.config/ml4w/settings/statusbar.json"
        blockLoading: true
        onLoaded: root.applySettings()
    }

    function applySettings(): void {
        try {
            let raw = settingsFile.text().replace(/\/\*[\s\S]*?\*\//g, "");
            let parsed = JSON.parse(raw);
            if (parsed.bar !== undefined && parsed.bar.enabled !== undefined)
                root.enabled = parsed.bar.enabled;
        } catch (e) {
            console.warn("statusbar.json: could not parse, keeping enabled =", root.enabled, e);
        }
    }

    // Flip the flag with a regex on the raw text so the file's formatting is
    // preserved, exactly like the old StatusbarApp did.
    function setEnabled(on: bool): void {
        root.enabled = on;
        let updated = settingsFile.text().replace(/("enabled"\s*:\s*)(true|false)/, "$1" + (on ? "true" : "false"));
        settingsFile.setText(updated);
    }

    // Emitted by the IPC refresh hook; the updates module re-runs its check.
    signal updatesRefreshRequested

    // Emitted by the IPC panel hook; the focused monitor's bar toggles the
    // named dropdown (audio | bluetooth | network).
    signal panelRequested(string name)

    IpcHandler {
        target: "statusbar"

        function toggle(): void {
            root.setEnabled(!root.enabled);
        }
        function enable(): void {
            root.setEnabled(true);
        }
        function disable(): void {
            root.setEnabled(false);
        }
        // Re-read statusbar.json (SidebarApp menu) and re-check updates.
        function reload(): void {
            settingsFile.reload();
            root.applySettings();
            root.updatesRefreshRequested();
        }
        function refresh(): void {
            reload();
        }
        // Toggle a dropdown panel (audio | bluetooth | network) on the
        // focused monitor's bar.
        function panel(name: string): void {
            root.panelRequested(name);
        }
        // Kept so existing SidebarApp switches / keybindings don't error. The
        // waybar-style bar has no collapsed pill mode, so these do nothing.
        function focus(): void {
        }
        function expand(): void {
        }
        function collapse(): void {
        }
        function alwaysExpand(): void {
        }
        function autoCollapse(): void {
        }
    }
}
