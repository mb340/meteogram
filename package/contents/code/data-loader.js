.pragma library

var initialized = false
var i18n = null
var dbgprint = null

function formatTimeIntervalString(time) {
    if (time < 60 * 1000) {
        return i18n("%1 s", Math.round(time / 1000))
    }

    var mins = time / 60000
    if (mins <= 180) {
        return i18n("%1 m", Math.round(mins))
    }

    var hours = mins / 60
    if (hours <= 48) {
        return i18n("%1 h", Math.round(hours))
    }

    var days = hours / 24
    if (days <= 14) {
        return i18n("%1 d", Math.round(days))
    }

    return i18n("a long time")
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

function generateCacheKey(placeIdentifier) {
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

        if (xhr.status !== 200) {
            print('ERROR - status: ' + xhr.status)
            print('ERROR - responseText: ' + xhr.responseText)
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

        if (xhr.status !== 200) {
            print('ERROR - status: ' + xhr.status)
            print('ERROR - responseText: ' + xhr.responseText)
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
