import QtQuick 2.0
import Sailfish.Silica 1.0

import "settings.js" as SettingsStore

Page {
    SilicaFlickable {
        anchors.fill: parent

        function qsTrIdStrings() {
            //% "Off"
            QT_TRID_NOOP("off")
            //% "15 sec"
            QT_TRID_NOOP("15-sec")
            //% "30 sec"
            QT_TRID_NOOP("30-sec")
            //% "1 min"
            QT_TRID_NOOP("1-min")
            //% "2 min"
            QT_TRID_NOOP("2-min")
        }

        Column {
            width: parent.width
            PageHeader {
                //% "Settings"
                title: qsTrId("settings")
            }


            ComboBox {
                //% "Search for"
                label: qsTrId("search-for")

                menu: ContextMenu {
                    //% "Station"
                    MenuItem { text: qsTrId("station") }
                    //% "Line"
                    MenuItem { text: qsTrId("line") }
                }
            }

            ListModel {
                id: refreshModel

                ListElement {
                    label: "off"
                    value: 0
                }
                ListElement {
                    label: "15-sec"
                    value: 15
                }
                ListElement {
                    label: "30-sec"
                    value: 30
                }
                ListElement {
                    label: "1-min"
                    value: 60
                }
                ListElement {
                    label: "2-min"
                    value: 120
                }
            }

            ComboBox {
                id: refreshCombo
                onCurrentIndexChanged: {
                    SettingsStore.saveAutoRefresh(refreshModel.get(currentIndex).value);
                }

                //% "Automatic refresh"
                label: qsTrId("automatic-refresh")

                menu: ContextMenu {
                    Repeater {
                        model: refreshModel
                        MenuItem {
                            text: qsTrId(label)
                        }
                    }
                }
            }

            ComboBox {
                //% "Result view cover action"
                label: qsTrId("result-view-cover-action")

                menu: ContextMenu {
                    //% "Search"
                    MenuItem { text: qsTrId("search") }
                    //% "Nearby"
                    MenuItem { text: qsTrId("nearby") }
                }
            }
        }
    }

    function refreshIndex(value) {
        for (var i = 0; i < refreshModel.count; ++i) {
            if (value <= refreshModel.get(i).value) {
                return i;
            }
        }
    }

    Component.onCompleted: {
        SettingsStore.getAutoRefresh(0, function(value) {
            refreshCombo.currentIndex = refreshIndex(value);
        });
    }
}
