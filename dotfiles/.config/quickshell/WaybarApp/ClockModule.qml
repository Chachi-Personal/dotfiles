import Quickshell
import qs.WaybarApp

// clock: "{:%H:%M - %a %Od}" → e.g. "14:23 - Sun 06".
ModuleLabel {
    // #clock { margin-left/right: 12px; }
    padLeft: 12
    padRight: 12

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "HH:mm - ddd dd")

    onClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/settings/calendar.sh"])
    onRightClicked: Quickshell.execDetached(["qs", "ipc", "call", "calendar", "toggle"])
}
