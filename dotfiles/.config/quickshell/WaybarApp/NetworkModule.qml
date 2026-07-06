import Quickshell
import Quickshell.Io
import QtQuick
import qs.WaybarApp

// network: wifi " {signalStrength}%", ethernet "  {ifname}", otherwise
// "Disconnected ⚠". State comes from nmcli, polled every 10s.
ModuleLabel {
    id: net

    property bool show: true
    property string kind: "disconnected"   // wifi | ethernet | disconnected
    property string ifname: ""
    property int signalStrength: 0

    visible: show
    text: kind === "wifi" ? "  " + signalStrength + "%" : kind === "ethernet" ? "   " + ifname : "Disconnected ⚠"

    onClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/settings/networkmanager.sh"])
    onRightClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/nm-applet.sh toggle"])

    Process {
        id: pollProc
        // Prefer ethernet over wifi when both are up, matching what waybar
        // shows for the default connection. Output: "ethernet:<if>",
        // "wifi:<if>:<signal>" or "disconnected".
        command: ["bash", "-c", "eth=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2==\"ethernet\" && $3==\"connected\"{print $1; exit}'); " + "if [ -n \"$eth\" ]; then echo \"ethernet:$eth\"; exit; fi; " + "wifi=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2==\"wifi\" && $3==\"connected\"{print $1; exit}'); " + "if [ -n \"$wifi\" ]; then sig=$(nmcli -t -f IN-USE,SIGNAL device wifi list --rescan no 2>/dev/null | awk -F: '$1==\"*\"{print $2; exit}'); echo \"wifi:$wifi:${sig:-0}\"; exit; fi; " + "echo disconnected"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split(":");
                if (parts[0] === "ethernet") {
                    net.kind = "ethernet";
                    net.ifname = parts[1] || "";
                } else if (parts[0] === "wifi") {
                    net.kind = "wifi";
                    net.ifname = parts[1] || "";
                    net.signalStrength = parseInt(parts[2]) || 0;
                } else {
                    net.kind = "disconnected";
                }
            }
        }
    }

    Timer {
        interval: 10 * 1000
        running: true
        repeat: true
        onTriggered: {
            pollProc.running = false;
            pollProc.running = true;
        }
    }
}
