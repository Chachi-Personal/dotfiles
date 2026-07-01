import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme

RowLayout {
    spacing: 4

    // The drawer icon (mirrors custom/system)
    Text {
        text: ""
        font.pixelSize: 14
        color: Theme.on_surface_variant
    }

    Text {
        id: cpuText
        color: Theme.on_surface_variant
        font.pixelSize: 12
        text: "C " + CpuService.usage + "%"
    }

    Text {
        id: memText
        color: Theme.on_surface_variant
        font.pixelSize: 12
        text: "M " + MemService.used + "%"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Qt.openUrlExternally("~/.config/ml4w/settings/system-monitor.sh")
    }
}
