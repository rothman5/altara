import QtQuick
import QtQuick.Controls.Basic
import "../theme"

ToolTip {
    id: baseToolTip
    opacity: 0.0
    delay: Theme.animationDuration

    background: Rectangle {
        id: toolTipBackground
        radius: Theme.cornerRadius / 2
        color: Qt.lighter(Theme.palette.surface.normal.bg, 4.0)

        Canvas {
            id: triangle
            width: 12
            height: 6
            anchors.topMargin: -1
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.fillStyle = toolTipBackground.color;
                ctx.beginPath();
                ctx.moveTo(width / 2, height);
                ctx.lineTo(0, 0);
                ctx.lineTo(width, 0);
                ctx.closePath();
                ctx.fill();
            }
        }
    }

    contentItem: Text {
        id: toolTipText
        text: baseToolTip.text
        wrapMode: Text.WordWrap
        font.weight: Font.Medium
        font.pixelSize: Theme.FontSize.XSMALL
        padding: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: Theme.palette.surface.normal.fg
    }

    onVisibleChanged: {
        if (baseToolTip.visible) {
            baseToolTip.opacity = 1.0;
            autoHideTimer.restart();
        } else {
            baseToolTip.opacity = 0.0;
            autoHideTimer.stop();
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.InOutQuad
            onStopped: {
                if (baseToolTip.opacity === 0) {
                    baseToolTip.visible = false;
                }
            }
        }
    }

    Timer {
        id: autoHideTimer
        repeat: false
        interval: Theme.animationDuration * 20
        onTriggered: {
            baseToolTip.opacity = 0.0;
        }
    }
}
