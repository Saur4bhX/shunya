import QtQuick
import Quickshell.Io

OsdWindow {
    id: root

    property int percent: 0

    IpcHandler {
        target: "brightness"

        function show(value: int): void {
            root.percent = Math.max(
                0,
                Math.min(100, value)
            )

            root.showOsd()
        }
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
