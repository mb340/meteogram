import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import "../../code/model-utils.js" as ModelUtils
import "../../code/data-loader.js" as DataLoader
import "../../code/unit-utils.js" as UnitUtils
import "../../code/icons.js" as IconTools

Item {
    id: phony

    property string providerId: 'phonyprovider'

    function loadDataFromInternet(successCallback, failureCallback, locationObject) {
        var placeIdentifier = locationObject.placeIdentifier
        var cacheKey = locationObject.cacheKey
        successCallback("", cacheKey)
        return []
    }

    function updateMeteogramModel() {

        meteogramModel.clear()

        const nHours = 48
        var now = new Date()
        var startTime = new Date(now.setMinutes(0, 0, 0))
        var curTime = startTime

        for (var i = 0; i < nHours; i++) {
            var dateFrom = curTime
            var dateTo = new Date(dateFrom.getTime() + (60 * 60 * 1000))

            // print('parsed: from=' + dateFrom + ', to=' + dateTo)
            var x = (i / 24) * 2 * Math.PI
            var tempRange = 1

            // var tempOffset = 10
            var tempOffset = (i / 2) + 10

            var temperature = tempOffset + (tempRange * Math.sin(x))

            var pressureOffset = 1010
            var pressureRange = 30
            var pressure = pressureOffset + ((pressureRange / 2) * Math.sin(x))

            var keys = Object.keys(IconTools.WeatherFont.codeByName)
            var n = Math.round(Math.random() * (keys.length - 1));
            var iconName = keys[n]
            // print(iconName)

            var prec = 30
            var prec = 20 * Math.sin(x)
            prec = Math.max(0, prec) + (10 - (20 * Math.random()))

            meteogramModel.append({
                from: dateFrom,
                to: dateTo,
                temperature: temperature,
                precipitationAvg: prec,
                precipitationLabel: "mm",
                precipitationMax: 0.0,
                windDirection: 0.0,
                windSpeedMps: 0.0,
                pressureHpa: pressure,
                iconName: iconName,
            })

            curTime = dateTo
        }

        dbgprint('meteogramModel.count = ' + meteogramModel.count)

        main.meteogramModelChanged = !main.meteogramModelChanged
    }

    function updateNextDaysModel() {
        nextDaysModel.clear()

        for (var day = 0; day < main.nextDaysCount; day++) {
            var obj = ModelUtils.createEmptyNextDaysObject()
            obj.dayTitle = "Day " + day

            for (var i = 0; i < 4; i++) {
                var tempInfo = {
                    temperature: 20,
                    iconName: "",
                    hidden: false,
                    isPast: false
                }
                obj.tempInfoArray.push(tempInfo)
            }

            ModelUtils.populateNextDaysObject(obj)
            nextDaysModel.append(obj)
        }

    }

    function createTodayTimeObj() {
        additionalWeatherInfo.sunRise = new Date()
        additionalWeatherInfo.sunSet = new Date()
        var currentTimeObj = {
            temperature:  20.0,
            iconName: "",
            humidity: 40,
            pressureHpa: 1000,
            windSpeedMps: 10,
            windDirection: 180,
            cloudiness: 75,
            updated: String(new Date()),
            rise: ""+additionalWeatherInfo.sunRise,
            set: ""+additionalWeatherInfo.sunSet,
        }
        actualWeatherModel.clear()
        actualWeatherModel.append(currentTimeObj)

        var nearFutureWeather = additionalWeatherInfo.nearFutureWeather
        nearFutureWeather.iconName = ""
        nearFutureWeather.temperature = 21.0
    }


    function setWeatherContents(cacheContent) {
        updateMeteogramModel()
        updateNextDaysModel()
        createTodayTimeObj()
        // updateTodayModels()
        updateAdditionalWeatherInfoText()
        return true
    }

    function getCreditLabel(placeIdentifier) {
        return 'Phony Provider'
    }

    function getCreditLink(placeIdentifier, placeAlias) {
        return 'https://127.0.0.1'
    }

    function reloadMeteogramImage(placeIdentifier) {
    }
}

