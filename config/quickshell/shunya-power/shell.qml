import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        anchors { top: true; bottom: true; left: true; right: true }
        color: "#00000099"
        exclusionMode: ExclusionMode.Ignore
        focusable: true

        WlrLayershell.namespace: "shunya-power"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

Item {
    anchors.fill: parent
    focus: true
    Component.onCompleted: forceActiveFocus()

    Keys.onEscapePressed: Qt.quit()
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Q) {
            event.accepted = true;
            Qt.quit();
        }
    }
}
        Row {
            anchors.centerIn: parent
            spacing: 12

            Repeater {
                model: [
                    { label: "Lock", command: ["loginctl", "lock-session"] },
		    { label: "Logout", command: ["hyprctl", "dispatch", "hl.dsp.exit()"] },
                    { label: "Suspend", command: ["systemctl", "suspend"] },
                    { label: "Reboot", command: ["systemctl", "reboot"] },
                    { label: "Power off", command: ["systemctl", "poweroff"] }
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
                        onClicked: {
			    Quickshell.execDetached(parent.modelData.command)
			    Qt.quit()
                        }
                    }
                }
            }
        }
    }
}
