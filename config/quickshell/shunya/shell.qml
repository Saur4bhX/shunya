import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    property bool wallpaperMode: false

    readonly property string wallpaperDirectory:
    "file://" + Quickshell.env("HOME") + "/Pictures/Wallpapers"

    function setWallpaper(path) {
        Quickshell.execDetached({
            command: [
                Quickshell.env("HOME") + "/.config/bin/shunya-theme",
                "set-wallpaper",
                path
            ]
        });
    }

    function wallpaperAction(action) {
        Quickshell.execDetached({
            command: [
                Quickshell.env("HOME") + "/.config/bin/shunya-theme",
                action
            ]
        });
    }

    function focusCurrentWallpaper() {
        if (!root.themeData.wallpaper || wallpaperModel.count === 0)
        return;

        const url = "file://" + root.themeData.wallpaper;
        const index = wallpaperModel.indexOf(url);

        if (index >= 0) {
            wallpaperGrid.currentIndex = index;
            wallpaperGrid.positionViewAtIndex(
                index,
                GridView.Contain
            );
        }
    }

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
    FolderListModel {
        id: wallpaperModel

        folder: root.wallpaperDirectory

        nameFilters: [
            "*.jpg",
            "*.jpeg",
            "*.png",
            "*.webp",
            "*.JPG",
            "*.JPEG",
            "*.PNG",
            "*.WEBP"
        ]

        showDirs: false
        showFiles: true
        showHidden: false

        sortField: FolderListModel.Name
    }
    visible: true
    implicitWidth: 640
    implicitHeight: 470
    color: root.palette.background
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "shunya-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Shortcut {
        sequence: "Esc"
        context: Qt.ApplicationShortcut

        onActivated: Qt.quit()
    }
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

            Button {
                text: root.wallpaperMode ? "Apps" : "Wallpapers"

                contentItem: Text {
                    text: parent.text
                    color: root.wallpaperMode
                    ? root.palette.onAccent
                    : root.palette.text

                    font.family: root.themeData.fontFamily
                    font.pointSize: root.themeData.fontSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 84
                    implicitHeight: 30
                    radius: 6
                    color: root.wallpaperMode
                    ? root.palette.accent
                    : root.palette.surface

                    border.width: 1
                    border.color: root.wallpaperMode
                    ? root.palette.accent
                    : root.palette.border
                }
                onClicked: {
                    root.wallpaperMode = !root.wallpaperMode;

                    if (root.wallpaperMode) {
                        root.focusCurrentWallpaper();
                        wallpaperGrid.forceActiveFocus();
                    } else {
                        search.forceActiveFocus();
                    }
                }

            }
            Text {
                text: "Accent"
                color: root.palette.muted
                font.family: root.themeData.fontFamily
                font.pointSize: root.themeData.fontSize
            }
            Button {
                text: root.themeData.accentMode === "auto" ? "Freeze" : "Auto"

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
                        root.themeData.accentMode === "auto"
                        ? "freeze-accent"
                        : "auto-accent"
                    ]
                })
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

            visible: !root.wallpaperMode
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

            visible: !root.wallpaperMode
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
        ColumnLayout {
            visible: root.wallpaperMode

            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Wallpapers"
                    color: root.palette.text
                    font.family: root.themeData.fontFamily
                    font.pointSize: root.themeData.fontSize
                    font.bold: true
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: "Previous"

                    contentItem: Text {
                        text: parent.text
                        color: root.palette.text
                        font.family: root.themeData.fontFamily
                        font.pointSize: root.themeData.fontSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitWidth: 74
                        implicitHeight: 30
                        radius: 6
                        color: root.palette.surface
                        border.width: 1
                        border.color: root.palette.border
                    }

                    onClicked: root.wallpaperAction("prev-wallpaper")
                }

                Button {
                    text: "Random"

                    contentItem: Text {
                        text: parent.text
                        color: root.palette.text
                        font.family: root.themeData.fontFamily
                        font.pointSize: root.themeData.fontSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitWidth: 68
                        implicitHeight: 30
                        radius: 6
                        color: root.palette.surface
                        border.width: 1
                        border.color: root.palette.border
                    }

                    onClicked: root.wallpaperAction("random-wallpaper")
                }

                Button {
                    text: "Next"

                    contentItem: Text {
                        text: parent.text
                        color: root.palette.text
                        font.family: root.themeData.fontFamily
                        font.pointSize: root.themeData.fontSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitWidth: 60
                        implicitHeight: 30
                        radius: 6
                        color: root.palette.surface
                        border.width: 1
                        border.color: root.palette.border
                    }

                    onClicked: root.wallpaperAction("next-wallpaper")
                }
            }

            GridView {
                id: wallpaperGrid
                currentIndex: -1
                keyNavigationEnabled: true
                highlightMoveDuration: 80
                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true
                focus: root.wallpaperMode

                model: wallpaperModel

                cellWidth: 190
                cellHeight: 122
                delegate: Rectangle {
                    id: wallpaperTile

                    required property string fileName
                    required property string filePath
                    required property url fileUrl
                    required property int index

                    readonly property bool current:
                    filePath === root.themeData.wallpaper

                    readonly property bool selected:
                    GridView.isCurrentItem

                    readonly property bool hovered:
                    tileMouse.containsMouse

                    width: 182
                    height: 112

                    radius: 9
                    clip: true

                    color: root.palette.surface

                    border.width:
                    current ? 3 :
                    selected ? 2 :
                    1

                    border.color:
                    current
                    ? root.palette.accent
                    : selected
                    ? root.palette.text
                    : hovered
                    ? root.palette.accent
                    : root.palette.border

                    Image {
                        anchors.fill: parent
                        anchors.margins: wallpaperTile.current ? 3 : 1

                        source: wallpaperTile.fileUrl
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true

                        sourceSize.width: 364
                        sourceSize.height: 224

                        opacity: wallpaperTile.hovered ? 0.92 : 1.0
                    }

                    // Subtle hover wash
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: wallpaperTile.current ? 3 : 1

                        radius: 6
                        color: root.palette.accent
                        opacity: wallpaperTile.hovered ? 0.08 : 0
                    }

                    // Current wallpaper badge
                    Rectangle {
                        visible: wallpaperTile.current

                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 8

                        width: 24
                        height: 24
                        radius: 12

                        color: root.palette.accent

                        Text {
                            anchors.centerIn: parent
                            text: "✓"

                            color: root.palette.onAccent
                            font.bold: true
                            font.pixelSize: 14
                        }
                    }

                    // Filename strip
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        height: 26

                        color: "#99000000"

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8

                            verticalAlignment: Text.AlignVCenter

                            text: wallpaperTile.fileName
                            color: "#ffffff"

                            font.family: root.themeData.fontFamily
                            font.pixelSize: 11

                            elide: Text.ElideMiddle
                        }
                    }

                    MouseArea {
                        id: tileMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            wallpaperGrid.currentIndex = wallpaperTile.index;
                            root.setWallpaper(wallpaperTile.filePath);
                        }
                    }
                }
                Keys.onReturnPressed: {
                    if (currentIndex >= 0) {
                        const path = wallpaperModel.get(
                            currentIndex,
                            "filePath"
                        );

                        root.setWallpaper(path);
                    }
                }

                Keys.onEnterPressed: {
                    if (currentIndex >= 0) {
                        const path = wallpaperModel.get(
                            currentIndex,
                            "filePath"
                        );

                        root.setWallpaper(path);
                    }
                }

                Text {
                    anchors.centerIn: parent

                    visible: wallpaperModel.count === 0

                    text: "No wallpapers found"
                    color: root.palette.muted

                    font.family: root.themeData.fontFamily
                    font.pointSize: root.themeData.fontSize
                }
            }
        }
        Text {
            text: root.wallpaperMode
            ? "Click wallpaper to apply    Esc applications"
            : "↑ ↓ select    Enter launch    Esc close"
            color: root.palette.muted
            font.family: root.themeData.fontFamily
            font.pointSize: root.themeData.fontSize
        }
    }
}
