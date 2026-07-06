import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import qs.WaybarApp

// One ml4w-glass "island" — the .modules-left/center/right boxes from the
// waybar theme: 12px rounded corners, a 1px primary→on_primary gradient
// border, a translucent dark gradient fill (brighter towards the bottom, like
// the CSS radial-gradient anchored below the bar) and an inset top highlight
// standing in for the CSS `box-shadow: inset 1px 2px 2px rgba(255,255,255,.2)`.
//
// The island can "melt" downwards: when `expanded` is set, the whole shape
// stretches to make room for `expansionComponent` below the module row —
// border and fill stay one continuous rounded rectangle, so the dropdown is
// seamlessly connected to the bar.
Item {
    id: panel

    default property alias content: row.data

    // --- melting-glass expansion ---
    property bool expanded: false
    property Component expansionComponent: null

    readonly property real expansionHeight: expansionLoader.item !== null ? expansionLoader.item.implicitHeight : 0
    // Animated portion of the expansion currently visible.
    property real revealed: expanded ? expansionHeight : 0
    Behavior on revealed {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutQuint
        }
    }

    implicitWidth: row.implicitWidth
    implicitHeight: Waybar.moduleHeight + revealed
    // Slightly less translucent while expanded so the dropdown stays readable
    // over whatever is behind it.
    opacity: expanded ? 0.92 : 0.8
    Behavior on opacity {
        NumberAnimation {
            duration: 350
        }
    }

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
        anchors.top: parent.top
        height: Waybar.moduleHeight
        // waybar "spacing": 0 — modules bring their own 8px side margins.
        spacing: 0
    }

    // Dropdown content, revealed as the island stretches down.
    Item {
        anchors.top: parent.top
        anchors.topMargin: Waybar.moduleHeight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        anchors.bottomMargin: 1
        clip: true

        Loader {
            id: expansionLoader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            // Keep the content alive while the collapse animation runs.
            active: panel.expanded || panel.revealed > 0.5
            sourceComponent: panel.expansionComponent
        }
    }
}
