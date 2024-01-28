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

    property double hourInterval: 1.0

    function createItem(index) {
        let item = undefined
        if (index !== undefined && index < model.count) {
            item = get(index)
        } else {
            item = {}
        }

        // Date
        item.from = new Date(0)

        // Celsius
        item.temperature = NaN

        // Celsius
        item.feelsLike = NaN

        // Celsius
        item.dewPoint = NaN

        // [0 - 1]
        item.precipitationProb = NaN

        // Millimeters
        item.precipitationAmount = NaN

        // Degrees
        item.windDirection = NaN

        // meters per second
        item.windSpeed = NaN

        // meters per second
        item.windGust = NaN

        // hPa
        item.pressure = NaN

        // String
        item.iconName = ""

        // [0 - 100]%
        item.humidity = NaN

        // [0 - 100]%
        item.cloudArea = NaN

        // [0 - 11+]
        item.uvi = NaN

        return item
    }

    function hasVariable(varName) {
        if (root.count <= 0) {
            return false
        }
        for (var i = 0; i < root.count; i++) {
            let val = root.get(i)[varName]
            // if (typeof(val) === 'number' && (-Infinity < val && val < +Infinity)) {
            if (isFinite(val)) {
                return true
            }
            break
        }
        return false
    }
}
