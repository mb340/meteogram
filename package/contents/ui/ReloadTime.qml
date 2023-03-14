import QtQuick 2.0

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
    property var expiresMsMap: ({})
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

    function start(cacheKey) {
        const INT_MAX = 2147483647
        var interval = getNextReloadTime(cacheKey) - Date.now()
        interval = Math.min(interval, INT_MAX)

        if (interval > 0) {
            reloadTimer.interval = interval
            dbgprint("ReloadTime: Start reload timer. interval = " + reloadTimer.interval +
                     ", next update in " + timeUtils.formatTimeIntervalString(interval))
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

    function setLastReloadedMs(key, timestamp) {
        if (lastReloadedMsMap[key] !== undefined) {
            timestamp = Math.max(timestamp, lastReloadedMsMap[key])
        }
        lastReloadedMsMap[key] = timestamp
    }

    function getLastReloadedMs(key) {
        if (!lastReloadedMsMap.hasOwnProperty(key)) {
            let ts = cacheDb.readPlaceCacheTimestamp(key)
            if (ts >= 0) {
                lastReloadedMsMap[key] = ts
            }
        }

        let lastReload = lastReloadedMsMap[key]
        let nextReload = lastReload + reloadIntervalMs
        if (Date.now() < nextReload) {
            // Check if someone else updated the cache more recently
            let ts = cacheDb.readPlaceCacheTimestamp(key)
            if (ts > lastReload) {
                lastReloadedMsMap[key] = ts
                lastReload = ts
            }
        }

        if (lastReload >= 0) {
            return lastReload
        }
        return undefined
    }

    function setLoadingError(key, timestamp, status) {
        if (loadingError.hasOwnProperty(key)) {
            // Do nothing if there is a more recent error
            if (loadingError[key].timestamp > timestamp) {
                return
            }
        }

        loadingError[key] = {
            timestamp: timestamp,
            status, status
        }
    }

    function getLoadingError(key) {
        if (!loadingError.hasOwnProperty(key)) {
            let res = cacheDb.readLoadingError(key)
            if (res !== null) {
                loadingError[key] = {
                    timestamp: res.timestamp,
                    status: res.status
                }
            }
        }

        let res = loadingError[key]
        let nextExpire = 0
        if (res != null) {
            let interval = getRetryIntervalFromStatus(res.status)
            if (interval !== undefined) {
                nextExpire = res.timestamp + interval
            }
        }

        if (Date.now() > nextExpire) {
            // Check if someone else updated the cache more recently
            let _res = cacheDb.readLoadingError(key)
            if (_res !== null) {
                let interval = getRetryIntervalFromStatus(_res.status)
                if (nextExpire < _res.timestamp + interval) {
                    loadingError[key] = _res
                    res = _res
                }
            }
        }

        return res
    }

    function clearLoadingError(key) {
        if (!loadingError.hasOwnProperty(key)) {
            return
        }
        delete loadingError[key]
    }

    function getRetryIntervalFromStatus(status) {
        if (status === 0) {
            return retryTimeMs
        } else if (status >= 100 || status < 600) {
            return (60 * 60 * 1000)
        }
        return undefined
    }

    function getErrorRetryTime(key) {
        let res = getLoadingError(key)
        if (res === undefined) {
            return undefined
        }

        let interval = getRetryIntervalFromStatus(res.status)
        if (interval !== undefined) {
            return res.timestamp + interval
        }

        return undefined
    }

    function getNextReloadTime(key) {
        var now = (new Date()).getTime()

        var t = getErrorRetryTime(key)
        if (t !== undefined && t >= 0) {
            dbgprint("getNextReloadTime: has loading error. Reload at " + (new Date(t)).toString())
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
    }

    function getExpireTime(cacheKey) {
        if (!expiresMsMap.hasOwnProperty(cacheKey)) {
            let ts = cacheDb.readPlaceCacheExpireTime(cacheKey)
            if (ts >= 0) {
                expiresMsMap[key] = ts
            }
        }

        let expireTime = expiresMsMap[cacheKey]
        if (Date.now() < expireTime) {
            // Check if someone else updated the cache more recently
            let ts = cacheDb.readPlaceCacheExpireTime(cacheKey)
            if (ts > expireTime) {
                expiresMsMap[key] = ts
                expireTime = ts
            }
        }

        if (expireTime >= 0) {
            return expireTime
        }

        return undefined
    }

    function isExpired(key) {
        var expireTime = getExpireTime(key)
        if (expireTime === undefined) {
            return true
        }

        var now = new Date()
        return now > expireTime
    }

    function updateNextReloadText(cacheKey) {
        var nextReloadTime = getNextReloadTime(cacheKey)
        var t = nextReloadTime - Date.now()
        nextReloadText = i18n("Next update is in %1", timeUtils.formatTimeIntervalString(t))
    }
}
