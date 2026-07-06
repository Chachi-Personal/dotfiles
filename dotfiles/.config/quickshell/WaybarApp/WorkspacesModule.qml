import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import qs.WaybarApp

// hyprland/workspaces, per output (all-outputs: false). Buttons follow the
// glass theme: the active workspace gets a wider 8px-radius pill filled with
// alpha(primary, .2) and an inset white highlight; hover shows
// alpha(secondary, .2); urgent blinks red.
Item {
    id: wsRoot

    // Name of the output this bar sits on; only its workspaces are shown.
    property string screenName: ""

    implicitWidth: row.implicitWidth + 6   // #workspaces horizontal padding 3px
    implicitHeight: Waybar.moduleHeight

    // on-scroll-up/down: hyprctl dispatch workspace r±1 (anywhere on the module)
    WheelHandler {
        target: wsRoot
        onWheel: event => Hyprland.dispatch("workspace " + (event.angleDelta.y > 0 ? "r+1" : "r-1"))
    }

    RowLayout {
        id: row
        x: 3
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            model: Hyprland.workspaces

            Rectangle {
                id: ws
                required property var modelData

                readonly property bool onThisScreen: modelData.monitor !== null && modelData.monitor.name === wsRoot.screenName
                readonly property bool isActive: modelData.active
                readonly property bool isUrgent: modelData.urgent

                visible: onThisScreen

                // Urgent buttons alternate red/background at 500ms like the
                // CSS blink animation.
                property bool blinkOn: true
                Timer {
                    running: ws.isUrgent
                    repeat: true
                    interval: 500
                    onTriggered: ws.blinkOn = !ws.blinkOn
                }

                Layout.leftMargin: 2
                Layout.rightMargin: 2
                implicitHeight: 24
                implicitWidth: Math.max(txt.implicitWidth + 12, isActive ? 30 : 0)

                radius: isActive ? 8 : (wsMouse.containsMouse ? 12 : 3)
                color: isUrgent ? (blinkOn ? "#f53c3c" : Theme.background) : isActive ? Qt.alpha(Theme.primary, 0.2) : wsMouse.containsMouse ? Qt.alpha(Theme.secondary, 0.2) : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on radius {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }

                // Inset top highlight of the active pill (the CSS inset
                // white box-shadows).
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    opacity: ws.isActive ? 1 : 0
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop {
                            position: 0.0
                            color: Qt.rgba(1, 1, 1, 0.45)
                        }
                        GradientStop {
                            position: 0.25
                            color: "transparent"
                        }
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 300
                        }
                    }
                }

                Text {
                    id: txt
                    anchors.centerIn: parent
                    text: ws.modelData.name !== "" ? ws.modelData.name : ws.modelData.id
                    color: Theme.on_surface
                    font.family: Theme.fontFamily
                    font.pixelSize: Waybar.fontSize
                }

                MouseArea {
                    id: wsMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ws.modelData.activate()
                }
            }
        }
    }
}
