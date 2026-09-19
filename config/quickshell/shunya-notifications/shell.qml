import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

ShellRoot {
    NotificationServer {
        id: server

        bodySupported: true
        bodyMarkupSupported: false
        actionsSupported: false
        persistenceSupported: false

        onNotification: notification => {
            notification.tracked = true;
        }
    }

    PanelWindow {
        id: panel

        visible: server.trackedNotifications.values.length > 0
        implicitWidth: 360
        implicitHeight: Math.max(
            1, Math.min(cards.height, screen.height - 80)
        )
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
        }

        margins {
            top: 48
            right: 12
        }

        WlrLayershell.namespace: "shunya-notifications"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        Flickable {
            anchors.fill: parent
            contentHeight: cards.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: cards
                width: parent.width
                spacing: 8

                Repeater {
                    model: server.trackedNotifications

                    delegate: Rectangle {
                        id: card
                        required property var modelData

                        width: cards.width
                        height: content.height + 24
                        radius: 8
                        color: "#232833"
                        border.color: "#536b8e"

                        Column {
                            id: content
                            x: 12
                            y: 12
                            width: parent.width - 24
                            spacing: 6

                            Text {
                                width: parent.width
                                text: card.modelData.appName
                                textFormat: Text.PlainText
                                color: "#a6b5cc"
                                font.family: "Source Code Pro"
                                font.pixelSize: 12
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width
                                text: card.modelData.summary
                                textFormat: Text.PlainText
                                color: "#edf1f7"
                                font.pixelSize: 15
                                font.bold: true
                                wrapMode: Text.Wrap
                            }

                            Text {
                                width: parent.width
                                text: card.modelData.body
                                textFormat: Text.PlainText
                                visible: text.length > 0
                                color: "#c5ccd8"
                                font.pixelSize: 13
                                wrapMode: Text.Wrap
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: card.modelData.dismiss()
                        }

                        Timer {
                            interval: card.modelData.expireTimeout > 0
                                ? card.modelData.expireTimeout * 1000
                                : 5000

                            running: card.modelData.expireTimeout !== 0
                                && card.modelData.urgency
                                    !== NotificationUrgency.Critical

                            onTriggered: card.modelData.expire()
                        }
                    }
                }
            }
        }
    }
}
