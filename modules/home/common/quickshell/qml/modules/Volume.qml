import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs

Item {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int percent: Math.round(volume * 100)

    readonly property string icon: {
        if (muted)
            return Icons.volumeMuted;
        if (percent < 34)
            return Icons.volume[0];
        return percent < 67 ? Icons.volume[1] : Icons.volume[2];
    }

    // Pipewire only keeps a node's volume bound while something is tracking it.
    PwObjectTracker {
        objects: [root.sink]
    }

    function setVolume(value: real): void {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1, value));
    }

    implicitWidth: label.implicitWidth + Theme.margin * 2 + 10
    implicitHeight: Theme.barHeight

    Text {
        id: label

        anchors.centerIn: parent
        text: root.muted ? root.icon : `${root.icon} ${root.percent}%`
        color: root.muted ? Theme.subdued : Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: event => {
            if (event.button === Qt.RightButton)
                Quickshell.execDetached(["pavucontrol"]);
            else if (root.sink?.audio)
                root.sink.audio.muted = !root.muted;
        }

        // `scroll-step: 5`
        onWheel: event => root.setVolume(root.volume + (event.angleDelta.y > 0 ? 0.05 : -0.05))
    }

    Tooltip {
        anchorItem: root
        shown: mouse.containsMouse
        content: root.sink?.description ?? root.sink?.name ?? "No audio sink"
    }
}
