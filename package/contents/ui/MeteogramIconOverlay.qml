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
import QtQuick.Controls 2.15
import "data_models"

Item {
    id: root

    property alias weatherIcons: weatherIcons

    property int iconSetType: -1
    property double iconDim: 0

    signal beginList()
    signal addItem(var data)
    signal endList()

    ManagedListModel {
        id: weatherIcons
    }

    Component.onCompleted: {
        root.beginList.connect(weatherIcons.beginList)
        root.addItem.connect(weatherIcons.addItem)
        root.endList.connect(weatherIcons.endList)
    }

    Repeater {
        model: fillModels ? weatherIcons.model : undefined

        delegate: WeatherIcon {
            iconSetType: root.iconSetType
            iconName: model.iconName
            partOfDay: model.partOfDay
            iconX: model.iconX
            iconY: model.iconY
            iconDim: root.iconDim
        }
    }
}
