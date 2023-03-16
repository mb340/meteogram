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

    readonly property double msPerMin: 60 * 1000

    readonly property double noConnectionRetryTime: 1 * msPerMin
    readonly property double httpErrorRetryTime: 60 * msPerMin
    readonly property double semaphoreWaitTime: 1 * msPerMin


    property int reloadInterval: plasmoid.configuration.reloadIntervalMin

    property int state: ReloadTimer.State.INITIAL

    property var loadingErr: null
    property double lastLoadTime: -1
    property double nextLoadTime: -1
    property double expireTime: -1

    property string nextLoadText: ''
    property string lastLoadText: ''

    required property var main
    required property var cacheDb

    property alias reloadTimer: reloadTimer


    enum State {
        INITIAL = 0,
        WAIT_SEMAPHORE = 1,
        LOADING_ERROR = 2,
        EXPIRE_TIME = 3,
        SCHEDULED_RELOAD = 4,
        LOADING = 5
    }


    Timer {
        id: reloadTimer
        interval: 60 * msPerMin
        running: false
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            // print("ReloadTimer: onTriggered: state", stateToString(state))
            switch (state) {
                case ReloadTimer.State.WAIT_SEMAPHORE:
                    main.loadFromCache()
                    break

                case ReloadTimer.State.LOADING_ERROR:
                case ReloadTimer.State.EXPIRE_TIME:
                case ReloadTimer.State.SCHEDULED_RELOAD:
                    state = ReloadTimer.State.LOADING
                    main.reloadData()
                    break

                default:
                case ReloadTimer.State.INITIAL:
                    break
            }
        }
    }

    property var getDateNow: function() {
        return Date.now()
    }

    function getRetryInterval(status) {
        if (status === 0) {
            return noConnectionRetryTime
        } else if (status >= 100 || status < 600) {
            return httpErrorRetryTime
        }
        return undefined
    }

    function getTimerInterval(timestamp) {
        let dt = timestamp - getDateNow()
        return dt
    }

    function fireTimer(interval) {
        reloadTimer.stop()

        interval = Math.max(0, interval)
        nextLoadTime = getDateNow() + interval

        // print("fireTimer: nextLoadTime ", nextLoadTime, new Date(nextLoadTime))

        reloadTimer.interval = interval
        reloadTimer.start()
    }

    function handleWaitSemaphoreState() {
        fireTimer(semaphoreWaitTime)
    }

    function handleLoadingErrorState() {
        let timerInterval = 0
        let interval = getRetryInterval(loadingErr.status)
        if (interval !== undefined) {
            timerInterval = getTimerInterval(getDateNow()/*loadingErr.timestamp*/ + interval)
        } else {
            state = ReloadTimer.State.INITIAL
        }

        fireTimer(timerInterval)
    }

    function handleExpireTime() {
        let timerInterval = getTimerInterval(expireTime)
        fireTimer(timerInterval)
    }

    function handleNextReload() {
        let timerInterval = undefined
        if (lastLoadTime === -1) {
            timerInterval = 0
        } else {
            let nextLoadTime = lastLoadTime + (reloadInterval * msPerMin)
            timerInterval = getTimerInterval(nextLoadTime)
        }

        fireTimer(timerInterval)
    }

    function handleState() {
        print("ReloadTimer: handleState",  stateToString(state))
        switch (state) {
            default:
            case ReloadTimer.State.INITIAL:
                updateState()
                break
            case ReloadTimer.State.WAIT_SEMAPHORE:
                handleWaitSemaphoreState()
                break
            case ReloadTimer.State.LOADING_ERROR:
                handleLoadingErrorState()
                break
            case ReloadTimer.State.EXPIRE_TIME:
                handleExpireTime()
                break
            case ReloadTimer.State.SCHEDULED_RELOAD:
                handleNextReload()
                break
        }
        updateLastLoadText()
        updateNextLoadText()
    }

    function stop() {
        reloadTimer.stop()
        state = ReloadTimer.State.INITIAL
    }

    function resetState(key) {
        reloadTimer.stop()
        state = ReloadTimer.State.INITIAL
        updateState(key)
    }

    function forceState(key, _state) {
        state = _state
        handleState(state)
    }

    function checkNextLoadElapsed(cacheKey) {
        if (state === ReloadTimer.State.LOADING) {
            return
        }

        let now = getDateNow()
        if (nextLoadTime >= 0 && nextLoadTime < now) {
            // print("ReloadTimer: rearmTimer")
            updateState(cacheKey)
        }
    }

    function forceLoad(key) {
        let expireTime = cacheDb.readPlaceCacheExpireTime(key)
        if (expireTime > 0) {
            if (expireTime > getDateNow()) {
                print("ReloadTimer: forceLoad: Can't force load.")
                return
            }
        }

        reloadTimer.stop()
        state = ReloadTimer.State.SCHEDULED_RELOAD
        reloadTimer.interval = 0
        reloadTimer.start()
    }

    function updateState(key) {
        print("ReloadTimer: updateState: key", key,", state =", stateToString(state))

        if (state === ReloadTimer.State.LOADING) {
            reloadTimer.stop()
            return
        }

        var flag = cacheDb.checkUpdateSemaphore(key)
        if (flag === false) {
            state = ReloadTimer.State.WAIT_SEMAPHORE
            handleState()
            return
        }

        loadingErr = cacheDb.readLoadingError(key)
        if (loadingErr !== null) {
            state = ReloadTimer.State.LOADING_ERROR
            handleState()
            return
        }

        expireTime = cacheDb.readPlaceCacheExpireTime(key)
        lastLoadTime = cacheDb.readPlaceCacheTimestamp(key)
        print("ReloadTimer: updateState: lastLoadTime:", lastLoadTime,  new Date(lastLoadTime))
        print("ReloadTimer: updateState: expireTime:", expireTime,  new Date(expireTime))

        if (lastLoadTime === -1) {
            lastLoadTime = 0
        }

        let nextLoadTime = lastLoadTime + (reloadInterval * msPerMin)        
        if (expireTime > nextLoadTime) {
            state = ReloadTimer.State.EXPIRE_TIME
        } else {
            state = ReloadTimer.State.SCHEDULED_RELOAD
        }
        handleState()
    }

    function updateNextLoadText() {
        if (nextLoadTime < 0) {
            nextLoadText = i18n("Never")
            return
        }
        if (state === ReloadTimer.State.LOADING) {
            nextLoadText = i18n("Loading")
            return
        }
        let interval = nextLoadTime - getDateNow()
        let intervalStr = timeUtils.formatTimeIntervalString(interval)
        nextLoadText = i18n("Next update is in %1", intervalStr)
        // print("nextLoadText = ", nextLoadText)
    }

    function updateLastLoadText() {
        if (state === ReloadTimer.State.LOADING_ERROR) {
            let errorMsg = ""
            if (loadingErr.status === 0) {
                errorMsg = i18n("No connection")
            } else {
                errorMsg = loadingErr.status
            }
            lastLoadText = i18n("Error") + ": " + errorMsg
            return
        }

        if (state === ReloadTimer.State.EXPIRE_TIME) {
            lastLoadText = i18n("Expirey time")
            return
        }

        if (lastLoadTime === null) {
            lastLoadText = i18n("Never")
            return
        } else {
            let interval = getDateNow() - lastLoadTime
            let intervalStr = timeUtils.formatTimeIntervalString(interval)
            lastLoadText = i18n("↓ %1 ago", intervalStr)
        }
        // print("lastLoadText = ", lastLoadText)
    }

    function stateToString(state) {
        switch (state) {
            default:
            case ReloadTimer.State.INITIAL:
                return "INITIAL"
            case ReloadTimer.State.WAIT_SEMAPHORE:
                return "WAIT_SEMAPHORE"
            case ReloadTimer.State.LOADING_ERROR:
                return "LOADING_ERROR"
            case ReloadTimer.State.EXPIRE_TIME:
                return "EXPIRE_TIME"
            case ReloadTimer.State.SCHEDULED_RELOAD:
                return "SCHEDULED_RELOAD"
            case ReloadTimer.State.LOADING:
                return "LOADING"
        }
        return null
    }

    Component.onCompleted: {
        updateNextLoadText()
        updateLastLoadText()
    }

}