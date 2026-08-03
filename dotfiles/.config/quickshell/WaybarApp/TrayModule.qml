import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs.WaybarApp

// tray: StatusNotifierItem hosts, 21px icons with 10px spacing
// (#tray { padding: 0 5px 0 10px; }). Collapses away when empty.
Item {
    id: tray

    property bool show: true
    // -1 = uncapped (default). When set (e.g. on compact/vertical outputs),
    // caps the module's width and makes overflow icons reachable by
    // scrolling instead of letting the island grow past this width.
    property int maxWidth: -1

    readonly property int contentWidth: row.implicitWidth + 15

    visible: show && SystemTray.items.values.length > 0
    implicitWidth: maxWidth > 0 ? Math.min(contentWidth, maxWidth) : contentWidth
    implicitHeight: Waybar.moduleHeight

    Flickable {
        anchors.fill: parent
        contentWidth: tray.contentWidth
        contentHeight: height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick

        RowLayout {
            id: row
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Repeater {
                model: SystemTray.items

                delegate: MouseArea {
                    id: trayItem
                    required property var modelData

                    implicitWidth: 21
                    implicitHeight: 21
                    Layout.alignment: Qt.AlignVCenter
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    Image {
                        anchors.centerIn: parent
                        source: trayItem.modelData.icon
                        width: 21
                        height: 21
                        sourceSize.width: 21
                        sourceSize.height: 21
                        fillMode: Image.PreserveAspectFit
                    }

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton && !modelData.onlyMenu)
                            modelData.activate();
                        else if (modelData.hasMenu)
                            trayMenu.open();
                    }

                    QsMenuAnchor {
                        id: trayMenu
                        menu: trayItem.modelData.menu
                        anchor.item: trayItem
                        anchor.edges: Edges.Bottom
                        anchor.gravity: Edges.Bottom
                    }
                }
            }
        }
    }
}
