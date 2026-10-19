import QtQuick
import Quickshell
import qs

Item {
    id: root

    // Clicking swaps time for date, as waybar's `format-alt` did.
    property bool showDate: false

    implicitWidth: 10 + 13 + label.implicitWidth + 15 // margin-left, padding-left, padding-right
    implicitHeight: Theme.barHeight

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    // The month grid waybar rendered from `{calendar}`, rebuilt here because
    // rich text collapses runs of plain spaces.
    function calendar(): string {
        const pad = value => (value < 10 ? "&nbsp;" : "") + value;
        const today = clock.date;
        const first = new Date(today.getFullYear(), today.getMonth(), 1);
        const days = new Date(today.getFullYear(), today.getMonth() + 1, 0).getDate();

        const rows = ["Su Mo Tu We Th Fr Sa".split(" ").join("&nbsp;")];
        let cells = new Array(first.getDay()).fill("&nbsp;&nbsp;");

        for (let day = 1; day <= days; day++) {
            cells.push(day === today.getDate() ? `<b>${pad(day)}</b>` : pad(day));
            if (cells.length === 7) {
                rows.push(cells.join("&nbsp;"));
                cells = [];
            }
        }

        if (cells.length > 0)
            rows.push(cells.join("&nbsp;"));

        return rows.join("<br/>");
    }

    Rectangle {
        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        color: Theme.surface
        bottomLeftRadius: 24 // `border-radius: 0 0 0 24px`

        Text {
            id: label

            x: 13
            anchors.verticalCenter: parent.verticalCenter
            text: root.showDate ? `${Icons.calendar} ${Qt.formatDateTime(clock.date, "dd/MM")}` : `${Icons.clock} ${Qt.formatDateTime(clock.date, "HH:mm")}`
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.showDate = !root.showDate
        }
    }

    Tooltip {
        anchorItem: root
        shown: mouse.containsMouse
        content: `<big>${Qt.formatDateTime(clock.date, "yyyy MMMM")}</big><br/><tt><small>${root.calendar()}</small></tt>`
    }
}
