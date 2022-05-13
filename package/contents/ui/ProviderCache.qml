import QtQuick 2.0

QtObject {

    id: providerCache

    property var cacheMap: ({})

    function initCache(cacheContent) {
        // fill xml cache xml
        if (cacheContent) {
            try {
                cacheMap = JSON.parse(cacheContent)
                dbgprint('cacheMap initialized - keys:')
                for (var key in cacheMap) {
                    dbgprint('  ' + key + ', data: ' + cacheMap[key])
                    lastTryReloadMap[key] = 0
                }
            } catch (error) {
                dbgprint('error parsing cacheContent')
            }
        }
        cacheMap = cacheMap || {}
    }

    function getContent(key) {
        return cacheMap[key]
    }


    function setContent(key, content) {
        dbgprint('saving cacheKey = ' + key)
        cacheMap[key] = content
    }

    function printKeys() {
        dbgprint('cacheMap now has these keys:')
        for (var key in cacheMap) {
            dbgprint('  ' + key)
        }
    }

    function hasKey(key) {
        return cacheMap && cacheMap[key] !== undefined
    }

}
