import Quickshell
import Quickshell.Io
import "WelcomeApp"
import "PowerApp"
import "SidebarApp"
import "CalendarApp"
import "WallpaperApp"
import "WaybarApp"
import "CustomTheme"

ShellRoot {
    // Test IPC tools: qs ipc show

    IpcHandler {
        target: "theme-manager"
        function reload(): void {
            Theme.reloadTheme();
        }
    }

    WelcomeWindow {}
    PowerWindow {}
    SidebarWindow {}
    CalendarWindow {}
    WallpaperWindow {}

    // One status bar per connected monitor. Variants creates an instance of the
    // delegate for every entry in the model and injects it as `modelData`; here
    // the model is the live list of screens, so plugging/unplugging a monitor
    // adds or removes its bar automatically.
    Variants {
        model: Quickshell.screens
        WaybarWindow {
            required property var modelData
            screen: modelData
        }
    }
}
