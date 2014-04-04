import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width
            PageHeader {
                title: "Settings"
            }


            ComboBox {
                label: "Search for"

                menu: ContextMenu {
                    MenuItem { text: "Station" }
                    MenuItem { text: "Line" }
                }
            }

            ComboBox {
                label: "Automatic refresh"

                menu: ContextMenu {
                    MenuItem { text: "Off" }
                    MenuItem { text: "15 sec" }
                    MenuItem { text: "30 sec" }
                    MenuItem { text: "1 min" }
                    MenuItem { text: "2 min" }
                }
            }
            
            ComboBox {
                label: "Result view cover action"

                menu: ContextMenu {
                    MenuItem { text: "Search" }
                    MenuItem { text: "Nearby" }
                }
            }
        }
    }
}
