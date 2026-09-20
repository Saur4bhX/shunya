import QtQuick
import Quickshell.Services.Pipewire

Text {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null

    required property var themeData
    readonly property var palette: themeData[themeData.mode || "dark"] || {}

    text: !audio ? "VOL --"
        : audio.muted ? "VOL muted"
        : "VOL " + Math.round(audio.volume * 100) + "%"

    color: root.palette.text
    font.family: root.themeData.fontFamily
    font.pointSize: root.themeData.fontSize
    height: 36
    verticalAlignment: Text.AlignVCenter

    PwObjectTracker {
        objects: [root.sink]
    }

    MouseArea {
        VolumeOsd {
            audio: root.audio
	    themeData: root.themeData
    }
        anchors.fill: parent
        enabled: root.audio !== null

        onClicked: root.audio.muted = !root.audio.muted

        onWheel: event => {
            if (event.angleDelta.y === 0)
                return;

            const step = event.angleDelta.y > 0 ? 0.05 : -0.05;
            root.audio.volume = Math.max(
                0, Math.min(1, root.audio.volume + step)
            );
            event.accepted = true;
        }
    }
}
