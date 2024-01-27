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

import "../code/icons.js" as IconTools


RowLayout {
    id: root

    required property int index

    required property var date
    required property double temperature
    required property double temperatureLow
    required property double temperatureHigh
    required property string iconName

    required property var now
    property bool past: date < now

    property int partOfDay: (index == 0 || index == 3) ? 1 : 0

    property bool hasMinMax: isFinite(temperatureLow) && isFinite(temperatureHigh)

    property bool hidden: !isFinite(temperature)

    property double pixelFontSize
    property int iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                               plasmoid.configuration.iconSetType : 0

    opacity: past ? 0.25 : 1
    // enabled: !past

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
            iconName: root.iconName
            partOfDay: root.partOfDay
            iconDim: Math.min(iconParent.width, iconParent.height)

            centerInParent: true
        }
    }
}
