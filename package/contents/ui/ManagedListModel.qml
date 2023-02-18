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

Item {
    id: root

    property int index: 0

    property alias count: root.index
    property alias model: listModel

    ListModel {
        id: listModel
    }

    function beginList() {
        index = 0
    }

    function addItem(data) {
        if (index >= listModel.count) {
            listModel.append(data)
        } else {
            listModel.set(index, data)
        }
        index++
    }

    function endList() {
        let count = listModel.count - index
        if (count > 0) {
            listModel.remove(index, count)
        }
    }

    function get(index) {
        return listModel.get(index)
    }

    function setProperty(index, property, value) {
        return listModel.setProperty(index, property, value)
    }
}
