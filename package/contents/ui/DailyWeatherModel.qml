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

    function createInstantItem() {
        return {

            date: new Date(0),

            // 0: Day
            // 1: Night
            partOfDay: 0,
            iconName: "",

            // Celsius
            temperature: NaN,
            temperatureHigh: NaN,
            temperatureLow: NaN,
            feelsLike: NaN,

            // Millimeters
            precipitationAmount: NaN,

            // Degrees
            windDirection: NaN,

            // meters per second
            windSpeed: NaN,

            // hPa
            pressure: NaN,

            // [0 - 100]%
            humidity: NaN,

            // [0 - 100]%
            cloudArea: NaN,

            // [0 - 11+]
            uvi: NaN
        }
    }

    function createItem() {
        return {
            foobar: "foobar",
            date: new Date(0),

            iconName: "",

            temperatureMin: NaN,
            temperatureMax: NaN,

            temperatureNight: NaN,
            temperatureMorn: NaN,
            temperatureDay: NaN,
            temperatureEve: NaN,

            feelsLikeNight: NaN,
            feelsLikeMorn: NaN,
            feelsLikeDay: NaN,
            feelsLikeEve: NaN,

            windDirection: NaN,
            windSpeed: NaN,
            windGust: NaN,

            precipitationProb: NaN,
            precipitationAmount: NaN,

            pressure: NaN,
            humidity: NaN,
            cloudArea: NaN,

            sunrise: NaN,
            sunset: NaN,
            moonrise: NaN,
            moonset: NaN,
            moonphase: NaN,
            models: [
                createInstantItem(),
                createInstantItem(),
                createInstantItem(),
                createInstantItem()
            ]
        }
    }
}
