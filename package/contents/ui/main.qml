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
import "../code/chart-utils.js" as ChartUtils
import "providers"
import "utils"

Item {
    id: main

    property bool initialized: false

    property int placeIndex: -1
    property string placeIdentifier
    property string placeAlias
    property string cacheKey
    property int timezoneID
    property int timezoneOffset
    property string timezoneShortName

    property string places: plasmoid.configuration.places

    property int temperatureType: plasmoid.configuration.temperatureType
    property int pressureType: plasmoid.configuration.pressureType
    property int windSpeedType: plasmoid.configuration.windSpeedType
    property int timezoneType: plasmoid.configuration.timezoneType
    property int precipitationType: plasmoid.configuration.precipitationType
    property string widgetFontName: plasmoid.configuration.widgetFontName
    property int widgetFontSize: plasmoid.configuration.widgetFontSize

    property bool twelveHourClockEnabled: Qt.locale().timeFormat(Locale.ShortFormat).toString().indexOf('AP') > -1
    property bool onlyOnePlace: true

    property alias currentWeatherModel: currentWeatherModel
    property alias meteogramModel: meteogramModel

    property string creditLink
    property string creditLabel

    property bool loadingData: false              // Download Attempt in progress Flag.
    property var loadingXhrs: []                  // Array of Download Attempt Objects

    property string lastReloadedText: '⬇ 0m ago'
    property string tooltipSubText: ''

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    property bool onDesktop: (plasmoid.location == PlasmaCore.Types.Desktop || plasmoid.location == PlasmaCore.Types.Floating)
    property bool inTray: false
    property string plasmoidCacheId: plasmoid.id

    property int inTrayActiveTimeoutSec: plasmoid.configuration.inTrayActiveTimeoutSec

    property int nextDaysCount: dailyWeatherModels.count

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5

    // 0 - standard
    // 1 - vertical
    // 2 - compact
    property int layoutType: plasmoid.configuration.layoutType

    property bool updatingPaused: false

    property var currentProvider: null

    property bool meteogramModelChanged: false

    property int maxMeteogramHours: plasmoid.configuration.maxMeteogramHours

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

    UnitUtils {
        id: unitUtils
    }

    TimeUtils {
        id: timeUtils
    }

    property var providerErrors: ({})

    ReloadTime {
        id: reloadTime
    }

    MetNo {
        id: metnoProvider
    }

    OpenWeatherMap {
        id: owmProvider
    }

    OpenMeteo {
        id: openMeteo
    }

    CurrentWeatherModel {
        id: currentWeatherModel
    }

    DailyWeatherModel {
        id: dailyWeatherModels
    }

    MeteogramModel {
        id: meteogramModel
    }

    ListModel {
        id: weatherAlertsModel
    }

    MeteogramColors {
        id: palette
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
            rearmTimer(cacheKey)
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
            rearmTimer(cacheKey)
        }
    }

    function initUtils() {
        if (!DataLoader.initialized) {
            DataLoader.i18n = i18n
            DataLoader.dbgprint = dbgprint
            DataLoader.initialized = true
        }
        if (!UnitUtils.initialized) {
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
                    temperatureType = UnitUtils.TemperatureType.CELSIUS
                    pressureType = UnitUtils.PressureType.HPA
                    windSpeedType = UnitUtils.WindSpeedType.KMH
                    precipitationType = UnitUtils.PrecipitationType.CM
                    break;
                case (Locale.ImperialUSSystem):
                    temperatureType = UnitUtils.TemperatureType.FAHRENHEIT
                    pressureType = UnitUtils.PressureType.INHG
                    windSpeedType = UnitUtils.WindSpeedType.MPH
                    precipitationType = UnitUtils.PrecipitationType.INCH
                    break;
                case (Locale.ImperialUKSystem):
                    temperatureType = UnitUtils.TemperatureType.CELSIUS
                    pressureType = UnitUtils.PressureType.HPA
                    windSpeedType = UnitUtils.WindSpeedType.MPH
                    precipitationType = UnitUtils.PrecipitationType.CM
                    break;
                default:
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
        setNextPlace()

        updateViewsTimer.init()
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
        if (providerId === 'openMeteo') {
            currentProvider = openMeteo
        }
     }

    function updatePlaceIndex(index, count, previous) {
        let step = 0
        if (index === -1) {
            index = Math.min(count - 1, Math.max(0, plasmoid.configuration.placeIndex))
        } else if (previous === true) {
            step = -1
        } else {
            step = 1
        }

        index = (index + count + step) % count
        return index
    }

    function setNextPlace(previous, initialize) {
        currentWeatherModel.clear()
        meteogramModel.hourInterval = 1

        var places = ConfigUtils.getPlacesArray()
        onlyOnePlace = places.length === 1

        if (initialize !== true) {
            placeIndex = updatePlaceIndex(placeIndex, places.length, previous)
            if (placeIndex < 0 || placeIndex >= places.length) {
                print("Error: Invalid place index " + placeIndex)
                return
            }
        }

        plasmoid.configuration.placeIndex = placeIndex

        var placeObject = places[placeIndex]
        if (!placeObject) {
            print("warning: No place object")
            return
        }

        placeIdentifier = placeObject.placeIdentifier
        placeAlias = placeObject.placeAlias
        if (placeObject.timezoneID  === undefined || placeObject.providerId === 'owm') {
          placeObject.timezoneID = -1
        }
        timezoneID = parseInt(placeObject.timezoneID)
        timezoneOffset = UnitUtils.getTimeZoneOffset(timezoneID)

        dbgprint('next placeIdentifier is: ' + placeIdentifier)
        cacheKey = DataLoader.generateCacheKey(placeIdentifier)
        dbgprint('next cacheKey is: ' + cacheKey)

        setCurrentProviderAccordingId(placeObject.providerId)

        var ok = loadFromCache()
        if (!ok) {
            reloadData()
        }

        rearmTimer(cacheKey)
    }

    function clearLoadingXhrs() {
        if (loadingXhrs) {
            loadingXhrs.forEach(function (xhr) {
                xhr.abort()
            })
            loadingXhrs = []
        }
    }

    function reloadDataSuccessCallback(contentToCache, cacheKey) {
        dbgprint("Data Loaded From Internet successfully.")
        reloadTime.stopAbortTimer(cacheKey)

        providerCache.setContent(cacheKey, contentToCache)
        providerCache.printKeys()

        saveCache()
        reloadTime.setLastReloadedMs(cacheKey)

        if (loadingXhrs.length > 0) {
            var xhr = loadingXhrs[0]
            var expires = xhr.getResponseHeader("expires");
            if (expires) {
                reloadTime.setExpireTime(Date.parse(expires), cacheKey)
            }
        }

        clearLoadingXhrs()
        providerErrors[cacheKey] = null

        if (main.cacheKey === cacheKey) {
            loadFromCache()
            rearmTimer(cacheKey)
        }

        loadingData = false
    }

    function reloadDataFailureCallback(cacheKey) {
        print("Failed to load data. cacheKey = " + cacheKey)
        reloadTime.stop()
        reloadTime.stopAbortTimer(cacheKey)
        var noConnection = false
        loadingXhrs.forEach(function (xhr) {
            noConnection |= (xhr.status === 0)
            if (noConnection) {
                providerErrors[cacheKey] = "No connection"
            } else if (xhr.status !== 200) {
                providerErrors[cacheKey] = xhr.status
            }
        })
        clearLoadingXhrs()

        if (noConnection) {
            reloadTime.setLoadingError(cacheKey, reloadTime.retryTimeMs)
        } else {
            reloadTime.setLoadingError(cacheKey)
        }

        if (main.cacheKey === cacheKey) {
            rearmTimer(cacheKey)
        }

        loadingData = false
    }

    function reloadData() {
        dbgprint("reloadData")

        if (loadingData) {
            dbgprint('still loading')
            return false
        }

        loadingData = true
        reloadTime.stopAbortTimer(cacheKey)
        reloadTime.clearLoadingError(cacheKey)

        var args = {
            placeIdentifier: placeIdentifier,
            timezoneID: timezoneID,
            cacheKey, cacheKey
        }
        loadingXhrs = currentProvider.loadDataFromInternet(reloadDataSuccessCallback,
                                                           reloadDataFailureCallback, args)

        reloadTime.startAbortTimer(cacheKey, () => reloadDataFailureCallback(cacheKey))
        return true
    }

    function reloadMeteogram() {
        meteogramModelChanged = !meteogramModelChanged
    }

    function rearmTimer(cacheKey) {

        reloadTime.stop()
        reloadTime.start(cacheKey)
        updateLastReloadedText()
    }

    Timer {
        id: updateWorker
        interval: 0
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: {

            weatherAlertsModel.clear()

            var content = providerCache.getContent(cacheKey)
            var success = currentProvider.setWeatherContents(content)
            if (!success) {
                print('error: setting weather contents not successful')
                return false
            }

            creditLink = currentProvider.getCreditLink(placeIdentifier, placeAlias)
            creditLabel = currentProvider.getCreditLabel(placeIdentifier)

            updateLastReloadedText()
            refreshTooltipSubText()

            if (currentProvider.providerId !== "owm") {
                reloadMeteogram()
            }
        }
    }

    function loadFromCache() {
        if (!providerCache.hasKey(cacheKey)) {
            print('error: cache not available')
            return false
        }

        dbgprint('loading from cache, config key: ' + cacheKey)
        updateWorker.restart()

        return true
    }

    onInTrayActiveTimeoutSecChanged: {
        initUtils()
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
        var providerError = providerErrors[cacheKey]
        if (providerError) {
            lastReloadedText = i18n("Error") + ": " + providerError
            return
        }

        var lastReloadedMs = (new Date()).getTime() - reloadTime.getLastReloadedMs(cacheKey)
        lastReloadedText = '⬇ ' + i18n("%1 ago",
                            DataLoader.formatTimeIntervalString(lastReloadedMs))
        plasmoid.status = getPlasmoidStatus(lastReloadedMs, inTrayActiveTimeoutSec)
    }

    function refreshTooltipSubText() {
        dbgprint('refreshing sub text')
        if (!currentWeatherModel.valid) {
            dbgprint('model not yet ready')
            tooltipSubText = ""
            return
        }

        var temperature = UnitUtils.formatValue(currentWeatherModel.temperature, "temperature",
                                                temperatureType)
        var windDir = Math.round(currentWeatherModel.windDirection)
        var windDirectionIcon = IconTools.getWindDirectionIconCode(windDir)
        var windSpeed = UnitUtils.getWindSpeedText(currentWeatherModel.windSpeedMps, windSpeedType)
        var pressure = UnitUtils.getPressureText(currentWeatherModel.pressureHpa, pressureType)
        var iconDesc = currentProvider.getIconDescription(currentWeatherModel.iconName)
        var dateStr = currentWeatherModel.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
        var timeStr = currentWeatherModel.date.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)

        var sunRiseTime = ""
        var sunSetTime = ""
        if (UnitUtils.hasSunriseSunsetData(currentWeatherModel)) {
            let sunRise = currentWeatherModel.sunRise
            let sunSet = currentWeatherModel.sunSet
            sunRiseTime = Qt.formatTime(sunRise, Qt.locale().timeFormat(Locale.ShortFormat))
            sunSetTime = Qt.formatTime(sunSet, Qt.locale().timeFormat(Locale.ShortFormat))
        }

        var subText = '<br />'
        subText += '<font size="4">' + dateStr + '</font>'
        subText += '<br />'
        subText += '<font size="4">' + timeStr + '</font>'
        subText += '<br /><br />'
        subText += '<font size="4">' + iconDesc + '</font>'
        subText += '<br /><br />'
        subText += '<font size="4" style="font-family: weathericons;">\uf055 </font>'
        subText += '<font size="4">' + temperature + '</font>'
        subText += '<br />'
        subText += '<font size="4" style="font-family: weathericons;">' + windDirectionIcon + '</font>'
        subText += '<font size="4"> ' + windDir + '\u00B0&nbsp;@ ' + windSpeed + '</font>'
        subText += '<br />'
        subText += '<font size="4" style="font-family: weathericons;">\uf079 </font>'
        subText += '<font size="4">' + pressure + '</font>'
        subText += '<br />'
        
        if (currentWeatherModel.humidity !== undefined) {
            let humidity = UnitUtils.formatValue(currentWeatherModel.humidity, "humidity")
            subText += '<font size="4" style="font-family: weathericons;">\uf07a </font>'
            subText += '<font size="4">' + humidity + '</font>'
            subText += '<br />'
        }
        if (currentWeatherModel.cloudArea !== undefined) {
            let cloudArea = UnitUtils.formatValue(currentWeatherModel.cloudArea, "cloudArea")
            subText += '<font size="4" style="font-family: weathericons;">\uf041 </font>'
            subText += '<font size="4">' + cloudArea + '</font>'
            subText += '<br />'
        }
        if (UnitUtils.hasSunriseSunsetData(currentWeatherModel)) {
            subText += '<table>'
            subText += '<tr>'
            subText += '<td><font size="4">'
            subText += '<font style="font-family: weathericons">\uf051</font>&nbsp;'
            subText += sunRiseTime + ' '+timezoneShortName + '&nbsp;&nbsp;&nbsp;</font></td>'
            subText += '<td><font size="4">'
            subText += '<font style="font-family: weathericons">\uf052</font>&nbsp;'
            subText += sunSetTime + ' '+timezoneShortName + '</font></td>'
            subText += '</tr>'
            subText += '</table>'
        }

        tooltipSubText = subText
    }

    function getPartOfDayIndex() {
        if (!UnitUtils.hasSunriseSunsetData(currentWeatherModel)) {
            return 0
        }
        var now = new Date()
        return currentWeatherModel.sunRise < now && now < currentWeatherModel.sunSet ? 0 : 1
    }

    function tryReload() {
        if (updatingPaused) {
            return
        }

        if (reloadTime.isReadyToReload(cacheKey)) {
            reloadData()
        }
    }

    onPlacesChanged: {
        if (!initialized) {
            return
        }
        setNextPlace(false, true)
    }

    onTemperatureTypeChanged: {
        refreshTooltipSubText()
        reloadMeteogram()
    }

    onPressureTypeChanged: {
        refreshTooltipSubText()
        reloadMeteogram()
    }

    onWindSpeedTypeChanged: {
        refreshTooltipSubText()
        reloadMeteogram()
    }

    onPrecipitationTypeChanged: {
        refreshTooltipSubText()
        reloadMeteogram()
    }

    onTwelveHourClockEnabledChanged: {
        refreshTooltipSubText()
        reloadMeteogram()
    }

    onTimezoneTypeChanged: {
        if (!initialized) {
            return
        }
        loadFromCache()
    }

    onMaxMeteogramHoursChanged: {
        if (!initialized) {
            return
        }
        loadFromCache()
    }

    function dbgprint(msg) {
        if (!debugLogging) {
            return
        }
        print('[weatherWidget] ' + msg)
    }

    /* Update the view models every hour */
    Timer {
        id: updateViewsTimer
        interval: 60 * 60 * 1000
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: {
            if (!loadFromCache()) {
                dbgprint('updateViewsTimer error')
            } else {
                dbgprint('updateViewsTimer loaded from cache')
            }
            init()
        }

        function init() {
            const ONE_HOUR = (60 * 60 * 1000)
            var dt = ONE_HOUR - (Date.now() % ONE_HOUR)
            updateViewsTimer.interval = dt
            updateViewsTimer.restart()

            dbgprint('updateViewsTimer: ' + (new Date(Date.now() + dt)))
        }
    }

    function getUnitType(varName) {
        if (UnitUtils.isTemperatureVarName(varName)) {
            return plasmoid.configuration.temperatureType
        } else if (varName === "pressure") {
            return plasmoid.configuration.pressureType
        } else if (varName === "windSpeed" || varName === "windGust") {
            return plasmoid.configuration.windSpeedType
        } else if (varName === "precipitationAmount") {
            return plasmoid.configuration.precipitationType
        }
        return undefined
    }

}
