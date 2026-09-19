import QtQuick
import Quickshell.Services.UPower

Text {
    readonly property var battery: UPower.displayDevice

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

    color: "#edf1f7"
    font.family: "Source Code Pro"
    font.pixelSize: 13
    height: 36
    verticalAlignment: Text.AlignVCenter
}
