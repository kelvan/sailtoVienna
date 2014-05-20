import QtQuick 2.0
import QtPositioning 5.2
import Sailfish.Silica 1.0

import io.thp.pyotherside 1.2

import "db.js" as Db

ApplicationWindow {
    id: appWindow
    cover: Qt.resolvedUrl('CoverContainer.qml')
    property var recent: ListModel {}
    property var favorites: ListModel {}
    property var nearbyModel: ListModel {}
    property int startPageContentHeight
    property int nearbyPageContentHeight
    property int py_loaded: 0
    // all 2 python libs loaded
    property bool py_completed: py_loaded == 2

    property var coordinate
    PositionSource {
        id: positionSource
        onPositionChanged: {
            if(py_completed) {
                coordinate = position.coordinate;
                py.call('glue.gui_search.stops.get_nearby', [coordinate.latitude, coordinate.longitude], function(result) {
                    nearbyModel.clear();
                    nearbyPageContentHeight = result.length * Theme.itemSizeMedium + 110
                    if(result.length > 0) {
                        result.forEach(function(entry) {
                            nearbyModel.append(entry);
                        });
                    }
                });
            }
        }
    }

    function updateFlickHeight() {
        var favHeight = 110 + favorites.count*Theme.itemSizeSmall;
        var recentHeight = 110 + recent.count*Theme.itemSizeSmall;
        startPageContentHeight = favHeight + recentHeight;
    }

    function loadFavorites() {
        Db.getFavorites(function insert(result) {
            for(var i = 0; i < result.rows.length; i++) {
                console.log(result.rows.item(i).station);
                favorites.append({ station: result.rows.item(i).station });
            }
            updateFlickHeight();
        });
    }

    function loadRecent() {
        Db.loadRecent(function insert(result) {
            for(var i = 0; i < result.rows.length; i++) {
                recent.append({ station: result.rows.item(i).station })
            }
            updateFlickHeight();
        });
    }

    function clearRecent() {
        var db = Db.open()
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM recent')
            recent.clear()
            updateFlickHeight();
        });
    }

    Component.onCompleted: {
        loadFavorites();
        loadRecent();
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../'));
            importModule('glue.gui_search', function() {py_loaded++});
            importModule('glue.gui_departures', function() {py_loaded++});
        }
    }

    initialPage: StartPage {}

    Result {
        id: resultPage
    }
}
