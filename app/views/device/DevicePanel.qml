import QtQuick
import QtQuick.Layouts
import "../bases"
import "../theme"

Item {
    id: devicePanel
    Layout.preferredHeight: Math.min(columnLayout.implicitHeight, parent.height / 2)

    DeviceDialog {
        id: deviceDialog
        x: (parent.parent.width / 2) - (width / 2)
        y: -(parent.parent.y + (parent.parent.height / 2))
        onSubmitted: function (index, name, port, baud) {
            var model = deviceListModel;
            if (deviceDialog.editing) {
                var result = model.edit_device(index, name, port, baud);
                if (result) {
                    notification.showInfo("A device has been edited: " + name, 3000);
                } else {
                    notification.showError("Failed to edit device: " + name, 3000);
                }
            } else {
                var result = model.add_device(name, port, baud);
                if (result) {
                    notification.showInfo("A new device has been added: " + name, 3000);
                } else {
                    notification.showError("Failed to add device: " + name, 3000);
                }
            }
        }
    }

    ColumnLayout {
        id: columnLayout
        spacing: Theme.padding / 2
        anchors.fill: parent

        BaseButton {
            id: addDeviceButton
            iconSource: "../assets/plus.svg"
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            onClicked: {
                deviceDialog.editing = false;
                deviceDialog.open();
            }

            BaseToolTip {
                id: addDeviceButtonToolTip
                text: "Add a new device"
                parent: addDeviceButton
                visible: addDeviceButton.hovered && !addDeviceButton.pressed
            }
        }

        DeviceList {
            id: deviceList
            dialogRef: deviceDialog
            visible: deviceList.nitems > 0
            maxHeight: devicePanel.parent.height / 2 - addDeviceButton.height - columnLayout.spacing - devicePanel.anchors.margins * 2
            Layout.fillWidth: true
        }

        Text {
            id: noDevicesText
            visible: deviceList.nitems === 0
            text: "No devices have been added."
            font.pixelSize: Theme.FontSize.BODY
            color: Theme.palette.placeholder.normal.bg
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 32
        }
    }

    BaseNotification {
        id: notification
    }
}
