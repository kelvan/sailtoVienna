.import QtQuick.LocalStorage 2.0 as Sql

var limit = 5;

function open() {
    return Sql.LocalStorage.openDatabaseSync("sailtoVienna", "1", "sailtoVienna settings and recent", 1000)
}

function addRecent(appWindow, station) {
    var db = open()
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
    var db = open()
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS recent(station TEXT, date INTEGER)');
    })

    db.readTransaction(function(tx) {
        var result = tx.executeSql('SELECT DISTINCT station FROM recent ORDER BY date DESC LIMIT ?', [limit]);
        callback(result);
    })
}
