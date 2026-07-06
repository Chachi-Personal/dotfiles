import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme
import qs.WaybarApp

// Audio dropdown: output volume/mute, output device picker and input
// volume/mute — everything through the native Pipewire service.
Item {
    id: panel

    implicitHeight: col.implicitHeight + 26

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink !== null && sink.ready && sink.audio !== null
    readonly property bool sourceReady: source !== null && source.ready && source.audio !== null

    // Every physical audio output (not application streams).
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio !== null)

    PwObjectTracker {
        objects: [panel.sink, panel.source].filter(n => n !== null)
    }

    function nodeLabel(n: PwNode): string {
        return n.description !== "" ? n.description : (n.nickname !== "" ? n.nickname : n.name);
    }

    ColumnLayout {
        id: col
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        spacing: 6

        Text {
            text: "OUTPUT"
            color: Theme.on_surface_variant
            font.family: Theme.fontFamily
            font.pixelSize: 11
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: panel.sinkReady && panel.sink.audio.muted ? "" : ""
                color: panel.sinkReady && panel.sink.audio.muted ? Theme.error : Theme.on_surface
                font.family: Waybar.iconFontFamily
                font.pixelSize: 14
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (panel.sinkReady)
                            panel.sink.audio.muted = !panel.sink.audio.muted;
                    }
                }
            }

            PanelSlider {
                Layout.fillWidth: true
                value: panel.sinkReady ? panel.sink.audio.volume : 0
                onMoved: v => {
                    if (panel.sinkReady) {
                        panel.sink.audio.muted = false;
                        panel.sink.audio.volume = v;
                    }
                }
            }

            Text {
                text: (panel.sinkReady ? Math.round(panel.sink.audio.volume * 100) : 0) + "%"
                color: Theme.on_surface
                font.family: Theme.fontFamily
                font.pixelSize: 13
                Layout.preferredWidth: 38
                horizontalAlignment: Text.AlignRight
            }
        }

        Repeater {
            model: panel.sinks

            PanelRow {
                required property var modelData
                Layout.fillWidth: true
                highlighted: modelData === Pipewire.defaultAudioSink
                onClicked: Pipewire.preferredDefaultAudioSink = modelData

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        text: panel.nodeLabel(modelData)
                        elide: Text.ElideRight
                        color: Theme.on_surface
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                    }
                    Text {
                        visible: modelData === Pipewire.defaultAudioSink
                        text: ""
                        color: Theme.primary
                        font.family: Waybar.iconFontFamily
                        font.pixelSize: 12
                    }
                }
            }
        }

        Text {
            Layout.topMargin: 6
            text: "INPUT"
            color: Theme.on_surface_variant
            font.family: Theme.fontFamily
            font.pixelSize: 11
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: ""
                color: panel.sourceReady && panel.source.audio.muted ? Theme.error : Theme.on_surface
                font.family: Waybar.iconFontFamily
                font.pixelSize: 14
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (panel.sourceReady)
                            panel.source.audio.muted = !panel.source.audio.muted;
                    }
                }
            }

            PanelSlider {
                Layout.fillWidth: true
                value: panel.sourceReady ? panel.source.audio.volume : 0
                onMoved: v => {
                    if (panel.sourceReady) {
                        panel.source.audio.muted = false;
                        panel.source.audio.volume = v;
                    }
                }
            }

            Text {
                text: (panel.sourceReady ? Math.round(panel.source.audio.volume * 100) : 0) + "%"
                color: Theme.on_surface
                font.family: Theme.fontFamily
                font.pixelSize: 13
                Layout.preferredWidth: 38
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
