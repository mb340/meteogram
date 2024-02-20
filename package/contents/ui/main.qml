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
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import QtQuick.Controls
import QtQml
import "../code/data-loader.js" as DataLoader
import "../code/config-utils.js" as ConfigUtils
import "../code/icons.js" as IconTools
import "../code/chart-utils.js" as ChartUtils
import "../code/print.js" as PrintUtil
import "providers"
import "utils"
import "data_models"

PlasmoidItem {
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

    property string plasmoidCacheId: Plasmoid.id

    property Item lightDarkItem: null
    property var theme: lightDarkItem

    // 0 - standard
    // 1 - vertical
    // 2 - compact
    property int layoutType: plasmoid.configuration.layoutType

    property bool updatingPaused: false

    property var currentProvider: null

    property int maxMeteogramHours: plasmoid.configuration.maxMeteogramHours

    property bool isPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge ||
                            Plasmoid.location === PlasmaCore.Types.BottomEdge ||
                            Plasmoid.location === PlasmaCore.Types.LeftEdge ||
                            Plasmoid.location === PlasmaCore.Types.RightEdge)

    property bool fillModels: main.expanded /*|| (!isPanel && isFullRepresentation)*/

    signal fullRedraw()

    anchors.fill: parent


    switchWidth: 44 * Kirigami.Units.gridUnit
    switchHeight: 28 * Kirigami.Units.gridUnit

    hideOnWindowDeactivate: !plasmoid.userConfiguring

    compactRepresentation: CompactRepresentation { }

    fullRepresentation: FullRepresentation {
        anchors.margins: isPanel ? 0 : Kirigami.Units.largeSpacing

        Component.onCompleted: {
            main.lightDarkItem = lightDarkItem
            main.fullRedraw.connect(this.meteogram.fullRedraw)
        }


        LightDarkItem {
            id: lightDarkItem
            visible: false

            Component.onCompleted: {
                main.initialize()
            }
        }
    }


    toolTipItem: Loader {

        Layout.minimumWidth: item?.implicitWidth ?? 0
        Layout.maximumWidth: item?.implicitWidth ?? 0
        Layout.minimumHeight: item?.implicitHeight ?? 0
        Layout.maximumHeight: item?.implicitHeight ?? 0

        source: Qt.resolvedUrl("Tooltip.qml")
    }

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

    function toggleUpdatingPaused() {
        updatingPaused = !updatingPaused
        if (updatingPaused) {
            reloadTimer.stop()
        } else {
            reloadTimer.updateState(cacheKey)
        }
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: updatingPaused ? i18n("Resume Updating") : i18n("Pause Updating")
            icon.name: updatingPaused ? 'media-playback-start' : 'media-playback-pause'
            onTriggered: toggleUpdatingPaused()
        }
    ]

    Connections {
        target: main
        function onExpandedChanged() {
            if (main.expanded === true) {
                reloadTimer.updateNextLoadText()
                reloadTimer.updateLastLoadText()
                reloadTimer.checkNextLoadElapsed(cacheKey)
            }
        }
    }

    Connections {
        target: plasmoid.configuration
        function onPlacesChanged() {
            if (!initialized) {
                return
            }
            setNextPlace(false, true)
        }
    }

    function initialize() {
        dbgprint("main: onCompleted: Plasmoid.id", Plasmoid.id, Plasmoid.containment.id)

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

            plasmoid.configuration.layoutSpacing = Kirigami.Units.smallSpacing

            plasmoid.configuration.firstRun = false
        }

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
        currentProvider = null
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

        var places = JSON.parse(plasmoid.configuration.places)

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

        creditLink = ""
        creditLabel = ""

        if (currentProvider == null) {
            dailyWeatherModels.clear()
            meteogramModel.clear()
            reloadMeteogram()
            return
        }

        beginLoadFromCache()

        var content = cacheDb.getContent(cacheKey)
        if (content === null) {
            dailyWeatherModels.clear()
            meteogramModel.clear()
            endLoadFromCache()
            reloadMeteogram()
            return
        }

        var success = currentProvider.setWeatherContents(content)
        if (!success) {
            print('error: setting weather contents not successful')
            cacheKey = null
            dailyWeatherModels.clear()
            meteogramModel.clear()
            endLoadFromCache()
            reloadMeteogram()
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
        fullRedraw()
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

    onTemperatureTypeChanged: {
        reloadMeteogram()
    }

    onPressureTypeChanged: {
        reloadMeteogram()
    }

    onWindSpeedTypeChanged: {
        reloadMeteogram()
    }

    onPrecipitationTypeChanged: {
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
            _loadFromCache(cacheKey)
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
