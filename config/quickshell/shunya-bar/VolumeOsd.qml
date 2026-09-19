import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    required property var audio

    visible: hideTimer.running
    implicitWidth: 260
    implicitHeight: 70
    color: "#171a20"

    anchors.top: true
    margins.top: 52
    exclusionMode: ExclusionMode.Ignore
    mask: Region {}

    WlrLayershell.namespace: "shunya-volume-osd"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    Connections {
        target: root.audio

        function onVolumeChanged() { hideTimer.restart(); }
        function onMutedChanged() { hideTimer.restart(); }
    }

    Timer {
        id: hideTimer
        interval: 1500
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: !root.audio ? "Volume unavailable"
                : root.audio.muted ? "Muted"
                : "Volume " + Math.round(root.audio.volume * 100) + "%"
            color: "#edf1f7"
            font.family: "Source Code Pro"
            font.pixelSize: 14
        }

        Rectangle {
            width: 220
            height: 6
            radius: 3
            color: "#34435b"

            Rectangle {
                width: parent.width * (
                    root.audio && !root.audio.muted
                    ? Math.max(0, Math.min(1, root.audio.volume)) : 0
                )
                height: parent.height
                radius: 3
                color: "#edf1f7"
            }
        }
    }
}
