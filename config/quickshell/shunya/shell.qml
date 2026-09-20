import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
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

    visible: true
    implicitWidth: 600
    implicitHeight: 440
    color: root.palette.background
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
RowLayout {
    Layout.fillWidth: true

    Text {
        text: "SHUNYA"
        color: root.palette.accent
        font.family: root.themeData.fontFamily
        font.pointSize: root.themeData.fontSize
        font.letterSpacing: 3
    }

    Item {
        Layout.fillWidth: true
    }
Text {
    text: "Theme"
    color: root.palette.muted
    font.family: root.themeData.fontFamily
    font.pointSize: root.themeData.fontSize
}
Button {
    text: root.themeData.mode === "dark" ? "Light" : "Dark"

    contentItem: Text {
        text: parent.text
        color: root.palette.text
        font.family: root.themeData.fontFamily
        font.pointSize: root.themeData.fontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitWidth: 64
        implicitHeight: 30
        radius: 6
        color: root.palette.surface
        border.width: 1
        border.color: root.palette.border
    }

    onClicked: Quickshell.execDetached({
        command: [
            Quickshell.env("HOME") + "/.config/bin/shunya-theme",
            "toggle"
        ]
    })
}
}

	TextField {
            id: search

            Layout.fillWidth: true
            placeholderText: "Search applications..."
            placeholderTextColor: root.palette.muted
            color: root.palette.text
            font.family: root.themeData.fontFamily
            font.pointSize: root.themeData.fontSize
            focus: true
            selectByMouse: true

            background: Rectangle {
                implicitHeight: 48
                color: root.palette.surface
                radius: 8
                border.color: root.palette.accent
            }

            Component.onCompleted: forceActiveFocus()
            onTextChanged: results.currentIndex = 0
            onAccepted: root.launch(results.currentIndex)

            Keys.onEscapePressed: Qt.quit()

            Keys.onDownPressed: {
                if (results.count > 0) {
                    results.currentIndex = Math.min(
                        results.currentIndex + 1,
                        results.count - 1
                    );
                }
            }

            Keys.onUpPressed: {
                if (results.count > 0) {
                    results.currentIndex = Math.max(
                        results.currentIndex - 1,
                        0
                    );
                }
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
                readonly property bool selected: ListView.isCurrentItem

                width: ListView.view.width
                height: 44
                radius: 6
                color: row.selected
                    ? root.palette.accent
                    : "transparent"

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    verticalAlignment: Text.AlignVCenter
                    text: row.modelData.name
                    color: row.selected
                        ? root.palette.onAccent
                        : root.palette.text
                    font.family: root.themeData.fontFamily
                    font.pointSize: root.themeData.fontSize
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
                color: root.palette.muted
                font.family: root.themeData.fontFamily
                font.pointSize: root.themeData.fontSize
            }
        }

	Text {
            text: "↑ ↓ select    Enter launch    Esc close"
            color: root.palette.muted
            font.family: root.themeData.fontFamily
            font.pointSize: root.themeData.fontSize
        }
    }
}
