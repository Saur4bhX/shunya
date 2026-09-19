import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        id: window

        property var pendingCommand: []
        property string pendingLabel: ""
        readonly property bool confirming: pendingCommand.length > 0

        anchors { top: true; bottom: true; left: true; right: true }
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
                } else if (event.key === Qt.Key_Return && window.confirming) {
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
                        command: ["hyprctl", "dispatch", "hl.dsp.exit()"],
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
                    required property var modelData

                    width: 110
                    height: 56
                    radius: 6
                    color: "#232833"

                    Text {
                        anchors.centerIn: parent
                        text: parent.modelData.label
                        color: "#edf1f7"
                        font.family: "Source Code Pro"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.selectAction(parent.modelData)
                    }
                }
            }
        }

        Column {
            visible: window.confirming
            anchors.centerIn: parent
            spacing: 16

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Confirm " + window.pendingLabel + "?"
                color: "#edf1f7"
                font.family: "Source Code Pro"
                font.pixelSize: 18
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Enter confirm    Escape cancel"
                color: "#a6b5cc"
                font.family: "Source Code Pro"
            }
        }
    }
}

