import QtQuick
import "../theme"

Rectangle {
    id: notification
    width: notificationText.implicitWidth + 24
    height: 32
    radius: Theme.cornerRadius * 2
    color: notification.fillColor
    opacity: 0
    visible: opacity > 0
    z: 100
    anchors.margins: 2
    anchors.topMargin: -36
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    property color fillColor: Theme.palette.info.normal.bg
    property color textColor: Theme.palette.info.normal.fg

    function showInfo(message) {
        notification.fillColor = Theme.palette.info.normal.bg;
        notification.textColor = Theme.palette.info.normal.fg;
        showMessage(message);
    }

    function showError(message) {
        notification.fillColor = Theme.palette.error.normal.bg;
        notification.textColor = Theme.palette.error.normal.fg;
        showMessage(message);
    }

    function showSuccess(message) {
        notification.fillColor = Theme.palette.success.normal.bg;
        notification.textColor = Theme.palette.success.normal.fg;
        showMessage(message);
    }

    function showWarning(message) {
        notification.fillColor = Theme.palette.warning.normal.bg;
        notification.textColor = Theme.palette.warning.normal.fg;
        showMessage(message);
    }

    function showMessage(message) {
        showAnimation.stop();
        fadeOutAnimation.stop();
        pauseTimer.stop();
        notificationText.text = message;
        showAnimation.from = notification.opacity;
        showAnimation.start();
    }

    Text {
        id: notificationText
        font.pixelSize: Theme.FontSize.BODY
        font.weight: Font.Medium
        color: notification.textColor
        anchors.centerIn: parent
    }

    Timer {
        id: pauseTimer
        interval: Theme.animationDuration * 10
        onTriggered: fadeOutAnimation.start()
    }

    NumberAnimation {
        id: showAnimation
        target: notification
        property: "opacity"
        from: 0
        to: 1
        duration: 200
        easing.type: Easing.OutQuad
        onFinished: pauseTimer.start()
    }

    NumberAnimation {
        id: fadeOutAnimation
        target: notification
        property: "opacity"
        from: 1
        to: 0
        duration: 300
        easing.type: Easing.InQuad
    }
}
