import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "../bases"
import "../theme"
import "../device"

Dialog {
    id: deviceDialog
    title: deviceDialog.editing ? "Edit a Device" : "Add a Device"
    modal: true
    width: 240

    signal submitted(int index, string name, string port, int baud)

    property bool editing: false
    property var deviceRef: null

    property string prevName: ""
    property string prevPort: ""
    property string prevBaud: ""
    property bool changed: deviceNameInput.text !== deviceDialog.prevName || devicePortInput.displayText !== deviceDialog.prevPort || deviceBaudInput.displayText !== deviceDialog.prevBaud

    onOpened: {
        portListModel.refresh(true);

        if (!deviceDialog.editing) {
            deviceDialog.prevName = "";
            deviceDialog.prevPort = "";
            deviceDialog.prevBaud = "";
            return;
        }

        deviceDialog.prevName = deviceDialog.deviceRef.name || "";
        deviceDialog.prevPort = deviceDialog.deviceRef.port || "";
        deviceDialog.prevBaud = deviceDialog.deviceRef.baud.toString() || "";

        deviceNameInput.text = deviceDialog.prevName;
        devicePortInput.displayText = deviceDialog.prevPort;

        var portIndex = devicePortInput.model.indexOf(deviceDialog.prevPort);
        if (portIndex !== -1) {
            devicePortInput.currentIndex = portIndex;
        } else {
            devicePortInput.currentIndex = 0;
        }

        var baudIndex = deviceBaudInput.model.indexOf(deviceDialog.prevBaud);
        if (baudIndex !== -1) {
            deviceBaudInput.currentIndex = baudIndex;
        } else {
            deviceBaudInput.currentIndex = 0;
        }
    }

    onClosed: {
        portListModel.stop_refresh();
    }

    onAccepted: {
        var name = deviceNameInput.text.trim();
        var port = devicePortInput.displayText;
        var baud = deviceBaudInput.displayText;
        var index = deviceListModel.get_index(deviceDialog.deviceRef);

        deviceDialog.submitted(index, name, port, parseInt(baud));
        deviceNameInput.clear();
        devicePortInput.currentIndex = 0;
        deviceBaudInput.currentIndex = 0;
    }

    onRejected: {
        deviceNameInput.clear();
        devicePortInput.currentIndex = 0;
        deviceBaudInput.currentIndex = 0;
        devicePortInput.displayText = portListModel.available()[devicePortInput.currentIndex];
    }

    background: Rectangle {
        id: dialogBackground
        radius: Theme.cornerRadius
        border.width: Theme.borderWidth
        color: Theme.palette.surface.normal.bg
        border.color: Theme.palette.border.normal.bg
    }

    contentItem: ColumnLayout {
        id: dialogContent
        spacing: 0
        width: parent.width
        anchors.margins: 0
        anchors.fill: parent

        RowLayout {
            id: titleRow
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.leftMargin: 8
            Layout.rightMargin: 0
            Layout.topMargin: 0
            Layout.bottomMargin: 0
            Layout.preferredHeight: 24

            Text {
                id: dialogTitle
                text: deviceDialog.title
                font.bold: true
                font.pixelSize: Theme.FontSize.MEDIUM
                color: Theme.palette.surface.normal.fg
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }

            BaseButton {
                id: closeButton
                borderWidth: 0
                surfaceColor: "transparent"
                surfaceTextColor: Theme.palette.surface.normal.fg
                surfaceHoveredColor: "transparent"
                surfaceHoveredTextColor: Theme.palette.primary.hovered.bg
                surfacePressedColor: "transparent"
                surfacePressedTextColor: Theme.palette.primary.pressed.bg
                surfaceDisabledColor: "transparent"
                surfaceDisabledTextColor: Theme.palette.surface.disabled.fg
                iconSource: "../assets/close.svg"
                iconColor: closeButton.pressed ? Theme.palette.primary.pressed.bg : closeButton.hovered ? Theme.palette.primary.hovered.bg : Theme.palette.surface.normal.fg
                Layout.topMargin: 3
                Layout.rightMargin: 1
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                onClicked: {
                    deviceDialog.reject();
                }
            }
        }

        Rectangle {
            id: titleSeparator
            color: dialogBackground.border.color
            opacity: 0.75
            Layout.fillWidth: true
            Layout.leftMargin: 0
            Layout.rightMargin: 0
            Layout.topMargin: 0
            Layout.bottomMargin: 8
            Layout.preferredHeight: dialogBackground.border.width
        }

        Text {
            id: deviceNameLabel
            text: "Device Name"
            font.bold: true
            font.pixelSize: Theme.FontSize.BODY
            color: Theme.palette.surface.disabled.fg
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 0
            Layout.bottomMargin: 0
            Layout.alignment: Qt.AlignLeft
        }

        BaseTextField {
            id: deviceNameInput
            placeholder: "Enter device name..."
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 4
        }

        Text {
            id: devicePortLabel
            text: "COM Port"
            font.bold: true
            font.pixelSize: Theme.FontSize.BODY
            color: Theme.palette.surface.disabled.fg
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 0
            Layout.alignment: Qt.AlignLeft
        }

        PortMenu {
            id: devicePortInput
            model: portListModel
            textRole: "port"
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 4
        }

        Text {
            id: deviceBaudLabel
            text: "Baudrate"
            font.bold: true
            font.pixelSize: Theme.FontSize.BODY
            color: Theme.palette.surface.disabled.fg
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 0
            Layout.alignment: Qt.AlignLeft
        }

        BaseMenu {
            id: deviceBaudInput
            model: ["9600", "38400", "115200", "460800", "921600", "1000000", "5000000"]
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 0
        }

        RowLayout {
            id: buttonRow
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            BaseButton {
                id: cancelButton
                text: "Cancel"
                borderColor: Theme.palette.primary.normal.bg
                borderHoveredColor: Theme.palette.primary.hovered.bg
                borderPressedColor: Theme.palette.primary.pressed.bg
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: dialogContent.width / 2
                onClicked: {
                    deviceDialog.reject();
                }
            }

            BaseButton {
                id: submitButton
                enabled: deviceDialog.changed && (deviceNameInput.text.length >= 4) && (devicePortInput.displayText.length > 0)
                text: deviceDialog.editing ? "Save" : "Add"
                borderWidth: 0
                surfaceColor: Theme.palette.primary.normal.bg
                surfaceTextColor: Theme.palette.primary.normal.fg
                surfaceHoveredColor: Theme.palette.primary.hovered.bg
                surfaceHoveredTextColor: Theme.palette.primary.hovered.fg
                surfacePressedColor: Theme.palette.primary.pressed.bg
                surfacePressedTextColor: Theme.palette.primary.pressed.fg
                surfaceDisabledColor: Theme.palette.primary.disabled.bg
                surfaceDisabledTextColor: Theme.palette.primary.disabled.fg
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: dialogContent.width / 2
                onClicked: {
                    deviceDialog.accept();
                }
            }
        }
    }

    header: Rectangle {
        visible: false
    }

    footer: Rectangle {
        visible: false
    }
}
