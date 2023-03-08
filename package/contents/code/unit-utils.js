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
    return celsia
}

function formatTemperatureStr(temperature, temperatureType, digits = undefined) {
    if (digits === undefined) {
        digits = 2
    }
    return convertTemperature(temperature, temperatureType).toFixed(digits)
}

function getTemperatureUnit(temperatureType) {
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

function getTemperatureText(temperatureStr, temperatureType, digits = undefined) {
    return formatTemperatureStr(temperatureStr, temperatureType, digits) +
            getTemperatureUnit(temperatureType)
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
const PressureType = {
    HPA: 0,
    INHG: 1,
    MMHG: 2
}

function convertPressure(hpa, pressureType) {
    if (pressureType === PressureType.INHG) {
        return Math.round(hpa * 0.0295299830714 * 100) / 100
    }
    if (pressureType === PressureType.MMHG) {
        return Math.round(hpa * 0.750061683 * 10) / 10
    }
    return hpa
}

function formatPressureStr(val, pressureType, digits = undefined) {
    if (pressureType === undefined) {
        pressureType = main.pressureType
    }
    if (digits === undefined) {
        if (pressureType === PressureType.INHG) {
            digits = 2
        } else {
            digits = 1
        }
    }
    return convertPressure(val, pressureType).toFixed(digits)
}
function getPressureText(hpa, pressureType, digits = undefined) {
    var pressureStr = ""
    if (typeof(hpa) === 'number') {
        pressureStr = formatPressureStr(hpa, pressureType, digits)
    } else {
        pressureStr = String(hpa)
    }
    return pressureStr + ' ' + getPressureUnit(pressureType)
}

function getPressureUnit(pressureType) {
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

function convertWindspeed(mps, windSpeedType) {
    if (windSpeedType === WindSpeedType.MPH) {
        return Math.round(mps * 2.2369362920544 * 10) / 10
    } else if (windSpeedType === WindSpeedType.KMH) {
        return Math.round(mps * 3.6 * 10) / 10
    }
    return parseFloat(mps)
}

function formatWindSpeedStr(mps, windSpeedType, digits = undefined) {
    if (digits === undefined) {
        digits = 1
    }
    return convertWindspeed(mps, windSpeedType).toFixed(digits)
}

function getWindSpeedText(mps, windSpeedType, digits = undefined) {
    return formatWindSpeedStr(mps, windSpeedType, digits) + ' ' + getWindSpeedUnit(windSpeedType)
}

function getWindSpeedUnit(windSpeedType) {
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

function formatWindDirectionStr(degrees, digits = undefined) {
    if (digits === undefined) {
        digits = 0
    }
    return degrees.toFixed(digits)
}

function getWindDirectionUnit() {
    return "°"
}

function getWindDirectionText(degrees, digits = undefined) {
    return formatWindDirectionStr(degrees, digits) + getWindDirectionUnit()
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
    return date.setTime(date.getTime() + (date.getTimezoneOffset() * 60 * 1000))
}

function dateNow(timezoneType) {
    if (timezoneType === undefined) {
        timezoneType = main.timezoneType
    }
    var now = convertDate(new Date(), timezoneType)
    return now
}


function isDST(DSTPeriods) {
    if(DSTPeriods === undefined) {
        return false
    }
    let now = (new Date).getTime() / 1000
    for (let f = 0; f < DSTPeriods.length; f++) {
        if ((now >= DSTPeriods[f].DSTStart) && (now <= DSTPeriods[f].DSTEnd)) {
           return true
        }
    }
    return false
}

function getTimeZoneOffset(timezoneId) {
    if (timezoneId === undefined) {
        timezoneId = main.timezoneID
    }
    if (timezoneId < 0 || timezoneId >= TZ.TZData.length) {
        return NaN
    }
    let tz = TZ.TZData[timezoneId]
    let offset = isDST(tz.DSTData, timezoneId) ? tz.DSTOffset : tz.Offset
    return parseInt(offset) * 1000
}

/*
 * Convert from system time to UTC or location-local time.
 */
function convertDate(date, timezoneType, offset = undefined) {
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
    if (offset === undefined) {
        offset = main.timezoneOffset
    }

    if (timezoneType === TimezoneType.UTC) {
        convertDateToUTC(date)
    } else if (timezoneType === TimezoneType.LOCATION_LOCAL_TIME) {
        convertDateToUTC(date)
        date.setTime(date.getTime() + offset)
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
const PrecipitationType = {
    MM: 0,
    CM: 1,
    INCH: 2,
    MIL: 3
}

function convertPrecipitation(precFloat, precipitationType) {
    if (precipitationType === PrecipitationType.CM) {
        return precFloat / 10.0
    } else if (precipitationType === PrecipitationType.INCH) {
        return Math.round(precFloat * 100) / (100 * 25.4)
    } else if (precipitationType === PrecipitationType.MIL) {
        return Math.round(precFloat * 39.3701 * 10) / 10
    }
    return precFloat
}

function formatPrecipitationStr(precFloat, precipitationType, digits = undefined) {
    let val = convertPrecipitation(precFloat, precipitationType)
    if (digits === undefined) {
        digits = 1
        if (precipitationType === PrecipitationType.MIL) {
            if (val >= 1.0) {
                digits = 0
            }
        } else if (precipitationType === PrecipitationType.CM) {
            digits = 2
        } else if (precipitationType === PrecipitationType.INCH) {
            digits = 3
        }
    }
    return val.toFixed(digits)
}

function getPrecipitationText(prec, precipitationType, digits = undefined) {
    return formatPrecipitationStr(prec, precipitationType, digits) + " " +
            getPrecipitationUnit(precipitationType)
}

function getPrecipitationUnit(precipitationType) {
    switch (precipitationType) {
    default:
    case 0:
        return i18n("mm")
    case 1:
        return i18n("cm")
    case 2:
        return i18n("in")
    case 3:
        return i18n("mil")
    }
}

function getSmallestPrecipitationType(precipitationType) {
    if (precipitationType === PrecipitationType.CM) {
        return PrecipitationType.MM
    } else if (precipitationType === PrecipitationType.INCH) {
        return PrecipitationType.MIL
    }
    return precipitationType
}

function convertPop(percentage) {
    return percentage * 100.0
}

function formatPopStr(percentage, digits = undefined) {
    if (digits === undefined) {
        digits = 0
    }
    return convertPop(percentage).toFixed(digits)
}

function getPopText(percentage) {
    return formatPopStr(percentage) + getPercentageUnit()
}

function convertPercentage(percentage) {
    return percentage * 1.0
}

function formatPercentageStr(percentage, digits = undefined) {
    if (digits === undefined) {
        digits = 0
    }
    return convertPercentage(percentage).toFixed(digits)
}

function getPercentageText(percentage, digits = undefined) {
    return formatPercentageStr(percentage, digits) + getPercentageUnit()
}

function getPercentageUnit() {
    return i18n("%")
}

function convertValue(value, varName) {
    let temperatureType = main.temperatureType
    let pressureType = main.pressureType
    let windSpeedType = main.windSpeedType

    if (varName === "temperature" || varName === "feelsLike" || varName === "dewPoint") {
        return convertTemperature(value, temperatureType)
    } else if (varName === "precipitationProb") {
        return convertPop(value)
    } else if (varName === "windSpeed" || varName === "windGust") {
        return convertWindspeed(value, windSpeedType)
    } else if (varName === "pressure") {
        return convertPressure(value, pressureType)
    } else if (varName === "humidity") {
        return convertPercentage(value)
    } else if (varName === "cloudArea") {
        return convertPercentage(value)
    }
    return value
}

function formatUnits(varName) {
    if (varName === "temperature" || varName === "feelsLike"  || varName === "dewPoint" ||
        varName === "temperatureHigh" || varName === "temperatureLow")
    {
        return getTemperatureUnit(main.temperatureType)
    } else if (varName === "precipitationProb") {
        return getPercentageUnit()
    } else if (varName === "precipitationAmount") {
        return getPrecipitationUnit("mm")
    } else if (varName === "windSpeed" || varName === "windGust") {
        return getWindSpeedUnit()
    } else if (varName === "windDirection") {
        return getWindDirectionUnit()
    } else if (varName === "pressure") {
        return getPressureUnit()
    } else if (varName === "humidity") {
        return getPercentageUnit()
    } else if (varName === "cloudArea") {
        return getPercentageUnit()
    }
    return ""
}

function formatValue(value, varName, partOfDay, digits = undefined) {
    partOfDay = (partOfDay !== undefined) ? partOfDay : 0
    let temperatureType = main.temperatureType
    let pressureType = main.pressureType
    let windSpeedType = main.windSpeedType
    let precipitationType = main.precipitationType

    if (varName === "temperature" || varName === "feelsLike"  || varName === "dewPoint" ||
        varName === "temperatureHigh" || varName === "temperatureLow")
    {
        return getTemperatureText(value, temperatureType, digits)
    } else if (varName === "precipitationProb") {
        return getPopText(value, digits)
    } else if (varName === "precipitationAmount") {
        return getPrecipitationText(value, precipitationType, digits)
    } else if (varName === "windSpeed" || varName === "windGust") {
        return getWindSpeedText(value, windSpeedType, digits)
    } else if (varName === "windDirection") {
        return getWindDirectionText(value, digits)
    } else if (varName === "pressure") {
        return getPressureText(value, pressureType, digits)
    } else if (varName === "humidity") {
        return getPercentageText(value, digits)
    } else if (varName === "cloudArea") {
        return getPercentageText(value, digits)
    }
    return value
}
