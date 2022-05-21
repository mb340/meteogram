import QtQuick 2.2
import "../../code/model-utils.js" as ModelUtils
import "../../code/data-loader.js" as DataLoader
import "../../code/unit-utils.js" as UnitUtils
import "../../code/db/timezoneData.js" as TZ



Item {
    id: metno

    property var locale: Qt.locale()
    property string providerId: 'metno'
    property string urlPrefix: 'https://api.met.no/weatherapi/locationforecast/2.0/compact?'

    property bool weatherDataFlag: false
    property bool sunRiseSetFlag: false
    property bool weatherDataFailFlag: false
    property string weatherDataJson: ""
    property string sunRiseDataJson: ""

    function getCreditLabel(placeIdentifier) {
        return i18n("Weather forecast data provided by The Norwegian Meteorological Institute.")
    }

    function getCreditLink(placeIdentifier, placeAlias) {
        placeAlias = placeAlias.replace(", ", ",")
        var lang = Qt.locale().name.substr(0,2)
        var url = 'https://yr.no/' + lang + '/search?q=' + placeAlias
        return url
    }

    function setWeatherContents(cacheContent) {

        var weatherData = cacheContent.weatherData
        actualWeatherModel.clear()
        var currentWeather = weatherData.properties.timeseries[0]
        var futureWeather = weatherData.properties.timeseries[1]
        var iconnumber = geticonNumber(currentWeather.data.next_1_hours.summary.symbol_code)
        var wd = currentWeather.data.instant.details["wind_from_direction"]
        var ws = currentWeather.data.instant.details["wind_speed"]
        var ap = currentWeather.data.instant.details["air_pressure_at_sea_level"]
        var hm = currentWeather.data.instant.details["relative_humidity"]
        var cld = currentWeather.data.instant.details["cloud_area_fraction"]
        actualWeatherModel.append({"temperature": currentWeather.data.instant.details["air_temperature"], "iconName": iconnumber, "windDirection": wd,"windSpeedMps": ws, "pressureHpa": ap, "humidity": hm, "cloudiness": cld})
        additionalWeatherInfo.nearFutureWeather.temperature = futureWeather.data.instant.details["air_temperature"]
        additionalWeatherInfo.nearFutureWeather.iconName = geticonNumber(futureWeather.data.next_1_hours.summary.symbol_code)
        updateNextDaysModel(weatherData)
        buildMetogramData(weatherData)


        var sunRiseData = cacheContent.sunRiseData
        additionalWeatherInfo.sunRise = undefined
        additionalWeatherInfo.sunSet = undefined
        if (sunRiseData.location !== undefined && sunRiseData.location.time !== undefined) {
            if (sunRiseData.location.time.length > 0 && sunRiseData.location.time[0].sunrise) {
                additionalWeatherInfo.sunRise = sunRiseData.location.time[0].sunrise.time
            }
            if (sunRiseData.location.time.length > 0 && sunRiseData.location.time[0].sunset) {
                additionalWeatherInfo.sunSet = sunRiseData.location.time[0].sunset.time
            }
        }
        if ((sunRiseData.results !== undefined)) {
            if (sunRiseData.results.sunrise !== undefined) {
                additionalWeatherInfo.sunRise = sunRiseData.results.sunrise
            }
            if (sunRiseData.results.sunset !== undefined) {
                additionalWeatherInfo.sunSet = sunRiseData.results.sunset
            }
        }

        updateAdditionalWeatherInfoText()

        return true
    }

    function parseISOString(s) {
        var b = s.split(/\D+/)
        return new Date(Date.UTC(b[0], --b[1], b[2], b[3], b[4], b[5], b[6]))
    }

    function buildMetogramData(readingsArray) {
        meteogramModel.clear()
        var readingsLength = (readingsArray.properties.timeseries.length)
        var dateNow = new Date()
        var dateFrom = parseISOString(readingsArray.properties.timeseries[0].time)
        var precipitation_unit = readingsArray.properties.meta.units["precipitation_amount"]
        var counter = 0
        var i = 1
        while (readingsArray.properties.timeseries[i].data.next_1_hours) {
            var obj = readingsArray.properties.timeseries[i]
            var dateTo = parseISOString(obj.time)
            if (dateTo < dateNow) {
                dateFrom = dateTo
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
            counter = (prec > 0) ? counter + 1 : 0
            meteogramModel.append({
                from: dateFrom,
                to: dateTo,
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
            dateFrom = dateTo
            i++
        }
        main.meteogramModelChanged = !main.meteogramModelChanged
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

        function resetobj() {
            var obj = {}
            obj.hidden0 = true
            obj.isPast0 = true
            obj.hidden1 = true
            obj.isPast1 = true
            obj.hidden2 = true
            obj.isPast2 = true
            obj.hidden3 = true
            obj.isPast3 = true
            return obj
        }

        function appendObj(obj) {
            if (!isObjectFilled(obj)) {
                return false
            }

            for (var i = 0; i < 4; i++) {
                if (('isPast'+i) in obj && obj['isPast'+i] === false) {
                    continue
                }
                obj['temperature'+i] = NaN
                obj['iconName'+i] = ""
            }

            nextDaysModel.append(obj)
            return true
        }

        nextDaysModel.clear()
        var readingsLength = (readingsArray.properties.timeseries.length) - 1
        var dateNow = UnitUtils.convertDate(new Date(), timezoneType)
        var obj = resetobj()
        var prevHour = -1;
        for (var i = 0; i < readingsLength; i++) {
            var reading = readingsArray.properties.timeseries[i]
            var date = UnitUtils.convertDate(new Date(Date.parse(reading.time)), timezoneType)
            var readingDate = date.toLocaleDateString(locale, 'ddd d MMM')

            var hour = date.getHours()

            if (reading.data.next_1_hours) {
                var iconnumber = geticonNumber(reading.data.next_1_hours.summary.symbol_code)
            }
            else if (reading.data.next_6_hours) {
                var iconnumber = geticonNumber(reading.data.next_6_hours.summary.symbol_code)
            } else {
              var iconnumber = undefined
            }
            var temperature = reading.data.instant.details["air_temperature"]

            if (prevHour > hour) {
                if (!appendObj(obj)) {
                    print('Next days obj not appended to model')
                }
                if (nextDaysModel.count >= 8) {
                    break;
                }

                obj = resetobj()
            }
            prevHour = hour

            if (!obj.dayTitle) {
                if (dateNow.getDate() == date.getDate()) {
                    obj.dayTitle = i18n('today')
                } else {
                    obj.dayTitle = readingDate
                }
            }

            // Match exact hour.
            // Take the next closest if exact match isn't available.
            if  (hour === 3 || (obj.isPast0 && 0 <= hour && hour <= 6)) {
                obj.temperature0 = temperature
                obj.iconName0 = iconnumber
                obj.hidden0 = false
                obj.isPast0 = false
                continue;
            }

            if  (hour === 9 || (obj.isPast1 && 6 <= hour && hour <= 12)) {
                obj.temperature1 = temperature
                obj.iconName1 = iconnumber
                obj.hidden1 = false
                obj.isPast1 = false
                continue;
            }

            if  (hour === 15 || (obj.isPast2 && 12 <= hour && hour <= 18)) {
                obj.temperature2 = temperature
                obj.iconName2 = iconnumber
                obj.hidden2 = false
                obj.isPast2 = false
                continue;
            }

            if  (hour === 21 || (obj.isPast3 && 18 <= hour && hour <= 23)) {
                obj.temperature3 = temperature
                obj.iconName3 = iconnumber
                obj.hidden3 = false
                obj.isPast3 = false
                continue;
            }
        }
        main.nextDaysCount = nextDaysModel.count
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

      let now = new Date().getTime() / 1000
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
    var codes = {
            "clearsky":    "1",
            "cloudy":    "4",
            "fair":    "2",
            "fog":    "15",
            "heavyrain":    "10",
            "heavyrainandthunder":    "11",
            "heavyrainshowers":    "41",
            "heavyrainshowersandthunder":    "25",
            "heavysleet":    "48",
            "heavysleetandthunder":    "32",
            "heavysleetshowers":    "43",
            "heavysleetshowersandthunder":    "27",
            "heavysnow":    "50",
            "heavysnowandthunder":    "34",
            "heavysnowshowers":    "45",
            "heavysnowshowersandthunder":    "29",
            "lightrain":    "46",
            "lightrainandthunder":    "30",
            "lightrainshowers":    "40",
            "lightrainshowersandthunder":    "24",
            "lightsleet":    "47",
            "lightsleetandthunder":    "31",
            "lightsleetshowers":    "42",
            "lightsnow":    "49",
            "lightsnowandthunder":    "33",
            "lightsnowshowers":    "44",
            "lightssleetshowersandthunder":    "26",
            "lightssnowshowersandthunder":    "28",
            "partlycloudy":    "3",
            "rain":    "9",
            "rainandthunder":    "22",
            "rainshowers":    "5",
            "rainshowersandthunder":    "6",
            "sleet":    "12",
            "sleetandthunder":    "23",
            "sleetshowers":    "7",
            "sleetshowersandthunder":    "20",
            "snow":    "13",
            "snowandthunder":    "14",
            "snowshowers":    "8",
            "snowshowersandthunder":    "21"
        }
        var underscore = text.indexOf("_")
        if (underscore > -1) {
            text = text.substr(0,underscore)
        }
        var num = codes[text]
        return num
    }

    function windDirection(bearing) {
        var Directions = ['N','NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW','N']
        var brg = Math.round((bearing + 11.25) / 22.5)
        return(Directions[brg])
    }
}
