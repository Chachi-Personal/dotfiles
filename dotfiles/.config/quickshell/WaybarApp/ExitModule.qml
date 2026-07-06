import Quickshell
import qs.WaybarApp

// custom/exit: opens the quickshell power menu.
ModuleLabel {
    property bool show: true
    visible: show
    text: ""
    fontFamily: Waybar.iconFontFamily
    onClicked: Quickshell.execDetached(["qs", "ipc", "call", "power", "toggle"])
}
