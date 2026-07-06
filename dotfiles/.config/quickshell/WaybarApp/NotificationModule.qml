import Quickshell
import Quickshell.Io
import QtQuick
import qs.WaybarApp

// custom/notification: swaync state bell drawn with Material Icons glyphs
// (#custom-notification { font-family: "Material Icons"; font-size: 20px; }).
// Left click toggles the panel, right click toggles do-not-disturb.
ModuleLabel {
    id: bell

    property string alt: "none"

    // Codepoints for the ligature names used in the waybar config:
    // notifications_active / notifications / notifications_paused /
    // notification_important / notifications_off.
    readonly property var icons: ({
            "notification": "",
            "none": "",
            "dnd-notification": "",
            "dnd-none": "",
            "inhibited-notification": "",
            "inhibited-none": "",
            "dnd-inhibited-notification": "",
            "dnd-inhibited-none": ""
        })

    fontFamily: "Material Icons"
    fontPixelSize: 20
    text: icons[alt] || ""

    onClicked: Quickshell.execDetached(["swaync-client", "-t", "-sw"])
    onRightClicked: Quickshell.execDetached(["swaync-client", "-d", "-sw"])

    // swaync's waybar subscription emits a JSON line on every change, e.g.
    // {"text": "3", "alt": "notification", "class": "notification"}.
    Process {
        command: ["swaync-client", "-swb"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    bell.alt = String(JSON.parse(data).alt || "none");
                } catch (e) {
                }
            }
        }
    }
}
