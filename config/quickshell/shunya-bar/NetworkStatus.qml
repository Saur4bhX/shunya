import QtQuick
import Quickshell.Networking

Text {
    id: root
    required property var themeData
    readonly property var palette: themeData[themeData.mode || "dark"] || {}
    text: {
        const connected = Networking.devices.values.filter(
            device => device.connected
                && (device.type === DeviceType.Wifi
                    || device.type === DeviceType.Wired)
        );

        if (connected.length === 0)
            return "NET disconnected";

        const wifi = connected.some(d => d.type === DeviceType.Wifi);
        const wired = connected.some(d => d.type === DeviceType.Wired);

        if (wifi && wired)
            return "NET WiFi + LAN";

        return wifi ? "NET WiFi" : "NET LAN";
    }

    color: root.palette.text
    font.family: root.themeData.fontFamily
    font.pointSize: root.themeData.fontSize
    height: 36
    verticalAlignment: Text.AlignVCenter
}
