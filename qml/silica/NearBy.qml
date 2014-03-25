import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Component.onCompleted: {
        positionSource.start();
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            console.log('NearBy get active status');
            positionSource.updateInterval = 2000;
        } else if (status === PageStatus.Deactivating) {
            console.log('NearBy lost active status');
            positionSource.updateInterval = 10000;
        }
    }

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
                id: header
                title: "Near By"
            }

            SilicaListView {
                id: nearbyList
                anchors.top: header.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                clip: true

                VerticalScrollDecorator {}

                ViewPlaceholder {
                    enabled: nearbyList.count == 0
                    text: "Looking for stations"
                    anchors.top: parent.top
                }

                model: nearbyModel

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
                        text: model.name
                    }

                    onClicked: pageStack.push(resultPage, {station: model.name})

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
}
