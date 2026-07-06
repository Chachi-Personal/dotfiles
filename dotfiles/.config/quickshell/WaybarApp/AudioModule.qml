import Quickshell.Services.Pipewire
import QtQuick
import qs.CustomTheme
import qs.WaybarApp

// pulseaudio: "{icon}  {volume}% {format_source}" — default sink volume plus
// the mic volume while the default source is unmuted. Left click opens the
// audio dropdown panel, right click toggles mute, the wheel steps ±2%.
Item {
    id: audio

    // True while this module's dropdown panel is open (set by WaybarWindow).
    property bool panelOpen: false
    // Emitted on left click; WaybarWindow toggles the dropdown.
    signal dropdownRequested

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink !== null && sink.ready && sink.audio !== null
    readonly property bool sourceReady: source !== null && source.ready && source.audio !== null

    readonly property int volume: sinkReady ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool muted: sinkReady ? sink.audio.muted : false
    readonly property bool micLive: sourceReady && !source.audio.muted
    readonly property int micVolume: sourceReady ? Math.round(source.audio.volume * 100) : 0

    // default icons ["","",""] by volume third; ""
    // when muted.
    readonly property string icon: muted ? "" : volume < 34 ? "" : ""

    readonly property color fg: panelOpen ? Theme.primary : Theme.on_surface

    PwObjectTracker {
        objects: [audio.sink, audio.source].filter(n => n !== null)
    }

    implicitWidth: row.implicitWidth + 16
    implicitHeight: Waybar.moduleHeight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: audio.icon
            color: audio.fg
            font.family: Waybar.iconFontFamily
            font.pixelSize: Waybar.fontSize
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: !audio.muted
            text: audio.volume + "%"
            color: audio.fg
            font.family: Theme.fontFamily
            font.pixelSize: Waybar.fontSize
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: audio.micLive
            text: audio.micVolume + "%"
            color: audio.fg
            font.family: Theme.fontFamily
            font.pixelSize: Waybar.fontSize
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: audio.micLive
            text: ""
            color: audio.fg
            font.family: Waybar.iconFontFamily
            font.pixelSize: Waybar.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                if (audio.sinkReady)
                    audio.sink.audio.muted = !audio.sink.audio.muted;
            } else {
                audio.dropdownRequested();
            }
        }
        onWheel: wheel => {
            if (!audio.sinkReady)
                return;
            let dir = wheel.angleDelta.y > 0 ? 1 : -1;
            audio.sink.audio.muted = false;
            audio.sink.audio.volume = Math.max(0, Math.min(1, audio.sink.audio.volume + dir * 0.02));
        }
    }
}
