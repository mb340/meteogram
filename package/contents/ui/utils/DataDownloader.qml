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


Item {
    id: dataDownloader

    property int abortTimeInterval: 60 * 1000

    property bool loadingData: false
    property var loadingXhrs: ({})
    property var abortTimers: ({})

    required property var cacheDb
    required property var reloadTimer

    required property var currentCacheKey
    required property var currentProvider

    signal loadFromCache()


    function clearLoadingXhrs(cacheKey, abort) {
        let xhrs = loadingXhrs[cacheKey]
        if (!xhrs) {
            return
        }

        if (abort === true) {
            xhrs.forEach(function (xhr) {
                xhr.abort()
            })
        }
        loadingXhrs[cacheKey] = []
    }

    function reloadDataSuccessCallback(contentToCache, cacheKey) {
        print("Data Loaded From Internet successfully.")

        stopAbortTimer(cacheKey)

        let expireTime = -1
        let xhrs = loadingXhrs[cacheKey]

        if (xhrs.length > 0) {
            var xhr = xhrs[0]
            var expires = xhr.getResponseHeader("expires");
            if (expires) {
                expireTime = Date.parse(expires)
            }
        }

        var ts = new Date().getTime()
        cacheDb.writePlaceCache(cacheKey, contentToCache, ts, expireTime)
        cacheDb.clearLoadingError(cacheKey)

        clearLoadingXhrs(cacheKey)

        cacheDb.releaseUpdateSemaphore(cacheKey)
        loadingData = false

        if (currentCacheKey === cacheKey) {
            loadFromCache()
        } else {
        }
        reloadTimer.resetState(cacheKey)
    }

    function reloadDataFailureCallback(cacheKey) {
        print("Failed to load data. cacheKey = " + cacheKey)

        stopAbortTimer(cacheKey)

        let noConnection = false
        let errorXhr = null
        let xhrs = loadingXhrs[cacheKey]
        xhrs.forEach(function (xhr) {
            noConnection |= (xhr.status === 0)
            if (noConnection) {
                errorXhr = !errorXhr ? xhr : errorXhr
            } else if (xhr.status !== 200) {
                errorXhr = !errorXhr ? xhr : errorXhr
            }
        })
        clearLoadingXhrs(cacheKey, true)

        if (errorXhr !== null) {
            var ts = Date.now()
            cacheDb.writeLoadingError(cacheKey, ts, errorXhr.status)
        }

        cacheDb.releaseUpdateSemaphore(cacheKey)
        loadingData = false

        reloadTimer.resetState(cacheKey)
    }

    function reloadData(cacheKey) {
        dbgprint("reloadData")

        if (loadingData) {
            dbgprint('still loading')
            return false
        }

        let sem = cacheDb.obtainUpdateSemaphore(cacheKey)
        if (sem === false) {
            print("reloadData: Couldn't obtain update semaphore")
            reloadTimer.forceState(cacheKey, ReloadTimer.State.WAIT_SEMAPHORE)
            return false
        }

        loadingData = true

        var args = {
            placeIdentifier: placeIdentifier,
            timezoneID: timezoneID,
            cacheKey, cacheKey
        }
        let xhrs = currentProvider.loadDataFromInternet(reloadDataSuccessCallback,
                                                        reloadDataFailureCallback, args)
        loadingXhrs[cacheKey] = xhrs

        startAbortTimer(cacheKey, () => reloadDataFailureCallback(cacheKey))
        return true
    }


    Component {
        id: abortTimer
        Timer {
            interval: abortTimeInterval
            running: false
            repeat: false
            triggeredOnStart: false
        }
    }

    function startAbortTimer(key, func) {
        if (!abortTimers[key]) {
            abortTimers[key] = abortTimer.createObject(dataDownloader)
            abortTimers[key].triggered.connect(func)
        }

        abortTimers[key].restart()
    }

    function stopAbortTimer(key) {
        if (abortTimers[key]) {
            abortTimers[key].stop()
            abortTimers[key] = null
        }
    }

}
