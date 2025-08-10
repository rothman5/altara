import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "theme"
import "device"

ApplicationWindow {
    id: appWindow
    title: "Altara"
    visible: true
    minimumWidth: 480
    minimumHeight: 640
    font.family: Theme.fontFamily
    color: Theme.palette.background.normal.bg

    ColumnLayout {
        anchors.topMargin: Theme.padding * 8
        anchors.leftMargin: Theme.padding
        anchors.rightMargin: Theme.padding
        anchors.bottomMargin: Theme.padding
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            id: titleColumn
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Text {
                id: titleText
                text: "Device Manager"
                font.pixelSize: Theme.FontSize.XLARGE
                font.bold: true
                color: Theme.palette.surface.normal.fg
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: versionText
                text: "v1.0.0"
                font.pixelSize: Theme.FontSize.MEDIUM
                font.bold: true
                font.italic: true
                color: Qt.darker(Theme.palette.surface.normal.fg, 1.2)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        DevicePanel {
            id: devicePanel
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        }
    }
}
