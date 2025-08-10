import QtQuick
import QtQuick.Layouts
import "../bases"
import "../theme"

Rectangle {
    id: deviceItem
    implicitHeight: deviceItemLayout.implicitHeight + Theme.padding * 2
    radius: Theme.cornerRadius
    border.width: Theme.borderWidth
    color: Theme.palette.surface.normal.bg
    border.color: Theme.palette.border.normal.bg

    signal toggleConnection
    signal actionButtonPressed

    property var deviceRef: null
    property var dialogRef: null

    Behavior on border.color {
        ColorAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    HoverHandler {
        id: deviceItemHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        onHoveredChanged: {
            deviceItem.border.color = deviceItemHoverHandler.hovered ? Theme.palette.border.hovered.bg : Theme.palette.border.normal.bg;
        }
    }

    MouseArea {
        id: deviceItemMouseArea
        hoverEnabled: true
        propagateComposedEvents: true
        preventStealing: true
        anchors.fill: parent
        onClicked: {
            if (!deviceItemActionButton.pressed && !deviceItemConnectButton.pressed && !(deviceItem.deviceRef && deviceItem.deviceRef.connected || false)) {
                deviceItem.dialogRef.editing = true;
                deviceItem.dialogRef.deviceRef = deviceItem.deviceRef;
                deviceItem.dialogRef.open();
            }
        }
    }

    RowLayout {
        id: deviceItemLayout
        anchors.fill: parent
        anchors.topMargin: Theme.padding
        anchors.bottomMargin: Theme.padding
        anchors.leftMargin: Theme.padding
        anchors.rightMargin: Theme.padding

        Column {
            id: deviceItemTextColumn
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

            Text {
                id: deviceItemNameText
                text: deviceItem.deviceRef && deviceItem.deviceRef.name || ""
                font.bold: true
                font.pixelSize: Theme.FontSize.MEDIUM
                color: Theme.palette.surface.normal.fg
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }

            Text {
                id: deviceItemStatusText
                text: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? "Connected" : "Disconnected"
                font.pixelSize: Theme.FontSize.SMALL
                color: Theme.palette.surface.disabled.fg
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }
        }

        Row {
            id: deviceItemActionRow
            spacing: Theme.padding
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            BaseButton {
                id: deviceItemActionButton
                borderWidth: 0
                iconSource: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? "../assets/configure.svg" : "../assets/delete.svg"
                iconColor: Theme.palette.info.normal.fg
                surfaceColor: Theme.palette.info.normal.bg
                surfaceTextColor: Theme.palette.info.normal.fg
                surfaceHoveredColor: Theme.palette.info.hovered.bg
                surfaceHoveredTextColor: Theme.palette.info.hovered.fg
                surfacePressedColor: Theme.palette.info.pressed.bg
                surfacePressedTextColor: Theme.palette.info.pressed.fg
                surfaceDisabledColor: Theme.palette.info.disabled.bg
                surfaceDisabledTextColor: Theme.palette.info.disabled.fg
                onClicked: {
                    deviceItem.actionButtonPressed();
                }

                BaseToolTip {
                    id: actionButtonToolTip
                    parent: deviceItemActionButton
                    text: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? "Open configuration" : "Remove device"
                    visible: deviceItemActionButton.hovered && !deviceItemActionButton.pressed
                }
            }

            BaseButton {
                id: deviceItemConnectButton
                borderWidth: 0
                iconSource: "../assets/power.svg"
                iconColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.normal.fg : Theme.palette.success.normal.fg
                surfaceColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.normal.bg : Theme.palette.success.normal.bg
                surfaceTextColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.normal.fg : Theme.palette.success.normal.fg
                surfaceHoveredColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.hovered.bg : Theme.palette.success.hovered.bg
                surfaceHoveredTextColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.hovered.fg : Theme.palette.success.hovered.fg
                surfacePressedColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.pressed.bg : Theme.palette.success.pressed.bg
                surfacePressedTextColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.pressed.fg : Theme.palette.success.pressed.fg
                surfaceDisabledColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.disabled.bg : Theme.palette.success.disabled.bg
                surfaceDisabledTextColor: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? Theme.palette.error.disabled.fg : Theme.palette.success.disabled.fg
                onClicked: {
                    deviceItem.toggleConnection();
                }

                BaseToolTip {
                    id: connectButtonToolTip
                    parent: deviceItemConnectButton
                    text: deviceItem.deviceRef && deviceItem.deviceRef.connected || false ? "Disconnect" : "Connect"
                    visible: deviceItemConnectButton.hovered && !deviceItemConnectButton.pressed
                }
            }
        }
    }
}
