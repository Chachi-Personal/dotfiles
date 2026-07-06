import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs.WaybarApp

// One waybar-style bar for one monitor: three glass islands (left / center /
// right) on a transparent full-width strip, replicating the ml4w-glass waybar
// theme. Instantiated per screen from shell.qml, so every monitor gets its
// own bar; the outputs listed in Waybar.compactOutputs get the reduced module
// set from the second block of the waybar config.
//
// The audio / bluetooth / network modules open dropdown panels that melt out
// of the right island. The window is taller than the visible bar to give the
// dropdown room; the input mask below keeps everything outside the bar strip
// and the (expanded) right island click-through.
PanelWindow {
    id: root

    readonly property bool compact: screen !== null && Waybar.compactOutputs.indexOf(screen.name) !== -1

    // Which dropdown is open: "" | "audio" | "bluetooth" | "network".
    property string openPanel: ""

    function togglePanel(name: string): void {
        openPanel = openPanel === name ? "" : name;
    }

    // The full config used "layer: dock" so the bar stays below fullscreen
    // apps; the compact one used "top". While a dropdown is open the bar has
    // to sit above normal windows regardless.
    WlrLayershell.layer: (compact || openPanel !== "") ? WlrLayer.Top : WlrLayer.Bottom

    visible: Waybar.enabled
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    // Bar strip plus room for the dropdown; only the bar itself reserves
    // space (windows tile below Waybar.barHeight).
    implicitHeight: Waybar.barHeight + 440
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: Waybar.barHeight

    // Input only lands on the bar strip and the (possibly expanded) right
    // island; the rest of the oversized window is click-through.
    mask: Region {
        item: barStrip
        regions: [
            Region {
                item: rightPanel
            }
        ]
    }

    Item {
        id: barStrip
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Waybar.barHeight
    }

    // Grabs the keyboard while a dropdown is open (the network panel's
    // password field needs it) and closes the dropdown as soon as the user
    // interacts with another window.
    HyprlandFocusGrab {
        windows: [root]
        active: root.openPanel !== ""
        onCleared: root.openPanel = ""
    }

    // "qs ipc call statusbar panel audio|bluetooth|network" toggles a
    // dropdown on the focused monitor's bar.
    Connections {
        target: Waybar
        function onPanelRequested(name: string): void {
            let mon = Hyprland.focusedMonitor;
            if (mon !== null && root.screen !== null && mon.name === root.screen.name)
                root.togglePanel(name);
        }
    }

    Component {
        id: audioPanelComponent
        AudioPanel {}
    }
    Component {
        id: bluetoothPanelComponent
        BluetoothPanel {}
    }
    Component {
        id: networkPanelComponent
        NetworkPanel {}
    }

    // Swap the dropdown content only when a panel is open; on close the last
    // content stays alive so it can slide away with the collapse animation.
    onOpenPanelChanged: {
        if (openPanel === "audio")
            rightPanel.expansionComponent = audioPanelComponent;
        else if (openPanel === "bluetooth")
            rightPanel.expansionComponent = bluetoothPanelComponent;
        else if (openPanel === "network")
            rightPanel.expansionComponent = networkPanelComponent;
    }

    // --- LEFT: appmenu + workspaces ---
    GlassPanel {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        AppMenuModule {}
        WorkspacesModule {
            screenName: root.screen !== null ? root.screen.name : ""
        }
    }

    // --- CENTER: clock ---
    GlassPanel {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        ClockModule {}
    }

    // --- RIGHT: status modules ---
    GlassPanel {
        id: rightPanel
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        expanded: root.openPanel !== ""

        UpdatesModule {
            show: !root.compact
        }
        AudioModule {
            panelOpen: root.openPanel === "audio"
            onDropdownRequested: root.togglePanel("audio")
        }
        BluetoothModule {
            panelOpen: root.openPanel === "bluetooth"
            onDropdownRequested: root.togglePanel("bluetooth")
        }
        NetworkModule {
            show: !root.compact
            panelOpen: root.openPanel === "network"
            onDropdownRequested: root.togglePanel("network")
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
