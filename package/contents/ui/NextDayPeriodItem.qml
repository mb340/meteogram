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
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

import "../code/icons.js" as IconTools
import "../code/unit-utils.js" as UnitUtils

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
    
    onPixelFontSizeChanged: {
        if (pixelFontSize > 0) {
            temperatureText.font.pixelSize = pixelFontSize
        }
    }
    
    opacity: past ? 0.5 : 1

    Item {
        /*spacer*/
        Layout.fillWidth: true
        height: parent.height
    }

    PlasmaComponents.Label {
        id: temperatureText

        font.pointSize: -1

        height: parent.height
        Layout.alignment: Qt.AlignRight
        Layout.fillWidth: true

        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        text: hidden ? '' :
              (!hasMinMax ? UnitUtils.getTemperatureNumberExt(temperature, temperatureType) :
                            UnitUtils.getTemperatureNumberExt(temperature_max, temperatureType) + " / " +
                            UnitUtils.getTemperatureNumberExt(temperature_min, temperatureType))
    }

    Item {
        id: iconParent
        width: parent.width / 3
        height: parent.height

        WeatherIcon {
            anchors.centerIn: parent

            iconSetType: root.iconSetType
            iconName: root.iconName
            partOfDay: root.partOfDay
            iconDim: getDim()

            centerInParent: true

            function getDim() {
                if (iconSetType === 1) {
                    return Math.min(iconParent.width, iconParent.height) * 1.00
                } else if (iconSetType === 2) {
                    return Math.min(iconParent.width, iconParent.height) * 1.25
                } else if (iconSetType === 3) {
                    return 1.1 * Math.min(iconParent.width, iconParent.height)
                }
                return iconParent.width
            }
        }
    }
}
