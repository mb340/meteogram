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
import QtQuick 2.5
import QtQuick.Controls 2.5


Item {
    id: temperatureIcon

    width: sizerLabel.width
    height: sizerLabel.height

    property int sizeMode: CompactItem.SizeMode.Fill

    property double parentWidth
    property double parentHeight

    property double sizerWidth
    property double sizerHeight

    property bool isVerticalState: false

    property alias contentWidth: sizerLabel.contentWidth
    property alias contentHeight: sizerLabel.contentHeight

    // Rectangle {
    //     anchors.fill: temperatureIcon
    //     color: "green"
    //     z: -1
    //     visible: false
    // }

    Label {
        id: sizerLabel

        text: "\uf008"

        font.family: 'weathericons'
        font.pixelSize: 1024
        minimumPixelSize: 1

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: Qt.rgba(1, 0, 0, 1)

        visible: false

        FontMetrics {
            id: temperatureIconMetrics
            font: sizerLabel.font
        }
    }

    WeatherIcon {
        iconSetType: compactItem.iconSetType
        iconName: ""
        iconX: 0
        iconY: 0
        iconDim: Math.min(temperatureIcon.width,
                          temperatureIcon.height +
                            (isVerticalState ? temperatureIconMetrics.descent : 0))
        partOfDay: 0

        width: temperatureIcon.width
        height: temperatureIcon.height

        anchors.fill: parent
        anchors.bottomMargin: temperatureIcon.bottomPadding

        anchors.centerIn: parent

        Component.onCompleted: {
            updateModel()
            currentWeatherModel.onValidChanged.connect(updateModel)
        }

        function updateModel() {
            iconName = currentWeatherModel.iconName

            if (!timeUtils.hasSunriseSunsetData(currentWeatherModel)) {
                partOfDay = 0
                return
            }
            partOfDay = timeUtils.isSunRisen(currentWeatherModel.date,
                                             timeUtils.roundToHour(currentWeatherModel.sunRise),
                                             timeUtils.roundToHour(currentWeatherModel.sunSet)) ? 0 : 1
        }
    }

    CompactItemDebugRect {
    }

    states: [
        State {
            name: "horizontalOnHorizontalPanel"
            PropertyChanges {
                target: sizerLabel

                // width: temperatureIconMetrics.maximumCharacterWidth
                width: Math.min((temperatureIconMetrics.averageCharacterWidth * 1.25),
                                (sizeMode === CompactItem.SizeMode.Fill) ? 1024 : sizerWidth)

                height: parentHeight

                fontSizeMode: Text.VerticalFit
                font.pixelSize: parentHeight // - temperatureIconMetrics.descent
            }
        },
        State {
            name: "horizontalOnVerticalPanel"
            PropertyChanges {
                target: sizerLabel

                // width: temperatureIconMetrics.maximumCharacterWidth
                width: sizerWidth
                height: sizerHeight

                fontSizeMode: Text.HorizontalFit
                font.pixelSize: 1024
            }
        },
        State {
            name: "verticalOnVerticalPanel"
            PropertyChanges {
                target: sizerLabel

                // width: parentWidth
                width: Math.min((parentWidth),
                                (sizeMode === CompactItem.SizeMode.Fill) ? 1024 : sizerWidth)
                height: contentHeight

                fontSizeMode: Text.HorizontalFit
                font.pixelSize: 1024
            }
        },
        State {
            name: "verticalOnHorizontalPanel"
            PropertyChanges {
                target: sizerLabel

                width: sizerWidth /*heightSizer.width*/
                height: sizerHeight /*heightSizer.height*/

                fontSizeMode: Text.Fit
                font.pixelSize: sizerHeight /*heightSizer.height*/
            }
        },
        State {
            name: "compact"
            PropertyChanges {
                target: sizerLabel

                width: Math.min(temperatureIcon.parent.width, temperatureIcon.parent.height)
                height: Math.min(temperatureIcon.parent.width, temperatureIcon.parent.height)

                fontSizeMode: Text.Fit
                font.pixelSize: 1024
            }
        }

    ]
}
