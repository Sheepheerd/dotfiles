import QtQuick
import Quickshell
import qs

// waybar got tooltips from GTK; here they are plain popup windows anchored
// under the module that owns them.
PopupWindow {
    id: root

    required property Item anchorItem
    property string content: ""
    property bool shown: false

    visible: shown && content !== ""

    anchor {
        item: anchorItem
        rect.x: anchorItem.width / 2
        rect.y: anchorItem.height - Theme.margin
        gravity: Edges.Bottom
    }

    implicitWidth: label.implicitWidth + 20
    implicitHeight: label.implicitHeight + 12
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Theme.surface
        radius: 8

        border {
            width: 1
            color: Theme.hover
        }

        Text {
            id: label

            anchors.centerIn: parent
            text: root.content
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignLeft
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
