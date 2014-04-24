.import "db.js" as Db

function saveAutoRefresh(value) {
    Db.setSetting('autorefresh', value, function(result) {
        if(result) {
            console.log('Setting saved');
        } else {
            console.log('Error while saving setting');
        }
    });
}

function getAutoRefresh(default_value, callback) {
    Db.getSetting('autorefresh', default_value, callback);
}
