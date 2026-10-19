import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs

// waybar listed `custom/playerlabel` but never configured it, so it always
// rendered empty. This is what it was reaching for: the current MPRIS track.
Item {
    id: root

    // Prefer whatever is actually playing over whatever registered first.
    readonly property var player: {
        const players = Mpris.players.values;
        return players.find(candidate => candidate.isPlaying) ?? players[0] ?? null;
    }

    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""

    // A long album title should not push the clock off the bar.
    readonly property int labelWidth: Math.min(label.implicitWidth, 320)

    visible: title !== ""
    implicitWidth: labelWidth + 25 // `padding-left: 10; padding-right: 15`
    implicitHeight: Theme.barHeight

    Text {
        id: label

        x: 10
        anchors.verticalCenter: parent.verticalCenter
        width: root.labelWidth
        elide: Text.ElideRight
        text: `${root.player?.isPlaying ? Icons.pause : Icons.play} ${root.artist === "" ? root.title : `${root.title} — ${root.artist}`}`
        color: Theme.foreground
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
                root.player?.next();
            else
                root.player?.togglePlaying();
        }
    }

    Tooltip {
        anchorItem: root
        shown: mouse.containsMouse && root.title !== ""
        content: `<b>${root.title}</b><br/>${root.artist}<br/>${root.player?.identity ?? ""}`
    }
}
