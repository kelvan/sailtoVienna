.import QtQuick.LocalStorage 2.0 as Sql

function open() {
    return Sql.LocalStorage.openDatabaseSync("sailtoVienna", "1", "sailtoVienna settings and recent", 1000)
}
