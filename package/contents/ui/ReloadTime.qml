import QtQuick 2.0
import "../code/data-loader.js" as DataLoader

Item {

    // Download Attempt Frequency in minutes
    property int reloadIntervalMin: plasmoid.configuration.reloadIntervalMin

    // Download Attempt Frequency in milliseconds
    property int reloadIntervalMs: reloadIntervalMin * 60 * 1000

    // Download Timeout in ms.
    property int loadingDataTimeoutMs: 60 * 1000

    property double retryTimeMs: 60 * 1000

    readonly property double maxTimeMs: 8640000000000000

    property var abortTimers: ({})
    property var lastReloadedMsMap: ({})
    property var expiresMsMap: {}
    property var loadingError: ({})

    property string nextReloadText: ''

    Timer {
        id: reloadTimer
        interval: 60*1000
        running: false
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            main.tryReload()
        }
    }

    Component {
        id: abortTimer
        Timer {
            interval: loadingDataTimeoutMs
            running: false
            repeat: false
            triggeredOnStart: false
        }
    }

    function init() {
        // fill last reloaded
        var lastReloadedMsJson = plasmoid.configuration.lastReloadedMsJson
        if (lastReloadedMsJson) {
            lastReloadedMsMap = JSON.parse(lastReloadedMsJson)
        }
        lastReloadedMsMap = lastReloadedMsMap || {}
        dbgprint("init: lastReloadedMsMap = " + JSON.stringify(lastReloadedMsMap))

        var expiresMsJson = plasmoid.configuration.expiresMsJson
        if (expiresMsJson) {
            expiresMsMap = JSON.parse(expiresMsJson)
        }
        expiresMsMap = expiresMsMap || {}
    }

    function start(cacheKey) {
        const INT_MAX = 2147483647
        var interval = getNextReloadTime(cacheKey) - Date.now()
        interval = Math.min(interval, INT_MAX)

        if (interval > 0) {
            reloadTimer.interval = interval
            dbgprint("ReloadTime: Start reload timer. interval = " + reloadTimer.interval +
                     ", next update in " + DataLoader.formatTimeIntervalString(interval))
            reloadTimer.start()
        } else {
            main.tryReload()
        }

    }

    function stop() {
        reloadTimer.stop()
    }

    function startAbortTimer(key, func) {
        if (!abortTimers[key]) {
            abortTimers[key] = abortTimer.createObject(null)
            abortTimers[key].triggered.connect(func)
        }

        abortTimers[key].restart()
    }

    function stopAbortTimer(key) {
        if (abortTimers[key]) {
            abortTimers[key].stop()
        }
    }

    function setLastReloadedMs(key) {
        var lastReloadedMs = new Date().getTime()
        lastReloadedMsMap[key] = lastReloadedMs
        var data = JSON.stringify(lastReloadedMsMap)
        plasmoid.configuration.lastReloadedMsJson = data
    }

    function getLastReloadedMs(key) {
        if (!lastReloadedMsMap || !lastReloadedMsMap[key]) {
            return undefined
        }
        return lastReloadedMsMap[key]
    }

    function hasLoadingError(key) {
        return (loadingError.hasOwnProperty(key)) && (loadingError[key].hasError === true)
    }

    function setLoadingError(key, retryTimeMs) {
        if (!hasLoadingError(key)) {
            loadingError[key] = {
                hasError: true,
                time: maxTimeMs
            }
        }

        loadingError[key].hasError = true
        if (retryTimeMs === undefined) {
            loadingError[key].time = maxTimeMs
        } else {
            loadingError[key].time = Date.now() + retryTimeMs
        }
    }

    function clearLoadingError(key) {
        if (!loadingError.hasOwnProperty(key)) {
            return
        }
        loadingError[key].hasError = false
        loadingError[key].time = maxTimeMs
    }

    function getErrorRetryTime(key) {
        if (!hasLoadingError(key)) {
            return maxTimeMs
        }
        return loadingError[key].time
    }

    function getNextReloadTime(key) {
        var now = (new Date()).getTime()

        if (hasLoadingError(key)) {
            var t = getErrorRetryTime(key)
            print("getNextReloadTime: has loading error. Reload at " + (new Date(t)).toString())
            return t
        }

        var lastReload = getLastReloadedMs(key)
        lastReload = lastReload !== undefined ? lastReload : now
        var t1 = Number(lastReload + reloadIntervalMs)

        var t2 = expiresMsMap[key] ? expiresMsMap[key] : 0
        var nextReload = Math.max(t1, t2)

        dbgprint("getNextReloadTime: nextReload = " + (new Date(nextReload)).toString())
        return nextReload
    }

    function isReadyToReload(key) {
        var now = new Date()
        var t = getNextReloadTime(key)
        var res = now >= t - 1000
        dbgprint("isReadyToReload: now = " + now + ", t = " + new Date(t))
        dbgprint("isReadyToReload: " + res)
        return res
    }

    function setExpireTime(time, cacheKey) {
        expiresMsMap[cacheKey] = time
        plasmoid.configuration.expiresMsJson = JSON.stringify(expiresMsMap)
    }

    function getExpireTime(cacheKey) {
        return expiresMsMap[cacheKey]
    }

    function isExpired(key) {
        var expireTime = expiresMsMap[key]
        if (expireTime === undefined) {
            return true
        }

        var now = new Date()
        return now > expireTime
    }

    function updateNextReloadText(cacheKey) {
        var nextReloadTime = getNextReloadTime(cacheKey)
        var t = nextReloadTime - Date.now()
        nextReloadText = i18n("Next update is in %1", DataLoader.formatTimeIntervalString(t))
    }
}
