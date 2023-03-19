import QtQuick 2.0
import QtTest 1.2
import "../ui/"
import "../ui/utils"


TestCase {
    id: root
    name: "ReloadTimeTests"

    property var plasmoid
    property alias timeUtils: timeUtils

    property var mockCacheDb: null
    property var reloadTimer: null


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

    Component {
        id: reloadTimerComponent
        ReloadTimer {
            fuzzFactorEnabled: false

            cacheDb: root.mockCacheDb

            currentCacheKey: mockMain.cacheKey
        }

    }

    function init() {
        plasmoid = createTemporaryObject(mockPlasmoidComponent, root)

        reloadTimer = createTemporaryObject(reloadTimerComponent, root)
        reloadTimer.getDateNow = function(){
            return 0
        }

        reloadTimer.state = ReloadTimer.State.INITIAL
        
        mockCacheDb = createTemporaryObject(mockCacheDbComponent, root)
        mockCacheDb._content[mockMain.cacheKey] = {
            content: "{}",
            timestamp: 0,
            expireTime: -1
        }
    }

    function cleanup() {
        verify(reloadTimer.getDateNow() > reloadTimer.lastLoadTime,
               "Time now can't be less than last load time.")

        reloadTimer = null
        mockCacheDb = null
    }

    function test_reloadTime_immediate() {
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin

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
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin

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
        mockCacheDb._semaphoreHolder = 0

        reloadTimer.minInterval = 0
        reloadTimer.semaphoreWaitTime = 100
        reloadTimer.loadFromCache.connect(() => {
            mockCacheDb._semaphoreHolder = mockMain.cacheKey
        })

        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.WAIT_SEMAPHORE)
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
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin
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
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin
        mockCacheDb._content[mockMain.cacheKey].timestamp = 2000

        reloadTimer.setLocalLoadTime(mockMain.cacheKey, 1000)

        let now = reloadInterval / 2
        reloadTimer.getDateNow = function(){
            return now
        }

        let isloadFromCacheCalled = false
        reloadTimer.loadFromCache.connect(() => {
            isloadFromCacheCalled = true
        })

        reloadTimer.updateState(mockMain.cacheKey)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, mockCacheDb._content[mockMain.cacheKey].timestamp +  + now + (reloadInterval / 2))
        compare(reloadTimer.reloadTimer.interval, mockCacheDb._content[mockMain.cacheKey].timestamp +  + (reloadInterval / 2))

        compare(isloadFromCacheCalled, true)
    }

    function test_reloadSpam() {
        plasmoid.configuration.reloadIntervalMin = 1


        reloadTimer.getDateNow = function(){
            return 0
        }

        reloadTimer.forceState(mockMain.cacheKey, ReloadTimer.State.SCHEDULED_RELOAD)
        reloadTimer.forceState(mockMain.cacheKey, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.reloadTimer.running, false)

        mockMain.cacheKey = "456"
        reloadTimer.forceState(mockMain.cacheKey, ReloadTimer.State.SCHEDULED_RELOAD)
        plasmoid.configuration.reloadIntervalMin = 60 * 60 * 1000
        mockMain.cacheKey = "123"
        reloadTimer.forceState(mockMain.cacheKey, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.reloadTimer.running, true)
    }
}
