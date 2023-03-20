/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import QtQuick.LocalStorage 2.0


QtObject {

    property var db: null

    required property var plasmoidCacheId

    function open() {
        let name = "WeatherMeteogramDB";
        let version = "1.0";
        let description = "Weather meteogram plasmoid";
        let estimatedSize = 1000000;
        db = LocalStorage.openDatabaseSync(name, version, description, estimatedSize);
        return db
    }

    function initialize() {
        db.transaction(function(tx) {
            try {
                let statement = 'CREATE TABLE IF NOT EXISTS Cache(key TEXT NOT NULL PRIMARY KEY, '+
                                                                  'timestamp INTEGER, ' +
                                                                  'expireTime INTEGER, ' +
                                                                  'content BLOB)'
                tx.executeSql(statement);

                statement = 'CREATE TABLE IF NOT EXISTS LoadingErrors(key TEXT NOT NULL PRIMARY KEY, '+
                                                                      'timestamp INTEGER, ' +
                                                                      'status INTEGER)'
                tx.executeSql(statement);

                statement = 'CREATE TABLE IF NOT EXISTS UpdateSemaphore(key TEXT NOT NULL PRIMARY KEY, '+
                                                                       'flag INTEGER)'
                tx.executeSql(statement);

            } catch (e) {
                print(e)
            }
        });

        return db;
    }

    function ensureUpdateSempahore(cacheKey) {
        db.transaction(function(tx) {
            try {
                let statement = 'INSERT OR IGNORE INTO UpdateSemaphore VALUES(?, ?)'
                let values = [cacheKey, -1]
                tx.executeSql(statement, values);
            } catch (e) {
                print(e);
            }
        })
    }

    function obtainUpdateSemaphore(cacheKey, flag = undefined) {
        var sem = false

        flag = (flag !== undefined) ? flag : plasmoidCacheId

        db.transaction(function(tx) {
            try {
                let statement = 'INSERT OR IGNORE INTO UpdateSemaphore VALUES(?, ?)'
                let values = [cacheKey, flag]
                tx.executeSql(statement, values);

                statement = "UPDATE UpdateSemaphore SET flag = ? " +
                            "WHERE key = ? AND (flag = ? or flag = -1)"
                values = [flag, cacheKey, flag]
                tx.executeSql(statement, values);

                statement = "SELECT flag FROM UpdateSemaphore WHERE key = ?"
                let rs = tx.executeSql(statement, cacheKey);
                if (!rs || rs.rows.length !== 1) {
                    return
                }

                let f = Number(rs.rows.item(0).flag)
                // print("obtainUpdateSemaphore: flag =", f)

                sem = (f !== -1 && Number(f) === Number(flag))
            } catch (e) {
                print(e);
            }
        })

        return sem
    }

    function releaseUpdateSemaphore(cacheKey) {
        let flag = plasmoidCacheId
        let res = true
        db.transaction(function(tx) {
            try {
                let statement = "UPDATE UpdateSemaphore SET flag = -1 " +
                                " WHERE key = ? AND flag = ?"
                let rs = tx.executeSql(statement, [cacheKey, flag]);
                if (!rs) {
                    res = false
                }
            } catch (e) {
                print(e);
                res = false
            }
        });
        return res
    }

    /* Check if semaphore is obtained by current plasmoid or is free to be obtained */
    function checkUpdateSemaphore(cacheKey) {
        let flag = plasmoidCacheId
        let sem = false
        db.transaction(function(tx) {
            try {
                var statement = 'SELECT flag FROM UpdateSemaphore WHERE key = ?'
                var rs = tx.executeSql(statement, [cacheKey]);
                if (!rs) {
                    return
                }

                if (rs.rows.length < 1) {
                    return sem = true
                }

                var f = Number(rs.rows.item(0).flag)
                // print("checkUpdateSemaphore: flag =", flag)

                sem = (f === -1 || Number(f) === Number(flag))
            } catch (e) {
                print(e);
                verify(false)
            }
        });

        return sem
    }

    function writePlaceCache(cacheKey, content, timestamp, expireTime) {
        db.transaction(function(tx) {
            try {
                if (typeof(content) !== 'string') {
                    print('error: cache content must be string')
                    return
                }

                try {
                    let tmp = JSON.parse(content)
                } catch (e) {
                    print(e)
                    print("error: cache content must be JSON string")
                    return
                }

                let values = [ cacheKey, timestamp, expireTime, content ]
                tx.executeSql('INSERT OR REPLACE INTO Cache VALUES(?, ?, ?, ?)', values);
                // print("writePlaceCache: wrote cacheKey:", cacheKey)
            } catch (e) {
                print(e);
            }
        });
    }

    function readStatement(cacheKey, statement) {
        var rs = undefined
        if (db == null) {
            console.trace()
            return null
        }
        db.readTransaction(function(tx) {
            rs = tx.executeSql(statement, [cacheKey]);
        });

        if (!rs) {
            print('error: No result for SQL statement')
            console.trace()
            return null
        }

        if (rs.rows.length === 0) {
            // print("error: DB doesn't contain cacheKey:", cacheKey)
            // console.trace()
            return null
        }

        if (rs.rows.length > 1) {
            print('error: Got more than one row for cacheKey ', cacheKey)
            console.trace()
            return null
        }

        return rs
    }

    function getContent(cacheKey) {
        var rs = undefined
        var statement = 'SELECT content FROM Cache WHERE key = ?'
        rs = readStatement(cacheKey, statement)
        if (rs === null) {
            return null
        }

        let content = rs.rows.item(0).content
        // print('getContent: cacheKey:', cacheKey)
        return content
    }

    function readPlaceCacheTimestamp(cacheKey) {
        if (cacheKey == null) {
            // print('readPlaceCacheTimestamp: cacheKey', cacheKey)
            console.trace()
        }

        var ts = null
        db.readTransaction(function(tx) {
            var statement = 'SELECT timestamp FROM Cache WHERE key = ?'
            var rs = tx.executeSql(statement, [cacheKey]);
            if (rs === null || rs.rows.length !== 1) {
                return
            }

            ts = rs.rows.item(0).timestamp
        });

        // print('readPlaceCacheTimestamp: cacheKey: ', cacheKey, ", timestamp: ", ts)
        if (ts === null) {
            return -1
        }
        return Number(ts)
    }

    function readPlaceCacheExpireTime(cacheKey) {
        var rs = undefined
        var statement = 'SELECT expireTime FROM Cache WHERE key = ?'
        rs = readStatement(cacheKey, statement)
        if (rs === null) {
            return -1
        }

        let expireTime = rs.rows.item(0).expireTime
        // print('readPlaceCacheTimestamp: cacheKey: ', cacheKey, ", expireTime: ", expireTime)
        return Number(expireTime)
    }

    function hasKey(cacheKey) {
        let res = false
        db.readTransaction(function(tx) {
            try {
                var statement = 'SELECT key FROM Cache WHERE key = ?'
                var rs = tx.executeSql(statement, [cacheKey]);
                res = (rs !== null) && (rs.rows.length === 1)
            } catch(e) {
                print(e)
            }
        });
        return res
    }

    function writeLoadingError(cacheKey, timestamp, status) {
        db.transaction(function(tx) {
            try {
                status = Number(status)
                if (status !== 0 && (status < 100 || status >= 600)) {
                    print("error: Not a valid HTTP status code:", status)
                    return
                }

                let values = [ cacheKey, timestamp, status ]
                tx.executeSql('INSERT OR REPLACE INTO LoadingErrors VALUES(?, ?, ?)', values);
                // print("writeLoadingError: wrote cacheKey:", cacheKey)
            } catch (e) {
                print(e);
            }
        });
    }

    function readLoadingError(cacheKey) {
        var rs = undefined
        var statement = 'SELECT timestamp, status FROM LoadingErrors WHERE key = ?'
        rs = readStatement(cacheKey, statement)
        if (rs === null) {
            return null
        }

        let item = rs.rows.item(0)
        // print('readLoadingError: cacheKey: ', cacheKey, ", status: ", item.status)
        return {
            timestamp: item.timestamp,
            status: item.status
        }
    }

    function clearLoadingError(cacheKey) {
        db.transaction(function(tx) {
            try {
                let values = [ cacheKey ]
                tx.executeSql('DELETE FROM LoadingErrors WHERE key = ?', values);
                // print("clearLoadingError: cacheKey:", cacheKey)
            } catch (e) {
                print(e);
                print("error: Failed to execute statement for cacheKey:", cacheKey)
            }
        });
    }
}
