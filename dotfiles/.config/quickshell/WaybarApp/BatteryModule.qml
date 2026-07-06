import Quickshell.Services.UPower
import QtQuick
import qs.CustomTheme
import qs.WaybarApp

// battery: "{icon} {capacity}%" with the charging / plugged glyphs from the
// waybar config. Below 30% on discharge the label gets the theme's error
// background (the CSS .warning/.critical rules).
Item {
    id: battery

    property bool show: true

    readonly property var device: UPower.displayDevice
    readonly property bool present: device !== null && device.isLaptopBattery

    // UPowerDevice.percentage is a 0–1 fraction; tolerate either scale.
    readonly property int capacity: {
        if (!present)
            return 0;
        let p = device.percentage;
        return Math.round(p <= 1.0 ? p * 100 : p);
    }

    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool plugged: present && (device.state === UPowerDeviceState.PendingCharge || device.state === UPowerDeviceState.FullyCharged)

    readonly property var icons: ["", "", "", "", ""]
    readonly property string icon: charging ? "" : plugged ? "" : icons[Math.min(4, Math.floor(capacity / 20))]

    readonly property bool alert: !charging && !plugged && capacity <= 30

    visible: show && present
    implicitWidth: content.implicitWidth + 16
    implicitHeight: Waybar.moduleHeight

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: content.implicitWidth + 12
        implicitHeight: 24
        radius: 8
        color: battery.alert ? Theme.error : "transparent"
        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 5

        // The battery/charging glyphs only exist in the Solid style, which
        // Qt's fontconfig fallback does not reach from Fira Sans — so the
        // icon gets its family set explicitly.
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: battery.icon
            color: battery.alert ? Theme.on_error : Theme.on_surface
            font.family: "Font Awesome 7 Free Solid"
            font.pixelSize: Waybar.fontSize
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: battery.capacity + "%"
            color: battery.alert ? Theme.on_error : Theme.on_surface
            font.family: Theme.fontFamily
            font.pixelSize: Waybar.fontSize
        }
    }
}
