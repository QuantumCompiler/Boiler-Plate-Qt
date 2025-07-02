import QtQuick 2.15
import QtQuick.Layouts 1.15
import App.Styles 1.0

ColumnLayout {
    spacing: 8

    property string label: "Default Header"

    Text {
        text: label
        color: "white"
        font.pixelSize: 24
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
    }

    Rectangle {
        color: Style.dividerColor
        Layout.preferredHeight: 1
        Layout.fillWidth: true
    }
}