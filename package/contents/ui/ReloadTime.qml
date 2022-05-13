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

    property var abortTimers: ({})
    property var lastReloadedMsMap: ({})
    property var loadingError: ({})

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
        print("init: lastReloadedMsMap = " + JSON.stringify(lastReloadedMsMap))
    }

    function start(interval) {
        reloadTimer.interval = interval
        dbgprint("Start reload timer. interval = " + reloadTimer.interval +
                 ", next update in " + DataLoader.getLastReloadedTimeText(interval))
        reloadTimer.start()
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
        return (key in loadingError) && (loadingError[key] === true)
    }

    function setLoadingError(key, val) {
        loadingError[key] = val
    }

    function getNextReloadTime(key) {
        var now = (new Date()).getTime()

        if (key in loadingError && loadingError[key] === true) {
            var t = now + retryTimeMs
            print("getNextReloadTime: has loading error. Reload at " + (new Date(t)).toString())
            return t
        }

        var lastReload = getLastReloadedMs(key)
        lastReload = lastReload !== undefined ? lastReload : now
        var nextReload = Number(lastReload + reloadIntervalMs)

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
}