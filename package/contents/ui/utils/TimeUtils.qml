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
import QtQml
import "../../code/db/timezoneData.js" as TZ


QtObject {

    enum TimezoneType {
        USER_LOCAL_TIME = 0,
        UTC = 1,
        LOCATION_LOCAL_TIME = 2
    }

    property bool twelveHourClockEnabled: Qt.locale().timeFormat(Locale.ShortFormat)
                                                     .toString()
                                                     .indexOf('AP') > -1

    function convertDateToUTC(date) {
        return date.setTime(date.getTime() + (date.getTimezoneOffset() * 60 * 1000))
    }

    function dateNow(timezoneType, offset) {
        var now = convertDate(new Date(), timezoneType, offset)
        return now
    }

    function isDST(DSTPeriods) {
        if(DSTPeriods === undefined) {
            return false
        }
        let now = dateNow(main.timezoneType, main.timezoneOffset).getTime() / 1000
        for (let f = 0; f < DSTPeriods.length; f++) {
            if ((now >= DSTPeriods[f].DSTStart) && (now <= DSTPeriods[f].DSTEnd)) {
               return true
            }
        }
        return false
    }

    function getTimeZoneOffset(timezoneId) {
        if (timezoneId === undefined) {
            print("error: timezoneId undefined")
            console.trace()
        }
        let tz = getTimezoneData(timezoneId)
        if (tz === undefined) {
            return 0
        }
        let offset = isDST(tz.DSTData, timezoneId) ? tz.DSTOffset : tz.Offset
        return parseInt(offset) * 1000
    }

    /*
     * Format offset in minutes to +/- hours
     * e.g Eastern Standard Time: +05
     */
    function formatTimeZoneOffsetString(offset) {
        let sign = offset < 0 ? "+" : "-"
        offset = offset / 60
        offset = String(Math.abs(offset)).padStart(2, "0")
        return sign + offset
    }

    function getTimezoneData(timezoneId) {
        let tzData = TZ.TZData.find((el) => { return el.id === timezoneId })
        return tzData
    }

    /*
     * Convert from system time to UTC or location-local time.
     */
    function convertDate(date, timezoneType, timezoneOffset) {
        if (typeof(date) === "string") {
            date = new Date(Date.parse(date))
        } else if (typeof(date) === "number") {
            if (!isFinite(date)) {
                return date
            }
            date = new Date(date)
        }
        if (timezoneType === undefined) {
            print("error: timezoneType undefined")
            console.trace()
        }
        if (timezoneOffset === undefined) {
            print("error: timezoneOffset undefined")
            console.trace()
        }

        if (timezoneType === TimeUtils.TimezoneType.UTC) {
            convertDateToUTC(date)
        } else if (timezoneType === TimeUtils.TimezoneType.LOCATION_LOCAL_TIME) {
            convertDateToUTC(date)
            date.setTime(date.getTime() + timezoneOffset)
        }
        return date
    }

    /*
     * Round date to the previous half hour
     */
    function floorDate(date) {
        date.setMinutes(0, 0, 0)
        return date
    }

    function hasSunriseSunsetData(currentWeatherModel) {
        return currentWeatherModel && Number(currentWeatherModel.sunRise) !== 0 &&
                Number(currentWeatherModel.sunSet) !== 0
    }

    function isSunRisen(t, sunRise, sunSet) {
        if (!t) {
            return true
        }

        var hourFrom = t.getHours()
        if (!sunRise || !sunSet) {
            return 6 <= hourFrom && hourFrom <= 18
        }

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

    function getHourText(hourNumber) {
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

    function formatTimeIntervalString(time) {
        if (time < 60 * 1000) {
            return i18n("%1 s", Math.round(time / 1000))
        }

        var mins = time / 60000
        if (mins <= 180) {
            return i18n("%1 m", Math.round(mins))
        }

        var hours = mins / 60
        if (hours <= 48) {
            return i18n("%1 h", Math.round(hours))
        }

        var days = hours / 24
        if (days <= 14) {
            return i18n("%1 d", Math.round(days))
        }

        return i18n("a long time")
    }

    function setDailyPeriodHour(dailyPeriodIdx, date) {
        if (dailyPeriodIdx === 0) {
            date.setHours(6, 0, 0, 0)
        } else if (dailyPeriodIdx === 1) {
            date.setHours(12, 0, 0, 0)
        } else if (dailyPeriodIdx === 2) {
            date.setHours(18, 0, 0, 0)
        } else {
            date.setDate(date.getDate() + 1)
            date.setHours(0, 0, 0, 0)
        }
        return date
    }
}

