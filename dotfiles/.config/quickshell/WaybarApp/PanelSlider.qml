import QtQuick
import qs.CustomTheme

// Minimal slider (0.0–1.0) for the dropdown panels.
Item {
    id: slider

    property real value: 0
    signal moved(real newValue)

    implicitHeight: 22

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 4
        radius: 2
        color: Qt.rgba(1, 1, 1, 0.15)
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: Math.max(0, Math.min(1, slider.value)) * track.width
        height: 4
        radius: 2
        color: Theme.primary
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: Math.max(0, Math.min(1, slider.value)) * (parent.width - width)
        width: 12
        height: 12
        radius: 6
        color: Theme.primary
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        function report(mx: real): void {
            slider.moved(Math.max(0, Math.min(1, mx / width)));
        }

        onPressed: mouse => report(mouse.x)
        onPositionChanged: mouse => {
            if (pressed)
                report(mouse.x);
        }
        onWheel: wheel => slider.moved(Math.max(0, Math.min(1, slider.value + (wheel.angleDelta.y > 0 ? 0.02 : -0.02))))
    }
}
