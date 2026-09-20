import QtQuick
import Quickshell.Services.UPower

Text {
    id: root

    readonly property var battery: UPower.displayDevice
    required property var themeData
    readonly property var palette: themeData[themeData.mode || "dark"] || {}
    text: {
        if (!battery.ready)
            return "BAT --";

        if (!battery.isLaptopBattery)
            return "";

        const percent = Math.round(battery.percentage * 100);
        let status = "";

        switch (battery.state) {
        case UPowerDeviceState.Charging:
            status = "charging";
            break;
        case UPowerDeviceState.Discharging:
            status = "battery";
            break;
        case UPowerDeviceState.FullyCharged:
            status = "full";
            break;
        case UPowerDeviceState.PendingCharge:
            status = "plugged";
            break;
        default:
            status = "unknown";
        }

        return "BAT " + percent + "% " + status;
    }

    color: root.palette.text
    font.family: root.themeData.fontFamily
    font.pointSize: root.themeData.fontSize
    height: 36
    verticalAlignment: Text.AlignVCenter
}
