import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

import io.thp.pyotherside 1.0

ApplicationWindow {
    property bool stopListVisible: false
    property bool departureListVisible: false

    id: window

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
                show_stopList();
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

    // ===============================
    // | end search, begin list      |
    // ===============================

    RectangularGlow {
        id: stopList_effect
        visible: stopListVisible || departureListVisible
        anchors.fill: stopList_rect
        glowRadius: 15
        spread: 0.5
        color: "lightgray"
        cornerRadius: stopList_rect.radius + glowRadius
    }

    Rectangle {
        id: stopList_rect

        visible: stopListVisible
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
            id: stopList
            clip: true

            visible: stopListVisible
            anchors {
                fill: parent
                margins: 10
            }

            delegate: Text {
                text: modelData
                font.pixelSize: 14

                MouseArea {
                    id: stopList_mouse
                    enabled: stopListVisible
                    anchors.fill: parent

                    onClicked: {
                        py.call('gui_departures.deps.get', [text], function(result) {
                            departureList.model.clear();
                            for(var i=0; i<result.length; i++)
                            {
                                departureList.model.append(result[i]);
                            }
                            window.title = 'SailtoVienna - ' + text
                            show_departureList();
                        });
                    }
                }
            }
        }
    }
    Rectangle {
        id: departureList_rect
        visible: departureListVisible
        anchors.fill: stopList_rect
        radius: stopList_rect.radius

        ListView {
            id: departureList
            visible: parent.visible
            clip: true

            anchors {
                fill: parent
                margins: 10
            }

            model: ListModel { id: departureModel }
            delegate: Component {
                id: listDelegate
                Item {
                    anchors.margins: 10
                    visible: departureListVisible
                    height: 30
                    width: departureList.width

                    Text {
                        id: c_line
                        width: 50
                        anchors.left: parent.left
                        text: line.name
                    }
                    Text {
                        anchors {
                            left: c_line.right
                            right: c_countdown.left
                        }
                        elide: Text.ElideRight
                        width: parent.width
                        text: line.towards
                    }
                    Text {
                        id: c_countdown
                        width: 30
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        text: countdown
                    }
                }
            }
        }
    }

    function show_stopList() {
        departureListVisible = false;
        stopListVisible = true;
        window.title = 'SailtoVienna'
    }

    function show_departureList() {
        stopListVisible = false;
        departureListVisible = true;
    }
}
