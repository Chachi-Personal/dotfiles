import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.WaybarApp

// One waybar-style bar for one monitor: three glass islands (left / center /
// right) on a transparent full-width strip, replicating the ml4w-glass waybar
// theme. Instantiated per screen from shell.qml, so every monitor gets its
// own bar; the outputs listed in Waybar.compactOutputs get the reduced module
// set from the second block of the waybar config.
PanelWindow {
    id: root

    readonly property bool compact: screen !== null && Waybar.compactOutputs.indexOf(screen.name) !== -1

    // The full config used "layer: dock" so the bar stays below fullscreen
    // apps; the compact one used "top".
    WlrLayershell.layer: compact ? WlrLayer.Top : WlrLayer.Bottom

    visible: Waybar.enabled
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    // Island height plus the 10px CSS margin above and below it. The
    // exclusive zone follows the window size automatically.
    implicitHeight: Waybar.barHeight

    // --- LEFT: appmenu + workspaces ---
    GlassPanel {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        AppMenuModule {}
        WorkspacesModule {
            screenName: root.screen !== null ? root.screen.name : ""
        }
    }

    // --- CENTER: clock ---
    GlassPanel {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ClockModule {}
    }

    // --- RIGHT: status modules ---
    GlassPanel {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        UpdatesModule {
            show: !root.compact
        }
        AudioModule {}
        BluetoothModule {}
        NetworkModule {
            show: !root.compact
        }
        BatteryModule {}
        HardwareModule {
            show: !root.compact
        }
        ToolsModule {
            show: !root.compact
        }
        TrayModule {}
        NotificationModule {}
        ExitModule {
            show: !root.compact
        }
    }
}
