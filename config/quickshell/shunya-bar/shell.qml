//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import Quickshell.Io

ShellRoot {
    id: shellRoot

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


    BrightnessOsd { themeData: shellRoot.themeData }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: bar
            required property var modelData

            screen: modelData
	    implicitHeight: 36
	    color: shellRoot.palette.background || "#171a20"

            anchors {
                top: true
                left: true
                right: true
            }

            exclusiveZone: 36
            WlrLayershell.namespace: "shunya-bar"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            // Workspaces
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Repeater {
                    model: 9

                    delegate: Rectangle {
                        id: workspace
                        required property int index

                        readonly property int number: index + 1
                        readonly property bool selected:
                            Hyprland.focusedWorkspace !== null
                            && Hyprland.focusedWorkspace.id === number

                        width: 28
                        height: 26
			radius: 4
			color: selected ? shellRoot.palette.accent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: workspace.number
			    color: workspace.selected
			        ? shellRoot.palette.onAccent
				: shellRoot.palette.muted
			    font.family: shellRoot.themeData.fontFamily || "Noto Sans"
			    font.pointSize: shellRoot.themeData.fontSize || 11
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch(
                                'hl.dsp.focus({ workspace = "'
                                + workspace.number + '" })'
                            )
                        }
                    }
                }
            }

            // Clock
            Text {
                anchors.centerIn: parent
                text: Qt.formatDateTime(clock.date, "ddd, dd MMM  HH:mm")
		color: shellRoot.palette.text
		font.family: shellRoot.themeData.fontFamily || "Noto Sans"
		font.pointSize: shellRoot.themeData.fontSize || 11
	}
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 18

		Tray { barWindow: bar }
		Volume { themeData: shellRoot.themeData }
		NetworkStatus { themeData: shellRoot.themeData }
		Battery { themeData: shellRoot.themeData }
	    }
        }
    }
}
