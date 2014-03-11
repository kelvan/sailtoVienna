import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        SilicaFlickable {
            anchors.fill: parent
            PullDownMenu {
                MenuItem {
                    text: "Settings"
                    onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
                }
                MenuItem {
                    text: "Search"
                    onClicked: pageStack.replace(Qt.resolvedUrl("Search.qml"))
                }
            }
            PageHeader {
                title: "Near By"
            }
        }
    }
}
