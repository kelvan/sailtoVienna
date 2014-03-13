import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

import io.thp.pyotherside 1.2

ApplicationWindow {
    id: appWindow
    cover: Qt.resolvedUrl('CoverContainer.qml')
    property var recent: ListModel {}

    function loadRecent() {
        var db = LocalStorage.openDatabaseSync("sailtoVienna", "1", "sailtoVienna settings and recent", 1000)
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS recent(station TEXT, date INTEGER)')
        })

        db.readTransaction(function(tx) {
            var result = tx.executeSql('SELECT station FROM recent ORDER BY date DESC LIMIT 5')
            for(var i = 0; i < result.rows.length; i++) {
                recent.append({ station: result.rows.item(i).station })
            }
        })
    }

    function clearRecent() {
        var db = LocalStorage.openDatabaseSync("sailtoVienna", "1", "sailtoVienna settings and recent", 1000)
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM recent')
            recent.clear()
        })
    }

    Component.onCompleted: loadRecent()

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../'));
            importModule('glue.gui_search', null);
            importModule('glue.gui_departures', null);
        }
    }

    initialPage: Page {

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
                MenuItem {
                    enabled: recent.count
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

    Result {
        id: resultPage
    }
}
