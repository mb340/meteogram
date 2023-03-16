import QtQuick 2.0
import "../code/icons.js" as IconTools

Item {
    id: root

    property string providerId: 'mockprovider'

    property double interval: 10 * 1000

    property bool doFailure: false

    property bool isAborted: false


    Timer {
        id: mockXhrResponse

        property string cacheKey
        property var successCallback
        property var failureCallback

        property int count: 0

        interval: root.interval
        running: false
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            print('mockXhrResponse: onTriggered')
            // if (count === 0) {
            //     failureCallback(cacheKey)
            // } else {
            //     successCallback("{}", cacheKey)
            // }
            if (doFailure) {
                failureCallback(cacheKey)
            } else {
                successCallback("{}", cacheKey)
            }
            count++
        }
    }

    function loadDataFromInternet(successCallback, failureCallback, locationObject) {
        var placeIdentifier = locationObject.placeIdentifier
        var cacheKey = locationObject.cacheKey

        mockXhrResponse.cacheKey = cacheKey
        mockXhrResponse.successCallback = successCallback
        mockXhrResponse.failureCallback = failureCallback
        
        // successCallback("{}", cacheKey)

        mockXhrResponse.start()

        var failureXhr = {
            status: 0,
            abort: function() {
                print("mock xhr abort")
                isAborted = true
            },
            getResponseHeader: function(header) { return null }
        }
        return [failureXhr]
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

    function getCreditLabel(placeIdentifier) {
        return 'Mock Provider'
    }

    function getCreditLink(placeIdentifier, placeAlias) {
        return 'https://127.0.0.1'
    }

    function getIconIr(iconCode) {
        return iconCode
    }

    function getIconDescription(iconCode) {
        return iconCode
    }
}
