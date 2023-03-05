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

    function createItem() {
        return {
            from: null,
            temperature: NaN,
            feelsLike: NaN,
            dewPoint: NaN,
            precipitationProb: NaN,
            precipitationAmount: NaN,
            windDirection: NaN,
            windSpeed: NaN,
            windGust: NaN,
            pressure: NaN,
            iconName: "",
            humidity: NaN,
            cloudArea: NaN,
            uvi: NaN
        }
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
