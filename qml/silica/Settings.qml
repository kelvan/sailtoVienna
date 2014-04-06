import QtQuick 2.0
import Sailfish.Silica 1.0

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
                    //% "Off"
                    MenuItem { text: qsTrId("off") }
                    //% "15 sec"
                    MenuItem { text: qsTrId("15-sec") }
                    //% "30 sec"
                    MenuItem { text: qsTrId("30-sec") }
                    //% "1 min
                    MenuItem { text: qsTrId("1-min") }
                    //% "2 min
                    MenuItem { text: qsTrId("2-min") }
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
