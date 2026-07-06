import Quickshell
import Quickshell.Io
import QtQuick
import qs.WaybarApp

// bluetooth: " {status}" where status is off / on / connected, polled from
// bluetoothctl every 30s like the waybar module. Hidden when there is no
// controller (format-no-controller: "").
ModuleLabel {
    id: bt

    property bool show: true
    property bool hasController: false
    property bool powered: false
    property int connections: 0

    readonly property string status: !powered ? "off" : connections > 0 ? "connected" : "on"

    visible: show && hasController
    text: " " + status

    onClicked: Quickshell.execDetached(["bash", "-c", "sleep 0.1 && " + Quickshell.env("HOME") + "/.config/ml4w/settings/bluetooth.sh"])

    Process {
        id: pollProc
        command: ["bash", "-c", "bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2}'; bluetoothctl devices Connected 2>/dev/null | grep -c ^Device"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n");
                bt.hasController = lines.length > 0 && (lines[0] === "yes" || lines[0] === "no");
                bt.powered = lines[0] === "yes";
                bt.connections = lines.length > 1 ? (parseInt(lines[1]) || 0) : 0;
            }
        }
    }

    Timer {
        interval: 30 * 1000
        running: true
        repeat: true
        onTriggered: {
            pollProc.running = false;
            pollProc.running = true;
        }
    }
}
