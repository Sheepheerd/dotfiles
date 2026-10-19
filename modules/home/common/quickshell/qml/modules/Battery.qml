import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs

Item {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool available: (battery?.isLaptopBattery ?? false) && (battery?.isPresent ?? false)
    readonly property int capacity: Math.round((battery?.percentage ?? 0) * 100)
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging
    readonly property bool plugged: !UPower.onBattery && !charging

    // waybar's `states`. The stylesheet only ever styled `warning`, but a
    // critical battery deserves at least as loud a treatment, so it shares it.
    readonly property bool alarming: !charging && capacity <= 30

    // Toggled by clicking, like waybar's `format-alt`.
    property bool showTime: false

    readonly property string icon: Icons.battery[Math.min(Icons.battery.length - 1, Math.floor(capacity / 20))]

    // UPowerDeviceState exposes a toString, but calling it on the singleton
    // collides with JS's own toString, so spell the labels out.
    readonly property string stateLabel: {
        switch (battery?.state) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.Empty:
            return "Empty";
        case UPowerDeviceState.FullyCharged:
            return "Fully charged";
        case UPowerDeviceState.PendingCharge:
            return "Pending charge";
        case UPowerDeviceState.PendingDischarge:
            return "Pending discharge";
        default:
            return "Unknown";
        }
    }

    readonly property string remaining: {
        const seconds = charging ? (battery?.timeToFull ?? 0) : (battery?.timeToEmpty ?? 0);
        if (seconds <= 0)
            return "";
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        return hours > 0 ? `${hours} h ${minutes} min` : `${minutes} min`;
    }

    visible: available
    implicitWidth: pill.implicitWidth + Theme.margin * 2
    implicitHeight: Theme.barHeight

    Rectangle {
        id: pill

        anchors.centerIn: parent
        implicitWidth: label.implicitWidth + 10
        implicitHeight: label.implicitHeight + 10
        radius: 5
        color: root.alarming ? Theme.red : "transparent"

        Text {
            id: label

            anchors.centerIn: parent
            text: {
                if (root.showTime && root.remaining !== "")
                    return `${root.icon} ${root.remaining}`;
                if (root.charging)
                    return `${root.capacity}% ${Icons.batteryCharging}`;
                if (root.plugged)
                    return `${root.capacity}% ${Icons.batteryPlugged}`;
                return `${root.icon}  ${root.capacity}%`;
            }
            color: root.alarming ? Theme.onAccent : Theme.green
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.showTime = !root.showTime
        }

        Tooltip {
            anchorItem: root
            shown: mouse.containsMouse
            content: {
                const model = root.battery?.model ?? "Battery";
                return root.remaining === "" ? `${model}<br/>${root.stateLabel}` : `${model}<br/>${root.stateLabel}, ${root.remaining} left`;
            }
        }
    }
}
