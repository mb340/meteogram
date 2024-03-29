import QtQuick
import QtTest
import "../ui/"
import "../ui/utils"


TestCase {
    id: root
    name: "DataDownloaderTests"

    property var mockCacheDb: null
    property var mockProvider: null
    property var placeObject: {
        placeAlias: root.placeAlias
    }

    property var reloadTimer: null
    property var dataDownloader: null

    property alias timeUtils: timeUtils

    property alias placeAlias: mockMain.placeAlias
    property alias timezoneID: mockMain.timezoneID

    property string plasmoidCacheId: mockMain.plasmoidCacheId

    function i18n(text) {
        return text
    }

    function dbgprint(text) {
        print(text)
    }

    property alias plasmoid: mockPlasmoid

    MockPlasmoid {
        id: mockPlasmoid
    }

    MockMain {
        id: mockMain

        currentProvider: mockProvider
    }

    TimeUtils {
        id: timeUtils
    }

    Component {
        id: mockProviderComponent
        MockProvider {
            id: mockProvider
        }
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

            cacheDb: mockCacheDb
            dataDownloader: root.dataDownloader

            currentCacheKey: mockMain.cacheKey

            Component.onCompleted: {
                // loadFromCache.connect(mockMain.loadFromCache)
                // reloadData.connect(dataDownloader.reloadData)
            }
        }

    }

    Component {
        id: dataDownloaderComponent

        DataDownloader {
            id: dataDownloader

            cacheDb: root.mockCacheDb
            reloadTimer: root.reloadTimer

            currentCacheKey: mockMain.cacheKey
            currentProvider: mockMain.currentProvider

            Component.onCompleted: {
                dataDownloader.loadFromCache.connect(mockMain.loadFromCache)
            }
        }
    }


    function init() {
        plasmoid.configuration.reloadIntervalHours = 60 * 1000

        reloadTimer = createTemporaryObject(reloadTimerComponent, root)

        mockProvider = createTemporaryObject(mockProviderComponent, root)
        mockCacheDb = createTemporaryObject(mockCacheDbComponent, root)
        mockCacheDb._content[mockMain.cacheKey] = {
            content: "{}",
            timestamp: 0,
            expireTime: -1
        }

        verify(mockMain.currentProvider !== null)

        dataDownloader = createTemporaryObject(dataDownloaderComponent, root)

        reloadTimer.state = ReloadTimer.State.INITIAL
        reloadTimer.loadFromCache.connect(mockMain.loadFromCache)
        reloadTimer.reloadData.connect(dataDownloader.reloadData)
    }

    function test_successCallback() {
        mockProvider.interval = 10

        dataDownloader.reloadData(mockMain.cacheKey)

        wait(1 * 1000)

        let sem = mockCacheDb.checkUpdateSemaphore(mockMain.cacheKey)
        compare(sem, true)

        compare(reloadTimer.state, ReloadTimer.State.SCHEDULED_RELOAD)

        verify(dataDownloader.loadingXhrs.hasOwnProperty(mockMain.cacheKey))
        compare(dataDownloader.loadingXhrs[mockMain.cacheKey], null)
    }

    function test_failureCallback() {
        mockProvider.interval = 10
        mockProvider.doFailure = true

        dataDownloader.reloadData(mockMain.cacheKey)

        wait(1 * 1000)

        let sem = mockCacheDb.checkUpdateSemaphore(mockMain.cacheKey)
        compare(sem, true)

        compare(reloadTimer.state, ReloadTimer.State.LOADING_ERROR)

        verify(dataDownloader.loadingXhrs.hasOwnProperty(mockMain.cacheKey))
        compare(dataDownloader.loadingXhrs[mockMain.cacheKey], null)
    }

    function test_downloadAbort() {
        mockProvider.interval = 60 * 60 * 1000
        mockProvider.doFailure = true

        dataDownloader.abortTimeInterval = 10
        dataDownloader.reloadData(mockMain.cacheKey)

        wait(1 * 1000)

        let sem = mockCacheDb.checkUpdateSemaphore(mockMain.cacheKey)
        compare(sem, true)

        compare(reloadTimer.state, ReloadTimer.State.LOADING_ERROR)

        verify(dataDownloader.loadingXhrs.hasOwnProperty(mockMain.cacheKey))
        compare(dataDownloader.loadingXhrs[mockMain.cacheKey], null)

        verify(mockProvider.isAborted)
    }

    function test_downloadInProgress() {
        mockProvider.interval = 60 * 60 * 1000
        mockProvider.doFailure = false

        let otherCacheKey = "456"
        mockCacheDb._content[otherCacheKey] = {
            content: "{}",
            timestamp: 0,
            expireTime: -1
        }

        reloadTimer.forceState(mockMain.cacheKey, ReloadTimer.State.SCHEDULED_RELOAD)

        wait(1 * 1000)

        let res = dataDownloader.reloadData(mockMain.cacheKey)
        compare(res, false)
        compare(reloadTimer.state, ReloadTimer.State.LOADING)
    }

    function test_downloadTimeout() {
        dataDownloader.abortTimeInterval = 10

        dataDownloader.reloadData(mockMain.cacheKey)

        wait(1 * 1000)

        let sem = mockCacheDb.checkUpdateSemaphore(mockMain.cacheKey)
        compare(sem, true)

        compare(reloadTimer.state, ReloadTimer.State.LOADING_ERROR)

        verify(dataDownloader.loadingXhrs.hasOwnProperty(mockMain.cacheKey))
        compare(dataDownloader.loadingXhrs[mockMain.cacheKey], null)
    }

}
