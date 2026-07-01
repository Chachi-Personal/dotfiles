import Quickshell
import QtQuick
import qs.CustomTheme

Text {
    id: clock
    color: Theme.on_surface
    font.family: Theme.fontFamily
    font.pixelSize: 13

    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(sysClock.date, "HH:mm - ddd dd")

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: (event) => {
            if (event.button === Qt.RightButton)
                Quickshell.ipc.call("calendar", "toggle")
        }
    }
}
