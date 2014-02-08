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
        //height: 20

        onAccepted: {
            py.call('gui_search.stops.get', [text], function(result) {
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
                importModule('gui_search', function () {
                    console.log('imported python module');
                });
                importModule('gui_departures', function () {
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
            delegate: Text {
                text: modelData
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log('clicked: ' + text);
                        py.call('gui_departures.deps.get', [text], function(result) {
                            console.log('got contents from Python: ' + result);
                            stopList.model = result;
                        });
                    }
                }
            }
        }
    }
}
