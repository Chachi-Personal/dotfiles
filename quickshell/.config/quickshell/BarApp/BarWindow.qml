// BarApp/BarWindow.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import "widgets"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            required property var modelData
            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 32
            color: Theme.background

            WlrLayershell.exclusionZone: 32

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 6

                // --- LEFT ---
                WorkspacesWidget {}
                WindowTitleWidget {}

                Item { Layout.fillWidth: true }

                // --- CENTER ---
                NowPlayingWidget {}

                Item { Layout.fillWidth: true }

                // --- RIGHT ---
                UpdatesWidget {}
                NotificationWidget {}
                NetworkWidget {}
                AudioWidget {}
                SystemWidget {}
                ClockWidget {}

                // Power button (mirrors custom/exit)
                Text {
                    text: ""
                    font.pixelSize: 16
                    color: Theme.primary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.ipc.call("power", "toggle")
                    }
                }
            }
        }
    }
}
