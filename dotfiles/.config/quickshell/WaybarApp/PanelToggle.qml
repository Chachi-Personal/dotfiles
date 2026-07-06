import QtQuick
import qs.CustomTheme

// Small on/off switch for the dropdown panels.
Item {
    id: toggle

    property bool checked: false
    signal toggled(bool on)

    implicitWidth: 40
    implicitHeight: 22

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: toggle.checked ? Theme.primary : Qt.rgba(1, 1, 1, 0.15)

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }

        Rectangle {
            width: 18
            height: 18
            radius: 9
            y: 2
            x: toggle.checked ? parent.width - width - 2 : 2
            color: toggle.checked ? Theme.on_primary : Theme.on_surface

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuint
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: toggle.toggled(!toggle.checked)
    }
}
