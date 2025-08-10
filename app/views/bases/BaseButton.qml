import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "../theme"

Button {
    id: baseButton
    Layout.preferredHeight: 32

    property bool scale: true
    property bool fade: true

    property string iconSource: ""
    property int iconSize: 16
    property color iconColor: Theme.palette.surface.normal.fg

    property int cornerRadius: Theme.cornerRadius
    property color surfaceColor: Theme.palette.surface.normal.bg
    property color surfaceTextColor: Theme.palette.surface.normal.fg
    property color surfaceHoveredColor: Theme.palette.surface.hovered.bg
    property color surfaceHoveredTextColor: Theme.palette.surface.hovered.fg
    property color surfacePressedColor: Theme.palette.surface.pressed.bg
    property color surfacePressedTextColor: Theme.palette.surface.pressed.fg
    property color surfaceDisabledColor: Theme.palette.surface.disabled.bg
    property color surfaceDisabledTextColor: Theme.palette.surface.disabled.fg

    property int borderWidth: Theme.borderWidth
    property color borderColor: Theme.palette.border.normal.bg
    property color borderHoveredColor: Theme.palette.border.hovered.bg
    property color borderPressedColor: Theme.palette.border.pressed.bg
    property color borderDisabledColor: Theme.palette.border.disabled.bg

    palette.buttonText: !baseButton.enabled ? baseButton.surfaceDisabledTextColor : baseButton.pressed ? baseButton.surfacePressedTextColor : baseButton.hovered ? baseButton.surfaceHoveredTextColor : baseButton.surfaceTextColor

    icon.source: baseButton.iconSource
    icon.width: baseButton.iconSize
    icon.height: baseButton.iconSize
    icon.color: baseButton.iconColor

    Behavior on icon.color {
        ColorAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    background: Rectangle {
        id: baseButtonBackground
        radius: baseButton.cornerRadius
        border.width: baseButton.borderWidth
        anchors.fill: parent
        color: !baseButton.enabled ? baseButton.surfaceDisabledColor : baseButton.pressed ? baseButton.surfacePressedColor : baseButton.hovered ? baseButton.surfaceHoveredColor : baseButton.surfaceColor
        border.color: !baseButton.enabled ? baseButton.borderDisabledColor : baseButton.pressed ? baseButton.borderPressedColor : baseButton.hovered ? baseButton.borderHoveredColor : baseButton.borderColor

        Behavior on color {
            enabled: baseButton.fade
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on border.color {
            enabled: baseButton.fade
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    transform: Scale {
        id: baseButtonScale
        origin.x: baseButton.width / 2
        origin.y: baseButton.height / 2
        xScale: (baseButton.scale && baseButton.pressed) ? 0.98 : 1
        yScale: (baseButton.scale && baseButton.pressed) ? 0.98 : 1

        Behavior on xScale {
            NumberAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on yScale {
            NumberAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
