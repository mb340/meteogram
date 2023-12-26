import QtQuick 2.0
import "../../code/icons.js" as IconTools

Item {
    property string providerId: 'phonyprovider'

    Timer {
        id: phonyXhrResponse

        property string cacheKey
        property var successCallback
        property var failureCallback

        property int count: 0

        interval: 1 * 1000
        running: false
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            print('phonyXhrResponse: onTriggered')
            // if (count === 0) {
            //     failureCallback(cacheKey)
            // } else {
            //     successCallback("{}", cacheKey)
            // }
            successCallback("{}", cacheKey)
            count++
        }
    }

    function loadDataFromInternet(successCallback, failureCallback, cacheKey, placeObject) {
        phonyXhrResponse.cacheKey = cacheKey
        phonyXhrResponse.successCallback = successCallback
        phonyXhrResponse.failureCallback = failureCallback
        
        successCallback("{}", cacheKey)
        return []

        // phonyXhrResponse.start()

        // var failureXhr = {
        //     status: 0,
        //     abort: function() {
        //         print("phony xhr abort")
        //         phonyXhrResponse.stop()
        //     },
        //     getResponseHeader: function(header) { return null }
        // }
        // return [failureXhr]
    }

    function updateMeteogramModel() {

        const nHours = 48
        var hourCount = 0
        var now = new Date()
        var date = new Date(now.setMinutes(0, 0, 0))

        meteogramModel.beginList()

        for (var i = 0; hourCount < 48; i++) {
            var x = (i / 24) * 2 * Math.PI
            var tempRange = 1

            // var tempOffset = 10
            var tempOffset = (i / 2) + 10

            var temperature = tempOffset + (tempRange * Math.sin(x))

            var pressureOffset = 1010
            var pressureRange = 30
            var pressure = pressureOffset + ((pressureRange / 2) * Math.sin(x))

            var keys = Object.keys(IconTools.MetNo.NameToCode)
            var n = Math.round(Math.random() * (keys.length - 1));
            var iconName = keys[n]
            // print(iconName)

            var prec = 30
            var prec = 20 * Math.sin(x)
            prec = Math.max(0, prec) + (10 - (20 * Math.random()))

            var item = meteogramModel.createItem()
            item.from = date
            item.iconName = iconName
            item.temperature = temperature
            // item.feelsLike = 
            // item.dewPoint = 
            // item.precipitationProb = 
            item.precipitationAmount = prec
            // item.windDirection =
            // item.windSpeed =
            // item.windGust =
            item.pressure = pressure
            // item.humidity = 
            // item.cloudArea = 
            meteogramModel.addItem(item)

            hourCount++
            date = new Date(date.getTime() + (60 * 60 * 1000))
        }

        meteogramModel.endList()
        meteogramModel.hourInterval = 1
    }

    function updateNextDaysModel() {
        let date = timeUtils.dateNow(timezoneType, main.timezoneOffset)
        date.setHours(0, 0, 0, 0)

        dailyWeatherModels.beginList()
        let hourlyIdx = 0

        for (var i = 0; i < 7; i++) {
            // print("buildDailyModel " + date)

            let dailyModel = dailyWeatherModels.createItem()
            dailyModel.date = date

            dailyModel.temperatureMin = 15
            dailyModel.temperatureMax = 25

            dailyModel.windDirection = 0
            dailyModel.windSpeed = 0
            dailyModel.windGust = 0

            dailyModel.precipitationProb = 0.0
            dailyModel.precipitationAmount = 0

            dailyWeatherModels.addItem(dailyModel)

            date.setDate(date.getDate() + 1)
        }

        dailyWeatherModels.endList()

    }

    function createTodayTimeObj() {

    }


    function setWeatherContents(cacheContent) {
        updateMeteogramModel()
        updateNextDaysModel()
        createTodayTimeObj()
        return true
    }

    function getCreditLabel() {
        return 'Phony Provider'
    }

    function getCreditLink(placeObject) {
        return 'https://127.0.0.1'
    }

    function getIconIr(iconCode) {
        return iconCode
    }

    function getIconDescription(iconCode) {
        return iconCode
    }
}

