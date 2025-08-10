pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "../theme"

ComboBox {
    id: baseMenu
    Layout.fillWidth: true
    Layout.preferredWidth: 128
    Layout.preferredHeight: 32

    property bool fade: true

    background: Rectangle {
        id: baseMenuBackground
        radius: Theme.cornerRadius
        border.width: Theme.borderWidth
        anchors.fill: parent
        color: !baseMenu.enabled ? Theme.palette.surface.disabled.bg : Theme.palette.surface.normal.bg
        border.color: !baseMenu.enabled ? Theme.palette.border.disabled.bg : baseMenu.popup.visible || baseMenu.hovered ? Theme.palette.border.hovered.bg : Theme.palette.border.normal.bg

        Behavior on border.color {
            enabled: baseMenu.fade
            ColorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    contentItem: Text {
        id: baseMenuText
        text: baseMenu.displayText
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        leftPadding: Theme.padding
        rightPadding: baseMenu.indicator.width + baseMenu.spacing
        color: !baseMenu.enabled ? Theme.palette.surface.disabled.fg : baseMenu.popup.visible || baseMenu.hovered ? Theme.palette.surface.hovered.fg : Theme.palette.surface.normal.fg
    }

    indicator: Canvas {
        id: baseMenuIndicator
        width: 12
        height: 8
        anchors.rightMargin: 8
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.strokeStyle = !baseMenu.enabled ? Theme.palette.surface.disabled.fg : baseMenu.popup.visible || baseMenu.hovered ? Theme.palette.surface.hovered.fg : Theme.palette.surface.normal.fg;
            ctx.lineWidth = 2;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            ctx.beginPath();
            ctx.moveTo(2, 2);
            ctx.lineTo(width / 2, height - 2);
            ctx.lineTo(width - 2, 2);
            ctx.stroke();
        }
    }

    popup: Popup {
        id: baseMenuPopup
        width: baseMenu.width
        y: baseMenu.height

        background: Rectangle {
            id: popupBackground
            radius: Theme.cornerRadius
            border.width: Theme.borderWidth
            color: Theme.palette.surface.normal.bg
            border.color: Theme.palette.border.normal.bg
        }

        contentItem: ListView {
            id: popupListView
            clip: true
            implicitHeight: popupListView.contentHeight
            model: baseMenu.popup.visible ? baseMenu.delegateModel : null
            currentIndex: baseMenu.highlightedIndex
        }
    }

    delegate: ItemDelegate {
        id: baseMenuItemDelegate
        width: ListView.view.width

        required property int index
        required property var modelData

        background: Rectangle {
            id: delegateBackground
            opacity: baseMenuItemDelegate.hovered ? 0.1 : 1.0
            radius: Theme.cornerRadius
            color: baseMenuItemDelegate.hovered ? Theme.palette.primary.hovered.bg : "transparent"
        }

        contentItem: Text {
            id: delegateText
            text: baseMenuItemDelegate.modelData
            leftPadding: Theme.padding / 2
            rightPadding: Theme.padding / 2
            verticalAlignment: Text.AlignVCenter
            color: baseMenuItemDelegate.hovered ? Theme.palette.surface.hovered.fg : Theme.palette.surface.normal.fg
        }

        onClicked: {
            baseMenu.currentIndex = baseMenuItemDelegate.index;
            baseMenu.popup.close();
        }
    }
}
