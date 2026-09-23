import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

Item {
    id: root

    // Hyprland reports workspaces in creation order; waybar laid them out by
    // number.
    readonly property var workspaces: Hyprland.workspaces.values.filter(ws => ws.id > 0).sort((a, b) => a.id - b.id)

    implicitWidth: pill.implicitWidth + Theme.margin * 2
    implicitHeight: Theme.barHeight

    Rectangle {
        id: pill

        anchors.centerIn: parent
        implicitWidth: row.implicitWidth + 10 // waybar's `padding: 0 5px`
        implicitHeight: Theme.pillHeight
        radius: Theme.pillRadius
        color: Theme.surface

        Row {
            id: row

            anchors.centerIn: parent
            height: parent.height

            Repeater {
                model: root.workspaces

                Rectangle {
                    id: button

                    required property var modelData

                    readonly property bool urgent: modelData.urgent
                    // waybar highlighted the focused workspace only, not every
                    // monitor's visible one.
                    readonly property bool active: modelData.focused

                    width: label.implicitWidth + 10 // `padding: 0 5px`
                    height: parent.height
                    radius: Theme.pillRadius
                    color: mouse.containsMouse ? Theme.hover : "transparent"

                    Text {
                        id: label

                        anchors.centerIn: parent
                        // Workspaces past the third have no icon in the waybar
                        // config either, so they fall back to their number.
                        text: button.urgent ? Icons.workspaceUrgent : (Icons.workspaces[button.modelData.name] ?? button.modelData.name)
                        color: mouse.containsMouse ? "#ffffff" : (button.active ? Theme.foreground : Theme.subdued)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }

                    MouseArea {
                        id: mouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: button.modelData.activate()
                    }
                }
            }
        }
    }

    // Scrolling anywhere on the pill walks workspaces, as `disable-scroll:
    // false` did in waybar.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => Hyprland.dispatch(event.angleDelta.y > 0 ? "workspace -1" : "workspace +1")
    }
}
