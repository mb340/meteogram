import QtQuick
import QtTest
import "../ui/"
import "../ui/utils"


TestCase {
    id: root
    name: "ReloadTimeTests"

    property var plasmoid
    property alias timeUtils: timeUtils

    property var placeObject: {
        placeAlias: mockMain.placeAlias
    }

    property var mockCacheDb: null
    property var reloadTimer: null

    property alias dataDownloader: dataDownloader

    property string plasmoidCacheId: mockMain.plasmoidCacheId


    function i18n(text) {
        return text
    }

    TimeUtils {
        id: timeUtils
    }

    Component {
        id: mockPlasmoidComponent
        MockPlasmoid {
            id: mockPlasmoid
        }
    }

    MockMain {
        id: mockMain
    }

    Component {
        id: mockCacheDbComponent

        MockCacheDb {

        }
    }

    DataDownloader {
        id: dataDownloader

        cacheDb: mockCacheDb
        reloadTimer: root.reloadTimer

        currentCacheKey: mockMain.cacheKey
        currentProvider: mockMain.currentProvider
    }

    Component {
        id: reloadTimerComponent
        ReloadTimer {
            fuzzFactorEnabled: false

            cacheDb: root.mockCacheDb
            dataDownloader: root.dataDownloader

            currentCacheKey: mockMain.cacheKey
        }

    }

    function init() {
        plasmoid = createTemporaryObject(mockPlasmoidComponent, root)

        mockCacheDb = createTemporaryObject(mockCacheDbComponent, root)
        mockCacheDb._content[mockMain.cacheKey] = {
            content: "{}",
            timestamp: 0,
            expireTime: -1
        }

        let props = {cacheDb: mockCacheDb}
        reloadTimer = createTemporaryObject(reloadTimerComponent, root, props)
        reloadTimer.getDateNow = function(){
            return 0
        }

        reloadTimer.state = ReloadTimer.State.INITIAL
        reloadTimer.reloadInterval = plasmoid.configuration.reloadIntervalHours
    }

    function cleanup() {
        verify(reloadTimer.getDateNow() >= reloadTimer.lastLoadTime,
               "Time now can't be less than last load time.")

        reloadTimer = null
        mockCacheDb = null
    }

    function test_reloadTime_immediate() {
        let reloadInterval = plasmoid.configuration.reloadIntervalHours * reloadTimer.msPerHour

        let now = reloadInterval + 1000
        reloadTimer.getDateNow = function(){
            return now
        }

        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, now)
        compare(reloadTimer.reloadTimer.interval, 0)
    }

    function test_reloadTime() {
        let reloadInterval = plasmoid.configuration.reloadIntervalHours * reloadTimer.msPerHour

        let now = reloadInterval / 2
        reloadTimer.getDateNow = function(){
            return now
        }

        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, now + (reloadInterval / 2))
        compare(reloadTimer.reloadTimer.interval, reloadInterval / 2)
    }

    function test_reloadTime_semaphore() {
        let res = mockCacheDb.obtainUpdateSemaphore(mockMain.cacheKey, 1000)
        verify(res === true)

        reloadTimer.semaphoreWaitTime = 100
        reloadTimer.reloadData.connect((key) => {
            mockCacheDb.obtainUpdateSemaphore(key)
        })

        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.WAIT_SEMAPHORE)
        mockCacheDb.releaseUpdateSemaphore(mockMain.cacheKey)
        wait(500)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
    }

    function test_reloadTime_load_error() {
        mockCacheDb._loadingErrors[mockMain.cacheKey] = mockCacheDb.noConnectionloadingError
        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.LOADING_ERROR)
        compare(reloadTimer.reloadTimer.interval, reloadTimer.noConnectionRetryTime)
    }

    function test_reloadTime_load_error_http() {
        mockCacheDb._loadingErrors[mockMain.cacheKey] = mockCacheDb.noConnectionloadingError
        mockCacheDb._loadingErrors[mockMain.cacheKey].status = 403   // HTTP status
        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.LOADING_ERROR)
        compare(reloadTimer.reloadTimer.interval, reloadTimer.httpErrorRetryTime)
    }

    function test_reloadTime_expire() {
        let reloadInterval = plasmoid.configuration.reloadIntervalHours * reloadTimer.msPerHour
        let now = 10000 + reloadInterval
        let expireTime = 20000 + reloadInterval

        reloadTimer.getDateNow = function(){
            return now
        }

        mockCacheDb._content[mockMain.cacheKey].timestamp = 1000
        mockCacheDb._content[mockMain.cacheKey].expireTime = expireTime
        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.EXPIRE_TIME)
        compare(reloadTimer.nextLoadTime, expireTime)
        compare(reloadTimer.reloadTimer.interval, expireTime - now)
    }

    function test_scheduleAndLoadFromCache() {
        let reloadInterval = plasmoid.configuration.reloadIntervalHours * reloadTimer.msPerHour
        mockCacheDb._content[mockMain.cacheKey].timestamp = 2000

        reloadTimer.setLocalLoadTime(mockMain.cacheKey, 1000)

        let now = reloadInterval / 2
        reloadTimer.getDateNow = function(){
            return now
        }

        let isloadFromCacheCalled = 0
        reloadTimer.loadFromCache.connect(() => {
            isloadFromCacheCalled++
        })

        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, mockCacheDb._content[mockMain.cacheKey].timestamp +  + now + (reloadInterval / 2))
        compare(reloadTimer.reloadTimer.interval, mockCacheDb._content[mockMain.cacheKey].timestamp +  + (reloadInterval / 2))

        compare(isloadFromCacheCalled, 1)
    }

    function test_nextReloadTriggeredAndRecheckLastLoadTime() {
        reloadTimer.reloadInterval = 0.0001
        mockCacheDb._content[mockMain.cacheKey].timestamp = 2000
        reloadTimer.setLocalLoadTime(mockMain.cacheKey, 2000)

        reloadTimer.getDateNow = function(){
            return 4000
        }

        let isloadFromCacheCalled = 0
        reloadTimer.loadFromCache.connect(() => {
            isloadFromCacheCalled++
        })

        reloadTimer.updateState(mockMain.cacheKey)

        // Simulate another plasmoid updating the cache
        mockCacheDb._content[mockMain.cacheKey].timestamp = 10000
        wait(1000)

        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(isloadFromCacheCalled, 2)

        reloadTimer.lastLoadTime = reloadTimer.getDateNow()
    }
}
