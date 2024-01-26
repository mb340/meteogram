.pragma library
.import "config-utils.js" as ConfigUtils

var debugLogging = false

function dbgprint(msg) {
    if (!debugLogging) {
        return
    }
    print('[weatherWidget] ' + msg)
}

function scheduleDataReload() {
    var now = new Date().getTime()
    loadingError = true
    return now + 600000
}

function getReloadedAgoMs(lastReloaded) {
    if (!lastReloaded) {
        lastReloaded = 0
    }
    return new Date().getTime() - lastReloaded
}

function generateCacheKey(placeObject) {
    let placeIdentifier = placeObject.providerId + "&" +
                            ConfigUtils.formatPlaceIdentifier(placeObject)
    return 'cache_' + Qt.md5(placeIdentifier)
}

function isXmlStringValid(xmlString) {
    return xmlString.indexOf('<?xml ') === 0 || xmlString.indexOf('<weatherdata>') === 0 || xmlString.indexOf('<current>') === 0
}

function fetchXmlFromInternet(getUrl, successCallback, failureCallback, cacheKey) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
        if (xhr.readyState !== XMLHttpRequest.DONE) {
            dbgprint(xhr.readyState)
            return
        }

        if (xhr.status !== 200 && xhr.status !== 203) {
            print('ERROR - url: ' + getUrl)
            print('ERROR - status: ' + xhr.status)
            if (xhr.responseText && xhr.responseText.length > 0) {
                print('ERROR - responseText: ' + xhr.responseText)
            }
            failureCallback(cacheKey)
            return
        }

        // success
        dbgprint('successfully loaded from the internet')
        dbgprint('successfully of url-call: ' + getUrl)
//        dbgprint('responseText: ' + xhr.responseText)

        var xmlString = xhr.responseText
        if (!isXmlStringValid(xmlString)) {
            print('incoming xmlString is not valid: ' + xmlString)
            return
        }
        dbgprint('incoming text seems to be valid')

        successCallback(xmlString)
    }
    dbgprint('GET url opening: ' + getUrl)
    xhr.open('GET', getUrl)
    dbgprint('GET url sending: ' + getUrl)
    xhr.send()

    dbgprint('GET called for url: ' + getUrl)
    return xhr
}

function fetchJsonFromInternet(getUrl, successCallback, failureCallback, cacheKey) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
        if (xhr.readyState !== XMLHttpRequest.DONE) {
            return
        }

        if (xhr.status !== 200 && xhr.status !== 203) {
            print('ERROR - url: ' + getUrl)
            print('ERROR - status: ' + xhr.status)
            if (xhr.responseText && xhr.responseText.length > 0) {
                print('ERROR - responseText: ' + xhr.responseText)
            }
            failureCallback(cacheKey)
            return
        }

        // success
        dbgprint('successfully loaded from the internet')
        dbgprint('successfully of url-call: ' + getUrl)
//        dbgprint('responseText: ' + xhr.responseText)

        var jsonString = xhr.responseText
        if (!IsJsonString(jsonString)) {
            print('incoming jsonString is not valid: ' + jsonString)
            return
        }
        dbgprint('incoming text seems to be valid')

        successCallback(jsonString)
    }
    dbgprint('GET url opening: ' + getUrl)
    xhr.open('GET', getUrl)
    dbgprint('GET url sending: ' + getUrl)
    xhr.send()

    dbgprint('GET called for url: ' + getUrl)
    return xhr
}

function IsJsonString(str) {
    try {
        JSON.parse(str)
    } catch (e) {
        return false
    }
    return true
}
