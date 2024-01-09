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
import "../code/chart-utils.js" as ChartUtils
import "../code/print.js" as PrintUtil
import "providers"
import "utils"

Item {
    id: main

    property bool initialized: false

    objectName: ""
    property var dbgprint: debugLogging ? PrintUtil.init(this, plasmoidCacheId) : ((...args) => {})

    property int placeIndex: -1
    property string placeAlias
    property var placeObject: null
    property string cacheKey
    property int timezoneID
    property int timezoneOffset
    property string timezoneShortName

    property string places: plasmoid.configuration.places

    property int temperatureType: plasmoid.configuration.temperatureType
    property int pressureType: plasmoid.configuration.pressureType
    property int windSpeedType: plasmoid.configuration.windSpeedType
    property int windDirectionType: plasmoid.configuration.windDirectionType
    property int timezoneType: plasmoid.configuration.timezoneType
    property int precipitationType: plasmoid.configuration.precipitationType

    property bool onlyOnePlace: true

    property alias currentWeatherModel: currentWeatherModel
    property alias meteogramModel: meteogramModel

    property string creditLink
    property string creditLabel

    property string tooltipSubText: ''

    property bool inTray: false
    property string plasmoidCacheId: plasmoid.id

    property int inTrayActiveTimeoutSec: plasmoid.configuration.inTrayActiveTimeoutSec

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5

    // 0 - standard
    // 1 - vertical
    // 2 - compact
    property int layoutType: plasmoid.configuration.layoutType

    property bool updatingPaused: false

    property var currentProvider: null

    property int maxMeteogramHours: plasmoid.configuration.maxMeteogramHours

    signal fullRedraw()

    anchors.fill: parent

    property Component crInTray: CompactRepresentationInTray { }
    property Component cr: CompactRepresentation { }

    property Component frInTray: FullRepresentationInTray { }
    property Component fr: FullRepresentation {
        Component.onCompleted: {
            main.fullRedraw.connect(this.meteogram.fullRedraw)
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

    CacheDb {
        id: cacheDb

        plasmoidCacheId: main.plasmoidCacheId
    }

    UnitUtils {
        id: unitUtils
    }

    TimeUtils {
        id: timeUtils
    }

    ReloadTimer {
        id: reloadTimer

        cacheDb: cacheDb
        dataDownloader: dataDownloader

        currentCacheKey: main.cacheKey

        Component.onCompleted: {
            loadFromCache.connect(main.loadFromCache)
            reloadData.connect(dataDownloader.reloadData)
        }
    }

    DataDownloader {
        id: dataDownloader

        cacheDb: cacheDb
        reloadTimer: reloadTimer

        currentCacheKey: main.cacheKey
        currentProvider: main.currentProvider

        Component.onCompleted: {
            dataDownloader.loadFromCache.connect(main.loadFromCache)
        }
    }

    MetNo {
        id: metnoProvider
    }

    OpenWeatherMap {
        id: owmProvider

        property alias tzOffset: main.timezoneOffset
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
        id: colorPalette
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
            reloadTimer.stop()
        } else {
            reloadTimer.updateState(cacheKey)
        }
    }

    Connections {
        target: plasmoid
        function onExpandedChanged() {
            if (plasmoid.expanded === true) {
                reloadTimer.updateNextLoadText()
                reloadTimer.updateLastLoadText()
                reloadTimer.checkNextLoadElapsed(cacheKey)
            }
        }
    }

    Component.onCompleted: {
        dbgprint("main: onCompleted: plasmoid.id", plasmoid.id, plasmoid.parent.id)

        if (plasmoid.configuration.firstRun === true) {
            switch (Qt.locale().measurementSystem) {
                case (Locale.MetricSystem):
                    plasmoid.configuration.temperatureType = UnitUtils.TemperatureType.CELSIUS
                    plasmoid.configuration.pressureType = UnitUtils.PressureType.HPA
                    plasmoid.configuration.windSpeedType = UnitUtils.WindSpeedType.KMH
                    plasmoid.configuration.precipitationType = UnitUtils.PrecipitationType.CM
                    break;
                case (Locale.ImperialUSSystem):
                    plasmoid.configuration.temperatureType = UnitUtils.TemperatureType.FAHRENHEIT
                    plasmoid.configuration.pressureType = UnitUtils.PressureType.INHG
                    plasmoid.configuration.windSpeedType = UnitUtils.WindSpeedType.MPH
                    plasmoid.configuration.precipitationType = UnitUtils.PrecipitationType.INCH
                    break;
                case (Locale.ImperialUKSystem):
                    plasmoid.configuration.temperatureType = UnitUtils.TemperatureType.CELSIUS
                    plasmoid.configuration.pressureType = UnitUtils.PressureType.HPA
                    plasmoid.configuration.windSpeedType = UnitUtils.WindSpeedType.MPH
                    plasmoid.configuration.precipitationType = UnitUtils.PrecipitationType.CM
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

        var db = cacheDb.open()
        cacheDb.initialize()
        if (db === null) {
            print('error initializing cache database')
        } else {
            dbgprint('cache database initialized')
        }

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

    function setTimezoneName() {
        timezoneShortName = ""
        if (timezoneType === TimeUtils.TimezoneType.USER_LOCAL_TIME) {
            let offset = new Date().getTimezoneOffset()
            let offsetStr = timeUtils.formatTimeZoneOffsetString(offset)
            timezoneShortName = i18n("UTC") + offsetStr
        } else if (timezoneType === TimeUtils.TimezoneType.UTC) {
            timezoneShortName = i18n("UTC")
        } else if (timezoneType === TimeUtils.TimezoneType.LOCATION_LOCAL_TIME) {
            let tzData = timeUtils.getTimezoneData(timezoneID)
            if (tzData !== undefined) {
                timezoneShortName = timeUtils.isDST(tzData.DSTData) ? tzData.DSTName : tzData.TZName
            } else {
                let offsetStr = timeUtils.formatTimeZoneOffsetString(-timezoneOffset / (60 * 1000))
                timezoneShortName = i18n("UTC")+ offsetStr
            }
        }
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
        } else {
            placeIndex = plasmoid.configuration.placeIndex
        }

        plasmoid.configuration.placeIndex = placeIndex

        placeObject = places[placeIndex]
        if (!placeObject) {
            print("warning: No place object")
            return
        }

        placeAlias = placeObject.placeAlias
        if (placeObject.timezoneID  === undefined || placeObject.providerId === 'owm') {
          placeObject.timezoneID = -1
        }
        timezoneID = parseInt(placeObject.timezoneID)
        timezoneOffset = timeUtils.getTimeZoneOffset(timezoneID)

        dbgprint('next place is: ' + placeObject.placeAlias)
        cacheKey = DataLoader.generateCacheKey(placeObject)
        dbgprint('next cacheKey is: ' + cacheKey)

        setCurrentProviderAccordingId(placeObject.providerId)

        loadFromCache(cacheKey)
        reloadTimer.resetState(cacheKey)
    }

    signal beginLoadFromCache()
    signal endLoadFromCache()

    function _loadFromCache(cacheKey) {
        if (cacheKey !== main.cacheKey) {
            return
        }

        if (!cacheDb.hasKey(cacheKey)) {
            print('error: cache not available')
            return
        }

        dbgprint('loading from cache, config key: ' + cacheKey)

        currentWeatherModel.clear()
        meteogramModel.hourInterval = 1

        weatherAlertsModel.clear()

        beginLoadFromCache()

        var content = cacheDb.getContent(cacheKey)
        if (content === null) {
            return
        }

        var success = currentProvider.setWeatherContents(content)
        if (!success) {
            print('error: setting weather contents not successful')
            cacheKey = null
            return
        }

        endLoadFromCache()

        creditLink = currentProvider.getCreditLink(placeObject)
        creditLabel = currentProvider.getCreditLabel(placeObject)

        if (currentProvider.providerId !== "owm") {
            reloadMeteogram()
        }
    }

    function loadFromCache(key) {
        Qt.callLater(_loadFromCache, key)
    }

    function reloadMeteogram() {
        setTimezoneName()
        refreshTooltipSubText()
        fullRedraw()
    }

    function getPlasmoidStatus(lastReloaded, inTrayActiveTimeoutSec) {
        var reloadedAgoMs = DataLoader.getReloadedAgoMs(lastReloaded)
        if (reloadedAgoMs < inTrayActiveTimeoutSec * 1000) {
            return PlasmaCore.Types.ActiveStatus
        } else {
            return PlasmaCore.Types.PassiveStatus
        }
    }

    function refreshTooltipSubText() {
        dbgprint('refreshing sub text')
        if (!currentWeatherModel.valid) {
            dbgprint('model not yet ready')
            tooltipSubText = ""
            return
        }

        var temperature = unitUtils.formatValue(currentWeatherModel.temperature, "temperature",
                                                temperatureType)
        var windDir = unitUtils.getWindDirectionText(currentWeatherModel.windDirection,
                                                     windDirectionType)
        var windDirectionIcon = IconTools.getWindDirectionIconCode(
                                    currentWeatherModel.windDirection)
        var windSpeed = unitUtils.getWindSpeedText(currentWeatherModel.windSpeedMps, windSpeedType)
        var pressure = unitUtils.getPressureText(currentWeatherModel.pressureHpa, pressureType)
        var iconDesc = currentProvider.getIconDescription(currentWeatherModel.iconName)
        var dateStr = currentWeatherModel.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
        var timeStr = currentWeatherModel.date.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)

        var sunRiseTime = ""
        var sunSetTime = ""
        if (timeUtils.hasSunriseSunsetData(currentWeatherModel)) {
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
        subText += '<font size="4"> ' + windDir + '&nbsp;@ ' + windSpeed + '</font>'
        subText += '<br />'
        subText += '<font size="4" style="font-family: weathericons;">\uf079 </font>'
        subText += '<font size="4">' + pressure + '</font>'
        subText += '<br />'
        
        if (currentWeatherModel.humidity !== undefined) {
            let humidity = unitUtils.formatValue(currentWeatherModel.humidity, "humidity")
            subText += '<font size="4" style="font-family: weathericons;">\uf07a </font>'
            subText += '<font size="4">' + humidity + '</font>'
            subText += '<br />'
        }
        if (currentWeatherModel.cloudArea !== undefined) {
            let cloudArea = unitUtils.formatValue(currentWeatherModel.cloudArea, "cloudArea")
            subText += '<font size="4" style="font-family: weathericons;">\uf041 </font>'
            subText += '<font size="4">' + cloudArea + '</font>'
            subText += '<br />'
        }
        if (timeUtils.hasSunriseSunsetData(currentWeatherModel)) {
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
        if (!timeUtils.hasSunriseSunsetData(currentWeatherModel)) {
            return 0
        }
        var now = new Date()
        return currentWeatherModel.sunRise < now && now < currentWeatherModel.sunSet ? 0 : 1
    }

    function tryReload() {
        if (updatingPaused) {
            return
        }
        reloadTimer.updateState(cacheKey)
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


    onTimezoneTypeChanged: {
        if (!initialized) {
            return
        }
        loadFromCache(cacheKey)
    }

    onMaxMeteogramHoursChanged: {
        if (!initialized) {
            return
        }
        loadFromCache(cacheKey)
    }

    /* Update the view models every hour */
    Timer {
        id: updateViewsTimer
        interval: 60 * 60 * 1000
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: {
            if (!loadFromCache(cacheKey)) {
                dbgprint('updateViewsTimer error')
            } else {
                dbgprint('updateViewsTimer loaded from cache')
            }
            reloadTimer.updateState(cacheKey)
            init()
        }

        function init() {
            var now = Date.now()
            var dt = new Date(now)
            dt.setMinutes(1, 0, 0)
            dt.setHours(dt.getHours() + 1)
            var interval = dt - now
            updateViewsTimer.interval = interval
            updateViewsTimer.restart()

            dbgprint('updateViewsTimer: ' + dt)
        }
    }
}
