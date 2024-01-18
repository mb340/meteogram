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
        item.from = new Date(0)
        item.temperature = NaN
        item.feelsLike = NaN
        item.dewPoint = NaN
        item.precipitationProb = NaN
        item.precipitationAmount = NaN
        item.windDirection = NaN
        item.windSpeed = NaN
        item.windGust = NaN
        item.pressure = NaN
        item.iconName = ""
        item.humidity = NaN
        item.cloudArea = NaN
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
