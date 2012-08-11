/*
 * The following code is taken from:
 * http://www.developer.nokia.com/Community/Wiki/How-to_create_a_persistent_settings_database_in_Qt_Quick_%28QML%29
 * At the time of writing (2011-11-12) there were no copyright or licensing notes in place at the above web site.
 * Hence, the following code is treated as public domain and has been simply copied and pasted here as is.
 * Note: the application name and the name and size of the database had been changed to reflect Simplictionary.
 * The version number is intended to describe the "storage format".
 * Thanks to the original author (Slocan) for sharing this code.
 */

//storage.js
// First, let's create a short helper function to get the database connection
function getDatabase() {
     return openDatabaseSync("QZeeControl", "1.0", "SettingsStorageDatabase", 4000);
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
          });
}

// This function is used to write a setting into the database
function setSetting(setting, value) {
   // setting: string representing the setting name (eg: “username”)
   // value: string representing the value of the setting (eg: “myUsername”)
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
              //console.log(rs.rowsAffected)
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
  );
  // The function returns “OK” if it was successful, or “Error” if it wasn't
  return res;
}
// This function is used to retrieve a setting from the database
function getSetting(setting) {
   var db = getDatabase();
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).value;
     } else {
         res = "Unknown";
     }
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}
