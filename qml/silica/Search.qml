import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }

            MenuItem {
                text: "Near By"
                onClicked: pageStack.replace(Qt.resolvedUrl("NearBy.qml"))
            }
        }

        PageHeader {
            id: header
            title: "Search"
        }

        TextField {
            id: searchInput
            width: parent.width
            placeholderText: "Station"
            label: "Station"

            anchors.top: header.bottom

            onTextChanged: py.call('glue.gui_search.stops.get', [text], function(result) { //FIXME timer
    searchList.model = result;  
})
        }

        SilicaListView {
            id: searchList
            anchors.top: searchInput.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true           

            VerticalScrollDecorator {}

            ViewPlaceholder {
                enabled: searchList.count == 0
                text: "Search stations"
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
                    text: modelData
                }

                onClicked: pageStack.push(Qt.resolvedUrl("Result.qml"), {station: modelData})

                Component {
                    id: contextMenu

                    ContextMenu {
                        MenuItem {
                            text: "Add to favourites" //FIXME do add / remove
                        }
                    }
                }
            }
        }
    }
}
