import QtQuick 2.0
import QtTest 1.2
import "../ui/"
import "../ui/utils"


TestCase {
    id: root
    name: "ReloadTimeTests"

    property alias plasmoid: mockPlasmoid
    property alias timeUtils: timeUtils

    property var mockCacheDb: null
    property var reloadTimer: null


    function i18n(text) {
        return text
    }

    TimeUtils {
        id: timeUtils
    }

    MockPlasmoid {
        id: mockPlasmoid
    }

    MockMain {
        id: mockMain
    }

    Component {
        id: mockCacheDbComponent

        QtObject {
            id: mockCacheDb

            property bool semaphoreFlag: true
            property double lastLoadTime: NaN
            property double expireTime: -1
            property var loadingError: null

            property var nullLoadingError: null
            property var noConnectionloadingError: ({
                    timestamp: 0,
                    status: 0
            })

            function checkUpdateSemaphore(key) {
                return semaphoreFlag
            }

            function readPlaceCacheTimestamp(key) {
                return lastLoadTime
            }

            function readPlaceCacheExpireTime(key) {
                return expireTime
            }

            function readLoadingError(key) {
                return loadingError
            }
        }
    }

    Component {
        id: reloadTimerComponent
        ReloadTimer {
            main: mockMain
            cacheDb: mockCacheDb
        }

    }

    function init() {
        reloadTimer = createTemporaryObject(reloadTimerComponent, root)
        reloadTimer.getDateNow = function(){
            return 0
        }

        reloadTimer.state = ReloadTimer.State.INITIAL
        
        mockCacheDb = createTemporaryObject(mockCacheDbComponent, root)
    }

    function cleanup() {
        verify(reloadTimer.getDateNow() > reloadTimer.lastLoadTime,
               "Time now can't be less than last load time.")

        reloadTimer = null
        mockCacheDb = null
    }

    function test_reloadTime_immediate() {
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin
        mockCacheDb.lastLoadTime = 0

        let now = reloadInterval + 1000
        reloadTimer.getDateNow = function(){
            return now
        }

        reloadTimer.updateState(123)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, now)
        compare(reloadTimer.reloadTimer.interval, 0)
    }

    function test_reloadTime() {
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin
        mockCacheDb.lastLoadTime = 0

        let now = reloadInterval / 2
        reloadTimer.getDateNow = function(){
            return now
        }

        reloadTimer.updateState(123)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, now + (reloadInterval / 2))
        compare(reloadTimer.reloadTimer.interval, reloadInterval / 2)
    }

    function test_reloadTime_semaphore() {
        mockCacheDb.lastLoadTime = 0
        mockCacheDb.semaphoreFlag = false
        reloadTimer.updateState(123)
        compare(reloadTimer.state, ReloadTimer.State.WAIT_SEMAPHORE)
    }

    function test_reloadTime_load_error() {
        mockCacheDb.lastLoadTime = 0
        mockCacheDb.loadingError = mockCacheDb.noConnectionloadingError
        reloadTimer.updateState(123)
        compare(reloadTimer.state, ReloadTimer.State.LOADING_ERROR)
        compare(reloadTimer.reloadTimer.interval, reloadTimer.noConnectionRetryTime)
    }

    function test_reloadTime_load_error_http() {
        mockCacheDb.lastLoadTime = 0
        mockCacheDb.loadingError = mockCacheDb.noConnectionloadingError
        mockCacheDb.loadingError.status = 403   // HTTP status
        reloadTimer.updateState(123)
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

        mockCacheDb.lastLoadTime = 1000
        mockCacheDb.expireTime = expireTime
        reloadTimer.updateState(123)
        compare(reloadTimer.state, ReloadTimer.State.EXPIRE_TIME)
        compare(reloadTimer.nextLoadTime, expireTime)
        compare(reloadTimer.reloadTimer.interval, expireTime - now)
    }

    function test_scheduleAndLoadFromCache() {
        let reloadInterval = plasmoid.configuration.reloadIntervalMin * reloadTimer.msPerMin
        mockCacheDb.lastLoadTime = 2000

        reloadTimer.setLocalLoadTime(123, 1000)

        let now = reloadInterval / 2
        reloadTimer.getDateNow = function(){
            return now
        }

        let isloadFromCacheCalled = false
        reloadTimer.loadFromCache.connect(() => {
            isloadFromCacheCalled = true
        })

        reloadTimer.updateState(123)
        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)
        compare(reloadTimer.nextLoadTime, mockCacheDb.lastLoadTime + now + (reloadInterval / 2))
        compare(reloadTimer.reloadTimer.interval, mockCacheDb.lastLoadTime + (reloadInterval / 2))

        compare(isloadFromCacheCalled, true)
    }
}
