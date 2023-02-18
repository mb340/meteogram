/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
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
import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 2.15
import "../code/data-loader.js" as DataLoader
import "../code/config-utils.js" as ConfigUtils
import "../code/icons.js" as IconTools
import "../code/unit-utils.js" as UnitUtils
import "providers"

Item {
    id: main

    property bool initialized: false

    property string placeIdentifier
    property string placeAlias
    property string cacheKey
    property int timezoneID
    property string timezoneShortName
    property bool renderMeteogram: plasmoid.configuration.renderMeteogram
    property int temperatureType: plasmoid.configuration.temperatureType
    property int pressureType: plasmoid.configuration.pressureType
    property int windSpeedType: plasmoid.configuration.windSpeedType
    property int timezoneType: plasmoid.configuration.timezoneType
    property string widgetFontName: plasmoid.configuration.widgetFontName
    property int widgetFontSize: plasmoid.configuration.widgetFontSize

    property bool twelveHourClockEnabled: Qt.locale().timeFormat(Locale.ShortFormat).toString().indexOf('AP') > -1
    property string placesJsonStr: plasmoid.configuration.places
    property bool onlyOnePlace: true

    property string datetimeFormat: 'yyyy-MM-dd\'T\'hh:mm:ss'
    property var xmlLocale: Qt.locale('en_GB')

    property alias currentWeatherModel: currentWeatherModel

    property string overviewImageSource
    property string creditLink
    property string creditLabel

    property bool loadingData: false              // Download Attempt in progress Flag.
    property var loadingXhrs: []                  // Array of Download Attempt Objects
    property bool imageLoadingError: true
    property bool alreadyLoadedFromCache: false

    property string lastReloadedText: '⬇ 0m ago'
    property string tooltipSubText: ''

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    property bool onDesktop: (plasmoid.location == PlasmaCore.Types.Desktop || plasmoid.location == PlasmaCore.Types.Floating)
    property bool inTray: false
    property string plasmoidCacheId: plasmoid.id

    property int inTrayActiveTimeoutSec: plasmoid.configuration.inTrayActiveTimeoutSec

    property int nextDaysCount: 8

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5

    // 0 - standard
    // 1 - vertical
    // 2 - compact
    property int layoutType: plasmoid.configuration.layoutType

    property bool updatingPaused: false

    property var currentProvider: null

    property bool meteogramModelChanged: false

    anchors.fill: parent

    property Component crInTray: CompactRepresentationInTray { }
    property Component cr: CompactRepresentation { }

    property Component frInTray: FullRepresentationInTray { }
    property Component fr: FullRepresentation {
        Component.onCompleted: {
            main.onMeteogramModelChangedChanged.connect(this.meteogram.fullRedraw)
        }
    }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: cr
    Plasmoid.fullRepresentation: fr

    property bool debugLogging: plasmoid.configuration.debugLogging

    FontLoader {
        id: weatherIconFont
        source: '../fonts/weathericons-regular-webfont-2.0.10.ttf'
    }

    ProviderCache {
        id: providerCache
    }

    ReloadTime {
        id: reloadTime
    }

    MetNo {
        id: metnoProvider
    }

    OpenWeatherMap {
        id: owmProvider
    }

    ListModel {
        id: actualWeatherModel
    }

    CurrentWeatherModel {
        id: currentWeatherModel
    }

    ManagedListModel {
        id: nextDaysModel
    }

    ManagedListModel {
        id: meteogramModel
    }


    ListModel {
        id: weatherAlertsModel
    }

    function initPausedAction() {
        plasmoid.setAction('toggleUpdatingPaused',
                           updatingPaused ? i18n("Resume Updating") : i18n("Pause Updating"),
                           updatingPaused ? 'media-playback-start' : 'media-playback-pause');
    }

    function action_toggleUpdatingPaused() {
        updatingPaused = !updatingPaused
        initPausedAction()
        if (updatingPaused) {
            reloadTime.stop()
        } else {
            rearmTimer()
        }
    }

    WeatherCache {
        id: weatherCache
        cacheId: plasmoidCacheId
    }

    function saveCache() {
        var s = JSON.stringify(providerCache.cacheMap)
        weatherCache.writeCache(s)
    }

    Connections {
        target: plasmoid
        function onExpandedChanged() {
            rearmTimer()
        }
    }

    function initUtils() {
        if (!DataLoader.initialized) {
            DataLoader.i18n = i18n
            DataLoader.dbgprint = dbgprint
            DataLoader.initialized = true
        }
        if (!UnitUtils.initialized) {
            UnitUtils.main = main
            UnitUtils.i18n = i18n
            UnitUtils.initialized = true
        }
        if (!IconTools.initialized) {
            IconTools.i18n = i18n
            IconTools.initialized = true
        }
    }

    Component.onCompleted: {
        initUtils()
        if (plasmoid.configuration.firstRun) {
          if (plasmoid.configuration.widgetFontSize === undefined) {
            plasmoid.configuration.widgetFontSize = 32
            widgetFontSize = 32
          }
            switch (Qt.locale().measurementSystem) {
                case (Locale.MetricSystem):
                  plasmoid.configuration.temperatureType = 0
                  plasmoid.configuration.pressureType = 0
                  plasmoid.configuration.windSpeedType = 2
                  break;
                case (Locale.ImperialUSSystem):
                  plasmoid.configuration.temperatureType = 1
                  plasmoid.configuration.pressureType = 1
                  plasmoid.configuration.windSpeedType = 1
                  break;
                case (Locale.ImperialUKSystem):
                  plasmoid.configuration.temperatureType = 0
                  plasmoid.configuration.pressureType = 0
                  plasmoid.configuration.windSpeedType = 1
                  break;
            }
            plasmoid.configuration.firstRun = false
        }
        inTray = (plasmoid.parent !== null && (plasmoid.parent.pluginName === 'org.kde.plasma.private.systemtray' || plasmoid.parent.objectName === 'taskItemContainer'))
        plasmoidCacheId = inTray ? plasmoid.parent.id : plasmoid.id
        dbgprint('inTray=' + inTray + ', plasmoidCacheId=' + plasmoidCacheId)

        // systray settings
        if (inTray) {
            Plasmoid.compactRepresentation = crInTray
            Plasmoid.fullRepresentation = frInTray
        }

        // init contextMenu
        initPausedAction()

        // fill xml cache xml
        var cacheContent = weatherCache.readCache()
        providerCache.initCache(cacheContent)

        reloadTime.init()

        initialized = true

        // set initial place
        setNextPlace(true)

        updateViewsTimer.init()
    }

    onPlacesJsonStrChanged: {
        if (!initialized) {
            return
        }
        if (placesJsonStr === '') {
            return
        }
        onlyOnePlace = ConfigUtils.getPlacesArray().length === 1
        setNextPlace(true)
    }

    function setCurrentProviderAccordingId(providerId) {
        if (providerId === 'owm') {
            dbgprint('setting provider OpenWeatherMap')
            currentProvider = owmProvider
        }
        if (providerId === "metno") {
            dbgprint('setting provider metno')
            currentProvider = metnoProvider
        }
     }

    function setNextPlace(initial,direction) {
        currentWeatherModel.clear()

        if (direction === undefined) {
          direction = "+"
        }

        var places = ConfigUtils.getPlacesArray()
        onlyOnePlace = places.length === 1
        dbgprint('places count=' + places.length + ', placeIndex=' + plasmoid.configuration.placeIndex)
        var placeIndex = plasmoid.configuration.placeIndex
        if (!initial) {
            (direction === "+") ? placeIndex++ :placeIndex--
        }
        if (placeIndex > places.length - 1) {
            placeIndex = 0
        }
        if (placeIndex < 0 ) {
            placeIndex = places.length - 1
        }
        plasmoid.configuration.placeIndex = placeIndex
        dbgprint('placeIndex now: ' + plasmoid.configuration.placeIndex)
        var placeObject = places[placeIndex]
        placeIdentifier = placeObject.placeIdentifier
        placeAlias = placeObject.placeAlias
        if (placeObject.timezoneID  === undefined ) {
          placeObject.timezoneID = -1
        }
        timezoneID = parseInt(placeObject.timezoneID)
        dbgprint('next placeIdentifier is: ' + placeIdentifier)
        cacheKey = DataLoader.generateCacheKey(placeIdentifier)
        dbgprint('next cacheKey is: ' + cacheKey)

        alreadyLoadedFromCache = false

        setCurrentProviderAccordingId(placeObject.providerId)

        var ok = loadFromCache()
        if (!ok) {
            reloadData()
        }

        rearmTimer()
    }

    function clearLoadingXhrs() {
        if (loadingXhrs) {
            loadingXhrs.forEach(function (xhr) {
                xhr.abort()
            })
            loadingXhrs = []
        }

        loadingData = false
    }

    function dataLoadedFromInternet(contentToCache, cacheKey) {
        dbgprint("Data Loaded From Internet successfully.")
        reloadTime.stopAbortTimer(cacheKey)

        providerCache.setContent(cacheKey, contentToCache)
        providerCache.printKeys()

        saveCache()

        reloadTime.setLastReloadedMs(cacheKey)

        clearLoadingXhrs()

        if (main.cacheKey === cacheKey) {
            alreadyLoadedFromCache = false
            loadFromCache()
            rearmTimer()
        }
    }

    function reloadDataFailureCallback(cacheKey) {
        print("Failed to load data. cacheKey = " + cacheKey)
        clearLoadingXhrs()
        reloadTime.setLoadingError(cacheKey, true)
        if (main.cacheKey === cacheKey) {
            rearmTimer()
        }
    }

    function reloadData() {
        dbgprint("reloadData")

        if (loadingData) {
            dbgprint('still loading')
            return false
        }

        loadingData = true
        reloadTime.stopAbortTimer(cacheKey)
        reloadTime.setLoadingError(cacheKey, false)

        var args = {
            placeIdentifier: placeIdentifier,
            timezoneID: timezoneID,
            cacheKey, cacheKey
        }
        loadingXhrs = currentProvider.loadDataFromInternet(dataLoadedFromInternet, reloadDataFailureCallback, args)

        reloadTime.startAbortTimer(cacheKey, () => reloadDataFailureCallback(cacheKey))
        return true
    }

    function reloadMeteogram() {
        meteogramModelChanged = !meteogramModelChanged
        currentProvider.reloadMeteogramImage(placeIdentifier)
    }

    function rearmTimer() {
        var t = reloadTime.getNextReloadTime(cacheKey) - (new Date()).getTime()
        dbgprint("rearmTimer: t = " + t)
        if (t > 0) {
            reloadTime.stop()
            reloadTime.start(t)
            updateLastReloadedText()
        } else {
            dbgprint("rearmTimer: try reload now")
            reloadData()
        }
    }

    function loadFromCache() {
         dbgprint('loading from cache, config key: ' + cacheKey)

        if (alreadyLoadedFromCache) {
            print('already loaded from cache')
            return true
        }

        creditLink = currentProvider.getCreditLink(placeIdentifier, placeAlias)
        creditLabel = currentProvider.getCreditLabel(placeIdentifier)

        if (!providerCache.hasKey(cacheKey)) {
            print('error: cache not available')
            return false
        }

        weatherAlertsModel.clear()

        var content = providerCache.getContent(cacheKey)
        var success = currentProvider.setWeatherContents(content)
        if (!success) {
            print('error: setting weather contents not successful')
            return false
        }

        updateLastReloadedText()
        refreshTooltipSubText()
        reloadMeteogram()
        alreadyLoadedFromCache = true
        return true
    }

    onInTrayActiveTimeoutSecChanged: {
        initUtils()
        if (placesJsonStr === '') {
            return
        }
        updateLastReloadedText()
    }

    function getPlasmoidStatus(lastReloaded, inTrayActiveTimeoutSec) {
        var reloadedAgoMs = DataLoader.getReloadedAgoMs(lastReloaded)
        if (reloadedAgoMs < inTrayActiveTimeoutSec * 1000) {
            return PlasmaCore.Types.ActiveStatus
        } else {
            return PlasmaCore.Types.PassiveStatus
        }
    }

    function updateLastReloadedText() {
        var lastReloadedMs = (new Date()).getTime() - reloadTime.getLastReloadedMs(cacheKey)
        lastReloadedText = '⬇ ' + i18n('%1 ago',
                            DataLoader.getLastReloadedTimeText(lastReloadedMs))
        plasmoid.status = getPlasmoidStatus(lastReloadedMs, inTrayActiveTimeoutSec)
    }

    function refreshTooltipSubText() {
        dbgprint('refreshing sub text')
        if (!currentWeatherModel.valid) {
            dbgprint('model not yet ready')
           return
        }
        var nearFutureWeather = currentWeatherModel.nearFuture
        var futureWeatherIcon = IconTools.getIconCode(nearFutureWeather.iconName, currentProvider.providerId, getPartOfDayIndex())
        var wind1=Math.round(currentWeatherModel.windDirection)
        var windDirectionIcon = IconTools.getWindDirectionIconCode(wind1)

        var sunRiseTime = ""
        var sunSetTime = ""
        if (UnitUtils.hasSunriseSunsetData()) {
            let sunRise = currentWeatherModel.sunRise
            let sunSet = currentWeatherModel.sunSet
            sunRiseTime = Qt.formatTime(sunRise, Qt.locale().timeFormat(Locale.ShortFormat))
            sunSetTime = Qt.formatTime(sunSet, Qt.locale().timeFormat(Locale.ShortFormat))
        }

        var subText = ''
        subText += '<br /><font size="4" style="font-family: weathericons;">' + windDirectionIcon + '</font><font size="4"> ' + wind1 + '\u00B0 &nbsp; @ ' + UnitUtils.getWindSpeedText(currentWeatherModel.windSpeedMps, windSpeedType) + '</font>'
        subText += '<br /><font size="4">' + UnitUtils.getPressureText(currentWeatherModel.pressureHpa, pressureType) + '</font>'
        subText += '<br /><table>'
        if ((currentWeatherModel.humidity !== undefined) && (currentWeatherModel.cloudiness !== undefined)) {
            subText += '<tr>'
            subText += '<td><font size="4"><font style="font-family: weathericons">\uf07a</font>&nbsp;' + currentWeatherModel.humidity + '%</font></td>'
            subText += '<td><font size="4"><font style="font-family: weathericons">\uf013</font>&nbsp;' + currentWeatherModel.cloudiness + '%</font></td>'
            subText += '</tr>'
            subText += '<tr><td>&nbsp;</td><td></td></tr>'
        }
        if (UnitUtils.hasSunriseSunsetData()) {
            subText += '<tr>'
            subText += '<td><font size="4"><font style="font-family: weathericons">\uf051</font>&nbsp;' + sunRiseTime + ' '+timezoneShortName + '&nbsp;&nbsp;&nbsp;</font></td>'
            subText += '<td><font size="4"><font style="font-family: weathericons">\uf052</font>&nbsp;' + sunSetTime + ' '+timezoneShortName + '</font></td>'
            subText += '</tr>'
        }
        subText += '</table>'

        subText += '<br /><br />'
        subText += '<font size="3">' + i18n("near future") + '</font>'
        subText += '<b>'
        subText += '<font size="6">&nbsp;&nbsp;&nbsp;' + UnitUtils.getTemperatureNumber(nearFutureWeather.temperature, temperatureType) + UnitUtils.getTemperatureEnding(temperatureType)
        subText += '&nbsp;&nbsp;&nbsp;<font style="font-family: weathericons">' + futureWeatherIcon + '</font></font>'
        subText += '</b>'
        tooltipSubText = subText
    }

    function getPartOfDayIndex() {
        if (!UnitUtils.hasSunriseSunsetData()) {
            return 0
        }
        var now = new Date()
        return currentWeatherModel.sunRise < now && now < currentWeatherModel.sunSet ? 0 : 1
    }

    function abortTooLongConnection(forceAbort) {
        if (!loadingData) {
            return
        }
        if (forceAbort) {
            dbgprint('timeout reached, aborting existing xhrs')
            loadingXhrs.forEach(function (xhr) {
                xhr.abort()
            })
            reloadDataFailureCallback()
        } else {
            dbgprint('regular loading, no aborting yet')
            return
        }
    }

    function tryReload() {
       updateLastReloadedText()

        if (updatingPaused) {
            return
        }

        var res = false
        if (reloadTime.isReadyToReload(cacheKey)) {
            dbgprint("tryReload: reloading key = " + cacheKey)
            res = reloadData()
        } else {
            loadFromCache()
        }

        if (!res) {
            rearmTimer()
        }
    }

    onTemperatureTypeChanged: {
        refreshTooltipSubText()
        meteogramModelChanged = !meteogramModelChanged
    }

    onPressureTypeChanged: {
        refreshTooltipSubText()
        meteogramModelChanged = !meteogramModelChanged
    }

    onWindSpeedTypeChanged: {
        refreshTooltipSubText()
    }

    onTwelveHourClockEnabledChanged: {
        refreshTooltipSubText()
    }

    onTimezoneTypeChanged: {
        if (!initialized) {
            return
        }
        alreadyLoadedFromCache = false
        loadFromCache()
    }

    function dbgprint(msg) {
        if (!debugLogging) {
            return
        }
        print('[weatherWidget] ' + msg)
    }

    Timer {
        id: updateViewsTimer
        interval: 60 * 60 * 1000
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: {
            alreadyLoadedFromCache = false
            if (!loadFromCache()) {
                print('updateViewsTimer error')
            } else {
                print('updateViewsTimer loaded from cache')
            }
            init()
        }

        function init() {
            const ONE_HOUR = (60 * 60 * 1000)
            var dt = ONE_HOUR - (Date.now() % ONE_HOUR)
            updateViewsTimer.interval = dt
            updateViewsTimer.restart()

            print('updateViewsTimer: ' + (new Date(Date.now() + dt)))
        }
    }

    Connections {
        target: plasmoid
        function onExpandedChanged() {
            if (!alreadyLoadedFromCache) {
                alreadyLoadedFromCache = true
                loadFromCache()
            }
        }
    }
}
