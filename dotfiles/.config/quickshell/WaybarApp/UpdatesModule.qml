import Quickshell
import Quickshell.Io
import QtQuick
import qs.CustomTheme
import qs.WaybarApp

// custom/updates: pending-update count from ml4w-check-system-updates,
// rendered as the yellow/red pill from the glass theme. Hidden while there is
// nothing to update (hide-empty-text).
Item {
    id: updates

    // Allows the window to drop the module on compact outputs.
    property bool show: true

    property int count: 0
    // The script tags the count "yellow" (normal) or "red" (many updates).
    property string klass: "yellow"

    readonly property bool red: klass.indexOf("red") !== -1

    visible: show && count > 0
    // CSS margin: 5px 0px 5px 5px around the pill.
    implicitWidth: pill.implicitWidth + 5
    implicitHeight: Waybar.moduleHeight

    Rectangle {
        id: pill
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        implicitWidth: label.implicitWidth + 12   // padding: 0 6px
        implicitHeight: 24
        radius: 8
        color: updates.red ? Theme.error : Theme.secondary

        Text {
            id: label
            anchors.centerIn: parent
            text: "  " + updates.count
            color: updates.red ? Theme.on_error : Theme.on_secondary
            font.family: Theme.fontFamily
            font.pixelSize: Waybar.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            let script = mouse.button === Qt.RightButton ? "installselectedupdates.sh" : "installupdates.sh";
            Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/settings/" + script]);
        }
    }

    function refresh(): void {
        checkProc.running = false;
        checkProc.running = true;
    }

    // The script prints {"text": "12", "class": "yellow", ...} or nothing.
    Process {
        id: checkProc
        command: ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-check-system-updates"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let raw = this.text.trim();
                    if (raw === "") {
                        updates.count = 0;
                        return;
                    }
                    let parsed = JSON.parse(raw);
                    updates.count = parseInt(parsed.text) || 0;
                    updates.klass = parsed.class !== undefined ? String(parsed.class) : "yellow";
                } catch (e) {
                    updates.count = 0;
                }
            }
        }
    }

    // Same 1800s interval as the waybar module.
    Timer {
        interval: 1800 * 1000
        running: true
        repeat: true
        onTriggered: updates.refresh()
    }

    // "qs ipc call statusbar reload" re-checks immediately (replaces the
    // SIGRTMIN+1 signal the install scripts send to waybar).
    Connections {
        target: Waybar
        function onUpdatesRefreshRequested(): void {
            updates.refresh();
        }
    }
}
