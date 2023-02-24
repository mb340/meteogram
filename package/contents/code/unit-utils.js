.pragma library
.import "./db/timezoneData.js" as TZ

var initialized = false
var main = null
var i18n = null
var precipitationMinVisible = null

/*
 * TEMPERATURE
 */
var TemperatureType = {
    CELSIUS: 0,
    FAHRENHEIT: 1,
    KELVIN: 2
}

function toFahrenheit(celsia) {
    return celsia * (9 / 5) + 32
}

function toKelvin(celsia) {
    return celsia + 273.15
}

function kelvinToCelsia(kelvin) {
    return kelvin - 273.15
}

function convertTemperature(celsia, temperatureType) {
    if (temperatureType === undefined) {
        temperatureType = main.temperatureType
    }
    if (temperatureType === TemperatureType.FAHRENHEIT) {
        return toFahrenheit(celsia)
    } else if (temperatureType === TemperatureType.KELVIN) {
        return toKelvin(celsia)
    }
    return Math.round(celsia)
}

function formatTemperatureStr(temperature, temperatureType) {
    return temperature.toFixed(0)
}

function formatTemperatureUnit(temperatureType) {
    if (temperatureType === undefined) {
        temperatureType = main.temperatureType
    }
    if (temperatureType === TemperatureType.CELSIUS ||
        temperatureType === TemperatureType.FAHRENHEIT)
    {
        return '°'
    }
    return ""
}

function getTemperatureNumberExt(temperatureStr, temperatureType) {
    return convertTemperature(temperatureStr, temperatureType) +
            formatTemperatureUnit(temperatureType)
}

function getTemperatureEnding(temperatureType) {
    if (temperatureType === TemperatureType.CELSIUS) {
        return i18n("°C")
    } else if (temperatureType === TemperatureType.FAHRENHEIT) {
        return i18n("°F")
    } else if (temperatureType === TemperatureType.KELVIN) {
        return i18n("K")
    }
    return ''
}

/*
 * PRESSURE
 */
var PressureType = {
    HPA: 0,
    INHG: 1,
    MMHG: 2
}

function convertPressure(hpa, pressureType) {
    if (pressureType === PressureType.INHG) {
        return hpa * 0.0295299830714
    }
    if (pressureType === PressureType.MMHG) {
        return hpa * 0.750061683
    }
    return hpa
}

function formatPressureStr(val, pressureDecimals) {
    return val.toFixed(pressureDecimals)
}

function getPressureNumber(hpa, pressureType) {
    if (pressureType === PressureType.INHG) {
        return Math.round(hpa * 0.0295299830714 * 10) / 10
    }
    if (pressureType === PressureType.MMHG) {
        return Math.round(hpa * 0.750061683)
    }
    return Math.round(hpa)
}

function getPressureText(hpa, pressureType) {
    return getPressureNumber(hpa, pressureType) + ' ' + getPressureEnding(pressureType)
}

function getPressureEnding(pressureType) {
    if (pressureType === undefined) {
        pressureType = main.pressureType
    }
    if (pressureType === PressureType.INHG) {
        return i18n("inHg")
    }
    if (pressureType === PressureType.MMHG) {
        return i18n("mmHg")
    }
    return i18n("hPa")
}

/*
 * WIND SPEED
 */
var WindSpeedType = {
    MPS: 0,
    MPH: 1,
    KMH: 2
}

function getWindSpeedNumber(mps, windSpeedType) {
    if (windSpeedType === WindSpeedType.MPH) {
        return Math.round(mps * 2.2369362920544 * 10) / 10
    } else if (windSpeedType === WindSpeedType.KMH) {
        return Math.round(mps * 3.6 * 10) / 10
    }
    return mps
}

function getWindSpeedText(mps, windSpeedType) {
    return getWindSpeedNumber(mps, windSpeedType) + ' ' + getWindSpeedEnding(windSpeedType)
}

function getWindSpeedEnding(windSpeedType) {
    if (windSpeedType === undefined) {
        windSpeedType = main.windSpeedType
    }
    if (windSpeedType === WindSpeedType.MPH) {
        return i18n("mph")
    } else if (windSpeedType === WindSpeedType.KMH) {
        return i18n("km/h")
    }
    return i18n("m/s")
}

function getHourText(hourNumber, twelveHourClockEnabled) {
    var result = hourNumber
    if (twelveHourClockEnabled) {
        if (hourNumber === 0) {
            result = 12
        } else {
            result = hourNumber > 12 ? hourNumber - 12 : hourNumber
        }
    }
    return result < 10 ? '0' + result : result
}

function getAmOrPm(hourNumber) {
    if (hourNumber === 0) {
        return Qt.locale().amText
    }
    return hourNumber > 11 ? Qt.locale().pmText : Qt.locale().amText
}


/*
 * TIMEZONE
 */
var TimezoneType = {
    USER_LOCAL_TIME: 0,
    UTC: 1,
    LOCATION_LOCAL_TIME: 2,
}

function convertDateToUTC(date) {
    return new Date(date.getUTCFullYear(),
                    date.getUTCMonth(),
                    date.getUTCDate(),
                    date.getUTCHours(),
                    date.getUTCMinutes(),
                    date.getUTCSeconds())
}

function dateNow(timezoneType) {
    if (timezoneType === undefined) {
        timezoneType = main.timezoneType
    }
    var now = convertDate(new Date(), timezoneType)
    return now
}

function isDST(DSTPeriods, timezoneType) {
    if(DSTPeriods === undefined) {
        return (false)
    }
    if (timezoneType === undefined) {
        timezoneType = main.timezoneType
    }

    let now = (new Date).getTime() / 1000
    let isDSTflag = false
    for (let f = 0; f < DSTPeriods.length; f++) {
        if ((now >= DSTPeriods[f].DSTStart) && (now <= DSTPeriods[f].DSTEnd)) {
           isDSTflag = true
        }
    }
    return(isDSTflag)
}

/*
 * Convert from system time to UTC or location-local time.
 */
function convertDate(date, timezoneType, timezoneId = undefined, offset = undefined) {
    if (typeof(date) === "string") {
        date = new Date(Date.parse(date))
    } else if (typeof(date) === "number") {
        if (!isFinite(date)) {
            return date
        }
        date = new Date(date)
    }
    if (timezoneType === undefined) {
        timezoneType = main.timezoneType
    }
    if (timezoneId === undefined) {
        timezoneId = main.timezoneID
    }

    if (timezoneType === TimezoneType.UTC) {
        return convertDateToUTC(date)
    } else if (timezoneType === TimezoneType.LOCATION_LOCAL_TIME) {
        var utcDate = convertDateToUTC(date)
        var _offset = offset
        if (_offset == undefined) {
            var tz = TZ.TZData[timezoneId]
            _offset = isDST(tz.DSTData, timezoneType, timezoneId) ? tz.DSTOffset : tz.Offset
        }
        _offset = parseInt(_offset) * 1000
        return new Date(utcDate.getTime() + _offset)
    }
    return date
}

/*
 * Round date to the previous half hour
 */
function floorDate(date) {
    let ts = date.getTime()
    return new Date(ts - (ts % (60 * 60 * 1000)))
}

function hasSunriseSunsetData() {
    return Number(main.currentWeatherModel.sunRise) !== 0 &&
            Number(main.currentWeatherModel.sunSet) !== 0
}

function isSunRisen(t) {
    var hourFrom = t.getHours()
    if (!hasSunriseSunsetData()) {
        return 6 <= hourFrom && hourFrom <= 18
    }

    var sunRise = main.currentWeatherModel.sunRise
    var sunSet = main.currentWeatherModel.sunSet

    var res = undefined
    // print('isSunRisen: sunRise = ' + sunRise)
    // print('isSunRisen: sunSet = ' + sunSet)

    var isSameDate = sunRise.getDate() === sunSet.getDate()

    if (isSameDate) {
        if (sunRise <= sunSet) {
            // Sun rise and set on same day
            res = hourFrom > sunRise.getHours() && hourFrom < sunSet.getHours()
        } else {
            // Sun set on next day
            res = hourFrom > sunRise.getHours() || hourFrom < sunSet.getHours()
        }
    } else  if (!isSameDate && sunSet > sunRise) {
        // Sun set on next day
        res = hourFrom > sunRise.getHours() || hourFrom < sunSet.getHours()
    } else {
        throw new Error("Unhandled sunrise / sunset case")
    }
    // print('isSunRisen: t = ' + t + ', res = ' + res)
    return res
}

/*
 * PRECIPITATION
 */
function precipitationFormat(precFloat) {
    // Format precipitation amount
    if (main.precipitationType === 0) {
        if (precFloat >= precipitationMinVisible) {
            var result = Math.round(precFloat * 10) / 10
            return result.toFixed(1)
        }
        return "0.0 "
    }
    return String(precFloat)
}

function precipitationProbFormat(prob) {
    // Format probability of precipitation
    return (prob * 100).toFixed(0)
}

function localisePrecipitationUnit(unitText) {
    switch (unitText) {
    case "mm":
        return i18n("mm")
    case "cm":
        return i18n("cm")
    case "in":
        return i18n("in")
    default:
        return unitText
    }
}

function convertValue(value, varName) {
    let temperatureType = main.temperatureType
    let pressureType = main.pressureType
    let windSpeedType = main.windSpeedType

    if (varName === "temperature" || varName === "feelsLike") {
        return convertTemperature(value, temperatureType)
    } else if (varName === "precipitationProb") {
        return value * 100
    } else if (varName === "windSpeed" || varName === "windGust") {
        return getWindSpeedNumber(value, windSpeedType)
    } else if (varName === "pressure") {
        return convertPressure(value, pressureType)
    } else if (varName === "humidity") {
        return value * 100
    } else if (varName === "cloudArea") {
        return value * 100
    }
    return value
}

function formatUnits(varName) {
    if (varName === "temperature" || varName === "feelsLike") {
        return formatTemperatureUnit(main.temperatureType)
    } else if (varName === "precipitationProb") {
        return i18n("%")
    } else if (varName === "precipitationAmount") {
        return i18n("mm")
    } else if (varName === "windSpeed" || varName === "windGust") {
        return getWindSpeedEnding()
    } else if (varName === "windDirection") {
        return '°'
    } else if (varName === "pressure") {
        return getPressureEnding()
    } else if (varName === "humidity") {
        return i18n("%")
    } else if (varName === "cloudArea") {
        return i18n("%")
    }
    return ""
}

function formatValue(value, varName, partOfDay) {
    partOfDay = (partOfDay !== undefined) ? partOfDay : 0
    let temperatureType = main.temperatureType
    let pressureType = main.pressureType
    let windSpeedType = main.windSpeedType

    if (varName === "temperature" || varName === "feelsLike") {
        return getTemperatureNumberExt(value, temperatureType)
    } else if (varName === "precipitationProb") {
        let precipStr = precipitationProbFormat(value)
        let precipSuffix = i18n("%")
        return precipStr + " " + precipSuffix
    } else if (varName === "precipitationAmount") {
        let precipStr = precipitationFormat(value)
        let precipSuffix = i18n("mm")
        return precipStr + " " + precipSuffix
    } else if (varName === "windSpeed" || varName === "windGust") {
        return getWindSpeedText(value, windSpeedType)
    } else if (varName === "windDirection") {
        return String(value) + '°'
    } else if (varName === "pressure") {
        var pressureStr = convertPressure(value, pressureType)
        var pressureSuffix = getPressureEnding(pressureType)
        if (!pressureStr) {
            return ""
        }
        return pressureStr.toFixed(2) + " " + pressureSuffix
    } else if (varName === "humidity") {
        return value + " %"
    } else if (varName === "clouds") {
        return value + " %"
    }
    return value
}
