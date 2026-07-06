import Quickshell
import Quickshell.Io
import QtQuick
import qs.CustomTheme
import qs.WaybarApp

// group/tools: drawer with clipboard history, the hypridle inhibitor toggle,
// the hyprsunset screen shader toggle and the power-profiles-daemon cycler.
DrawerGroup {
    id: tools

    icon: ""

    // --- cliphist ---
    ModuleLabel {
        text: ""
        fontFamily: Waybar.iconFontFamily
        onClicked: Quickshell.execDetached(["bash", "-c", "sleep 0.1 && " + Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-cliphist"])
        onRightClicked: Quickshell.execDetached(["bash", "-c", "sleep 0.1 && " + Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-cliphist d"])
        onMiddleClicked: Quickshell.execDetached(["bash", "-c", "sleep 0.1 && " + Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-cliphist w"])
    }

    // --- hypridle inhibitor (icon tinted while the inhibitor is active) ---
    ModuleLabel {
        id: hypridle
        property string klass: ""
        text: ""
        fontFamily: Waybar.iconFontFamily
        textColor: klass === "active" ? Theme.primary : Theme.on_surface
        onClicked: {
            Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/hypridle.sh toggle"]);
            hypridleRepoll.restart();
        }

        Process {
            id: hypridleProc
            command: ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/hypridle.sh status"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    try {
                        hypridle.klass = String(JSON.parse(this.text.trim()).class || "");
                    } catch (e) {
                    }
                }
            }
        }
        Timer {
            interval: 60 * 1000
            running: true
            repeat: true
            onTriggered: {
                hypridleProc.running = false;
                hypridleProc.running = true;
            }
        }
        // Give the toggle a moment to apply before re-reading the status.
        Timer {
            id: hypridleRepoll
            interval: 600
            onTriggered: {
                hypridleProc.running = false;
                hypridleProc.running = true;
            }
        }
    }

    // --- hyprsunset screen shader ---
    ModuleLabel {
        text: ""
        fontFamily: Waybar.iconFontFamily
        onClicked: Quickshell.execDetached(["bash", "-c", "sleep 0.5; " + Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-toggle-hyprsunset"])
    }

    // --- power-profiles-daemon (click cycles the profile) ---
    ModuleLabel {
        id: ppd
        property string profile: ""
        readonly property var icons: ({
                "performance": "",
                "balanced": "",
                "power-saver": ""
            })
        visible: profile !== ""
        fontFamily: Waybar.iconFontFamily
        text: icons[profile] || ""
        onClicked: {
            let order = ["performance", "balanced", "power-saver"];
            let next = order[(order.indexOf(profile) + 1) % order.length];
            Quickshell.execDetached(["powerprofilesctl", "set", next]);
            ppdRepoll.restart();
        }

        Process {
            id: ppdProc
            command: ["bash", "-c", "powerprofilesctl get 2>/dev/null"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: ppd.profile = this.text.trim()
            }
        }
        Timer {
            interval: 10 * 1000
            running: true
            repeat: true
            onTriggered: {
                ppdProc.running = false;
                ppdProc.running = true;
            }
        }
        Timer {
            id: ppdRepoll
            interval: 400
            onTriggered: {
                ppdProc.running = false;
                ppdProc.running = true;
            }
        }
    }
}
