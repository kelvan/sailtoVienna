.import QtQuick.LocalStorage 2.0 as Sql

var limit = 5;

function open() {
    return Sql.LocalStorage.openDatabaseSync("sailtoVienna", "1", "sailtoVienna settings and recent", 1000);
}

function addRecent(appWindow, station) {
    var db = open();
    db.transaction(function(tx) {
        for(var i=0; i<appWindow.recent.count; i++) {
            if(appWindow.recent.get(i).station == station) {
                appWindow.recent.remove(i);
            }
        }
        tx.executeSql('DELETE FROM recent WHERE station==?', station);
        appWindow.recent.insert(0, { station: station });
        if(appWindow.recent.count > limit)
            appWindow.recent.remove(limit, appWindow.recent.count - limit);
        tx.executeSql('INSERT INTO recent (station, date) VALUES (?, ?)', [station, +new Date]);
    })
}

function loadRecent(callback) {
    var db = open();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS recent(station TEXT, date INTEGER)');
    });

    db.readTransaction(function(tx) {
        var result = tx.executeSql('SELECT DISTINCT station FROM recent ORDER BY date DESC LIMIT ?', [limit]);
        callback(result);
    })
}

function isFavorite(station, callback) {
    var db = open();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS favorite(station TEXT)');
    });

    db.readTransaction(function(tx) {
        var result = tx.executeSql('SELECT count(*) as count FROM favorite WHERE station=?', station);
        callback(result.rows.item(0).count==1);
    });
}

function addFavorite(station, callback) {
    var db = open();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS favorite(station TEXT)');
    });

    appWindow.favorites.insert(0, { station: station });

    db.transaction(function(tx) {
        var result = tx.executeSql('INSERT OR REPLACE INTO favorite(station) VALUES(?)', station);
        callback();
    });
}

function removeFavorite(station, callback) {
    var db = open();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS favorite(station TEXT)');
    });

    for(var i=0; i<appWindow.favorites.count; i++) {
        if(appWindow.favorites.get(i).station == station) {
            appWindow.favorites.remove(i);
        }
    }

    db.transaction(function(tx) {
        var result = tx.executeSql('DELETE FROM favorite WHERE station=?', station);
        callback();
    });
}

function getFavorites(callback) {
    var db = open();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS favorite(station TEXT)');
    });

    db.readTransaction(function(tx) {
        var result = tx.executeSql('SELECT station FROM favorite ORDER BY station ASC');
        callback(result);
    });
}
