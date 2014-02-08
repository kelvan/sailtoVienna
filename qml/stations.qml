import QtQuick 2.0
import io.thp.pyotherside 1.0

Rectangle {
    width: 400
    height: 600

    TextInput {
        id: searchInput

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 20

        onAccepted: {
            py.call('gui_stations.stations.get', [text], function(result) {
                console.log('got contents from Python: ' + result);
                stopList.model = result;
            });
        }

        Python {
            id: py
            Component.onCompleted: {
                addImportPath('.');
                addImportPath('pyWL');
                addImportPath('glue');
                importModule('gui_stations', function () {
                    console.log('imported python module');
                });
            }
        }
    }

    Rectangle {
        color: 'lightsteelblue'
        anchors {
            top: searchInput.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        ListView {
            anchors.fill: parent
            id: stopList
            delegate: Text { text: modelData }
        }
    }
}
