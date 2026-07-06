import Quickshell
import Quickshell.Io
import QtQuick
import qs.WaybarApp

// group/hardware: a drawer with the system icon that expands to
// disk / cpu / memory readouts. Clicking any of them opens the ML4W system
// monitor, like the waybar on-click handlers.
DrawerGroup {
    id: hw

    icon: ""
    onIconClicked: hw.openMonitor()

    property int diskPct: 0
    property int cpuPct: 0
    property int memPct: 0

    function openMonitor(): void {
        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/settings/system-monitor.sh"]);
    }

    ModuleLabel {
        text: "D " + hw.diskPct + "%"
        onClicked: hw.openMonitor()
    }
    ModuleLabel {
        text: "/ C " + hw.cpuPct + "%"
        onClicked: hw.openMonitor()
    }
    ModuleLabel {
        text: "/ M " + hw.memPct + "%"
        onClicked: hw.openMonitor()
    }

    // --- disk (30s, like the waybar module) ---
    Process {
        id: diskProc
        command: ["bash", "-c", "df --output=pcent / | tail -1 | tr -dc 0-9"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: hw.diskPct = parseInt(this.text) || 0
        }
    }
    Timer {
        interval: 30 * 1000
        running: true
        repeat: true
        onTriggered: {
            diskProc.running = false;
            diskProc.running = true;
        }
    }

    // --- memory ((total - available) / total) ---
    Process {
        id: memProc
        command: ["awk", "/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%d\", (t-a)/t*100}", "/proc/meminfo"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: hw.memPct = parseInt(this.text) || 0
        }
    }

    // --- cpu (usage from consecutive /proc/stat samples) ---
    property real cpuPrevTotal: 0
    property real cpuPrevIdle: 0

    Process {
        id: cpuProc
        command: ["head", "-1", "/proc/stat"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let f = this.text.trim().split(/\s+/).slice(1).map(Number);
                let total = f.reduce((a, b) => a + b, 0);
                let idle = f[3] + (f[4] || 0);
                let dTotal = total - hw.cpuPrevTotal;
                let dIdle = idle - hw.cpuPrevIdle;
                if (hw.cpuPrevTotal > 0 && dTotal > 0)
                    hw.cpuPct = Math.round(100 * (1 - dIdle / dTotal));
                hw.cpuPrevTotal = total;
                hw.cpuPrevIdle = idle;
            }
        }
    }

    Timer {
        interval: 5 * 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = false;
            cpuProc.running = true;
            memProc.running = false;
            memProc.running = true;
        }
    }
}
