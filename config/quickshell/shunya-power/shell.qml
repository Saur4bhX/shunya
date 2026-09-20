import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root

    readonly property var themeData: {
        try {
            return JSON.parse(themeFile.text());
        } catch (error) {
            return {};
        }
    }

    readonly property var palette:
        themeData[themeData.mode || "dark"] || {}

    FileView {
        id: themeFile
        path: Quickshell.env("HOME") + "/.config/shunya/theme.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    PanelWindow {
        id: window

        property var pendingCommand: []
        property string pendingLabel: ""
        readonly property bool confirming: pendingCommand.length > 0

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "#00000099"
        exclusionMode: ExclusionMode.Ignore
        focusable: true

        WlrLayershell.namespace: "shunya-power"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        function run(command) {
            Quickshell.execDetached(command);
            Qt.quit();
        }

        function selectAction(action) {
            if (action.confirm) {
                pendingCommand = action.command;
                pendingLabel = action.label;
            } else {
                run(action.command);
            }
        }

        Item {
            anchors.fill: parent
            focus: true
            Component.onCompleted: forceActiveFocus()

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    if (window.confirming) {
                        window.pendingCommand = [];
                        window.pendingLabel = "";
                    } else {
                        Qt.quit();
                    }

                    event.accepted = true;
                } else if (event.key === Qt.Key_Q) {
                    Qt.quit();
                    event.accepted = true;
                } else if (
                    event.key === Qt.Key_Return
                    && window.confirming
                ) {
                    window.run(window.pendingCommand);
                    event.accepted = true;
                }
            }
        }

        Row {
            visible: !window.confirming
            anchors.centerIn: parent
            spacing: 12

            Repeater {
                model: [
                    {
                        label: "Lock",
                        command: ["loginctl", "lock-session"],
                        confirm: false
                    },
                    {
                        label: "Logout",
                        command: [
                            "hyprctl",
                            "dispatch",
                            "hl.dsp.exit()"
                        ],
                        confirm: true
                    },
                    {
                        label: "Suspend",
                        command: ["systemctl", "suspend"],
                        confirm: false
                    },
                    {
                        label: "Reboot",
                        command: ["systemctl", "reboot"],
                        confirm: true
                    },
                    {
                        label: "Power off",
                        command: ["systemctl", "poweroff"],
                        confirm: true
                    }
                ]

                delegate: Rectangle {
                    id: actionButton
                    required property var modelData

                    width: 110
                    height: 56
                    radius: 6
                    color: root.palette.surface
                    border.color: root.palette.accent

                    Text {
                        anchors.centerIn: parent
                        text: actionButton.modelData.label
                        color: root.palette.text
                        font.family: root.themeData.fontFamily
                        font.pointSize: root.themeData.fontSize
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.selectAction(
                            actionButton.modelData
                        )
                    }
                }
            }
        }

        Rectangle {
            visible: window.confirming
            anchors.centerIn: parent
            width: 360
            height: 130
            radius: 8
            color: root.palette.surface
            border.color: root.palette.accent

            Column {
                anchors.centerIn: parent
                spacing: 16

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Confirm " + window.pendingLabel + "?"
                    color: root.palette.text
                    font.family: root.themeData.fontFamily
                    font.pointSize: root.themeData.fontSize + 2
                    font.bold: true
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Enter confirm    Escape cancel"
                    color: root.palette.muted
                    font.family: root.themeData.fontFamily
                    font.pointSize: root.themeData.fontSize
                }
            }
        }
    }
}
