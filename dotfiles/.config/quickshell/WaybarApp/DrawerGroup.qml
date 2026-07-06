import QtQuick
import QtQuick.Layouts
import qs.WaybarApp

// A waybar drawer group: only the first module (the icon) is visible until
// the pointer hovers the group, then the remaining modules slide out
// (transition-duration: 300).
Item {
    id: group

    property bool show: true
    property string icon: ""
    default property alias drawerContent: drawerRow.data

    signal iconClicked

    readonly property bool expanded: hover.hovered

    visible: show
    implicitWidth: layout.implicitWidth
    implicitHeight: Waybar.moduleHeight

    HoverHandler {
        id: hover
    }

    RowLayout {
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        ModuleLabel {
            text: group.icon
            fontFamily: Waybar.iconFontFamily
            onClicked: group.iconClicked()
        }

        Item {
            id: drawer
            clip: true
            implicitHeight: Waybar.moduleHeight
            implicitWidth: group.expanded ? drawerRow.implicitWidth : 0

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            RowLayout {
                id: drawerRow
                x: 0
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0
            }
        }
    }
}
