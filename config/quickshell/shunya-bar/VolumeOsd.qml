import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    required property var audio

    required property var themeData
    readonly property var palette: themeData[themeData.mode || "dark"] || {}
    visible: hideTimer.running
    implicitWidth: 260
    implicitHeight: 70
    color: root.palette.background

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
            color: root.palette.text
            font.family: root.themeData.fontFamily
            font.pointSize: root.themeData.fontSize
        }

        Rectangle {
            width: 220
            height: 6
            radius: 3
            color: root.palette.border

            Rectangle {
                width: parent.width * (
                    root.audio && !root.audio.muted
                    ? Math.max(0, Math.min(1, root.audio.volume)) : 0
                )
                height: parent.height
                radius: 3
                color: root.palette.text
            }
        }
    }
}
