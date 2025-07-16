import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import App.Styles 1.0

Button {
    property string btnText: "Default"
    property bool btnEnable: true
    property bool btnHover: true
    property bool btnTextBold: true
    property int btnHeight: 50
    property int btnWidth: 0
    property int btnRadius: 12
    property int btnTextSize: 14
    property color btnColor: Style.defaultBtn
    property color btnHoverColor: "transparent"
    property color btnTextColor: "white"

    text: btnText
    enabled: btnEnable
    Layout.preferredHeight: btnHeight
    width: btnWidth > 0 ? btnWidth : implicitWidth

    background: Rectangle {
        color: btnColor
        radius: btnRadius

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: btnHover
            onEntered: parent.color = btnHoverColor
            onExited: parent.color = btnColor
            onClicked: parent.parent.clicked()
        }
    }

    contentItem: Text {
        text: btnText
        color: btnTextColor
        font.pixelSize: btnTextSize
        font.bold: btnTextBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
    }
}