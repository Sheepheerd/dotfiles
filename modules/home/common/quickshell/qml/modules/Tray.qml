import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs

Item {
    id: root

    readonly property var items: SystemTray.items.values

    visible: items.length > 0
    implicitWidth: pill.implicitWidth + Theme.margin * 2
    implicitHeight: Theme.barHeight

    Rectangle {
        id: pill

        anchors.centerIn: parent
        implicitWidth: row.implicitWidth + 10 // `padding: 0 5px`
        implicitHeight: Theme.pillHeight
        radius: Theme.pillRadius
        color: Theme.surface

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 5

            Repeater {
                model: root.items

                MouseArea {
                    id: trayItem

                    required property var modelData

                    implicitWidth: 16 // `icon-size: 16`
                    implicitHeight: 16
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    onClicked: event => {
                        if (event.button === Qt.MiddleButton)
                            modelData.secondaryActivate();
                        else if (event.button === Qt.RightButton || modelData.onlyMenu)
                            menuAnchor.open();
                        else
                            modelData.activate();
                    }

                    IconImage {
                        anchors.fill: parent
                        source: trayItem.modelData.icon
                    }

                    QsMenuAnchor {
                        id: menuAnchor

                        menu: trayItem.modelData.menu

                        anchor {
                            item: trayItem
                            rect.y: trayItem.height + Theme.margin
                            gravity: Edges.Bottom
                        }
                    }

                    Tooltip {
                        anchorItem: root
                        shown: trayItem.containsMouse
                        content: trayItem.modelData.tooltipTitle || trayItem.modelData.title || trayItem.modelData.id
                    }
                }
            }
        }
    }
}
