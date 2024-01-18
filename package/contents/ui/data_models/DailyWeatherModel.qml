/*
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

ManagedListModel {
    id: root

    function hasVariable(varName) {
        if (root.count <= 0) {
            return false
        }
        for (var i = 0; i < root.count; i++) {
            let item = root.get(i)
            let models = item.models
            if (models === undefined) {
                continue
            }
            for (var j = 0; j < models.count; j++) {
                let val = models.get(j)[varName]
                // if (typeof(val) === 'number' && (-Infinity < val && val < +Infinity)) {
                if (isFinite(val)) {
                    return true
                }
            }
        }
        return false
    }

    function createInstantItem(item) {
        let i = undefined
        if (item !== undefined) {
            i = item
        } else {
            i = {}
        }

        i.date = new Date(0)

        // 0: Day
        // 1: Night
        i.partOfDay = 0

        i.iconName = ""

        // Celsius
        i.temperature = NaN
        i.temperatureHigh = NaN
        i.temperatureLow = NaN
        i.feelsLike = NaN

        // Millimeters
        i.precipitationAmount = NaN

        // Degrees
        i.windDirection = NaN

        // meters per second
        i.windSpeed = NaN

        // hPa
        i.pressure = NaN

        // [0 - 100]%
        i.humidity = NaN

        // [0 - 100]%
        i.cloudArea = NaN

        // [0 - 11+]
        i.uvi = NaN

        return i
    }

    function createItem(index) {
        let item = undefined
        if (index !== undefined && index < model.count) {
            item = get(index)
        } else {
            item = {
                models: []
            }
        }

        item.date = new Date(0)

        item.iconName = ""

        item.temperatureMin = NaN
        item.temperatureMax = NaN

        item.temperatureNight = NaN
        item.temperatureMorn = NaN
        item.temperatureDay = NaN
        item.temperatureEve = NaN

        item.feelsLikeNight = NaN
        item.feelsLikeMorn = NaN
        item.feelsLikeDay = NaN
        item.feelsLikeEve = NaN

        item.windDirection = NaN
        item.windSpeed = NaN
        item.windGust = NaN

        item.precipitationProb = NaN
        item.precipitationAmount = NaN

        item.pressure = NaN
        item.humidity = NaN
        item.cloudArea = NaN

        item.sunrise = NaN
        item.sunset = NaN
        item.moonrise = NaN
        item.moonset = NaN
        item.moonphase = NaN

        for (var i = 0; i < 4; i++) {
            if (i >= item.models.length) {
                item.models.push(createInstantItem())
            } else {
                createInstantItem(item.models.get(i))
            }
        }

        return item
    }
}
