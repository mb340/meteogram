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
import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import "../code/icons.js" as IconTools

RowLayout {
    id: root

    property double temperature
    property double temperature_min: NaN
    property double temperature_max: NaN
    property string iconName
    property bool hidden
    property bool past
    property int partOfDay
    property double pixelFontSize

    property bool hasMinMax: isFinite(temperature_min) && isFinite(temperature_max)

    property int iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                               plasmoid.configuration.iconSetType : 0

    opacity: past ? 0.5 : 1

    Item {
        /*spacer*/
        Layout.fillWidth: true
        height: parent.height
    }

    Label {
        id: temperatureText

        font.pixelSize: pixelFontSize
        font.pointSize: -1

        height: parent.height
        Layout.alignment: Qt.AlignRight
        Layout.fillWidth: false

        text: hidden ? '' : unitUtils.getTemperatureText(temperature, temperatureType, 0)
    }

    Item {
        id: iconParent
        width: height
        height: parent.height

        WeatherIcon {
            anchors.centerIn: parent

            iconSetType: root.iconSetType

            iconModel: ({
                iconX: 0,
                iconY: 0,
                iconName: root.iconName,
                partOfDay: root.partOfDay,
                iconDim: Math.min(iconParent.width, iconParent.height),
            })

            centerInParent: true
        }
    }
}
