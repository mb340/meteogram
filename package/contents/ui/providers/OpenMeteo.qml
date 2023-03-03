import QtQuick 2.0
import "../../code/model-utils.js" as ModelUtils
import "../../code/data-loader.js" as DataLoader
import "../../code/icons.js" as IconTools
import "../../code/unit-utils.js" as UnitUtils
import "../../code/db/timezoneData.js" as TZ

Item {

    property string providerId: 'openMeteo'

    readonly property string url: "https://api.open-meteo.com/v1/forecast?"

                                  // "latitude=43.87&longitude=-79.27&" +

    readonly property string args: "&hourly=temperature_2m," +
                                  "relativehumidity_2m," +
                                  "dewpoint_2m," +
                                  "apparent_temperature," +
                                  "precipitation_probability," +
                                  "precipitation," +
                                  "weathercode," +
                                  "pressure_msl," +
                                  "cloudcover," +
                                  "windspeed_10m," +
                                  "winddirection_10m," +
                                  "windgusts_10m&" +

                                  "models=best_match&" +

                                  "daily=weathercode," +
                                  "temperature_2m_max," +
                                  "temperature_2m_min," +
                                  "apparent_temperature_max," +
                                  "apparent_temperature_min," +
                                  "sunrise,sunset," +
                                  "uv_index_max," +
                                  "uv_index_clear_sky_max," +
                                  "precipitation_sum," +
                                  "precipitation_probability_max," +
                                  "windspeed_10m_max," +
                                  "windgusts_10m_max," +
                                  "winddirection_10m_dominant&" +

                                  // "current_weather=true&" +
                                  "windspeed_unit=ms&" +
                                  // "timeformat=unixtime&" +

                                  "timezone=Europe%2FLondon"
                                  // "timezone=auto"


    function parseDate(dateString) {
        let d = new Date(dateString + ':00.000Z')
        return UnitUtils.convertDate(d)
    }

    function getCurrentHourDay(data) {
        let hourly = data.hourly
        let daily = data.daily
        let now = UnitUtils.dateNow()
        now.setMinutes(0, 0, 0)

        var hourlyIdx = -1
        for (var i = 0; i < hourly.time.length; i++) {
            let date = parseDate(hourly.time[i])
            date.setMinutes(0, 0, 0)
            if (date.getTime() === now.getTime()) {
                hourlyIdx = i
                break
            }
        }

        if (hourlyIdx === -1) {
            return [-1, -1]
        }

        now.setHours(0, 0, 0, 0)

        var dailyIdx = -1
        for (var i = 0; i < daily.time.length; i++) {
            let date = new Date(daily.time[i])
            date.setHours(0, 0, 0, 0)
            if (date.getTime() == now.getTime()) {
                dailyIdx = i
                break
            }
        }

        if (dailyIdx === -1) {
            return [-1, -1]
        }

        return [hourlyIdx, dailyIdx]
    }

    function buildCurrentModel(data) {
        let hourly = data.hourly
        let daily = data.daily

        let [hourlyIdx, dailyIdx] = getCurrentHourDay(data)
        if (hourlyIdx === -1 || dailyIdx === -1) {
            return
        }

        currentWeatherModel.iconName = String(hourly.weathercode[hourlyIdx])
        currentWeatherModel.temperature = parseFloat(hourly.temperature_2m[hourlyIdx])
        currentWeatherModel.windDirection = parseFloat(hourly.winddirection_10m[hourlyIdx])
        currentWeatherModel.windSpeedMps = parseFloat(hourly.windspeed_10m[hourlyIdx])

        currentWeatherModel.pressureHpa = parseFloat(hourly.pressure_msl[hourlyIdx])
        currentWeatherModel.humidity = parseFloat(hourly.relativehumidity_2m[hourlyIdx])
        currentWeatherModel.cloudArea = parseFloat(hourly.cloudcover[hourlyIdx])

        currentWeatherModel.sunRise = parseDate(daily.sunrise[dailyIdx])
        currentWeatherModel.sunSet = parseDate(daily.sunset[dailyIdx])

        currentWeatherModel.valid = true
        // print('currentWeatherModel.valid')
    }

    function buildDailyPart(data, currDay, hourlyIdx, dailyModel) {
        let hourly = data.hourly

        // print("currDay " + currDay)
        // return hourlyIdx

        var currDay = new Date(currDay.getTime())
        currDay.setHours(0, 0, 0, 0)
        // print("currDay " + currDay)

        let i = -1
        let prevPeriodIdx = -1
        let temperatureMin = Infinity
        let temperatureMax = -Infinity
        let temperatureCount = 0
        let precipitationSum = 0

        for (i = hourlyIdx; i < hourly.time.length; i++) {
            let day = parseDate(hourly.time[i])
            day.setHours(0, 0, 0, 0)
            let dayHour = parseDate(hourly.time[i])
            dayHour.setMinutes(0, 0, 0)

            // continue until matching day is found
            if (day < currDay) {
                continue
            }

            // Stop at next day
            if (day > currDay) {
                break
            }

            let hour = dayHour.getHours()

            let isNearestHour = false
            let partOfDay = 0
            let dailyPeriodIdx = -1
            if  (hour < 6) {
                isNearestHour = hour === 3
                dailyPeriodIdx = 0
                partOfDay = 1
            } else if (hour < 12) {
                isNearestHour = hour === 9
                dailyPeriodIdx = 1
            } else if (hour < 18) {
                isNearestHour = hour === 15
                dailyPeriodIdx = 2
            } else if (hour < 24) {
                isNearestHour = hour === 21
                dailyPeriodIdx = 3
                partOfDay = 1
            }

            // print(dayHour)

            if (dailyPeriodIdx != prevPeriodIdx) {
                temperatureMin = Infinity
                temperatureMax = -Infinity
                temperatureCount = 0
                precipitationSum = 0
            }
            prevPeriodIdx = dailyPeriodIdx

            let temperature = parseFloat(hourly.temperature_2m[i])
            temperatureMin = Math.min(temperatureMin, temperature)
            temperatureMax = Math.max(temperatureMax, temperature)

            let precipitation = parseFloat(hourly.precipitation[i])
            precipitationSum += precipitation

            let item = dailyModel.models[dailyPeriodIdx]
            if (isNearestHour) {
                item.partOfDay = partOfDay
                item.iconName = String(hourly.weathercode[i])

                item.temperature = temperature
                item.feelsLike = parseFloat(hourly.apparent_temperature[i])
                // item.dewPoint = parseFloat(hourly.dewpoint_2m[i])
                // item.precipitationProb = parseFloat(hourly.precipitation_probability[i]) / 100.0
                item.windDirection = parseFloat(hourly.winddirection_10m[i])
                item.windSpeed = parseFloat(hourly.windspeed_10m[i])
                item.windGust = parseFloat(hourly.windgusts_10m[i])
                item.pressure = parseFloat(hourly.pressure_msl[i])
                item.humidity = parseFloat(hourly.relativehumidity_2m[i])
                item.cloudArea = parseFloat(hourly.cloudcover[i])
            }

            item.temperatureLow = temperatureMin
            item.temperatureHigh = temperatureMax
            item.precipitationAmount = precipitationSum
        }

        return i
    }

    function buildDailyModel(data) {
        let daily = data.daily

        let today = UnitUtils.dateNow()
        today.setHours(0, 0, 0, 0)

        dailyWeatherModels.beginList()
        let hourlyIdx = 0

        for (var i = 0; i < daily.time.length; i++) {
            let date = new Date(daily.time[i])

            if (date < today) {
                continue
            }

            // print("buildDailyModel " + date)

            let dailyModel = dailyWeatherModels.createItem()
            dailyModel.date = date

            dailyModel.temperatureMin = parseFloat(daily.temperature_2m_min[i])
            dailyModel.temperatureMax = parseFloat(daily.temperature_2m_max[i])

            dailyModel.windDirection = parseFloat(daily.winddirection_10m_dominant[i])
            dailyModel.windSpeed = parseFloat(daily.windspeed_10m_max[i])
            dailyModel.windGust = parseFloat(daily.windgusts_10m_max[i])

            dailyModel.precipitationProb = parseFloat(daily.precipitation_probability_max[i]) / 100.0
            dailyModel.precipitationAmount = parseFloat(daily.precipitation_sum[i])

            hourlyIdx = buildDailyPart(data, date, hourlyIdx, dailyModel)

            dailyWeatherModels.addItem(dailyModel)
        }

        dailyWeatherModels.endList()
    }

    function buildMeteogramModel(data) {
        let hourly = data.hourly
        let now = UnitUtils.dateNow()
        now.setMinutes(0, 0, 0)

        const maxHours = 62
        let hourCount = 0

        meteogramModel.beginList()

        for (var i = 0; i < hourly.time.length && hourCount < maxHours; i++) {
            let date = parseDate(hourly.time[i])

            if (date < now) {
                continue
            }

            var item = meteogramModel.createItem()
            item.from = date
            item.iconName = String(hourly.weathercode[i])
            item.temperature = parseFloat(hourly.temperature_2m[i])
            item.feelsLike = parseFloat(hourly.apparent_temperature[i])
            item.dewPoint = parseFloat(hourly.dewpoint_2m[i])
            item.precipitationProb = parseFloat(hourly.precipitation_probability[i]) / 100.0
            item.precipitationAmount = parseFloat(hourly.precipitation[i])
            item.windDirection = parseFloat(hourly.winddirection_10m[i])
            item.windSpeed = parseFloat(hourly.windspeed_10m[i])
            item.windGust = parseFloat(hourly.windgusts_10m[i])
            item.pressure = parseFloat(hourly.pressure_msl[i])
            item.humidity = parseFloat(hourly.relativehumidity_2m[i])
            item.cloudArea = parseFloat(hourly.cloudcover[i])
            meteogramModel.addItem(item)

            hourCount++
        }

        meteogramModel.endList()
        meteogramModel.hourInterval = 1
    }

    function loadDataFromInternet(successCallback, failureCallback, locationObject) {
        print('locationObject = ' + JSON.stringify(locationObject))
        var placeIdentifier = locationObject.placeIdentifier
        var cacheKey = locationObject.cacheKey

        function successCurrent(jsonString) {
            // print("successCurrent")
            // print(jsonString)
            successCallback(jsonString, cacheKey)
        }

        var getUrl = url + placeIdentifier + args
        var xhr1 = DataLoader.fetchJsonFromInternet(getUrl, successCurrent, failureCallback)

        return [xhr1]
    }

    function setWeatherContents(cacheContent) {
        // print(cacheContent)
        let data = JSON.parse(cacheContent)

        buildMeteogramModel(data)
        buildDailyModel(data)
        buildCurrentModel(data)

        return true
    }

    function getCreditLabel(placeIdentifier) {
        return 'Weather data by Open-Meteo.com'
    }

    function getCreditLink(placeIdentifier) {
        return "https://open-meteo.com/"
    }

    function reloadMeteogramImage(placeIdentifier) {
        main.overviewImageSource = ''
    }

    function getIconIr(iconCode) {
        const OpenMeteoToIr = {
            0:  "clearsky",
            1:  "fair",
            2:  "partlycloudy",
            3:  "cloudy",
            45: "fog",
            48: "fog",
            51: "lightrain",
            53: "rain",
            55: "heavyrain",
            56: "lightsleet",
            57: "sleet",
            61: "lightrain",
            63: "rain",
            65: "heavyrain",
            66: "lightsleet",
            67: "sleet",
            71: "lightsnow",
            73: "snow",
            75: "heavysnow",
            77: "snow",
            80: "lightrainshowers",
            81: "rainshowers",
            82: "heavyrainshowers",
            85: "lightsnowshowers",
            86: "heavysnowshowers",
            95: "rainandthunder",
            96: "lightsleetandthunder",
            99: "heavysleetandthunder"
        }

        let irName = null
        let code = parseInt(iconCode)
        if (!isNaN(code)) {
            irName = OpenMeteoToIr[code]
        }
        return irName
    }

    function getIconDescription(iconCode) {

        const descriptionByCode = {
            0:  i18n("Clear sky"),
            1:  i18n("Mainly clear"),
            2:  i18n("Partly cloudy"),
            3:  i18n("Overcast"),
            45: i18n("Fog"),
            48: i18n("Depositing rime fog"),
            51: i18n("Light drizzle"),
            53: i18n("Moderate drizzle"),
            55: i18n("Heavy drizzle"),
            56: i18n("Light freezing drizzle"),
            57: i18n("Dense freezing drizzle"),
            61: i18n("Slight rain"),
            63: i18n("Moderate rain"),
            65: i18n("Heavy rain"),
            66: i18n("Light freezing rain"),
            67: i18n("Heavy freezing rain"),
            71: i18n("Slight snow fall"),
            73: i18n("Moderate snow fall"),
            75: i18n("Heave snow fall"),
            77: i18n("Snow grains"),
            80: i18n("Slight rain showers"),
            81: i18n("Moderate rain showers"),
            82: i18n("Violent rain showers"),
            85: i18n("Slight snow showers"),
            86: i18n("Heavy snow showers"),
            95: i18n("Slight or moderate thunderstorm"),
            96: i18n("Thunderstorm with slight hail"),
            99: i18n("Thunderstorm with heavy hail")
        }

        let code = parseInt(iconCode)
        if (isNaN(code)) {
            return ""
        }
        return descriptionByCode[code]
    }
}
