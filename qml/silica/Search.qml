import QtQuick 2.0
import Sailfish.Silica 1.0

import "db.js" as Db

Page {
    SilicaFlickable {
        id: searchFlick
        anchors.fill: parent

        VerticalScrollDecorator {}

        Timer {
            id: searchDelay
            interval: 500
            running: false
            repeat: false

            onTriggered: py.call('glue.gui_search.stops.get', [searchInput.text], function(result) {
                searchList.model = result;
                searchFlick.contentHeight = header.height + searchInput.height + searchList.count * Theme.itemSizeMedium
            });
        }

        PullDownMenu {
            MenuItem {
                //% "Settings"
                text: qsTrId("settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }

            MenuItem {
                //% "Nearby"
                text: qsTrId("nearby")
                onClicked: pageStack.replace(Qt.resolvedUrl("NearBy.qml"))
            }
        }

        PageHeader {
            id: header
            //% "Search"
            title: qsTrId("search")
        }

        TextField {
            id: searchInput
            width: parent.width
            //% "Station"
            placeholderText: qsTrId("station")
            label: qsTrId("station")

            anchors.top: header.bottom

            onTextChanged: if(text.length > 2) searchDelay.restart()
        }

        SilicaListView {
            id: searchList
            anchors.top: searchInput.bottom
            anchors.bottom: parent.bottom
            interactive : false
            width: parent.width
            clip: true

            ViewPlaceholder {
                enabled: searchList.count == 0
                //% "Search stations"
                text: qsTrId("search-stations")
                anchors.top: parent.top
            }

            model: ListModel {}

            delegate: ListItem {
                width: parent.width
                contentHeight: Theme.itemSizeMedium

                menu: contextMenu

                Label {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: Theme.paddingLarge
                    }
                    text: Theme.highlightText(modelData, searchInput.text, Theme.highlightColor)
                }

                onClicked: pageStack.push(resultPage, {station: modelData})

                Component {
                    id: contextMenu

                    ContextMenu {
                        MenuItem {
                            //% "Add to favourites"
                            text: qsTrId("add-to-favourites") //FIXME do add / remove
                        }
                    }
                }
            }
        }
    }
}
