import QtQuick
import Quickshell.Services.Pipewire

Text {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null

    text: !audio ? "VOL --"
        : audio.muted ? "VOL muted"
        : "VOL " + Math.round(audio.volume * 100) + "%"

    color: "#edf1f7"
    font.family: "Source Code Pro"
    font.pixelSize: 13
    height: 36
    verticalAlignment: Text.AlignVCenter

    PwObjectTracker {
        objects: [root.sink]
    }

    MouseArea {
        VolumeOsd {
            audio: root.audio
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
