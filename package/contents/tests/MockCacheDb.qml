import QtQuick


QtObject {
    id: mockCacheDb

    property var loadingError: null

    property var nullLoadingError: null
    property var noConnectionloadingError: ({
            timestamp: 0,
            status: 0
    })

    property var _semaphoreHolder: ({})
    property var _loadingErrors: ({})

    property var _content: ({})


    function ensureUpdateSempahore(cacheKey) {

    }

    function obtainUpdateSemaphore(cacheKey, flag = undefined) {
        flag = (flag !== undefined) ? flag : plasmoidCacheId
        if (!_semaphoreHolder.hasOwnProperty(cacheKey)) {
            _semaphoreHolder[cacheKey] = flag
            return true
        }
        if (_semaphoreHolder[cacheKey] === flag || _semaphoreHolder[cacheKey] === -1) {
            _semaphoreHolder[cacheKey] = flag
            return true
        }
        return false
    }

    function checkUpdateSemaphore(key, flag = undefined) {
        flag = (flag !== undefined) ? flag : plasmoidCacheId
        if (_semaphoreHolder.hasOwnProperty(key)) {
            return _semaphoreHolder[key] === flag || _semaphoreHolder[key] === -1
        }
        return true
    }

    function releaseUpdateSemaphore(cacheKey) {
        _semaphoreHolder[cacheKey] = -1
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
