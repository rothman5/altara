pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: deviceList
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: deviceList.minHeight
    Layout.maximumHeight: deviceList.maxHeight

    property var dialogRef: null
    property int nitems: deviceListView.count
    property int minHeight: Math.min(deviceListView.contentHeight, deviceList.maxHeight)
    property int maxHeight: 240

    ListView {
        id: deviceListView
        model: deviceListModel
        clip: true
        spacing: 4
        anchors.fill: parent
        verticalLayoutDirection: ListView.BottomToTop
        onCountChanged: {
            Qt.callLater(() => {
                deviceListView.positionViewAtEnd();
            });
        }

        delegate: DeviceItem {
            id: deviceItem
            width: deviceListView.width
            deviceRef: deviceItem.device
            dialogRef: deviceList.dialogRef
            onActionButtonPressed: {
                if (connected) {
                    console.log("Open configuration for device:", name);
                } else {
                    deviceListView.model.remove_device(index);
                }
            }

            required property int index
            required property string name
            required property var device
            required property bool connected
        }
    }

    Rectangle {
        id: bottomVignette
        visible: deviceListView.contentHeight > deviceListView.height && !deviceListView.atYEnd
        height: 24
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 1.0
                color: Theme.palette.background.normal.bg
            }
        }
    }

    Rectangle {
        id: topVignette
        visible: deviceListView.contentHeight > deviceListView.height && !deviceListView.atYBeginning
        height: 24
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Theme.palette.background.normal.bg
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }
}
