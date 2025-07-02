import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import App.Styles 1.0
import "../JS/helpers.js" as Helpers
import "Components" as Components

ApplicationWindow {
    id: homeWindow
    visible: true
    width: 800
    height: 500
    minimumWidth: 800
    minimumHeight: 500
    title: "Boiler Plate Qt"

    property string cppView: "C++"
    property string pythonView: "Python"
    property string currentView: cppView

    background: Rectangle {
        color: Style.blueFocus
    }

    // Main column layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top Dashboard bar
        Rectangle {
            id: dashboardBar
            height: 50
            width: parent.width

            // Bottom border line
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "white"
            }

            // Dashboard label
            Text {
                text: "DASHBOARD - " + homeWindow.currentView
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                color: "white"
                font.pixelSize: 14
                font.bold: true
                font.capitalization: Font.AllUppercase
            }
        }

        // Main content area split: sidebar + main panel
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Sidebar
            Rectangle {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
                color: Style.dashBoardSide

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    spacing: 8
                    width: parent.width - 32

                    Components.RoundedButton {
                        id: cppViewBtn
                        btnText: cppView
                        btnHeight: 50
                        btnWidth: 150
                        btnRadius: 6
                        btnColor: Style.defaultBtn
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            homeWindow.currentView = cppViewBtn.text;
                        }
                    }

                    Components.RoundedButton {
                        id: pythonViewBtn
                        btnText: pythonView
                        btnHeight: 50
                        btnWidth: 150
                        btnRadius: 6
                        btnColor: Style.defaultBtn
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            homeWindow.currentView = pythonViewBtn.text;
                        }
                    }
                }
            }

            // Main content placeholder
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.dashBoardMain

                // Dynamic content loader
                Loader {
                    id: contentLoader
                    anchors.fill: parent
                    anchors.margins: 20

                    source: {
                        switch(homeWindow.currentView) {
                            case cppView:
                                return "Pages/C++.qml"
                            case pythonView:
                                return "Pages/Python.qml"
                            default:
                                return "Pages/C++.qml"
                        }
                    }
                }
            }
        }
    }
}