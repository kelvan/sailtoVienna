import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

import io.thp.pyotherside 1.0

ApplicationWindow {
    width: 400
    height: 600

    color: 'white'

    title: 'SailtoVienna'

    RectangularGlow {
        id: effect
        anchors.fill: searchInput_rect
        glowRadius: 15
        spread: 0.5
        color: "lightgray"
        cornerRadius: searchInput_rect.radius + glowRadius
    }

    Rectangle {
        id: searchInput_rect
        color: 'white'
        radius: 5

        height: 30
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }
    }

    TextInput {
        id: searchInput
        color: 'black'
        focus: true
        font.pixelSize: 16

        anchors {
            verticalCenter: searchInput_rect.verticalCenter
            left: searchInput_rect.left
            leftMargin: 10
        }

        onAccepted: {
            py.call('gui_search.stops.get', [text], function(result) {
                stopList.model = result;
            });
        }

        onTextChanged: {
            accepted()
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

    RectangularGlow {
        id: effect_list
        anchors.fill: stopList_rect
        glowRadius: 15
        spread: 0.5
        color: "lightgray"
        cornerRadius: stopList_rect.radius + glowRadius
    }

    Rectangle {
        id: stopList_rect

        radius: 10
        color: 'white'
        anchors {
            top: searchInput_rect.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        ListView {
            anchors {
                fill: parent
                margins: 10
            }
            id: stopList
            delegate: Text {
                text: modelData
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log('clicked: ' + text);
                        py.call('gui_departures.deps.get', [text], function(result) {
                            stopList.model = result;
                        });
                    }
                }
            }
        }
    }
}
