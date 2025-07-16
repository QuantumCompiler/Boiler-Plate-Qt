import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import App.Styles 1.0
import "../Components" as Components

Rectangle {
    color: "transparent"
    id: simPage
    
    ColumnLayout {
        spacing: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 8

        Components.DashboardHeader {
            label: "C++"
        }
    }
}