import QtQuick
import qs.CustomTheme
import qs.WaybarApp

// waybar's `label.module`: 14px text with 8px margins either side, plus the
// usual left/right/middle click and scroll hooks.
Item {
    id: mod

    property alias text: label.text
    property alias textColor: label.color
    property alias fontPixelSize: label.font.pixelSize
    // Icon glyphs (Font Awesome PUA codepoints) resolve via fontconfig
    // fallback, exactly like they do for waybar's GTK labels.
    property string fontFamily: Theme.fontFamily
    property int padLeft: 8
    property int padRight: 8

    signal clicked
    signal rightClicked
    signal middleClicked
    signal scrolled(int dir)

    implicitWidth: label.implicitWidth + padLeft + padRight
    implicitHeight: Waybar.moduleHeight

    Text {
        id: label
        x: mod.padLeft
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.on_surface
        font.family: mod.fontFamily
        font.pixelSize: Waybar.fontSize
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                mod.clicked();
            else if (mouse.button === Qt.RightButton)
                mod.rightClicked();
            else
                mod.middleClicked();
        }
        onWheel: wheel => mod.scrolled(wheel.angleDelta.y > 0 ? 1 : -1)
    }
}
