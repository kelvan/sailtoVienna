import QtQuick 2.0
import Sailfish.Silica 1.0

import io.thp.pyotherside 1.2

ApplicationWindow {
    id: appWindow
    cover: Qt.resolvedUrl('CoverContainer.qml')

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
                    enabled: false
                    text: "Clear history"
                    onClicked: pageStack.push(console.log("clear history"))
                }
            }   

            PageHeader {
                id: topHeader
                title: "Favourites"
            }
            PageHeader {
                anchors.top: topHeader.bottom
                title: "History"
            }
        }
    }

    Result {
        id: resultPage
    }
}
