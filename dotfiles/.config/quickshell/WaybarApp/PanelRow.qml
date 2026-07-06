import QtQuick
import qs.CustomTheme

// Hoverable list row for the dropdown panels: quiet by default,
// alpha(secondary) on hover, alpha(primary) when highlighted (active item).
Rectangle {
    id: row

    property bool highlighted: false
    default property alias content: inner.data

    signal clicked
    signal rightClicked

    implicitHeight: 34
    radius: 8
    color: highlighted ? Qt.alpha(Theme.primary, 0.2) : mouse.containsMouse ? Qt.alpha(Theme.secondary, 0.2) : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    Item {
        id: inner
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: m => m.button === Qt.RightButton ? row.rightClicked() : row.clicked()
    }
}
