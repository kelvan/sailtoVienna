import QtQuick 2.0
import Sailfish.Silica 1.0

import io.thp.pyotherside 1.2

import "db.js" as Db

ApplicationWindow {
    id: appWindow
    cover: Qt.resolvedUrl('CoverContainer.qml')
    property var recent: ListModel {}

    function loadRecent() {
        var db = Db.open()
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS recent(station TEXT, date INTEGER)')
        })

        db.readTransaction(function(tx) {
            var result = tx.executeSql('SELECT station FROM recent ORDER BY date DESC LIMIT 5')
            for(var i = 0; i < result.rows.length; i++) {
                recent.append({ station: result.rows.item(i).station })
            }
        })
    }

    function clearRecent() {
        var db = Db.open()
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM recent')
            recent.clear()
        })
    }

    Component.onCompleted: loadRecent()

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../'));
            importModule('glue.gui_search', null);
            importModule('glue.gui_departures', null);
        }
    }

    initialPage: StartPage {}

    Result {
        id: resultPage
    }
}
