import Quickshell
import Quickshell.Io
import QtQuick
import qs.CustomTheme

Item {
    property string nowPlaying: ""
    visible: nowPlaying !== ""

    Process {
        id: proc
        command: ["/bin/sh", "-c",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-now-playing"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var j = JSON.parse(this.text.trim())
                    nowPlaying = j.text ?? ""
                } catch(e) { nowPlaying = "" }
            }
        }
    }

    Timer { interval: 1000; running: true; repeat: true; onTriggered: proc.running = true }

    Text {
        text: "  " + nowPlaying
        color: Theme.secondary
        font.family: Theme.fontFamily
        font.pixelSize: 12
        maximumLineCount: 1
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: (e) => {
            if (e.button === Qt.LeftButton)
                proc.command = ["playerctl", "play-pause"]
            else if (e.button === Qt.RightButton)
                proc.command = ["playerctl", "next"]
            else
                proc.command = ["playerctl", "previous"]
            proc.running = true
        }
    }
}
