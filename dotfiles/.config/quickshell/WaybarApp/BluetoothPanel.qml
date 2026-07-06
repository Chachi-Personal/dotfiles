import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import qs.WaybarApp

// Bluetooth dropdown: adapter power toggle, discovery, and the known-device
// list with click-to-(dis)connect — all through the native Bluetooth service.
Item {
    id: panel

    implicitHeight: col.implicitHeight + 26

    readonly property var adapter: Bluetooth.defaultAdapter

    // Known devices, plus everything discovered while scanning; connected
    // first, then by name.
    readonly property var devices: {
        let discovering = adapter !== null && adapter.discovering;
        return Bluetooth.devices.values.filter(d => d.paired || d.bonded || d.connected || (discovering && (d.deviceName !== "" || d.name !== ""))).sort((a, b) => (b.connected - a.connected) || (a.deviceName || a.name).localeCompare(b.deviceName || b.name));
    }

    function stateText(d: var): string {
        if (d.state === BluetoothDeviceState.Connecting)
            return "connecting…";
        if (d.state === BluetoothDeviceState.Disconnecting)
            return "disconnecting…";
        return d.connected ? "connected" : "";
    }

    ColumnLayout {
        id: col
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "Bluetooth"
                color: Theme.on_surface
                font.family: Theme.fontFamily
                font.pixelSize: 13
                font.bold: true
                Layout.fillWidth: true
            }

            // Discovery toggle (spins up a scan while the panel is open).
            Text {
                visible: panel.adapter !== null && panel.adapter.enabled
                text: ""
                color: panel.adapter !== null && panel.adapter.discovering ? Theme.primary : Theme.on_surface_variant
                font.family: Waybar.iconFontFamily
                font.pixelSize: 13
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (panel.adapter !== null)
                            panel.adapter.discovering = !panel.adapter.discovering;
                    }
                }
            }

            PanelToggle {
                checked: panel.adapter !== null && panel.adapter.enabled
                onToggled: on => {
                    if (panel.adapter !== null)
                        panel.adapter.enabled = on;
                }
            }
        }

        Repeater {
            model: panel.devices

            PanelRow {
                required property var modelData
                Layout.fillWidth: true
                highlighted: modelData.connected
                onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        text: modelData.deviceName !== "" ? modelData.deviceName : modelData.name
                        elide: Text.ElideRight
                        color: Theme.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                    }
                    Text {
                        visible: modelData.batteryAvailable
                        text: " " + Math.round(modelData.battery * 100) + "%"
                        color: Theme.on_surface_variant
                        font.family: Waybar.iconFontFamily
                        font.pixelSize: 12
                    }
                    Text {
                        visible: text !== ""
                        text: panel.stateText(modelData)
                        color: modelData.connected ? Theme.primary : Theme.on_surface_variant
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }
        }

        Text {
            visible: panel.devices.length === 0
            text: panel.adapter === null ? "No bluetooth adapter" : panel.adapter.enabled ? "No known devices" : "Bluetooth is off"
            color: Theme.on_surface_variant
            font.family: Theme.fontFamily
            font.pixelSize: 12
        }
    }
}
