import QtQuick 2.0
import Sailfish.Silica 1.0

import "db.js" as Db

Page {
    property string station
    property bool refreshing: false
    property var resultList: ListModel {}
    property int refreshRate: 0

    Timer {
        id: refreshTimer
        interval: refreshRate
        running: refreshRate > 0
        repeat: true
        triggeredOnStart: false
        onTriggered: refresh()
     }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            Db.addRecent(appWindow, station);
            Db.isFavorite(station, function callback(isFav) {
                favoriteItem.isFavorite = isFav;
            });
            resultList.clear();
            refresh();
            Db.getSetting('autorefresh', 0, function(value) {
                refreshRate = parseInt(value, 0) * 1000;
            });
        } else if (status === PageStatus.Deactivating) {
            refreshRate = 0;
        }
    }

    SilicaListView {
        id: departureList
        anchors.fill: parent

        VerticalScrollDecorator {}

        PullDownMenu {
            busy: refreshing

            MenuItem {
                id: favoriteItem
                property bool isFavorite
                //% "Remove from favourites"
                text: isFavorite? qsTrId("remove-from-favourites"):
                //% "Add to favourites"
                qsTrId("add-to-favourites")
                onClicked: {
                    if(isFavorite) {
                        Db.removeFavorite(station, function callback(){
                            isFavorite = false;
                        });
                    } else {
                        Db.addFavorite(station, function callback(){
                            isFavorite = true;
                        });
                    }
                }
            }

            MenuItem {
                //% "Refreshing..."
                text: refreshing ? qsTrId("refreshing...") :
                //% "Refresh"
                qsTrId("refresh")
                enabled: !refreshing
                onClicked: refresh()
            }
        }

        header: Column {
            width: parent.width

            PageHeader {
                //% "Result"
                title: qsTrId("result")
            }

            Item {
                width: parent.width
                height: Theme.itemSizeMedium

                Label {
                    anchors {
                        left: parent.left
                        right: busy.running ? busy.left: busy.right
                        margins: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }

                    text: station
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    truncationMode: TruncationMode.Fade
                }

                BusyIndicator {
                    id: busy
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: Theme.paddingLarge
                    }
                    running: refreshing
                }
            }
        }

        ViewPlaceholder {
            enabled: departureList.count == 0 && !refreshing
            //% "No departures found"
            text: qsTrId("no-departures-found")
        }

        model: resultList

        delegate: ListItem {
            width: parent.width
            height: Theme.itemSizeSmall

            Row {
                anchors.fill: parent
                anchors.margins: Theme.paddingLarge

                Label {
                    width: parent.width * 0.25 - image.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.line.name
                }

                Image {
                    id: image
                    anchors.verticalCenter: parent.verticalCenter
                    source: model.line.barrierFree ? Qt.resolvedUrl('wheelchair.png') : ''
                }

                Label {
                    width: parent.width * 0.6
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.line.towards
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    width: parent.width * 0.15
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    text: model.countdown
                }
            }
        }
    }

    function refresh() {
        if(!refreshing) {
            refreshing = true;
            console.log('refreshing');
            py.call('glue.gui_departures.deps.get',
                [station], function(result) {
                    resultList.clear()
                    if(result)
                        result.forEach(function(entry) {
                            resultList.append(entry)
                        })
                    refreshing = false;
            });
        }
    }
}
