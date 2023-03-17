import QtQuick 2.0


QtObject {
    id: mockCacheDb

    property bool semaphoreFlag: true
    property var loadingError: null

    property var nullLoadingError: null
    property var noConnectionloadingError: ({
            timestamp: 0,
            status: 0
    })

    property var _semaphoreHolder: null
    property var _loadingErrors: ({})

    property var _content: ({})


    function ensureUpdateSempahore(cacheKey) {

    }

    function obtainUpdateSemaphore(cacheKey, flag = undefined) {
        if (_semaphoreHolder === null) {
            _semaphoreHolder = cacheKey
            return true
        }
        return false
    }

    function checkUpdateSemaphore(key) {
        if (_semaphoreHolder === null || _semaphoreHolder === key) {
            return true
        }
        return false
    }

    function releaseUpdateSemaphore(cacheKey) {
        if (_semaphoreHolder === cacheKey) {
            _semaphoreHolder = null
            return
        }
    }

    function writePlaceCache(cacheKey, content, timestamp, expireTime) {
        _content[cacheKey] = {
            content: content,
            timestamp: timestamp,
            expireTime: expireTime
        }
    }

    function getContent(cacheKey) {
        return _content[cacheKey].content
    }

    function readPlaceCacheTimestamp(key) {
        return _content[key].timestamp
    }

    function readPlaceCacheExpireTime(key) {
        return _content[key].expireTime
    }

    function hasKey(cacheKey) {
        return _content.hasOwnProperty(cacheKey)
    }

    function writeLoadingError(cacheKey, timestamp, status) {
        _loadingErrors[cacheKey] = {
            timestamp: timestamp,
            status: status
        }
    }

    function readLoadingError(cacheKey) {
        return _loadingErrors[cacheKey]
    }

    function clearLoadingError(cacheKey) {
        delete _loadingErrors[cacheKey]
    }
}
