pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import "../bases"
import "../theme"

BaseMenu {
    id: portMenu

    property string placeholderPort: "No devices available"

    delegate: ItemDelegate {
        id: portMenuItemDelegate
        width: ListView.view.width
        enabled: portMenuItemDelegate.model.port !== portMenu.placeholderPort

        required property int index
        required property var model

        background: Rectangle {
            id: delegateBackground
            opacity: portMenuItemDelegate.hovered ? 0.1 : 1.0
            radius: Theme.cornerRadius
            color: (delegateText.text === portMenu.placeholderPort) ? "transparent" : portMenuItemDelegate.hovered ? Theme.palette.primary.hovered.bg : "transparent"
        }

        contentItem: Text {
            id: delegateText
            text: portMenuItemDelegate.model.port
            leftPadding: Theme.padding / 2
            rightPadding: Theme.padding / 2
            verticalAlignment: Text.AlignVCenter
            color: (delegateText.text === portMenu.placeholderPort) ? Theme.palette.surface.normal.fg : portMenuItemDelegate.hovered ? Theme.palette.surface.hovered.fg : Theme.palette.surface.normal.fg
        }

        onClicked: {
            if (portMenuItemDelegate.model.port === portMenu.placeholderPort) {
                return;
            }

            portMenu.currentIndex = portMenuItemDelegate.index;
            portMenu.popup.close();
        }
    }
}
