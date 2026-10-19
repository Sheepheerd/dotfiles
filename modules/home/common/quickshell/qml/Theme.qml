pragma Singleton

import QtQuick
import Quickshell

// Every value here is lifted from the waybar stylesheet this bar replaces, so
// the two are visually interchangeable.
Singleton {
    readonly property color background: "#f2141414" // rgba(20, 20, 20, 0.95)
    readonly property color border: "#1f1f1f"
    readonly property color surface: "#1f1f1f"
    readonly property color hover: "#333333"
    readonly property color foreground: "#eaeaea"
    readonly property color subdued: "#888888"
    readonly property color red: "#cc6666"
    readonly property color green: "#a6e3a1"
    readonly property color onAccent: "#1a1a1a"

    readonly property string fontFamily: "CaskaydiaCove NFP"
    readonly property int fontSize: 14

    // Waybar asked for `height: 16` but its margins and padding grew the layer
    // to 37px; matching that keeps the reserved strip identical.
    readonly property int barHeight: 37
    readonly property int margin: 5
    readonly property int pillHeight: barHeight - margin * 2
    readonly property int pillRadius: 16
}
