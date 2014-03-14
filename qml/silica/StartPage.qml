import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Search.qml"), {});
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: "Nearby"
                onClicked: pageStack.push(Qt.resolvedUrl("NearBy.qml"))
            }
        }

        PushUpMenu {
            visible: appWindow.recent.count

            MenuItem {
                text: "Clear recent"
                onClicked: clearRecent()
            }
        }   

        PageHeader {
            id: favHeader
            title: "Favourites"
        }
        PageHeader {
            id: recentHeader
            anchors.top: favHeader.bottom
            title: "Recent"
        }
        
        Column {
            anchors.top: recentHeader.bottom
            width: parent.width
            Repeater {
                model: recent

                ListItem {
                    contentHeight: Theme.itemSizeMedium
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
