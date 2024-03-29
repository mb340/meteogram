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
// import QtQuick.XmlListModel 2.0
import QtQml.XmlListModel
import "../../code/data-loader.js" as DataLoader
import "./owm"

QtObject {
    id: owm

    property string providerId: 'owm'

    readonly property int updateInterval: 3 * 60 * 60 * 1000
    readonly property var xmlLocale: Qt.locale('en_GB')

    property string urlPrefix: 'http://api.openweathermap.org/data/2.5'
    property string appIdAndModeSuffix: '&units=metric&mode=xml&appid=5819a34c58f8f07bc282820ca08948f1'

    property bool updateSemaphore: false

    property string cacheKey: ""
    property var successCallback: null
    property var failureCallback: null

    property var modelLongTerm: null
    property var modelHourByHour: null
    property var modelCurrent: null

    property QtObject cacheModelLongTerm: CacheListModel {
    }

    property QtObject cacheModelHourByHour: CacheListModel {
    }

    property QtObject cacheModelCurrent: CacheListModel {
    }


    property Component xmlModelLongTermComponent: XmlModelLongTerm {
    }

    property Component xmlModelHourByHourComponent: XmlModelHourByHour {
    }

    property Component xmlModelCurrentComponent: XmlModelCurrent {
    }

    function parseDate(dateString) {
        let d = new Date(dateString + '.000Z')
        return timeUtils.convertDate(d, timezoneType, tzOffset)
    }

    function cleanUpXmlModels() {
        if (modelCurrent && modelCurrent.destroy) {
            modelCurrent.destroy()
            modelCurrent = null
        }
        if (modelLongTerm && modelLongTerm.destroy) {
            modelLongTerm.destroy()
            modelLongTerm = null
        }
        if (modelHourByHour && modelHourByHour.destroy) {
            modelHourByHour.destroy()
            modelHourByHour = null
        }
    }

    function handleStatusChanged(xmlModel) {
        if (!updateSemaphore) {
            return
        }
        if (xmlModel.status === XmlListModel.Error) {
            print("XML model load error:", xmlModel.errorString())
            updateSemaphore = false
            if (owm.failureCallback) {
                owm.failureCallback(owm.cacheKey, 400)
            }
            cleanUpXmlModels()
            return
        }
        xmlModelReady()
    }

    function applyModelData() {
        if (modelCurrent.count > 0) {
            let item = modelCurrent.get(0)
            tzOffset = item.timezone * 1000
            main.timezoneOffset = tzOffset
        } else {
            tzOffset = 0
            print("warning: OpenWeatherMap timezone offset data not available")
        }
        createTodayTimeObj()
        updateTodayModels()
        updateMeteogramModel()
        updateNextDaysModel()
        fixupNextDaysModel()
        main.reloadMeteogram()
    }

    function xmlModelReady() {
        if (!updateSemaphore) {
            return
        }
        if (modelCurrent.status != XmlListModel.Ready) {
            return
        }
        if (modelHourByHour.status != XmlListModel.Ready) {
            return
        }
        if (modelLongTerm.status != XmlListModel.Ready) {
            return
        }
        dbgprint('all xml models ready')

        updateSemaphore = false

        applyModelData()


        if (owm.successCallback) {
            let data = {
                modelCurrent: modelCurrent.toArray(),
                modelHourByHour: modelHourByHour.toArray(),
                modelLongTerm: modelLongTerm.toArray()
            }
            let jsonStr = JSON.stringify(data)
            owm.successCallback(jsonStr, owm.cacheKey)
        }

        cleanUpXmlModels()
    }

    function createTodayTimeObj() {
        var currentTimeObj = modelCurrent.count > 0 ? modelCurrent.get(0) : null
        if (currentTimeObj === null) {
            return
        }
        currentWeatherModel.date = parseDate(currentTimeObj.updated)
        currentWeatherModel.temperature = currentTimeObj.temperature
        currentWeatherModel.iconName = currentTimeObj.iconName
        currentWeatherModel.windDirection = currentTimeObj.windDirection
        currentWeatherModel.windSpeedMps = currentTimeObj.windSpeedMps
        currentWeatherModel.pressureHpa = currentTimeObj.pressureHpa
        currentWeatherModel.humidity = currentTimeObj.humidity
        currentWeatherModel.cloudArea = currentTimeObj.cloudiness

        currentWeatherModel.sunRise = parseDate(currentTimeObj.rise)
        currentWeatherModel.sunSet = parseDate(currentTimeObj.set)
        currentWeatherModel.valid = true

        dbgprint('setting actual weather from current xml model')
        dbgprint('sunRise: ' + currentWeatherModel.sunRise)
        dbgprint('sunSet:  ' + currentWeatherModel.sunSet)
        dbgprint('current: ' + currentTimeObj.temperature)
    }

    function updateTodayModels() {

        dbgprint('updating today models')

        var now = timeUtils.dateNow(timezoneType, tzOffset)

        // set current models
        for (var i = 0; i < modelHourByHour.count; i++) {
            var timeObj = modelHourByHour.get(i)
            var dateFrom = parseDate(timeObj.from)
            var dateTo = parseDate(timeObj.to)
            dbgprint('HOUR BY HOUR: dateFrom=' + dateFrom + ', dateTo=' + dateTo + ', i=' + i)

            if (dateFrom <= now && now <= dateTo) {
                let prec = parseFloat(timeObj.precipitationValue)
                currentWeatherModel.precipitationAmount = !isNaN(prec) ? prec : 0
                currentWeatherModel.precipitationProb = parseFloat(timeObj.precipitationProb)

                let isStale = currentWeatherModel.date < dateFrom

                if (!currentWeatherModel.valid || isStale) {
                    dbgprint('adding to actualWeatherModel - temperature: ' + timeObj.temperature + ', iconName: ' + timeObj.iconName)
                    currentWeatherModel.date = dateFrom
                    currentWeatherModel.temperature = timeObj.temperature
                    currentWeatherModel.iconName = timeObj.iconName
                    currentWeatherModel.windDirection = timeObj.windDirection
                    currentWeatherModel.windSpeedMps = timeObj.windSpeedMps
                    currentWeatherModel.pressureHpa = timeObj.pressureHpa
                    currentWeatherModel.humidity = timeObj.humidity
                    currentWeatherModel.cloudArea = timeObj.clouds
                    currentWeatherModel.valid = true
                    break
                }
            }
        }

        dbgprint('result currentWeatherModel.valid: ' + currentWeatherModel.valid)
    }

    /* Update next days model with more granular data from hourly data */
    function fixupNextDaysModel() {
        var dateNow = timeUtils.dateNow(timezoneType, tzOffset)
        var intervalStart = timeUtils.floorDate(dateNow)

        var prevHour = -1;
        var nearestHour = [NaN, NaN, NaN, NaN]

        let dailyPeriodIdx = -1
        let prevPeriodIdx = -1

        function checkIsNearestHour(obj_num, targetHour, hour) {
            if (isNaN(nearestHour[obj_num])) {
                nearestHour[obj_num] = hour
                return true
            }

            if (Math.abs(targetHour - hour) < Math.abs(nearestHour[obj_num] - hour)) {
                nearestHour[obj_num] = hour
                return true
            }
            return false
        }

        function getDailyModelIndex(startIndex, date) {
            var date = new Date(date)
            date.setHours(0, 0, 0, 0)
            startIndex = Math.max(0, startIndex)
            // print("getDailyModelIndex ", startIndex, date)
            for (var i = startIndex; i < dailyWeatherModels.count; i++) {
                let item = dailyWeatherModels.get(i)
                let d = new Date(item.date)
                d.setHours(0, 0, 0, 0)
                if (d.getTime() == date.getTime()) {
                    return i
                }
                if (d > date) {
                    break
                }
            }
            return -i
        }

        var hourCount = 0

        var prevHour = -1
        var dailyModelIdx = -1
        var dailyItem = null
        var dailyItemDate = null

        for (var i = 0; i < modelHourByHour.count && hourCount < main.maxMeteogramHours; i++) {
            var obj = modelHourByHour.get(i)
            var dateFrom = parseDate(obj.from)
            var dateTo = parseDate(obj.to)
            var hour = dateFrom.getHours()

            var dayStart = dateFrom.setHours(0, 0, 0, 0)

            if (intervalStart >= dateTo) {
                continue
            }

            if (dailyModelIdx === -1 || dailyItemDate !== dayStart) {
                dailyModelIdx = getDailyModelIndex(dailyModelIdx, dateFrom)
                if (dailyModelIdx < 0) {
                    break
                }

                dailyItem = dailyWeatherModels.get(dailyModelIdx)
                dailyItemDate = new Date(dailyItem.date)
                dailyItemDate.setHours(0, 0, 0, 0)
            }

            if (prevHour > hour) {
                nearestHour = [NaN, NaN, NaN, NaN]
            }
            prevHour = hour

            // Match exact hour.
            // Take the next closest if exact match isn't available.
            let isNearestHour = false
            let targetHour = -1
            if  (hour < 6) {
                dailyPeriodIdx = 0
                targetHour = 3
            } else if (hour < 12) {
                dailyPeriodIdx = 1
                targetHour = 9
            } else if (hour < 18) {
                dailyPeriodIdx = 2
                targetHour = 15
            } else if (hour < 24) {
                dailyPeriodIdx = 3
                targetHour = 21
            }

            isNearestHour = checkIsNearestHour(dailyPeriodIdx, targetHour, hour)
            if (isNearestHour) {
                var item = dailyItem.models.get(dailyPeriodIdx)
                if (item.iconName != obj.iconName) {
                    item.iconName = obj.iconName
                    dailyItem.models.set(dailyPeriodIdx, item)
                    dailyWeatherModels.set(dailyModelIdx, dailyItem)
                }
            }

            hourCount++
        }
    }

    function updateNextDaysModel() {

        dailyWeatherModels.beginList()

        for (var i = 0; i < modelLongTerm.count; i++) {
            let item = modelLongTerm.get(i)
            let dailyModel = dailyWeatherModels.createItem(i)

            let dateFrom = Date.fromLocaleString(xmlLocale, item.date, 'yyyy-MM-dd')
            dailyModel.date = dateFrom
            dailyModel.iconName = item.iconName
            dailyModel.temperatureMin = Number(item.temperatureMin)
            dailyModel.temperatureMax = Number(item.temperatureMax)

            dailyModel.temperatureNight = Number(item.temperatureNight)
            dailyModel.temperatureMorn = Number(item.temperatureMorning)
            dailyModel.temperatureDay = Number(item.temperatureDay)
            dailyModel.temperatureEve = Number(item.temperatureEvening)

            dailyModel.feelsLikeNight = Number(item.feelsLikeNight)
            dailyModel.feelsLikeMorn = Number(item.feelsLikeMorn)
            dailyModel.feelsLikeDay = Number(item.feelsLikeDay)
            dailyModel.feelsLikeEve = Number(item.feelsLikeEvening)

            dailyModel.precipitationProb = Number(item.precipitationProb)

            let prec = parseFloat(item.precipitationValue)
            dailyModel.precipitationAmount = !isNaN(prec) ? prec : 0

            dailyModel.humidity = Number(item.humidity)
            dailyModel.pressure = Number(item.pressureHpa)
            dailyModel.cloudArea = Number(item.clouds)

            dailyModel.windDirection = Number(item.windDirection)
            dailyModel.windSpeed = Number(item.windSpeedMps)
            dailyModel.windGust = Number(item.windGust)

            let isListModel = !!dailyModel.models.get
            let night = isListModel ? dailyModel.models.get(0) : dailyModel.models[0]
            let morn = isListModel ? dailyModel.models.get(1) : dailyModel.models[1]
            let day = isListModel ? dailyModel.models.get(2) : dailyModel.models[2]
            let eve = isListModel ? dailyModel.models.get(3) : dailyModel.models[3]

            night.date = timeUtils.setDailyPeriodHour(0, new Date(dateFrom))
            morn.date = timeUtils.setDailyPeriodHour(1, new Date(dateFrom))
            day.date = timeUtils.setDailyPeriodHour(2, new Date(dateFrom))
            eve.date = timeUtils.setDailyPeriodHour(3, new Date(dateFrom))

            night.temperature = Number(item.temperatureNight)
            morn.temperature = Number(item.temperatureMorning)
            day.temperature = Number(item.temperatureDay)
            eve.temperature = Number(item.temperatureEvening)

            night.iconName = item.iconName
            morn.iconName = item.iconName
            day.iconName = item.iconName
            eve.iconName = item.iconName

            dailyWeatherModels.addItem(dailyModel)
        }

        dailyWeatherModels.endList()
    }

    function updateMeteogramModel() {

        meteogramModel.beginList()

        var hourCount = 0
        var dateNow = timeUtils.dateNow(timezoneType, tzOffset)
        var intervalStart = timeUtils.floorDate(dateNow)

        for (var i = 0; i < modelHourByHour.count && hourCount < main.maxMeteogramHours; i++) {
            var obj = modelHourByHour.get(i)
            var dateFrom = parseDate(obj.from)
            var dateTo = parseDate(obj.to)
//             dbgprint('meteo fill: i=' + i + ', from=' + obj.from + ', to=' + obj.to)
//             dbgprint('parsed: from=' + dateFrom + ', to=' + dateTo)
            if (intervalStart >= dateTo) {
                continue
            }

            let prec = parseFloat(obj.precipitationValue)

            var item = meteogramModel.createItem(i)
            item.from = dateFrom
            item.temperature = parseFloat(obj.temperature)
            item.feelsLike = parseFloat(obj.feelsLike)
            item.precipitationAmount = !isNaN(prec) ? prec : 0
            item.precipitationProb = parseFloat(obj.precipitationProb)
            item.windDirection = parseFloat(obj.windDirection)
            item.windSpeed = parseFloat(obj.windSpeedMps)
            item.windGust = parseFloat(obj.windGust)
            item.pressure = parseFloat(obj.pressureHpa)
            item.iconName = obj.iconName
            item.humidity = parseFloat(obj.humidity)
            item.cloudArea = parseFloat(obj.clouds)
            meteogramModel.addItem(item)

            hourCount += 3
        }

        meteogramModel.endList()
        meteogramModel.hourInterval = 3
        dbgprint('meteogramModel.count = ' + meteogramModel.count)
    }

    /**
     * successCallback(contentToCache)
     * failureCallback()
     */
    function loadDataFromInternet(successCallback, failureCallback, cacheKey, placeObject) {
        var placeIdentifier = placeObject.placeIdentifier
        var versionParam = '&v=' + new Date().getTime()

        owm.successCallback = successCallback
        owm.failureCallback = failureCallback
        owm.cacheKey = cacheKey


        var props = {
            handleStatusChanged: owm.handleStatusChanged
        }
        modelCurrent = xmlModelCurrentComponent.createObject(owm, props)
        modelHourByHour = xmlModelHourByHourComponent.createObject(owm, props)
        modelLongTerm = xmlModelLongTermComponent.createObject(owm, props)

        updateSemaphore = true

        // xmlModelLongTerm.source = "http://127.0.0.1:8000/daily.xml"
        // xmlModelHourByHour.source = "http://127.0.0.1:8000/forecast.xml"
        // xmlModelCurrent.source = "http://127.0.0.1:8000/weather.xml"

        let urlHourByHour = urlPrefix +
                            '/forecast?id=' +
                            placeIdentifier +
                            appIdAndModeSuffix +
                            versionParam
        let urlLongTerm = urlPrefix +
                            '/forecast/daily?id=' +
                            placeIdentifier +
                            '&cnt=8' +
                            appIdAndModeSuffix +
                            versionParam
        let urlCurrent = urlPrefix +
                            '/weather?id=' +
                            placeIdentifier +
                            appIdAndModeSuffix +
                            versionParam
        modelHourByHour.source = urlHourByHour
        modelLongTerm.source = urlLongTerm
        modelCurrent.source = urlCurrent

        return []
    }

    function setWeatherContents(cacheContent) {
        cacheContent = JSON.parse(cacheContent)
        if (!cacheContent.modelCurrent || !cacheContent.modelLongTerm ||
            !cacheContent.modelHourByHour)
        {
            return false
        }

        cacheModelCurrent.data = cacheContent.modelCurrent
        cacheModelLongTerm.data = cacheContent.modelLongTerm
        cacheModelHourByHour.data = cacheContent.modelHourByHour

        modelCurrent = cacheModelCurrent
        modelLongTerm = cacheModelLongTerm
        modelHourByHour = cacheModelHourByHour

        applyModelData()

        cacheModelCurrent.data = []
        cacheModelLongTerm.data = []
        cacheModelHourByHour.data = []

        return true
    }

    function getCreditLabel() {
        return 'Weather forecast data provided by OpenWeather.'
    }

    function getCreditLink(placeObject) {
        return 'http://openweathermap.org/city/' + placeObject.placeIdentifier
    }

    function getIconIr(iconCode) {
        const OwmToIr = {
            200:"lightrainandthunder",
            201:"rainandthunder",
            202:"heavyrainandthunder",
            210:"lightrainandthunder",
            211:"rainandthunder",
            212:"heavyrainandthunder",
            221:"heavyrainandthunder",
            230:"lightrainandthunder",
            231:"rainandthunder",
            232:"heavyrainandthunder",
            300:"lightrain",
            301:"lightrainshowers",
            302:"heavyrain",
            310:"rain",
            311:"rain",
            312:"heavyrain",
            313:"rain",
            314:"heavyrain",
            321:"rain",
            500:"lightrain",
            501:"lightrainshowers",
            502:"heavyrain",
            503:"heavyrain",
            504:"heavyrain",
            511:"sleet",
            520:"lightsleet",
            521:"rain",
            522:"heavyrain",
            531:"heavyrain",
            600:"lightsnow",
            601:"snow",
            602:"heavysnow",
            611:"sleet",
            612:"lightsleet",
            613:"lightsleetshowers",
            615:"lightsleet",
            616:"sleet",
            620:"lightsleet",
            621:"heavysleet",
            622:"heavysleetshowers",
            701:"fog",
            711:"fog",
            721:"fog",
            731:"fog",
            741:"fog",
            751:"fog",
            761:"fog",
            762:"",
            771:"snow",
            781:"",
            800:"clearsky",
            801:"fair",
            802:"fair",
            803:"cloudy",
            804:"cloudy",
        }

        return OwmToIr[iconCode]
    }

    function getIconDescription(iconCode) {
        const descriptionByCode = {
            200: i18n("Thunderstorm with light rain"),
            201: i18n("Thunderstorm with rain"),
            202: i18n("Thunderstorm with heavy rain"),
            210: i18n("Light thunderstorm"),
            211: i18n("Thunderstorm"),
            212: i18n("Heavy thunderstorm"),
            221: i18n("Ragged thunderstorm"),
            230: i18n("Thunderstorm with light drizzle"),
            231: i18n("Thunderstorm with drizzle"),
            232: i18n("Thunderstorm with heavy drizzle "),
            300: i18n("Light intensity drizzle"),
            301: i18n("Drizzle"),
            302: i18n("Heavy intensity drizzle"),
            310: i18n("Light intensity drizzle rain"),
            311: i18n("Drizzle rain"),
            312: i18n("Heavy intensity drizzle rain"),
            313: i18n("Shower rain and drizzle"),
            314: i18n("Heavy shower rain and drizzle"),
            321: i18n("Shower drizzle "),
            500: i18n("Light rain"),
            501: i18n("Moderate rain"),
            502: i18n("Heavy intensity rain"),
            503: i18n("Very heavy rain"),
            504: i18n("Extreme rain"),
            511: i18n("Freezing rain"),
            520: i18n("Light intensity shower rain"),
            521: i18n("Shower rain"),
            522: i18n("Heavy intensity shower rain"),
            531: i18n("Ragged shower rain "),
            600: i18n("Light snow"),
            601: i18n("Snow"),
            602: i18n("Heavy snow"),
            611: i18n("Sleet"),
            612: i18n("Light shower sleet"),
            613: i18n("Shower sleet"),
            615: i18n("Light rain and snow"),
            616: i18n("Rain and snow"),
            620: i18n("Light shower snow"),
            621: i18n("Shower snow"),
            622: i18n("Heavy shower snow "),
            701: i18n("Mist"),
            711: i18n("Smoke"),
            721: i18n("Haze"),
            731: i18n("Sand/ dust whirls"),
            741: i18n("Fog"),
            751: i18n("Sand"),
            761: i18n("Dust"),
            762: i18n("Volcanic ash"),
            771: i18n("Squalls"),
            781: i18n("Tornado "),
            800: i18n("Clear sky "),
            801: i18n("Few clouds: 11-25%"),
            802: i18n("Scattered clouds: 25-50%"),
            803: i18n("Broken clouds: 51-84%"),
            804: i18n("Overcast clouds: 85-100%")
        }

        if (!(iconCode in descriptionByCode)) {
            return ""
        }

        return descriptionByCode[iconCode]
    }
}
