import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var themeData

    readonly property var palette:
        themeData[themeData.mode || "dark"] || {}

    property bool osdVisible: false

    // Common OSD styling
    property int osdWidth: 260
    property int osdHeight: 60
    property int cornerRadius: 14
    property int timeout: 1500
    property real glassOpacity: 0.55

    function withAlpha(hex, alpha) {
        if (!hex || hex.length !== 7)
            return Qt.rgba(0.12, 0.12, 0.15, alpha)

        return Qt.rgba(
            parseInt(hex.slice(1, 3), 16) / 255,
            parseInt(hex.slice(3, 5), 16) / 255,
            parseInt(hex.slice(5, 7), 16) / 255,
            alpha
        )
    }

    readonly property color glassColor:
        withAlpha(root.palette.background, root.glassOpacity)

    function showOsd() {
        root.osdVisible = true
        hideTimer.restart()
    }

    function hideOsd() {
        hideTimer.stop()
        root.osdVisible = false
    }

    visible: root.osdVisible

    implicitWidth: root.osdWidth
    implicitHeight: root.osdHeight

    color: "transparent"

    anchors.top: true
    margins.top: 52

    exclusionMode: ExclusionMode.Ignore
    mask: Region {}

    WlrLayershell.namespace: "shunya-osd"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    Timer {
        id: hideTimer

        interval: root.timeout
        repeat: false

        onTriggered: root.osdVisible = false
    }

    Rectangle {
        anchors.fill: parent
        z: -1

        radius: root.cornerRadius
        color: root.glassColor

        border.width: 1
        border.color: root.palette.border
    }
}
