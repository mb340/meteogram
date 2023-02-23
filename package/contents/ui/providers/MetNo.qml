import QtQuick 2.2
import "../../code/model-utils.js" as ModelUtils
import "../../code/data-loader.js" as DataLoader
import "../../code/icons.js" as IconTools
import "../../code/unit-utils.js" as UnitUtils
import "../../code/db/timezoneData.js" as TZ



Item {
    id: metno

    property var locale: Qt.locale()
    property string providerId: 'metno'
    property string urlPrefix: 'https://api.met.no/weatherapi/locationforecast/2.0/compact?'
    property string forecastPrefix: 'https://www.yr.no/en/forecast/daily-table/'

    property bool weatherDataFlag: false
    property bool sunRiseSetFlag: false
    property bool weatherDataFailFlag: false
    property string weatherDataJson: ""
    property string sunRiseDataJson: ""

    function getCreditLabel(placeIdentifier) {
        return i18n("Weather forecast data provided by The Norwegian Meteorological Institute.")
    }

   function extLongLat(placeIdentifier) {
        return placeIdentifier.substr(placeIdentifier.indexOf("lat=" )+4,placeIdentifier.indexOf("&lon=")-4) +","+
               placeIdentifier.substr(placeIdentifier.indexOf("&lon=")+5,placeIdentifier.indexOf("&altitude=")-placeIdentifier.indexOf("&lon=")-5)
    }

    function getCreditLink(placeIdentifier, placeAlias) {
         return forecastPrefix + extLongLat(placeIdentifier)
    }

    function getIndexOfCurrentHour(weatherData) {
        let i = 0
        let timeseries = weatherData.properties.timeseries
        var dateNow = UnitUtils.dateNow(timezoneType)
        var hour = dateNow.getHours()

        while (i < timeseries.length) {
            let weather = timeseries[i]
            var date = UnitUtils.convertDate(weather.time, timezoneType)
            if (Math.abs(dateNow - date) < 60 * 60 * 1000) {
                return i
            }
            i++
        }
        return -1
    }

    function setWeatherContents(cacheContent) {
        var weatherData = cacheContent.weatherData
        updateCurrentWeather(weatherData)
        updateNextDaysModel(weatherData)
        buildMetogramData(weatherData)

        var sunRise = undefined
        var sunSet = undefined
        var sunRiseData = cacheContent.sunRiseData
        if (sunRiseData.location !== undefined && sunRiseData.location.time !== undefined) {
            if (sunRiseData.location.time.length > 0 && sunRiseData.location.time[0].sunrise) {
                sunRise = sunRiseData.location.time[0].sunrise.time
            }
            if (sunRiseData.location.time.length > 0 && sunRiseData.location.time[0].sunset) {
                sunSet = sunRiseData.location.time[0].sunset.time
            }
        }
        if ((sunRiseData.results !== undefined)) {
            if (sunRiseData.results.sunrise !== undefined) {
                sunRise = sunRiseData.results.sunrise
            }
            if (sunRiseData.results.sunset !== undefined) {
                sunSet = sunRiseData.results.sunset
            }
        }

        if (sunRise && sunSet) {
            currentWeatherModel.sunRise = UnitUtils.convertDate(sunRise, timezoneType)
            currentWeatherModel.sunSet = UnitUtils.convertDate(sunSet, timezoneType)
        }

        return true
    }

    function updateCurrentWeather(weatherData) {
        var currentIndex = getIndexOfCurrentHour(weatherData)
        if (currentIndex === -1) {
            print("error: weather data doesn't contain current hour data")
            return
        }

        var currentWeather = weatherData.properties.timeseries[currentIndex]
        var iconnumber = geticonNumber(currentWeather.data.next_1_hours.summary.symbol_code)
        var temperature = currentWeather.data.instant.details["air_temperature"]
        var wd = currentWeather.data.instant.details["wind_from_direction"]
        var ws = currentWeather.data.instant.details["wind_speed"]
        var ap = currentWeather.data.instant.details["air_pressure_at_sea_level"]
        var hm = currentWeather.data.instant.details["relative_humidity"]
        var cld = currentWeather.data.instant.details["cloud_area_fraction"]

        currentWeatherModel.temperature = temperature
        currentWeatherModel.iconName = iconnumber
        currentWeatherModel.windDirection = wd
        currentWeatherModel.windSpeedMps = ws
        currentWeatherModel.pressureHpa = ap
        currentWeatherModel.humidity = hm
        currentWeatherModel.cloudiness = cld
        currentWeatherModel.valid = true

        if (currentIndex + 1 < weatherData.properties.timeseries.length) {
            let futureWeather = weatherData.properties.timeseries[currentIndex + 1]
            temperature = futureWeather.data.instant.details["air_temperature"]
            iconnumber = geticonNumber(futureWeather.data.next_1_hours.summary.symbol_code)
            currentWeatherModel.nearFuture.temperature = temperature
            currentWeatherModel.nearFuture.iconName = iconnumber
        }
    }

    function parseISOString(s) {
        var b = s.split(/\D+/)
        return new Date(Date.UTC(b[0], --b[1], b[2], b[3], b[4], b[5], b[6]))
    }

    function buildMetogramData(readingsArray) {
        meteogramModel.beginList()
        var dateNow = UnitUtils.dateNow(timezoneType)
        var intervalStart = UnitUtils.floorDate(dateNow)
        var precipitation_unit = readingsArray.properties.meta.units["precipitation_amount"]
        var i = 0
        var timeseries = readingsArray.properties.timeseries
        while (i < timeseries.length && timeseries[i].data.next_1_hours) {
            var obj = timeseries[i]
            var dateFrom = UnitUtils.convertDate(obj.time, timezoneType)
            if (dateFrom < intervalStart) {
                i++
                continue
            }
            var wd = obj.data.instant.details["wind_from_direction"]
            var ws = obj.data.instant.details["wind_speed"]
            var ap = obj.data.instant.details["air_pressure_at_sea_level"]
            var airtmp = parseFloat(obj.data.instant.details["air_temperature"])
            var icon = obj.data.next_1_hours.summary["symbol_code"]
            var prec = obj.data.next_1_hours.details["precipitation_amount"]
            var hm = obj.data.instant.details["relative_humidity"]
            var cld = obj.data.instant.details["cloud_area_fraction"]
            meteogramModel.addItem({
                from: dateFrom,
                temperature: airtmp,
                precipitationAvg: prec,
                precipitationMax: prec,
                precipitationLabel: precipitation_unit,
                windDirection: parseFloat(wd),
                windSpeedMps: parseFloat(ws),
                pressureHpa: parseFloat(ap),
                iconName: geticonNumber(icon),
                humidity: parseFloat(hm),
                cloudArea: parseFloat(cld)
            })
            i++
        }
        meteogramModel.endList()
    }

    function formatTime(ISOdate) {
        return ISOdate.substr(11,5)
    }

    function formatDate(ISOdate) {
        return ISOdate.substr(0,10)
    }

    function isObjectFilled(obj) {
        return !obj.isPast0 || !obj.isPast1 || !obj.isPast2 || !obj.isPast3
    }

    function updateNextDaysModel(readingsArray) {
        var readingsLength = (readingsArray.properties.timeseries.length) - 1

        var prevHour = -1;
        var nearestHour = [NaN, NaN, NaN, NaN]

        function checkIsNearestHour(obj_num, target_hour, hour) {
            if (isNaN(nearestHour[obj_num])) {
                nearestHour[obj_num] = hour
                return true
            }

            if (Math.abs(target_hour - hour) < Math.abs(nearestHour[obj_num] - hour)) {
                nearestHour[obj_num] = hour
                return true
            }
            return false
        }

        dailyWeatherModels.beginList()
        let dailyModel = dailyWeatherModels.createItem()

        let dailyPeriodIdx = -1
        let prevPeriodIdx = -1
        let temperatureMin = NaN
        let temperatureMax = NaN
        let temperatureCount = 0

        for (var i = 0; i < readingsLength; i++) {
            var reading = readingsArray.properties.timeseries[i]
            var details = reading.data.instant.details
            var date = UnitUtils.convertDate(new Date(Date.parse(reading.time)), timezoneType)

            // Hour convention [1 - 24]
            var hour = date.getHours() + 1

            // Check for new day
            if (prevHour > hour) {
                dailyWeatherModels.addItem(dailyModel)
                if (dailyWeatherModels.count >= 8) {
                    break;
                }

                dailyModel = dailyWeatherModels.createItem()
                nearestHour = [NaN, NaN, NaN, NaN]
            }
            prevHour = hour

            // Match exact hour.
            // Take the next closest if exact match isn't available.
            let isNearestHour = false
            if  (hour <= 6) {
                dailyPeriodIdx = 0
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 3, hour)
            } else if (hour <= 12) {
                dailyPeriodIdx = 1
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 9, hour)
            } else if (hour <= 18) {
                dailyPeriodIdx = 2
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 15, hour)
            } else if (hour <= 24) {
                dailyPeriodIdx = 3
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 21, hour)
            }

            if (dailyPeriodIdx != prevPeriodIdx) {
                temperatureMin = NaN
                temperatureMax = NaN
                temperatureCount = 0
            }
            prevPeriodIdx = dailyPeriodIdx

            //
            // Populate daily data model
            //
            let iconNumber = ""
            let precipitation = NaN
            if (reading.data.next_6_hours) {
                let summary = reading.data.next_6_hours.summary
                let details = reading.data.next_6_hours.details
                iconNumber = geticonNumber(summary.symbol_code)
                precipitation = parseFloat(details.precipitation_amount)
            } else if (reading.data.next_1_hours) {
                let summary = reading.data.next_1_hours.summary
                let details = reading.data.next_1_hours.details
                iconNumber = geticonNumber(summary.symbol_code)
                precipitation = parseFloat(details.precipitation_amount)
            }

            let temperature = details["air_temperature"]
            temperatureMin = Math.min(isFinite(temperatureMin) ? temperatureMin : temperature, temperature)
            temperatureMax = Math.max(isFinite(temperatureMax) ? temperatureMax : temperature, temperature)
            temperatureCount++

            let item = dailyModel.models[dailyPeriodIdx]
            if (isNearestHour) {
                dailyModel.date = date
                item.temperature = temperature
                item.iconName = iconNumber
                item.pressure = parseFloat(details["air_pressure_at_sea_level"])
                item.cloudiness = parseFloat(details["cloud_area_fraction"])
                item.humidity = parseFloat(details["relative_humidity"])
                item.windDirection = parseFloat(details["wind_from_direction"])
                item.windSpeed = parseFloat(details["wind_speed"])
                item.precipitationAmount = precipitation
            }

            if (temperatureCount > 1) {
                item.temperatureLow = temperatureMin
                item.temperatureHigh = temperatureMax
            }
        }

        dailyWeatherModels.endList()
        main.nextDaysCount = dailyWeatherModels.count
    }

    function calculateOffset(seconds) {
      let hrs = String("0" + Math.floor(Math.abs(seconds) / 3600)).slice(-2)
      let mins = String("0" + (seconds % 3600)).slice(-2)
      let sign = (seconds >= 0) ? "+" : "-"
      return(sign + hrs + ":" + mins)
    }

    function isDST(DSTPeriods) {
      if(DSTPeriods === undefined)
        return (false)

      let now = UnitUtils.dateNow(timezoneType).getTime() / 1000
      let isDSTflag = false
      for (let f = 0; f < DSTPeriods.length; f++) {
        if ((now >= DSTPeriods[f].DSTStart) && (now <= DSTPeriods[f].DSTEnd)) {
          isDSTflag = true
        }
      }
      return(isDSTflag)
    }

    function loadDataFromInternet(successCallback, failureCallback, locationObject) {
        var placeIdentifier = locationObject.placeIdentifier
        var cacheKey = locationObject.cacheKey

        function loadCompleted() {
            var cacheContent = {}
            cacheContent["weatherData"] = JSON.parse(weatherDataJson)
            cacheContent["sunRiseData"] = JSON.parse(sunRiseDataJson)
            weatherDataJson = ""
            sunRiseDataJson = ""
            successCallback(cacheContent, cacheKey)
        }

        function successWeather(jsonString) {
            weatherDataJson = jsonString
            weatherDataFlag = true
            if ((weatherDataFlag) && (sunRiseSetFlag)) {
                loadCompleted()
            }
        }

        function successSRAS(jsonString) {
            sunRiseDataJson = jsonString
            sunRiseSetFlag = true
            if ((weatherDataFlag) && (sunRiseSetFlag)) {
                loadCompleted()
            }
        }

        function failureCb() {
            dbgprint("DOH!")
            weatherDataJson = ""
            sunRiseDataJson = ""
            if (!weatherDataFailFlag) {
                weatherDataFailFlag = true
                failureCallback(cacheKey)
            }
        }

        weatherDataFlag = false
        sunRiseSetFlag = false
        weatherDataFailFlag = false
        var TZURL = ""

        if (locationObject.timezoneID === -1) {
          console.log("[weatherWidget] Timezone Data not available - using sunrise-sunset.org API")
          TZURL = "https://api.sunrise-sunset.org/json?formatted=0&" + placeIdentifier
        } else {
          console.log("[weatherWidget] Timezone Data is available - using met.no API")
          if (isDST(TZ.TZData[locationObject.timezoneID].DSTData)) {
            timezoneShortName = TZ.TZData[locationObject.timezoneID].DSTName
          } else {
            timezoneShortName = TZ.TZData[locationObject.timezoneID].TZName
          }
          TZURL = 'https://api.met.no/weatherapi/sunrise/2.0/.json?' + placeIdentifier.replace("altitude","height") + "&date=" + formatDate(new Date().toISOString())
          if (isDST(TZ.TZData[locationObject.timezoneID].DSTData)) {
            TZURL += "&offset=" + calculateOffset(TZ.TZData[locationObject.timezoneID].DSTOffset)
          } else {
            TZURL += "&offset=" + calculateOffset(TZ.TZData[locationObject.timezoneID].Offset)
          }
        }
        console.log(TZURL)

        var xhr1 = DataLoader.fetchJsonFromInternet(urlPrefix + placeIdentifier, successWeather, failureCb)
        var xhr2 = DataLoader.fetchJsonFromInternet(TZURL, successSRAS, failureCb)
//         var xhr1 = DataLoader.fetchJsonFromInternet('http://localhost/weather.json', successWeather, failureCallback)
//         var xhr2 = DataLoader.fetchJsonFromInternet('http://localhost/sunrisesunset.json?' + TZURL, successSRAS, failureCallback)
        return [xhr1, xhr2]
    }

    function reloadMeteogramImage(placeIdentifier) {
        main.overviewImageSource = ''
    }

    function geticonNumber(text) {

        var underscore = text.indexOf("_")
        if (underscore > -1) {
            text = text.substr(0,underscore)
        }
        var num = IconTools.MetNo.NameToCode[text]
        return num
    }

    function windDirection(bearing) {
        var Directions = ['N','NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW','N']
        var brg = Math.round((bearing + 11.25) / 22.5)
        return(Directions[brg])
    }
}
