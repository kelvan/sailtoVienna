import QtQuick 2.0
import Sailfish.Silica 1.0

import "settings.js" as SettingsStore

Page {
    SilicaFlickable {
        anchors.fill: parent

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

            ComboBox {
                //% "Automatic refresh"
                label: qsTrId("automatic-refresh")

                menu: ContextMenu {

                    onActivated: {
                        console.log(index);
                    }

                    function saveAutoRefresh(value) {
                        Db.setSetting('autorefresh', value, function(result) {
                            if(result) {
                                console.log('Setting saved');
                            } else {
                                console.log('Error while saving setting');
                            }
                        });
                    }

                    MenuItem {
                        //% "Off"
                        text: qsTrId("off")
                        onClicked: SettingsStore.saveAutoRefresh('off')
                    }
                    MenuItem {
                        //% "15 sec"
                        text: qsTrId("15-sec")
                        onClicked: SettingsStore.saveAutoRefresh('15')
                    }
                    MenuItem {
                        //% "30 sec"
                        text: qsTrId("30-sec")
                        onClicked: SettingsStore.saveAutoRefresh('30')
                    }
                    MenuItem {
                        //% "1 min"
                        text: qsTrId("1-min")
                        onClicked: SettingsStore.saveAutoRefresh('60')
                    }
                    MenuItem {
                        //% "2 min"
                        text: qsTrId("2-min")
                        onClicked: SettingsStore.saveAutoRefresh('120')
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
}
