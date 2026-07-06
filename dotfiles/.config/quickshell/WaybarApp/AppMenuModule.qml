import Quickshell
import qs.WaybarApp

// custom/appmenu: the "Apps" launcher label.
ModuleLabel {
    text: "Apps"
    // #custom-appmenu { padding-left: 5px; padding-right: 3px; } on top of the
    // 8px label.module margins.
    padLeft: 13
    padRight: 11

    onClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/launcher.sh"])
    onRightClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/keybindings.sh"])
}
