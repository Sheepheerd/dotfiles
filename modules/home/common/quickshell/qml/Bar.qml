import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.modules

PanelWindow {
    required property var modelData

    screen: modelData

    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.layer: WlrLayer.Top

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.background

    Row {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        Workspaces {}
        Battery {}
        Media {}
    }

    Row {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        Tray {}
        Volume {}
        Clock {}
    }

    // waybar drew this with `border-bottom: 1px solid #1f1f1f`; it sits last so
    // the full-height clock does not paint over it.
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: 1
        color: Theme.border
    }
}
