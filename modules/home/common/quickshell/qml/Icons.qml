pragma Singleton

import QtQuick
import Quickshell

// Nerd Font glyphs, named and given as codepoints so this file stays plain
// ASCII and survives copy-paste. Values match the waybar config's icons.
Singleton {
    function glyph(codepoint: int): string {
        return String.fromCodePoint(codepoint);
    }

    // Workspaces 4 and up had no icon in waybar either; they fall back to
    // their number.
    readonly property var workspaces: ({
        "1": glyph(0xf489), // terminal
        "2": glyph(0xe658), // firefox
        "3": glyph(0xe62b)  // audio
    })
    readonly property string workspaceUrgent: glyph(0xf06a)

    // Ordered empty -> full.
    readonly property var battery: [0xf244, 0xf243, 0xf242, 0xf241, 0xf240].map(glyph)
    readonly property string batteryCharging: glyph(0xeea1)
    readonly property string batteryPlugged: glyph(0xf1e6)

    // Ordered quiet -> loud.
    readonly property var volume: [0xf057f, 0xf0580, 0xf057e].map(glyph)
    readonly property string volumeMuted: glyph(0xf075f)

    readonly property string clock: glyph(0xf017)
    readonly property string calendar: glyph(0xf073)

    readonly property string play: glyph(0xf04b)
    readonly property string pause: glyph(0xf04c)
}
