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
    property alias model: root._model

    property var defaultModel: null
    property var _model: defaultModel ? defaultModel : listModel

    signal onDataChanged(variant topLeft, variant bottomRight)

    ListModel {
        id: listModel
    }

    Component.onCompleted: {
        listModel.onDataChanged.connect(onDataChanged)
    }

    function beginList() {
        index = 0
    }

    function addItem(data) {
        if (index >= _model.count) {
            _model.append(data)
        } else {
            _model.set(index, data)
        }
        index++
    }

    function endList() {
        let count = _model.count - index
        if (count > 0) {
            _model.remove(index, count)
        }
    }

    function clear() {
        index = 0
        return _model.clear()
    }

    function get(index) {
        return _model.get(index)
    }

    function set(index, dict) {
        _model.set(index, dict)
    }

    function setProperty(index, property, value) {
        return _model.setProperty(index, property, value)
    }
}
