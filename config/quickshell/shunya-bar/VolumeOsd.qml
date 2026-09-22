import QtQuick

OsdWindow {
    id: root

    required property var audio

    Connections {
        target: root.audio

        function onVolumeChanged() {
            root.showOsd()
        }

        function onMutedChanged() {
            root.showOsd()
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: !root.audio
                ? "Volume unavailable"
                : root.audio.muted
                    ? "Muted"
                    : "Volume "
                        + Math.round(root.audio.volume * 100)
                        + "%"

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
                        ? Math.max(
                            0,
                            Math.min(1, root.audio.volume)
                        )
                        : 0
                )

                height: parent.height
                radius: 3
                color: root.palette.accent
            }
        }
    }
}
