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
import "../code/icons.js" as IconTools
import "../code/unit-utils.js" as UnitUtils

RowLayout {
    property string temperature
    property string temperature_min
    property string temperature_max
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
            temperatureIcon.font.pixelSize = pixelFontSize
        }
    }
    
    opacity: past ? 0.5 : 1

    Item {
        /*spacer*/
        Layout.fillWidth: true
        height: parent.height
        visible: hasMinMax
    }


    PlasmaComponents.Label {
        id: temperatureText

        font.pointSize: -1

        height: parent.height
        Layout.alignment: Qt.AlignRight
        Layout.fillWidth: true

        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        text: hidden ? '' : UnitUtils.getTemperatureNumberExt(temperature, temperatureType)

        visible: !hasMinMax
    }

    PlasmaComponents.Label {
        // id: temperatureText

        font.pointSize: -1

        height: parent.height
        Layout.alignment: Qt.AlignRight
        Layout.fillWidth: true

        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        text: hidden ? '' : UnitUtils.getTemperatureNumberExt(temperature_max, temperatureType)

        visible: hasMinMax
    }

    PlasmaComponents.Label {
        text: "/"
        visible: !hidden && hasMinMax
    }

    PlasmaComponents.Label {
        // id: temperatureText
        
        font.pointSize: -1

        height: parent.height
        Layout.alignment: Qt.AlignRight
        Layout.fillWidth: true

        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        text: hidden ? '' : UnitUtils.getTemperatureNumberExt(temperature_min, temperatureType)

        visible: hasMinMax
    }
    
    Item {
        width: parent.width / 3
        height: parent.height

        PlasmaComponents.Label {
            id: temperatureIcon
            
            font.pointSize: -1
            
            anchors.centerIn: parent
            
            font.family: 'weathericons'
            text: hidden ? '' : IconTools.getIconCode(iconName, currentProvider.providerId, partOfDay)
            visible: iconSetType === 0
        }

        Image {
            id: weatherIcon
            visible: (iconSetType === 1 || iconSetType === 2)

            property var imgSrc: (iconSetType === 1 ?
                                    IconTools.getMetNoIconImage(iconName, currentProvider.providerId, partOfDay) :
                                    (iconSetType === 2 ?
                                        IconTools.getBasmiliusIconImage(iconName, currentProvider.providerId, partOfDay) :
                                        null))


            source: imgSrc ? imgSrc : "images/placeholder.svg"
            property double dim: iconSetType === 1 ? (Math.min(parent.width, parent.height) * 1.00) :
                                    (iconSetType === 2 ? (Math.min(parent.width, parent.height) * 1.25) : 1.00)


            width: dim
            height: dim

            anchors.centerIn: parent
        }


        DropShadow {
            anchors.fill: weatherIcon
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: weatherIcon
            visible: weatherIcon.visible
        }
    }
    
}