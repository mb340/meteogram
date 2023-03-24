/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.0

QtObject {

    enum TemperatureType {
            CELSIUS = 0,
            FAHRENHEIT = 1,
            KELVIN = 2
    }

    enum PrecipitationType {
        MM = 0,
        CM = 1,
        INCH = 2,
        MIL = 3
    }

    enum PressureType {
        HPA = 0,
        INHG = 1,
        MMHG = 2
    }

    enum WindSpeedType {
        MPS = 0,
        MPH = 1,
        KMH = 2
    }

    enum WindDirectionType {
        AZIMUTH = 0,
        CARDINAL = 1
    }

    /*
     * TEMPERATURE
     */
    function isTemperatureVarName(varName) {
        return typeof(varName) === 'string' &&
                (varName.startsWith("temperature") ||
                 varName.startsWith("feelsLike") ||
                 varName === "dewPoint")
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
            print("error: temperatureType not defined")
            console.trace()
        }
        if (temperatureType === UnitUtils.TemperatureType.FAHRENHEIT) {
            return toFahrenheit(celsia)
        } else if (temperatureType === UnitUtils.TemperatureType.KELVIN) {
            return toKelvin(celsia)
        }
        return celsia
    }

    function formatTemperatureStr(temperature, temperatureType, digits = undefined) {
        if (digits === undefined) {
            digits = 2
        }
        if (temperature === 0.0) {
            digits = 0
        }
        return convertTemperature(temperature, temperatureType).toFixed(digits)
    }

    function getTemperatureUnit(temperatureType) {
        if (temperatureType === undefined) {
            print("error: temperatureType not defined")
            console.trace()
        }
        if (temperatureType === UnitUtils.TemperatureType.CELSIUS ||
            temperatureType === UnitUtils.TemperatureType.FAHRENHEIT)
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
        if (temperatureType === UnitUtils.TemperatureType.CELSIUS) {
            return i18n("°C")
        } else if (temperatureType === UnitUtils.TemperatureType.FAHRENHEIT) {
            return i18n("°F")
        } else if (temperatureType === UnitUtils.TemperatureType.KELVIN) {
            return i18n("K")
        }
        return ''
    }

    /*
     * PRESSURE
     */
    function convertPressure(hpa, pressureType) {
        if (pressureType === UnitUtils.PressureType.INHG) {
            return Math.round(hpa * 0.0295299830714 * 100) / 100
        }
        if (pressureType === UnitUtils.PressureType.MMHG) {
            return Math.round(hpa * 0.750061683 * 10) / 10
        }
        return hpa
    }

    function formatPressureStr(val, pressureType, digits = undefined) {
        if (pressureType === undefined) {
            print("error: pressureType not defined")
            console.trace()
        }
        if (digits === undefined) {
            if (pressureType === UnitUtils.PressureType.INHG) {
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
            print("error: pressureType not defined")
            console.trace()
        }
        if (pressureType === UnitUtils.PressureType.INHG) {
            return i18n("inHg")
        }
        if (pressureType === UnitUtils.PressureType.MMHG) {
            return i18n("mmHg")
        }
        return i18n("hPa")
    }

    /*
     * WIND SPEED
     */
    function convertWindspeed(mps, windSpeedType) {
        if (windSpeedType === UnitUtils.WindSpeedType.MPH) {
            return Math.round(mps * 2.2369362920544 * 10) / 10
        } else if (windSpeedType === UnitUtils.WindSpeedType.KMH) {
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
            print("error: windSpeedType not defined")
            console.trace()
        }
        if (windSpeedType === UnitUtils.WindSpeedType.MPH) {
            return i18n("mph")
        } else if (windSpeedType === UnitUtils.WindSpeedType.KMH) {
            return i18n("km/h")
        }
        return i18n("m/s")
    }

    function toCardinal(degrees) {
        const Directions = [
            i18n('N'), i18n('NNE'), i18n('NE'), i18n('ENE'),
            i18n('E'), i18n('ESE'), i18n('SE'), i18n('SSE'),
            i18n('S'), i18n('SSW'), i18n('SW'), i18n('WSW'),
            i18n('W'), i18n('WNW'), i18n('NW'), i18n('NNW'), i18n('N')
        ]
        var brg = Math.round(degrees / 22.5)
        return(Directions[brg])
    }

    function convertWindDirection(degrees) {
        if (windDirectionType === UnitUtils.WindDirectionType.CARDINAL) {
            return toCardinal(degrees)
        }

        return degrees
    }

    function formatWindDirectionStr(degrees, windDirectionType, digits = undefined) {
        if (digits === undefined) {
            digits = 0
        }

        if (windDirectionType === UnitUtils.WindDirectionType.CARDINAL) {
            return convertWindDirection(degrees)
        }

        return degrees.toFixed(digits)
    }

    function getWindDirectionUnit() {
        if (windDirectionType === UnitUtils.WindDirectionType.CARDINAL) {
            return ""
        }
        return "°"
    }

    function getWindDirectionText(degrees, windDirectionType, digits = undefined) {
        return formatWindDirectionStr(degrees, windDirectionType, digits) +
                getWindDirectionUnit(windDirectionType,)
    }

    /*
     * PRECIPITATION
     */
    function convertPrecipitation(precFloat, precipitationType) {
        if (precipitationType === UnitUtils.PrecipitationType.CM) {
            return precFloat / 10.0
        } else if (precipitationType === UnitUtils.PrecipitationType.INCH) {
            return Math.round(precFloat * 100) / (100 * 25.4)
        } else if (precipitationType === UnitUtils.PrecipitationType.MIL) {
            return Math.round(precFloat * 39.3701 * 10) / 10
        }
        return precFloat
    }

    function formatPrecipitationStr(precFloat, precipitationType, digits = undefined) {
        let val = convertPrecipitation(precFloat, precipitationType)
        if (digits === undefined) {
            digits = 1
            if (precipitationType === UnitUtils.PrecipitationType.MIL) {
                if (val >= 1.0) {
                    digits = 0
                }
            } else if (precipitationType === UnitUtils.PrecipitationType.CM) {
                digits = 2
            } else if (precipitationType === UnitUtils.PrecipitationType.INCH) {
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
        if (precipitationType === UnitUtils.PrecipitationType.CM) {
            return UnitUtils.PrecipitationType.MM
        } else if (precipitationType === UnitUtils.PrecipitationType.INCH) {
            return UnitUtils.PrecipitationType.MIL
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

    function convertValue(value, varName, unitType) {
        unitType = unitType > -1 ? unitType : -1

        if (isTemperatureVarName(varName)) {
            return convertTemperature(value, unitType)
        } else if (varName === "precipitationProb") {
            return convertPop(value)
        } else if (varName === "windSpeed" || varName === "windGust") {
            return convertWindspeed(value, unitType)
        } else if (varName === "pressure") {
            return convertPressure(value, unitType)
        } else if (varName === "humidity") {
            return convertPercentage(value)
        } else if (varName === "cloudArea") {
            return convertPercentage(value)
        }
        return value
    }

    function formatUnits(varName, unitType) {
        if (isTemperatureVarName(varName)) {
            return getTemperatureUnit(unitType)
        } else if (varName === "precipitationProb") {
            return getPercentageUnit()
        } else if (varName === "precipitationAmount") {
            return getPrecipitationUnit("mm")
        } else if (varName === "windSpeed" || varName === "windGust") {
            return getWindSpeedUnit(unitType)
        } else if (varName === "windDirection") {
            return getWindDirectionUnit()
        } else if (varName === "pressure") {
            return getPressureUnit(unitType)
        } else if (varName === "humidity") {
            return getPercentageUnit()
        } else if (varName === "cloudArea") {
            return getPercentageUnit()
        }
        return ""
    }

    function formatValue(value, varName, unitType, partOfDay, digits = undefined) {
        unitType = unitType > -1 ? unitType : -1
        partOfDay = (partOfDay !== undefined) ? partOfDay : 0

        if (isTemperatureVarName(varName)) {
            return getTemperatureText(value, unitType, digits)
        } else if (varName === "precipitationProb") {
            return getPopText(value, digits)
        } else if (varName === "precipitationAmount") {
            return getPrecipitationText(value, unitType, digits)
        } else if (varName === "windSpeed" || varName === "windGust") {
            return getWindSpeedText(value, unitType, digits)
        } else if (varName === "windDirection") {
            return getWindDirectionText(value, unitType, digits)
        } else if (varName === "pressure") {
            return getPressureText(value, unitType, digits)
        } else if (varName === "humidity") {
            return getPercentageText(value, digits)
        } else if (varName === "cloudArea") {
            return getPercentageText(value, digits)
        }
        return value
    }

    function getUnitType(varName) {
        if (isTemperatureVarName(varName)) {
            return plasmoid.configuration.temperatureType
        } else if (varName === "pressure") {
            return plasmoid.configuration.pressureType
        } else if (varName === "windSpeed" || varName === "windGust") {
            return plasmoid.configuration.windSpeedType
        } else if (varName === "windDirection") {
            return plasmoid.configuration.windDirectionType
        } else if (varName === "precipitationAmount") {
            return plasmoid.configuration.precipitationType
        }
        return undefined
    }
}
