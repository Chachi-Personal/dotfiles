import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import qs.WaybarApp

// One ml4w-glass "island" — the .modules-left/center/right boxes from the
// waybar theme: 12px rounded corners, a 1px primary→on_primary gradient
// border, a translucent dark gradient fill (brighter towards the bottom, like
// the CSS radial-gradient anchored below the bar) and an inset top highlight
// standing in for the CSS `box-shadow: inset 1px 2px 2px rgba(255,255,255,.2)`.
Item {
    id: panel

    default property alias content: row.data

    implicitWidth: row.implicitWidth
    implicitHeight: Waybar.moduleHeight
    opacity: 0.8

    // Border layer: the fill is inset 1px so the gradient shows as a rim.
    Rectangle {
        anchors.fill: parent
        radius: 12
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {
                position: 0.0
                color: Theme.primary
            }
            GradientStop {
                position: 1.0
                color: Theme.on_primary
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 11
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0
                    color: Qt.alpha(Theme.surface_dim, 0.9)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.alpha(Qt.darker(Theme.surface, 1.4), 0.92)
                }
            }
        }

        // Inset highlight along the top edge.
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 11
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(1, 1, 1, 0.16)
                }
                GradientStop {
                    position: 0.18
                    color: "transparent"
                }
                GradientStop {
                    position: 1.0
                    color: "transparent"
                }
            }
        }
    }

    RowLayout {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        // waybar "spacing": 0 — modules bring their own 8px side margins.
        spacing: 0
    }
}
