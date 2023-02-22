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
import QtQuick.XmlListModel 2.0
import "../../code/model-utils.js" as ModelUtils
import "../../code/data-loader.js" as DataLoader
import "../../code/unit-utils.js" as UnitUtils

Item {
    id: owm

    property string providerId: 'owm'

    property string urlPrefix: 'http://api.openweathermap.org/data/2.5'
    property string appIdAndModeSuffix: '&units=metric&mode=xml&appid=5819a34c58f8f07bc282820ca08948f1'

    property bool updateSemaphore: false

    property int tzOffset: 0

// DEBUGGING URLs
//     property string urlPrefix: 'http://localhost/forecast'
//     property string appIdAndModeSuffix: ''

    XmlListModel {
        id: xmlModelLocation
        query: '/weatherdata/location'

        XmlRole {
            name: 'name'
            query: 'name/string()'
        }

        XmlRole {
            name: 'timezone'
            query: 'timezone/number()'
        }
    }

    XmlListModel {
        id: xmlModelLongTerm
        query: '/weatherdata/forecast/time'

        XmlRole {
            name: 'date'
            query: '@day/string()'
        }
        XmlRole {
            name: 'temperatureMorning'
            query: 'temperature/@morn/number()'
        }
        XmlRole {
            name: 'temperatureDay'
            query: 'temperature/@day/number()'
        }
        XmlRole {
            name: 'temperatureEvening'
            query: 'temperature/@eve/number()'
        }
        XmlRole {
            name: 'temperatureNight'
            query: 'temperature/@night/number()'
        }
        XmlRole {
            name: 'feelsLikeDay'
            query: 'feels_like/@day/number()'
        }
        XmlRole {
            name: 'feelsLikeEvening'
            query: 'feels_like/@eve/number()'
        }
        XmlRole {
            name: 'feelsLikeNight'
            query: 'feels_like/@night/number()'
        }
        XmlRole {
            name: 'feelsLikeMorn'
            query: 'feels_like/@morn/number()'
        }
        XmlRole {
            name: 'iconName'
            query: 'symbol/@number/string()'
        }
        XmlRole {
            name: 'windDirection'
            query: 'windDirection/@deg/number()'
        }
        XmlRole {
            name: 'windSpeedMps'
            query: 'windSpeed/@mps/number()'
        }
        XmlRole {
            name: 'windGust'
            query: 'windGust/@gust/number()'
        }
        XmlRole {
            name: 'pressureHpa'
            query: 'pressure/@value/number()'
        }
        XmlRole {
            name: 'humidity'
            query: 'humidity/@value/number()'
        }
        XmlRole {
            name: 'clouds'
            query: 'clouds/@all/number()'
        }
        XmlRole {
            name: 'precipitation'
            query: 'precipitation/@probability/number()'
        }
    }

    XmlListModel {
        id: xmlModelHourByHour
        query: '/weatherdata/forecast/time'

        XmlRole {
            name: 'from'
            query: '@from/string()'
        }
        XmlRole {
            name: 'to'
            query: '@to/string()'
        }
        XmlRole {
            name: 'temperature'
            query: 'temperature/@value/number()'
        }
        XmlRole {
            name: 'iconName'
            query: 'symbol/@number/string()'
        }
        XmlRole {
            name: 'windDirection'
            query: 'windDirection/@deg/number()'
        }
        XmlRole {
            name: 'windSpeedMps'
            query: 'windSpeed/@mps/number()'
        }
        XmlRole {
            name: 'pressureHpa'
            query: 'pressure/@value/number()'
        }
        XmlRole {
            name: 'precipitationProb'
            query: 'precipitation/@probability/number()'
        }
        XmlRole {
            name: 'precipitationValue'
            query: 'precipitation/@value/number()'
        }
        XmlRole {
            name: 'humidity'
            query: 'humidity/@value/number()'
        }
        XmlRole {
            name: 'clouds'
            query: 'clouds/@all/number()'
        }
    }

    XmlListModel {
        id: xmlModelCurrent
        query: '/current'

        XmlRole {
            name: 'temperature'
            query: 'temperature/@value/number()'
        }
        XmlRole {
            name: 'iconName'
            query: 'weather/@number/string()'
        }
        XmlRole {
            name: 'humidity'
            query: 'humidity/@value/number()'
        }
        XmlRole {
            name: 'pressureHpa'
            query: 'pressure/@value/number()'
        }
        XmlRole {
            name: 'windSpeedMps'
            query: 'wind/speed/@value/number()'
        }
        XmlRole {
            name: 'windDirection'
            query: 'wind/direction/@value/number()'
        }
        XmlRole {
            name: 'cloudiness'
            query: 'clouds/@value/number()'
        }
        XmlRole {
            name: 'updated'
            query: 'lastupdate/@value/string()'
        }
        XmlRole {
            name: 'rise'
            query: 'city/sun/@rise/string()'
        }
        XmlRole {
            name: 'set'
            query: 'city/sun/@set/string()'
        }
    }

    property var xmlModelLocationStatus: xmlModelLocation.status
    property var xmlModelLongTermStatus: xmlModelLongTerm.status
    property var xmlModelCurrentStatus: xmlModelCurrent.status
    property var xmlModelHourByHourStatus: xmlModelHourByHour.status

    function parseDate(dateString) {
        let d = new Date(dateString + '.000Z')
        return UnitUtils.convertDate(d, timezoneType, undefined, tzOffset)
    }

    onXmlModelCurrentStatusChanged: {
        if (xmlModelCurrent.status != XmlListModel.Ready) {
            return
        }
        dbgprint('xmlModelCurrent ready')
        xmlModelReady()
    }

    onXmlModelHourByHourStatusChanged: {
        if (xmlModelHourByHour.status != XmlListModel.Ready) {
            return
        }
        dbgprint('xmlModelHourByHour ready')
        xmlModelReady()
    }

    onXmlModelLongTermStatusChanged: {
        if (xmlModelLongTerm.status != XmlListModel.Ready) {
            return
        }
        dbgprint('xmlModelLongTerm ready')
        xmlModelReady()
    }

    onXmlModelLocationStatusChanged: {
        if (xmlModelLocation.status != XmlListModel.Ready) {
            return
        }
        xmlModelReady()
    }

    function xmlModelReady() {
        if (!updateSemaphore) {
            return
        }
        if (xmlModelLocation.status != XmlListModel.Ready) {
            return
        }
        if (xmlModelCurrent.status != XmlListModel.Ready) {
            return
        }
        if (xmlModelHourByHour.status != XmlListModel.Ready) {
            return
        }
        if (xmlModelLongTerm.status != XmlListModel.Ready) {
            return
        }
        dbgprint('all xml models ready')
        if (xmlModelLocation.count > 0) {
            let item = xmlModelLocation.get(0)
            tzOffset = item.timezone
        } else {
            tzOffset = 0
            print("warning: OpenWeatherMap timezone offset data not available")
        }
        createTodayTimeObj()
        updateTodayModels()
        updateMeteogramModel()
        updateNextDaysModel()
        refreshTooltipSubText()
        updateSemaphore = false
    }

    function createTodayTimeObj() {
        if (xmlModelCurrent.count > 0) {
            var currentTimeObj = xmlModelCurrent.get(0)
            currentWeatherModel.temperature = currentTimeObj.temperature
            currentWeatherModel.iconName = currentTimeObj.iconName
            currentWeatherModel.windDirection = currentTimeObj.windDirection
            currentWeatherModel.windSpeedMps = currentTimeObj.windSpeedMps
            currentWeatherModel.pressureHpa = currentTimeObj.pressureHpa
            currentWeatherModel.humidity = currentTimeObj.humidity
            currentWeatherModel.cloudiness = currentTimeObj.cloudiness
            currentWeatherModel.valid = true
        }

        currentWeatherModel.sunRise = parseDate(currentTimeObj.rise)
        currentWeatherModel.sunSet = parseDate(currentTimeObj.set)
        dbgprint('setting actual weather from current xml model')
        dbgprint('sunRise: ' + currentWeatherModel.sunRise)
        dbgprint('sunSet:  ' + currentWeatherModel.sunSet)
        dbgprint('current: ' + currentTimeObj.temperature)
    }

    function updateTodayModels() {

        dbgprint('updating today models')

        var now = new Date()
        dbgprint('now: ' + now)
        var tooOldCurrentDataLimit = new Date(now.getTime() - (2 * 60 * 60 * 1000))

        // set current models
        var foundNow = false
        for (var i = 0; i < xmlModelHourByHour.count; i++) {
            var timeObj = xmlModelHourByHour.get(i)
            var dateFrom = parseDate(timeObj.from)
            var dateTo = parseDate(timeObj.to)
            dbgprint('HOUR BY HOUR: dateFrom=' + dateFrom + ', dateTo=' + dateTo + ', i=' + i)

            if (!foundNow && dateFrom <= now && now <= dateTo) {
                dbgprint('foundNow setting to true')
                foundNow = true
                if (!currentWeatherModel.valid) {
                    dbgprint('adding to actualWeatherModel - temperature: ' + timeObj.temperature + ', iconName: ' + timeObj.iconName)
                    currentWeatherModel.temperature = timeObj.temperature
                    currentWeatherModel.iconName = timeObj.iconName
                    currentWeatherModel.windDirection = timeObj.windDirection
                    currentWeatherModel.windSpeedMps = timeObj.windSpeedMps
                    currentWeatherModel.pressureHpa = timeObj.pressureHpa
                    currentWeatherModel.humidity = timeObj.humidity
                    currentWeatherModel.cloudiness = timeObj.cloudiness
                    currentWeatherModel.valid = true
                }
                continue
            }

            if (foundNow) {
                currentWeatherModel.nearFuture.iconName = timeObj.iconName
                currentWeatherModel.nearFuture.temperature = timeObj.temperature
                dbgprint('setting near future - ' + timeObj.iconName + ', temp: ' + timeObj.temperature)
                break
            }
        }

        dbgprint('result currentWeatherModel.valid: ' + currentWeatherModel.valid)
        dbgprint('result nearFutureWeather.iconName: ' + currentWeatherModel.nearFuture.iconName)

    }

    function updateNextDaysModel() {

        dailyWeatherModels.precipitationUnit = "mm"
        dailyWeatherModels.beginList()

        for (var i = 0; i < xmlModelLongTerm.count; i++) {
            let item = xmlModelLongTerm.get(i)
            let dailyModel = dailyWeatherModels.createItem()

            let dateFrom = Date.fromLocaleString(xmlLocale, item.date, 'yyyy-MM-dd')
            dailyModel.date = dateFrom

            let night = dailyModel.models[0]
            let morn = dailyModel.models[1]
            let day = dailyModel.models[2]
            let eve = dailyModel.models[3]

            night.temperature = item.temperatureNight
            morn.temperature = item.temperatureMorning
            day.temperature = item.temperatureDay
            eve.temperature = item.temperatureEvening

            night.iconName = item.iconName
            morn.iconName = item.iconName
            day.iconName = item.iconName
            eve.iconName = item.iconName

            dailyWeatherModels.addItem(dailyModel)
        }

        dailyWeatherModels.endList()
        main.nextDaysCount = dailyWeatherModels.count
    }

    function updateMeteogramModel() {

        meteogramModel.beginList()

        var firstFromMs = null
        var limitMsDifference = 1000 * 60 * 60 * 63 // 2.50 days
        var dateNow = UnitUtils.convertDate(new Date(), timezoneType, undefined, tzOffset)
        var intervalStart = UnitUtils.floorDate(dateNow)

        for (var i = 0; i < xmlModelHourByHour.count; i++) {
            var obj = xmlModelHourByHour.get(i)
            var dateFrom = parseDate(obj.from)
            var dateTo = parseDate(obj.to)
//             dbgprint('meteo fill: i=' + i + ', from=' + obj.from + ', to=' + obj.to)
//             dbgprint('parsed: from=' + dateFrom + ', to=' + dateTo)
            if (intervalStart > dateTo) {
                continue
            }

            meteogramModel.addItem({
                from: dateFrom,
                temperature: parseInt(obj.temperature),
                precipitationAvg: parseFloat(obj.precipitationValue),
                precipitationMax: parseFloat(obj.precipitationValue),
                precipitationLabel: "mm",
                windDirection: obj.windDirection,
                windSpeedMps: parseFloat(obj.windSpeedMps),
                pressureHpa: parseFloat(obj.pressureHpa),
                iconName: obj.iconName,
                humidity: parseFloat(obj.humidity),
                cloudArea: parseFloat(obj.clouds)
            })

            if (firstFromMs === null) {
                firstFromMs = dateFrom.getTime()
            }

            if (dateTo.getTime() - firstFromMs > limitMsDifference) {
                dbgprint('breaking')
                break
            }
        }

        meteogramModel.endList()
        meteogramModel.hourInterval = 3
        meteogramModel.precipitationUnit = "mm"
        dbgprint('meteogramModel.count = ' + meteogramModel.count)

        main.meteogramModelChanged = !main.meteogramModelChanged
    }

    /**
     * successCallback(contentToCache)
     * failureCallback()
     */
    function loadDataFromInternet(successCallback, failureCallback, locationObject) {
        var placeIdentifier = locationObject.placeIdentifier
        var cacheKey = locationObject.cacheKey

        var loadedCounter = 0

        var loadedData = {
            current: null,
            hourByHour: null,
            longTerm: null
        }

        var versionParam = '&v=' + new Date().getTime()

        function successLongTerm(xmlString) {
            loadedData.longTerm = xmlString
            successCallback(loadedData, cacheKey)
        }

        function successHourByHour(xmlString) {
            loadedData.hourByHour = xmlString
            DataLoader.fetchXmlFromInternet(urlPrefix + '/forecast/daily?id=' + placeIdentifier + '&cnt=8' + appIdAndModeSuffix + versionParam, successLongTerm, failureCallback)
        }

        function successCurrent(xmlString) {
            loadedData.current = xmlString
            DataLoader.fetchXmlFromInternet(urlPrefix + '/forecast?id=' + placeIdentifier + appIdAndModeSuffix + versionParam, successHourByHour, failureCallback)
        }

        var xhr1 = DataLoader.fetchXmlFromInternet(urlPrefix + '/weather?id=' + placeIdentifier + appIdAndModeSuffix + versionParam, successCurrent, failureCallback)

        return [xhr1]
    }

    function setWeatherContents(cacheContent) {
        if (!cacheContent.longTerm || !cacheContent.hourByHour || !cacheContent.current) {
            return false
        }
        updateSemaphore = true
        xmlModelLocation.xml = ''
        xmlModelLocation.xml = cacheContent.longTerm
        xmlModelCurrent.xml = ''
        xmlModelCurrent.xml = cacheContent.current
        xmlModelLongTerm.xml = ''
        xmlModelLongTerm.xml = cacheContent.longTerm
        xmlModelHourByHour.xml = ''
        xmlModelHourByHour.xml = cacheContent.hourByHour
        return true
    }

    function getCreditLabel(placeIdentifier) {
        return 'Weather forecast data provided by OpenWeather.'
    }

    function getCreditLink(placeIdentifier) {
        return 'http://openweathermap.org/city/' + placeIdentifier
    }

    function reloadMeteogramImage(placeIdentifier) {
        main.overviewImageSource = ''
    }

}
