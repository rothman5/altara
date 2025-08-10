import QtQuick

QtObject {
    id: paletteColorSet

    property Color normal: Color {
        bg: "#000000"
        fg: "#FFFFFF"
    }

    property real focusedScale: 1.2
    property real hoveredScale: 1.5
    property real pressedScale: 1.7
    property real disabledScale: 1.9

    property Color focused: Color {
        bg: Theme.dark ? Qt.lighter(paletteColorSet.normal.bg, paletteColorSet.focusedScale) : Qt.darker(paletteColorSet.normal.bg, paletteColorSet.focusedScale)
        fg: Theme.dark ? Qt.lighter(paletteColorSet.normal.fg, paletteColorSet.focusedScale) : Qt.darker(paletteColorSet.normal.fg, paletteColorSet.focusedScale)
    }

    property Color hovered: Color {
        bg: Theme.dark ? Qt.lighter(paletteColorSet.normal.bg, paletteColorSet.hoveredScale) : Qt.darker(paletteColorSet.normal.bg, paletteColorSet.hoveredScale)
        fg: Theme.dark ? Qt.lighter(paletteColorSet.normal.fg, paletteColorSet.hoveredScale) : Qt.darker(paletteColorSet.normal.fg, paletteColorSet.hoveredScale)
    }

    property Color pressed: Color {
        bg: Theme.dark ? Qt.lighter(paletteColorSet.normal.bg, paletteColorSet.pressedScale) : Qt.darker(paletteColorSet.normal.bg, paletteColorSet.pressedScale)
        fg: Theme.dark ? Qt.lighter(paletteColorSet.normal.fg, paletteColorSet.pressedScale) : Qt.darker(paletteColorSet.normal.fg, paletteColorSet.pressedScale)
    }

    property Color disabled: Color {
        bg: Qt.darker(paletteColorSet.normal.bg, paletteColorSet.disabledScale)
        fg: Qt.darker(paletteColorSet.normal.fg, paletteColorSet.disabledScale)
    }
}
