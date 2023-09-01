import QtQuick 2.2
import "../../code/data-loader.js" as DataLoader
import "../../code/icons.js" as IconTools


Item {
    id: metno

    property string providerId: 'metno'
    property string urlPrefix: 'https://api.met.no/weatherapi/locationforecast/2.0/complete?'
    property string forecastPrefix: 'https://www.yr.no/en/forecast/daily-table/'


    function getCreditLabel() {
        return i18n("Weather forecast data provided by The Norwegian Meteorological Institute.")
    }

    function getCreditLink(placeObject) {
        let args = parseFloat(placeObject.latitude).toFixed(4) + "," +
                    parseFloat(placeObject.longitude).toFixed(4)
        return forecastPrefix + args
    }

    function getIndexOfCurrentHour(weatherData) {
        let i = 0
        let timeseries = weatherData.properties.timeseries
        var dateNow = timeUtils.dateNow(timezoneType, main.timezoneOffset)
        var hour = dateNow.getHours()

        while (i < timeseries.length) {
            let weather = timeseries[i]
            var date = timeUtils.convertDate(weather.time, timezoneType, main.timezoneOffset)
            if (Math.abs(dateNow - date) < 60 * 60 * 1000) {
                return i
            }
            i++
        }
        return -1
    }

    function updateSunriseData(cacheContent) {
        var sunRise = undefined
        var sunSet = undefined
        var sunRiseData = cacheContent.sunRiseData

        if (sunRiseData === undefined) {
            print("metno: error updateSunriseData: sunRiseData undefined")
            return
        }

        // Parse data from met.no
        if (sunRiseData.properties.sunrise && sunRiseData.properties.sunset) {
            let sunriseData = sunRiseData.properties.sunrise
            if (sunriseData.time) {
                sunRise = timeUtils.convertDate(sunriseData.time, timezoneType, main.timezoneOffset)
            }

            let sunsetData = sunRiseData.properties.sunset
            if (sunsetData.time) {
                sunSet = timeUtils.convertDate(sunsetData.time, timezoneType, main.timezoneOffset)
            }
        }

        // Parse data from sunrise-sunset.org
        if (!sunRise || !sunSet) {
            let data = sunRiseData.results
            if (data !== undefined) {
                if (data.sunrise !== undefined) {
                    sunRise = timeUtils.convertDate(data.sunrise, timezoneType, main.timezoneOffset)
                }
                if (data.sunset !== undefined) {
                    sunSet = timeUtils.convertDate(data.sunset, timezoneType, main.timezoneOffset)
                }
            }
        }


        if (sunRise && sunSet) {
            currentWeatherModel.sunRise = sunRise
            currentWeatherModel.sunSet = sunSet
        }
    }

    function setWeatherContents(cacheContent) {
        cacheContent = JSON.parse(cacheContent)

        var weatherData = cacheContent.weatherData
        updateSunriseData(cacheContent)
        updateCurrentWeather(weatherData)
        updateNextDaysModel(weatherData)
        buildMetogramData(weatherData)

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

        currentWeatherModel.date = timeUtils.convertDate(currentWeather.time, timezoneType,
                                                         main.timezoneOffset)
        currentWeatherModel.temperature = temperature
        currentWeatherModel.iconName = iconnumber
        currentWeatherModel.windDirection = wd
        currentWeatherModel.windSpeedMps = ws
        currentWeatherModel.pressureHpa = ap
        currentWeatherModel.humidity = hm
        currentWeatherModel.cloudArea = cld
        currentWeatherModel.valid = true

        if (currentIndex + 1 < weatherData.properties.timeseries.length) {
            let futureWeather = weatherData.properties.timeseries[currentIndex + 1]
            temperature = futureWeather.data.instant.details["air_temperature"]
            iconnumber = geticonNumber(futureWeather.data.next_1_hours.summary.symbol_code)
            currentWeatherModel.nearFuture.temperature = temperature
            currentWeatherModel.nearFuture.iconName = iconnumber
        }
    }

    function buildMetogramData(readingsArray) {
        meteogramModel.beginList()
        var dateNow = timeUtils.dateNow(timezoneType, main.timezoneOffset)
        var intervalStart = timeUtils.floorDate(dateNow)
        var precipitation_unit = readingsArray.properties.meta.units["precipitation_amount"]
        var i = 0
        let hourCount = 0
        var timeseries = readingsArray.properties.timeseries
        while (i < timeseries.length && hourCount < main.maxMeteogramHours &&
               timeseries[i].data.next_1_hours)
        {
            var obj = timeseries[i]
            var dateFrom = timeUtils.convertDate(obj.time, timezoneType, main.timezoneOffset)
            if (dateFrom < intervalStart) {
                i++
                continue
            }
            var wd = obj.data.instant.details["wind_from_direction"]
            var ws = obj.data.instant.details["wind_speed"]
            var ap = obj.data.instant.details["air_pressure_at_sea_level"]
            var airtmp = parseFloat(obj.data.instant.details["air_temperature"])
            var dewPoint = parseFloat(obj.data.instant.details["dew_point_temperature"])
            var icon = obj.data.next_1_hours.summary["symbol_code"]
            var prec = obj.data.next_1_hours.details["precipitation_amount"]
            var hm = obj.data.instant.details["relative_humidity"]
            var cld = obj.data.instant.details["cloud_area_fraction"]
            var uvi = obj.data.instant.details["ultraviolet_index_clear_sky"]

            var item = meteogramModel.createItem()
            item.from = dateFrom
            item.temperature = airtmp
            item.dewPoint = dewPoint
            item.precipitationAmount = prec
            item.windDirection = parseFloat(wd)
            item.windSpeed = parseFloat(ws)
            item.pressure = parseFloat(ap)
            item.iconName = geticonNumber(icon)
            item.humidity = parseFloat(hm)
            item.cloudArea = parseFloat(cld)
            item.uvi = parseFloat(uvi)
            meteogramModel.addItem(item)
            i++
            hourCount++
        }
        meteogramModel.endList()
    }

    function formatDate(ISOdate) {
        return ISOdate.substr(0,10)
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
            var date = timeUtils.convertDate(new Date(Date.parse(reading.time)), timezoneType,
                                             main.timezoneOffset)

            // Hour convention [0 - 23]
            var hour = date.getHours()

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

            dailyModel.date = new Date(date)
            dailyModel.date.setHours(0, 0, 0, 0)

            // Match exact hour.
            // Take the next closest if exact match isn't available.
            let isNearestHour = false
            let partOfDay = 0
            if  (hour < 6) {
                dailyPeriodIdx = 0
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 3, hour)
                partOfDay = 1
            } else if (hour < 12) {
                dailyPeriodIdx = 1
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 9, hour)
            } else if (hour < 18) {
                dailyPeriodIdx = 2
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 15, hour)
            } else if (hour < 24) {
                dailyPeriodIdx = 3
                isNearestHour = checkIsNearestHour(dailyPeriodIdx, 21, hour)
                partOfDay = 1
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
                temperatureMax = parseFloat(details.air_temperature_max)
                temperatureMin = parseFloat(details.air_temperature_min)
            } else if (reading.data.next_1_hours) {
                let summary = reading.data.next_1_hours.summary
                let details = reading.data.next_1_hours.details
                iconNumber = geticonNumber(summary.symbol_code)
                precipitation = parseFloat(details.precipitation_amount)
            }

            let temperature = details["air_temperature"]
            // temperatureMin = Math.min(isFinite(temperatureMin) ? temperatureMin : temperature, temperature)
            // temperatureMax = Math.max(isFinite(temperatureMax) ? temperatureMax : temperature, temperature)
            temperatureCount++

            let item = dailyModel.models[dailyPeriodIdx]
            if (isNearestHour) {
                item.date = new Date(date)
                timeUtils.setDailyPeriodHour(dailyPeriodIdx, item.date)

                item.partOfDay = partOfDay
                item.temperature = temperature
                item.iconName = iconNumber
                item.pressure = parseFloat(details["air_pressure_at_sea_level"])
                item.cloudArea = parseFloat(details["cloud_area_fraction"])
                item.humidity = parseFloat(details["relative_humidity"])
                item.windDirection = parseFloat(details["wind_from_direction"])
                item.windSpeed = parseFloat(details["wind_speed"])
                item.precipitationAmount = precipitation
                item.temperatureLow = temperatureMin
                item.temperatureHigh = temperatureMax
            }

        }

        dailyWeatherModels.endList()
    }

    function formatOffsetString(seconds) {
      let hrs = String("0" + Math.floor(Math.abs(seconds) / 3600)).slice(-2)
      let mins = String("0" + (seconds % 3600)).slice(-2)
      let sign = (seconds >= 0) ? "+" : "-"
      return(sign + hrs + ":" + mins)
    }

    function formatSunriseUrlArgs(placeObject) {
        let lat = parseFloat(placeObject.latitude).toFixed(4)
        let lon = parseFloat(placeObject.longitude).toFixed(4)
        let url = "lat=" + lat + "&lon=" + lon
        return url
    }

    function getTzUrl(placeObject) {
        let timezoneID = parseInt(placeObject.timezoneID)
        let tzUrl = null
        if (timezoneID === -1) {
            dbgprint("[weatherWidget] Timezone Data not available - using sunrise-sunset.org API")
            let lat = parseFloat(placeObject.latitude).toFixed(4)
            let lon = parseFloat(placeObject.longitude).toFixed(4)
            let args = "lat=" + lat + "&lng=" + lon
            tzUrl = "https://api.sunrise-sunset.org/json?formatted=0&" + args
        } else {
            dbgprint("[weatherWidget] Timezone Data is available - using met.no API")
            let args = formatSunriseUrlArgs(placeObject)
            tzUrl = 'https://api.met.no/weatherapi/sunrise/3.0/sun?' + args +
                        "&date=" + formatDate(new Date().toISOString())

            let tzData = timeUtils.getTimezoneData(timezoneID)
            if (timeUtils.isDST(tzData.DSTData)) {
                tzUrl += "&offset=" + formatOffsetString(tzData.DSTOffset)
            } else {
                tzUrl += "&offset=" + formatOffsetString(tzData.Offset)
            }
        }
        dbgprint(tzUrl)
        return tzUrl
    }

    function formatUrlArgs(placeObject) {
        let lat = parseFloat(placeObject.latitude).toFixed(4)
        let lon = parseFloat(placeObject.longitude).toFixed(4)
        let alt = parseInt(placeObject.altitude)
        let url = "lat=" + lat + "&lon=" + lon + "&altitude=" + alt
        return url
    }

    function loadDataFromInternet(successCallback, failureCallback, cacheKey, placeObject) {
        var weatherDataFlag = false
        var sunRiseSetFlag = false
        var weatherDataFailFlag = false
        var cacheContent = {}
        var sunRiseData = null

        function loadCompleted() {
            successCallback(JSON.stringify(cacheContent), cacheKey)
        }

        function successWeather(jsonString) {
            cacheContent["weatherData"] = JSON.parse(jsonString)
            weatherDataFlag = true
            if ((weatherDataFlag) && (sunRiseSetFlag)) {
                loadCompleted()
            }
        }

        function successSRAS(jsonString) {
            try {
                let obj = JSON.parse(jsonString)
                cacheContent["sunRiseData"] = obj
                let ts = new Date()
                ts.setHours(0, 0, 0, 0)
                cacheContent["sunRiseDataTimestamp"] = ts
            } catch (e) {
                print("metno: error parsing sunrise JSON data:", e)
                print("metno: sunrise jsonString:", jsonString)
                console.trace()
            }
            sunRiseSetFlag = true
            if ((weatherDataFlag) && (sunRiseSetFlag)) {
                loadCompleted()
            }
        }

        function failureCb() {
            dbgprint("DOH!")
            if (!weatherDataFailFlag) {
                weatherDataFailFlag = true
                failureCallback(cacheKey)
            }
        }

        let tzUrl = getTzUrl(placeObject)
        let url = urlPrefix + formatUrlArgs(placeObject)

        var xhrs = []
        var xhr1 = DataLoader.fetchJsonFromInternet(url, successWeather, failureCb, cacheKey)
        xhrs.push(xhr1)

        let jsonStr = cacheDb.getContent(cacheKey)
        let sunRiseDataTimestamp = null
        if (jsonStr) {
            let content = JSON.parse(jsonStr)
            sunRiseDataTimestamp = content.sunRiseDataTimestamp
            if (sunRiseDataTimestamp) {
                sunRiseDataTimestamp = new Date(sunRiseDataTimestamp)
            }
            sunRiseData = content.sunRiseData
        }

        var today = new Date()
        today.setHours(0, 0, 0, 0)
        if (!sunRiseData || !sunRiseDataTimestamp ||
            sunRiseDataTimestamp.getTime() !== today.getTime())
        {
            var xhr2 = DataLoader.fetchJsonFromInternet(tzUrl, successSRAS, failureCb, cacheKey)
            xhrs.push(xhr2)
        } else {
            cacheContent.sunRiseData = sunRiseData
            cacheContent.sunRiseDataTimestamp = sunRiseDataTimestamp
            sunRiseSetFlag = true
        }

        return xhrs
    }

    function geticonNumber(text) {

        var underscore = text.indexOf("_")
        if (underscore > -1) {
            text = text.substr(0,underscore)
        }
        return text
    }

    function getIconIr(iconCode) {
        return iconCode
    }

    function getIconDescription(iconCode) {
        if (!iconCode) {
            return ""
        }

        iconCode = geticonNumber(iconCode)
        const descriptionByCode = {
            "clearsky":                    i18n("Clear sky"),
            "cloudy":                      i18n("Cloudy"),
            "fair":                        i18n("Fair"),
            "fog":                         i18n("Fog"),
            "heavyrain":                   i18n("Heavy rain"),
            "heavyrainandthunder":         i18n("Heavy rain and thunder"),
            "heavyrainshowers":            i18n("Heavy rain showers"),
            "heavyrainshowersandthunder":  i18n("Heavy rain showers and thunder"),
            "heavysleet":                  i18n("Heavy sleet"),
            "heavysleetandthunder":        i18n("Heavy sleet and thunder"),
            "heavysleetshowers":           i18n("Heavy sleet showers"),
            "heavysleetshowersandthunder": i18n("Heavy sleet showers and thunder"),
            "heavysnow":                   i18n("Heavy snow"),
            "heavysnowandthunder":         i18n("Heavy snow and thunder"),
            "heavysnowshowers":            i18n("Heavy snow showers"),
            "heavysnowshowersandthunder":  i18n("Heavy snow showers and thunder"),
            "lightrain":                   i18n("Light rain"),
            "lightrainandthunder":         i18n("Light rain and thunder"),
            "lightrainshowers":            i18n("Light rain showers"),
            "lightrainshowersandthunder":  i18n("Light rain showers and thunder"),
            "lightsleet":                  i18n("Light sleet"),
            "lightsleetandthunder":        i18n("Light sleet and thunder"),
            "lightsleetshowers":           i18n("Light sleet showers"),
            "lightsnow":                   i18n("Light snow"),
            "lightsnowandthunder":         i18n("Light snow and thunder"),
            "lightsnowshowers":            i18n("Light snow showers"),
            "lightssleetshowersandthunder":i18n("Light sleet showers and thunder"),
            "lightssnowshowersandthunder": i18n("Light snow showers and thunder"),
            "partlycloudy":                i18n("Partly cloudy"),
            "rain":                        i18n("Rain"),
            "rainandthunder":              i18n("Rain and thunder"),
            "rainshowers":                 i18n("Rain showers"),
            "rainshowersandthunder":       i18n("Rain showers and thunder"),
            "sleet":                       i18n("Sleet"),
            "sleetandthunder":             i18n("Sleet and thunder"),
            "sleetshowers":                i18n("Sleet showers"),
            "sleetshowersandthunder":      i18n("Sleet showers and thunder"),
            "snow":                        i18n("Snow"),
            "snowandthunder":              i18n("Snow and thunder"),
            "snowshowers":                 i18n("Snow showers"),
            "snowshowersandthunder":       i18n("Snow showers and thunder")
        }
        return descriptionByCode[iconCode]
    }
}
