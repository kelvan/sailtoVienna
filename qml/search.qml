import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

import io.thp.pyotherside 1.0

ApplicationWindow {
    property bool stopListVisible: false
    property bool departureListVisible: false
    property string activeStation: ''
    property string activeTowards: ''
    property string activeLine: ''


    id: window

    width: 400
    height: 600

    color: 'white'

    title: activeStation.length == 0 ? 'SailtoVienna' : 'SailtoVienna - ' + activeStation

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
                        activeStation = parent.text;
                        load_departures();
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

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                activeLine = parent.text;
                                load_departures();
                            }
                        }
                    }
                    Text {
                        anchors {
                            left: c_line.right
                            right: c_countdown.left
                        }
                        elide: Text.ElideRight
                        width: parent.width
                        text: line.towards

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                activeTowards = parent.text;
                                load_departures();
                            }
                        }
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

    Timer {
        id: dep_reload_timer

        interval: 20000
        repeat: true
        triggeredOnStart: false

        onTriggered: {
            if (activeStation) {
                console.log('auto-refresh');
                load_departures();
            } else {
                console.log('No active station, cannot autor-refresh');
                dep_reload_timer.stop();
            }
        }
    }

    function show_stopList() {
        departureListVisible = false;
        stopListVisible = true;
        activeStation = '';
        dep_reload_timer.stop();
    }

    function show_departureList() {
        stopListVisible = false;
        departureListVisible = true;
        dep_reload_timer.restart();
    }

    function fill_departure_list(result) {
        departureList.model.clear();
        for(var i=0; i<result.length; i++)
        {
            departureList.model.append(result[i]);
        }
        show_departureList();
    }

    function load_departures_towards() {
        py.call('gui_departures.deps.filter_towards', [activeStation, activeTowards], fill_departure_list);
    }

    function load_departures_line() {
        py.call('gui_departures.deps.filter_line', [activeStation, activeLine], fill_departure_list);
    }

    function load_departures() {
        if (activeLine) {
            load_departures_line();
        } else if(activeTowards) {
            load_departures_towards();
        } else {
            py.call('gui_departures.deps.get', [activeStation], fill_departure_list);
        }
    }
}
