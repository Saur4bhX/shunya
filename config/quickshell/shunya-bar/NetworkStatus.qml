import QtQuick
import Quickshell.Networking

Text {
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

    color: "#edf1f7"
    font.family: "Source Code Pro"
    font.pixelSize: 13
    height: 36
    verticalAlignment: Text.AlignVCenter
}
