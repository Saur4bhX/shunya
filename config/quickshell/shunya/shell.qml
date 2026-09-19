import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: true
    implicitWidth: 600
    implicitHeight: 440
    color: "#171a20"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "shunya-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    readonly property var matches: {
        const query = search.text.trim().toLowerCase();

        return DesktopEntries.applications.values
            .filter(app => (app.name + " " + app.genericName)
                .toLowerCase().includes(query))
            .sort((a, b) => a.name.localeCompare(b.name));
    }

    function launch(index) {
        const app = matches[index];
        if (!app)
            return;

        if (app.runInTerminal) {
            Quickshell.execDetached({
                command: ["kitty", "-e"].concat(Array.from(app.command)),
                workingDirectory: app.workingDirectory
            });
        } else {
            app.execute();
        }

        Qt.quit();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        Text {
            text: "SHUNYA"
            color: "#a6b5cc"
            font.family: "Source Code Pro"
            font.pixelSize: 14
            font.letterSpacing: 3
        }

        TextField {
            id: search

            Layout.fillWidth: true
            placeholderText: "Search applications..."
            placeholderTextColor: "#8993a3"
            color: "#edf1f7"
            font.pixelSize: 18
            focus: true
            selectByMouse: true

            background: Rectangle {
                implicitHeight: 48
                color: "#232833"
                radius: 8
                border.color: "#536b8e"
            }

            Component.onCompleted: forceActiveFocus()
            onTextChanged: results.currentIndex = 0
            onAccepted: root.launch(results.currentIndex)

            Keys.onEscapePressed: Qt.quit()
            Keys.onDownPressed: {
                if (results.count > 0)
                    results.currentIndex =
                        Math.min(results.currentIndex + 1, results.count - 1);
            }
            Keys.onUpPressed: {
                if (results.count > 0)
                    results.currentIndex =
                        Math.max(results.currentIndex - 1, 0);
            }
        }

        ListView {
            id: results

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            model: root.matches
            currentIndex: 0
            highlightMoveDuration: 0

            delegate: Rectangle {
                id: row

                required property var modelData
                required property int index

                width: ListView.view.width
                height: 44
                radius: 6
                color: ListView.isCurrentItem ? "#34435b" : "transparent"

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    verticalAlignment: Text.AlignVCenter
                    text: row.modelData.name
                    color: "#edf1f7"
                    font.pixelSize: 16
                    elide: Text.ElideRight
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.launch(row.index)
                }
            }

            Text {
                anchors.centerIn: parent
                visible: results.count === 0
                text: "No matching applications"
                color: "#8993a3"
            }
        }

        Text {
            text: "↑ ↓ select    Enter launch    Esc close"
            color: "#8993a3"
            font.pixelSize: 12
        }
    }
}
