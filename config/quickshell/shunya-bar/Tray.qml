import QtQuick
import QtQuick.Controls
import Quickshell.Services.SystemTray

Row {
    id: root

    required property var barWindow
    height: 36
    spacing: 6

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem
            required property var modelData

            width: 26
            height: 36

            function showMenu() {
                if (!modelData.hasMenu)
                    return;

                const point = mapToItem(
                    root.barWindow.contentItem, 0, height
                );
                modelData.display(root.barWindow, point.x, point.y);
            }

            Image {
                id: icon
                anchors.centerIn: parent
                width: 20
                height: 20
                source: trayItem.modelData.icon
                sourceSize.width: 20
                sourceSize.height: 20
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.centerIn: parent
                visible: icon.status !== Image.Ready
                text: (trayItem.modelData.title || "?").charAt(0)
                color: "#edf1f7"
            }

            ToolTip.visible: mouse.containsMouse
            ToolTip.delay: 500
            ToolTip.text: modelData.tooltipTitle || modelData.title

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                    | Qt.MiddleButton

                onClicked: event => {
                    if (event.button === Qt.RightButton) {
                        trayItem.showMenu();
                    } else if (event.button === Qt.MiddleButton) {
                        trayItem.modelData.secondaryActivate();
                    } else if (trayItem.modelData.onlyMenu) {
                        trayItem.showMenu();
                    } else {
                        trayItem.modelData.activate();
                    }
                }
            }
        }
    }
}
