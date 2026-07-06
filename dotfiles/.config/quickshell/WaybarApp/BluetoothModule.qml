import Quickshell.Bluetooth
import qs.CustomTheme
import qs.WaybarApp

// bluetooth: " {status}" where status is off / on / connected, straight
// from the native Bluetooth service. Hidden when there is no adapter
// (format-no-controller: ""). Left click opens the bluetooth dropdown panel.
ModuleLabel {
    id: bt

    property bool show: true
    // True while this module's dropdown panel is open (set by WaybarWindow).
    property bool panelOpen: false
    // Emitted on left click; WaybarWindow toggles the dropdown.
    signal dropdownRequested

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property int connections: Bluetooth.devices.values.filter(d => d.connected).length
    readonly property string status: adapter === null || !adapter.enabled ? "off" : connections > 0 ? "connected" : "on"

    visible: show && adapter !== null
    text: " " + status
    textColor: panelOpen ? Theme.primary : Theme.on_surface

    onClicked: bt.dropdownRequested()
}
