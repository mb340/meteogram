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
import QtGraphicalEffects 1.12
import org.kde.plasma.core 2.0 as PlasmaCore

Item {

    property var weatherIcons: []

    Component {
        id: imageComponent
        Item {
            x: iconX
            y: iconY
            width: iconDim
            height: width

            Image {
                id: image
                source: iconSource
                smooth: true
                anchors.fill: parent
            }

            DropShadow {
                anchors.fill: image
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 17
                color: !textColorLight ? "#80000000" : "#80ffffff"
                source: image
            }
        }
    }

    Component {
        id: iconItemComponent

        Item {
            x: iconX
            y: iconY
            width: iconDim
            height: width

            PlasmaCore.IconItem {
                id: image
                source: iconSource
                anchors.fill: parent
            }

            DropShadow {
                anchors.fill: image
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 17
                color: !textColorLight ? "#80000000" : "#80ffffff"
                source: image
            }
        }
    }

    Repeater {
        model: weatherIcons

        delegate: Loader {
            property var iconSource: modelData.iconSource
            property var iconX: modelData.iconX
            property var iconY: modelData.iconY
            property var iconDim: modelData.iconDim

            asynchronous: true

            sourceComponent: {
                if (modelData.iconType === "Icon") {
                    return iconItemComponent
                } else if (modelData.iconType === "Image") {
                    return imageComponent
                }
            }
        }
    }
}
