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

function convertTemperature(celsia, temperatureType) {
    if (temperatureType === TemperatureType.FAHRENHEIT) {
        return toFahrenheit(celsia)
    } else if (temperatureType === TemperatureType.KELVIN) {
        return toKelvin(celsia)
    }
    return celsia
}

function formatTemperatureStr(temperature, temperatureType) {
    return temperature.toFixed(0)
}

function getTemperatureNumberExt(temperatureStr, temperatureType) {
    return getTemperatureNumber(temperatureStr, temperatureType) + (temperatureType === TemperatureType.CELSIUS || temperatureType === TemperatureType.FAHRENHEIT ? '°' : '')
}

function getTemperatureNumber(temperatureStr, temperatureType) {
    var fl = parseFloat(temperatureStr)
    if (temperatureType === TemperatureType.FAHRENHEIT) {
        fl = toFahrenheit(fl)
    } else if (temperatureType === TemperatureType.KELVIN) {
        fl = toKelvin(fl)
    }
    return Math.round(fl)
}

function kelvinToCelsia(kelvin) {
    return kelvin - 273.15
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
    UTC: 1
}

function convertDate(date, timezoneType) {
    if (timezoneType === TimezoneType.UTC) {
        return new Date(date.getTime() + (date.getTimezoneOffset() * 60000))
    }
    return date
}

function hasSunriseSunsetData() {
    if (!main.additionalWeatherInfo) {
        return false
    }
    if (main.additionalWeatherInfo.sunRise === undefined ||
        main.additionalWeatherInfo.sunSet === undefined)
    {
        return false
    }
    if (typeof(main.additionalWeatherInfo.sunRise) === "number" &&
        isNaN(main.additionalWeatherInfo.sunRise))
    {
        return false
    }
    if (typeof(main.additionalWeatherInfo.sunSet) === "number" &&
        isNaN(main.additionalWeatherInfo.sunSet))
    {
        return false
    }
    return true

}

function isSunRisen(t) {
    var hourFrom = t.getHours()
    if (!hasSunriseSunsetData()) {
        return 6 <= hourFrom && hourFrom <= 18
    }

    var sunRise = main.additionalWeatherInfo.sunRise
    var sunSet = main.additionalWeatherInfo.sunSet

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
function precipitationFormat(precFloat, precipitationLabel) {
    if (precipitationLabel === i18n('%')) {
        return (precFloat * 100).toFixed(0)
    }
    if (precFloat >= precipitationMinVisible) {
        var result = Math.round(precFloat * 10) / 10
        return result.toFixed(1)
    }
    return ''
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
