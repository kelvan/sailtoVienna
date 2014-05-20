import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Search.qml"), {});
            updateFlickHeight();
        }
    }

    SilicaFlickable {
        id: startFlick
        contentHeight: startPageContentHeight
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                //% "Settings"
                text: qsTrId("settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                //% "Nearby"
                text: qsTrId("nearby")
                onClicked: pageStack.push(Qt.resolvedUrl("NearBy.qml"))
            }
        }

        PushUpMenu {
            visible: appWindow.recent.count
            enabled: appWindow.recent.count

            MenuItem {
                //% "Clear recent"
                text: qsTrId("clearrecent")
                onClicked: clearRecent()
            }
        }

        PageHeader {
            id: favHeader
            //% "Bookmarks"
            title: qsTrId("bookmarks")
        }
        Column {
            id: favList
            anchors.top: favHeader.bottom
            width: parent.width
            Repeater {
                id:favRepeater
                model: appWindow.favorites

                ListItem {
                    contentHeight: Theme.itemSizeSmall
                    onClicked: pageStack.push(resultPage, {station: model.station})

                    Label {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: Theme.paddingLarge
                        }
                        text: model.station
                    }
                }
            }
        }

        PageHeader {
            id: recentHeader
            anchors.top: favList.bottom
            //% "Recent"
            title: qsTrId("recent")
        }
        Column {
            id: recentList
            anchors.top: recentHeader.bottom
            width: parent.width
            Repeater {
                id: recentRepeater
                model: recent

                ListItem {
                    contentHeight: Theme.itemSizeSmall
                    onClicked: pageStack.push(resultPage, {station: model.station})

                    Label {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: Theme.paddingLarge
                        }
                        text: model.station
                    }
                }
            }
        }
    }
}
