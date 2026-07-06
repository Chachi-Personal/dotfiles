import Quickshell.Networking
import qs.CustomTheme
import qs.WaybarApp

// network: wifi " {signalStrength}%", ethernet "  {ifname}",
// otherwise "Disconnected ⚠" — straight from the native Networking service
// (NetworkManager backend). Left click opens the network dropdown panel.
ModuleLabel {
    id: net

    property bool show: true
    // True while this module's dropdown panel is open (set by WaybarWindow).
    property bool panelOpen: false
    // Emitted on left click; WaybarWindow toggles the dropdown.
    signal dropdownRequested

    // Prefer ethernet over wifi when both are up, like the waybar module.
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired && d.connected) || null
    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) || null
    readonly property var wifiNetwork: wifiDevice !== null ? (wifiDevice.networks.values.find(n => n.connected) || null) : null

    readonly property int signalPct: {
        if (wifiNetwork === null)
            return 0;
        let s = wifiNetwork.signalStrength;
        return Math.round(s <= 1.0 ? s * 100 : s);
    }

    visible: show
    text: wired !== null ? "  " + wired.name : wifiNetwork !== null ? "  " + signalPct + "%" : "Disconnected ⚠"
    textColor: panelOpen ? Theme.primary : Theme.on_surface

    onClicked: net.dropdownRequested()
}
