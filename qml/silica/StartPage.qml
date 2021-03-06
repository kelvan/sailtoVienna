import QtQuick 2.0
import Sailfish.Silica 1.0

import "db.js" as Db

Page {
    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached(Qt.resolvedUrl("Search.qml"), { attached: true });
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
                id: favRepeater
                model: appWindow.favorites

                ListItem {
                    id: bookmarkItem
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

                    menu: Component {
                        id: contextMenu

                        ContextMenu {
                            MenuItem {
                                //% "Remove from favourites"
                                text: qsTrId("remove-from-favourites")
                                onClicked: {
                                    //% "Removing"
                                    bookmarkItem.remorseAction(qsTrId('removing'), function() {
                                        //Db.removeBookmark(modelData, function(success){
                                            //if(success) {
                                            //    bookmarkItem.model.remove(index);
                                            //}
                                        //});
                                    });
                                }
                            }
                        }
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
