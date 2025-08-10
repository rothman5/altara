pragma Singleton

import QtQuick

QtObject {
    id: theme

    enum FontSize {
        XSMALL = 10,
        SMALL = 12,
        BODY = 13,
        MEDIUM = 14,
        LARGE = 24,
        XLARGE = 32
    }

    property bool dark: true
    property string fontFamily: "gg sans"
    property int borderWidth: 1
    property int cornerRadius: 8
    property int padding: 8
    property int animationDuration: 200

    property Scheme palette: Scheme {
        primary: ColorSet {
            disabledScale: 3
            normal: Color {
                bg: "#ebcb8b"
                fg: "#0d0d0f"
            }
            focused: Color {
                bg: Qt.darker(theme.palette.primary.normal.bg, theme.palette.primary.disabledScale)
                fg: Qt.darker(theme.palette.primary.normal.fg, theme.palette.primary.disabledScale)
            }
            hovered: Color {
                bg: Qt.darker(theme.palette.primary.normal.bg, theme.palette.primary.hoveredScale)
                fg: Qt.darker(theme.palette.primary.normal.fg, theme.palette.primary.hoveredScale)
            }
            pressed: Color {
                bg: Qt.darker(theme.palette.primary.normal.bg, theme.palette.primary.pressedScale)
                fg: Qt.darker(theme.palette.primary.normal.fg, theme.palette.primary.pressedScale)
            }
        }

        secondary: ColorSet {
            disabledScale: 3
            normal: Color {
                bg: "#81a1c1"
                fg: "#0d0d0f"
            }
            focused: Color {
                bg: Qt.darker(theme.palette.secondary.normal.bg, theme.palette.secondary.disabledScale)
                fg: Qt.darker(theme.palette.secondary.normal.fg, theme.palette.secondary.disabledScale)
            }
            hovered: Color {
                bg: Qt.darker(theme.palette.secondary.normal.bg, theme.palette.secondary.hoveredScale)
                fg: Qt.darker(theme.palette.secondary.normal.fg, theme.palette.secondary.hoveredScale)
            }
            pressed: Color {
                bg: Qt.darker(theme.palette.secondary.normal.bg, theme.palette.secondary.pressedScale)
                fg: Qt.darker(theme.palette.secondary.normal.fg, theme.palette.secondary.pressedScale)
            }
        }

        background: ColorSet {
            normal: Color {
                bg: "#030303"
                fg: "#c3c3c3"
            }
        }

        surface: ColorSet {
            normal: Color {
                bg: "#0d0d0f"
                fg: "#c3c3c3"
            }
        }

        border: ColorSet {
            focusedScale: 2
            normal: Color {
                bg: "#222222"
                fg: "#222222"
            }
        }

        info: ColorSet {
            disabledScale: 3
            normal: Color {
                bg: "#b8b8b8"
                fg: "#0d0d0f"
            }
            focused: Color {
                bg: Qt.darker(theme.palette.info.normal.bg, theme.palette.info.disabledScale)
                fg: Qt.darker(theme.palette.info.normal.fg, theme.palette.info.disabledScale)
            }
            hovered: Color {
                bg: Qt.darker(theme.palette.info.normal.bg, theme.palette.info.hoveredScale)
                fg: Qt.darker(theme.palette.info.normal.fg, theme.palette.info.hoveredScale)
            }
            pressed: Color {
                bg: Qt.darker(theme.palette.info.normal.bg, theme.palette.info.pressedScale)
                fg: Qt.darker(theme.palette.info.normal.fg, theme.palette.info.pressedScale)
            }
        }

        error: ColorSet {
            disabledScale: 3
            normal: Color {
                bg: "#bf616a"
                fg: "#0d0d0f"
            }
            focused: Color {
                bg: Qt.darker(theme.palette.error.normal.bg, theme.palette.error.disabledScale)
                fg: Qt.darker(theme.palette.error.normal.fg, theme.palette.error.disabledScale)
            }
            hovered: Color {
                bg: Qt.darker(theme.palette.error.normal.bg, theme.palette.error.hoveredScale)
                fg: Qt.darker(theme.palette.error.normal.fg, theme.palette.error.hoveredScale)
            }
            pressed: Color {
                bg: Qt.darker(theme.palette.error.normal.bg, theme.palette.error.pressedScale)
                fg: Qt.darker(theme.palette.error.normal.fg, theme.palette.error.pressedScale)
            }
        }

        success: ColorSet {
            disabledScale: 3
            normal: Color {
                bg: "#a3be8c"
                fg: "#0d0d0f"
            }
            focused: Color {
                bg: Qt.darker(theme.palette.success.normal.bg, theme.palette.success.disabledScale)
                fg: Qt.darker(theme.palette.success.normal.fg, theme.palette.success.disabledScale)
            }
            hovered: Color {
                bg: Qt.darker(theme.palette.success.normal.bg, theme.palette.success.hoveredScale)
                fg: Qt.darker(theme.palette.success.normal.fg, theme.palette.success.hoveredScale)
            }
            pressed: Color {
                bg: Qt.darker(theme.palette.success.normal.bg, theme.palette.success.pressedScale)
                fg: Qt.darker(theme.palette.success.normal.fg, theme.palette.success.pressedScale)
            }
        }

        warning: ColorSet {
            disabledScale: 3
            normal: Color {
                bg: "#d08770"
                fg: "#0d0d0f"
            }
            focused: Color {
                bg: Qt.darker(theme.palette.warning.normal.bg, theme.palette.warning.disabledScale)
                fg: Qt.darker(theme.palette.warning.normal.fg, theme.palette.warning.disabledScale)
            }
            hovered: Color {
                bg: Qt.darker(theme.palette.warning.normal.bg, theme.palette.warning.hoveredScale)
                fg: Qt.darker(theme.palette.warning.normal.fg, theme.palette.warning.hoveredScale)
            }
            pressed: Color {
                bg: Qt.darker(theme.palette.warning.normal.bg, theme.palette.warning.pressedScale)
                fg: Qt.darker(theme.palette.warning.normal.fg, theme.palette.warning.pressedScale)
            }
        }

        placeholder: ColorSet {
            normal: Color {
                bg: "#696969"
                fg: "#696969"
            }
        }
    }
}
