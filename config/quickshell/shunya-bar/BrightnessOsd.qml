import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    required property var themeData
    readonly property var palette:
        themeData[themeData.mode || "dark"] || {}
    property int percent: 0

    visible: hideTimer.running
    implicitWidth: 260
    implicitHeight: 70
    color: root.palette.background
    anchors.top: true
    margins.top: 52
    exclusionMode: ExclusionMode.Ignore
    mask: Region {}

    WlrLayershell.namespace: "shunya-brightness-osd"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    IpcHandler {
        target: "brightness"

        function show(value: int): void {
            root.percent = Math.max(0, Math.min(100, value));
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: "Brightness " + root.percent + "%"
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
                width: parent.width * root.percent / 100
                height: parent.height
                radius: 3
		color: root.palette.accent
            }
        }
    }
}
