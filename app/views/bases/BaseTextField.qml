import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "../theme"

TextField {
    id: baseTextField
    Layout.fillWidth: true
    Layout.preferredWidth: 128
    Layout.preferredHeight: 32

    property int maxLength: 24
    property string placeholder: "Enter some text..."

    property int cornerRadius: Theme.cornerRadius
    property color surfaceColor: Theme.palette.surface.normal.bg
    property color surfaceTextColor: Theme.palette.surface.normal.fg

    property int borderWidth: Theme.borderWidth
    property color borderColor: Theme.palette.border.normal.bg
    property color borderHoveredColor: Theme.palette.border.hovered.bg

    maximumLength: baseTextField.maxLength
    placeholderText: baseTextField.placeholder
    placeholderTextColor: Theme.palette.placeholder.normal.bg
    color: baseTextField.surfaceTextColor
    selectionColor: Theme.palette.secondary.normal.bg
    selectedTextColor: Theme.palette.secondary.normal.fg

    background: Rectangle {
        id: baseTextFieldBackground
        radius: baseTextField.cornerRadius
        border.width: baseTextField.borderWidth
        color: baseTextField.surfaceColor
        border.color: baseTextField.hovered ? (baseTextField.text.length < 4 && baseTextField.text.length > 0 ? Theme.palette.error.hovered.bg : baseTextField.borderHoveredColor) : (baseTextField.text.length < 4 && baseTextField.text.length > 0 ? Theme.palette.error.normal.bg : baseTextField.borderColor)

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
