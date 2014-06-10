import QtQuick 2.0
import Sailfish.Silica 1.0

import "db.js" as Db

Page {
    Component.onCompleted: {
        positionSource.start();
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            positionSource.updateInterval = 2000;
        } else if (status === PageStatus.Deactivating) {
            positionSource.updateInterval = 10000;
        }
    }

    SilicaFlickable {
        VerticalScrollDecorator {}

        contentHeight: nearbyPageContentHeight

        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                //% "Settings"
                text: qsTrId("settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                //% "Search"
                text: qsTrId("search")
                onClicked: pageStack.replace(Qt.resolvedUrl("Search.qml"))
            }
        }

        PageHeader {
            id: header
            //% "Nearby"
            title: qsTrId("nearby")
        }

        SilicaListView {
            id: nearbyList
            interactive: false
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true

            ViewPlaceholder {
                enabled: nearbyList.count == 0
                //% "Looking for stations"
                text: qsTrId("looking-for-stations")
                anchors.top: parent.top
            }

            model: nearbyModel

            delegate: ListItem {
                property bool isFavorite

                width: parent.width
                contentHeight: Theme.itemSizeMedium

                menu: contextMenu

                Row {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingLarge

                    Label {
                        width: parent.width * 0.25
                        anchors.verticalCenter: parent.verticalCenter
                        //% "km"
                        text: model.distance + " " + qsTrId("km")
                    }

                    Label {
                        width: parent.width * 0.75
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.name
                        truncationMode: TruncationMode.Fade
                    }
                }

                onClicked: pageStack.push(resultPage, {station: model.name})

                Component {
                    id: contextMenu

                    ContextMenu {
                        MenuItem {
                            //% "Remove from favourites"
                            text: isFavorite? qsTrId("remove-from-favourites"):
                            //% "Add to favourites"
                            qsTrId("add-to-favourites")

                            Component.onCompleted: {
                                Db.isFavorite(model.name, function(result) {
                                    isFavorite = result;
                                });
                            }
                            onClicked: {
                                if(isFavorite) {
                                    Db.removeBookmark(model.name, function(){
                                        isFavorite = false;
                                    });
                                } else {
                                    Db.addBookmark(model.name, function(){
                                        isFavorite = true;
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
