import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import qs.WaybarApp

// Network dropdown: wifi toggle, wired status and the wifi network list with
// click-to-connect (inline password prompt for new secured networks) — all
// through the native Networking service (NetworkManager backend).
Item {
    id: panel

    implicitHeight: col.implicitHeight + 26

    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) || null
    readonly property var wiredDevices: Networking.devices.values.filter(d => d.type === DeviceType.Wired)

    // Strongest networks first; capped so the dropdown always fits inside
    // the window strip reserved for it.
    readonly property var networks: {
        if (wifiDevice === null)
            return [];
        return [...wifiDevice.networks.values].filter(n => n.name !== "").sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength)).slice(0, 8);
    }

    // Network currently asking for a password (WifiNetwork or null).
    property var pskNetwork: null

    // Scan while the panel is open.
    Component.onCompleted: {
        if (wifiDevice !== null)
            wifiDevice.scannerEnabled = true;
    }
    Component.onDestruction: {
        if (wifiDevice !== null)
            wifiDevice.scannerEnabled = false;
    }

    function pct(s: real): int {
        return Math.round(s <= 1.0 ? s * 100 : s);
    }

    function activate(net: var): void {
        panel.pskNetwork = null;
        if (net.connected) {
            net.disconnect();
        } else if (net.known || net.security === WifiSecurityType.Open) {
            net.connect();
        } else {
            panel.pskNetwork = net;
        }
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
                text: "Network"
                color: Theme.on_surface
                font.family: Theme.fontFamily
                font.pixelSize: 13
                font.bold: true
                Layout.fillWidth: true
            }
            Text {
                text: "Wi-Fi"
                color: Theme.on_surface_variant
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
            PanelToggle {
                checked: Networking.wifiEnabled
                onToggled: on => Networking.wifiEnabled = on
            }
        }

        // Wired connections (display only).
        Repeater {
            model: panel.wiredDevices

            PanelRow {
                required property var modelData
                Layout.fillWidth: true
                highlighted: modelData.connected

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Text {
                        text: "\uf796"
                        color: Theme.on_surface
                        font.family: Waybar.iconFontFamily
                        font.pixelSize: 12
                    }
                    Text {
                        Layout.fillWidth: true
                        text: modelData.name
                        elide: Text.ElideRight
                        color: Theme.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                    }
                    Text {
                        text: modelData.connected ? "connected" : (modelData.hasLink ? "link" : "no link")
                        color: modelData.connected ? Theme.primary : Theme.on_surface_variant
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }
        }

        Repeater {
            model: panel.networks

            PanelRow {
                required property var modelData
                Layout.fillWidth: true
                highlighted: modelData.connected
                onClicked: panel.activate(modelData)

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Text {
                        text: "\uf1eb"
                        // Fade the wifi icon with the signal strength.
                        opacity: 0.4 + 0.6 * Math.min(1, panel.pct(modelData.signalStrength) / 100)
                        color: Theme.on_surface
                        font.family: Waybar.iconFontFamily
                        font.pixelSize: 12
                    }
                    Text {
                        Layout.fillWidth: true
                        text: modelData.name
                        elide: Text.ElideRight
                        color: Theme.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                    }
                    Text {
                        visible: modelData.security !== WifiSecurityType.Open
                        text: "\uf023"
                        color: Theme.on_surface_variant
                        font.family: Waybar.iconFontFamily
                        font.pixelSize: 11
                    }
                    Text {
                        text: modelData.stateChanging ? "…" : (modelData.connected ? "connected" : panel.pct(modelData.signalStrength) + "%")
                        color: modelData.connected ? Theme.primary : Theme.on_surface_variant
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }
        }

        // Inline password prompt for a new secured network.
        Rectangle {
            visible: panel.pskNetwork !== null
            Layout.fillWidth: true
            implicitHeight: 34
            radius: 8
            color: Qt.alpha(Theme.surface_container_high, 0.9)
            border.color: Qt.alpha(Theme.primary, 0.5)
            border.width: 1

            onVisibleChanged: {
                if (visible) {
                    pskInput.text = "";
                    pskInput.forceActiveFocus();
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                Text {
                    text: "\uf023"
                    color: Theme.primary
                    font.family: Waybar.iconFontFamily
                    font.pixelSize: 12
                }

                TextInput {
                    id: pskInput
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    color: Theme.on_surface
                    font.family: Theme.fontFamily
                    font.pixelSize: 13
                    clip: true
                    verticalAlignment: TextInput.AlignVCenter

                    Text {
                        visible: pskInput.text === ""
                        text: panel.pskNetwork !== null ? "Password for " + panel.pskNetwork.name : ""
                        color: Theme.on_surface_variant
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    onAccepted: {
                        if (panel.pskNetwork !== null)
                            panel.pskNetwork.connectWithPsk(text);
                        panel.pskNetwork = null;
                    }
                    Keys.onEscapePressed: panel.pskNetwork = null
                }

                Text {
                    text: "connect"
                    color: Theme.primary
                    font.family: Theme.fontFamily
                    font.pixelSize: 12
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pskInput.accepted()
                    }
                }
            }
        }

        Text {
            visible: panel.wifiDevice === null && panel.wiredDevices.length === 0
            text: "No network devices"
            color: Theme.on_surface_variant
            font.family: Theme.fontFamily
            font.pixelSize: 12
        }
    }
}
