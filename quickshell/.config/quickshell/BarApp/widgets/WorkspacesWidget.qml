import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme

RowLayout {
    spacing: 4

    Repeater {
        model: Hyprland.workspaces.values

        Rectangle {
            property bool active: Hyprland.focusedWorkspace?.id === modelData.id
            width: 20; height: 20; radius: 4
            color: active ? Theme.primary : Theme.surface_container_high

            Text {
                anchors.centerIn: parent
                text: modelData.id
                font.pixelSize: 11
                color: active ? Theme.on_primary : Theme.on_surface_variant
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
                // scroll support:
                onWheel: (event) => {
                    if (event.angleDelta.y > 0)
                        Hyprland.dispatch("workspace r+1")
                    else
                        Hyprland.dispatch("workspace r-1")
                }
            }
        }
    }
}
