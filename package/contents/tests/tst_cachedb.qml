import QtQuick
import QtTest
import "../ui/"
import "../ui/utils"


TestCase {
    id: root
    name: "CacheDbTests"

    property alias plasmoid: mockPlasmoid

    MockPlasmoid {
        id: mockPlasmoid
    }

    CacheDb {
        id: cacheDb

        plasmoidCacheId: 1
    }

    property var db: null

    function initTestCase() {
        db = cacheDb.open()
        verify(db != null, "Failed to open db")
    }

    function init() {
        db.transaction(function(tx) {
            try {
                tx.executeSql("DROP TABLE IF EXISTS Cache");
                tx.executeSql("DROP TABLE IF EXISTS LoadingErrors");
                tx.executeSql("DROP TABLE IF EXISTS UpdateSemaphore");
            } catch (e) {
                print(e);
            }
        })
        cacheDb.initialize()
    }

    function cleanup() {
        db.transaction(function(tx) {
            try {
                tx.executeSql("DROP TABLE IF EXISTS Cache");
                tx.executeSql("DROP TABLE IF EXISTS LoadingErrors");
                tx.executeSql("DROP TABLE IF EXISTS UpdateSemaphore");
            } catch (e) {
                print(e);
            }
        })
    }

    function test_init() {
        verify(db)
    }

    function test_obtainUpdateSemaphore() {
        var sem = cacheDb.obtainUpdateSemaphore("123")
        verify(sem)
    }

    function test_checkUpdateSemaphore_initialize() {
        var sem = cacheDb.checkUpdateSemaphore("123")
        verify(sem === true)
    }

    function test_checkUpdateSemaphore() {
        var sem = cacheDb.obtainUpdateSemaphore("123")
        verify(sem === true)

        sem = cacheDb.checkUpdateSemaphore("123")
        verify(sem === true)
    }

    function test_checkUpdateSemaphore_already_locked() {
        let flag = "20"
        verify(flag !== plasmoid.id)

        var sem = cacheDb.obtainUpdateSemaphore("123", flag)
        verify(sem === true)

        sem = cacheDb.checkUpdateSemaphore("123")
        verify(sem === false)
    }

    function test_releaseUpdateSemaphore() {
        let res = cacheDb.releaseUpdateSemaphore()
        verify(res === true)

        let sem = cacheDb.obtainUpdateSemaphore("123")
        verify(sem === true)

        res = cacheDb.releaseUpdateSemaphore("123")
        verify(res === true)
    }

    function test_writePlaceCache() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        cacheDb.writePlaceCache(key, content, timestamp, -1)

        let res = cacheDb.getContent(key)
        verify(res !== null)
        compare(res, content)
    }

    function test_writePlaceCache_fail() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        cacheDb.writePlaceCache(key, content, timestamp, -1)

        let wrongKey = "abc"
        let res = cacheDb.getContent(wrongKey)
        verify(res === null)
    }

    function test_readPlaceCacheTimestamp() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        cacheDb.writePlaceCache(key, content, timestamp, -1)

        let res = cacheDb.readPlaceCacheTimestamp(key)
        compare(typeof(res), 'number')
        compare(res, timestamp)
    }

    function test_readPlaceCacheExpireTime() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        cacheDb.writePlaceCache(key, content, timestamp, -1)

        let res = cacheDb.readPlaceCacheExpireTime(key)
        compare(typeof(res), 'number')
        compare(res, -1)
    }

    function test_readPlaceCacheExpireTime_fail() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        let expireTime = 32000
        cacheDb.writePlaceCache(key, content, timestamp, expireTime)

        let wrongKey = "abc"
        let res = cacheDb.readPlaceCacheExpireTime(wrongKey)
        compare(typeof(res), 'number')
        compare(res, -1)
        verify(res !== expireTime)
    }

    function test_hasKey() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        let expireTime = 32000
        cacheDb.writePlaceCache(key, content, timestamp, expireTime)

        let res = cacheDb.hasKey(key)
        compare(res, true)

        let wrongKey = "abc"
        res = cacheDb.hasKey(wrongKey)
        compare(res, false)
    }

    function test_writeLoadingError() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        let expireTime = 32000
        cacheDb.writePlaceCache(key, content, timestamp, expireTime)

        let ts = 17000
        let status = 0
        cacheDb.writeLoadingError(key, ts, status)

        let res = cacheDb.readLoadingError(key)
        verify(res !== null)
        compare(res.timestamp, ts)
        compare(res.status, status)
    }

    function test_clearLoadingError() {
        let key = "123"
        let data = { foo: "bar" }
        let content = JSON.stringify(data)
        let timestamp = 16000
        let expireTime = 32000
        cacheDb.writePlaceCache(key, content, timestamp, expireTime)

        let ts = 17000
        let status = 0
        cacheDb.writeLoadingError(key, ts, status)
        
        cacheDb.clearLoadingError(key)

        let res = cacheDb.readLoadingError(key)
        compare(res, null)
    }
}
