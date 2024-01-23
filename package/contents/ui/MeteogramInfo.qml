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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import org.kde.kirigami as Kirigami
import "../code/icons.js" as IconTools
import "data_models"


Item {
    id: meteogramInfo
    visible: false

    property bool isAnchorTop: true
    property bool isAnchorLeft: true

    property double anchorsMargins: 0.0

    property double idx: -1
    property var hourModel: undefined

    readonly property double textPad: 32 * 1

    property alias boxWidth: hoverItem.width
    property alias boxHeight: hoverItem.height

    /*
     * Placeholder item positioned at the mouse cursor.
     * The actual info box is anchored to this item.
     */
    Item {
        id: hoverPoint
    }

    /*
     * Background
     */
    Rectangle {
        color: Qt.rgba(main.theme.meteogram.backgroundColor.r,
                       main.theme.meteogram.backgroundColor.g,
                       main.theme.meteogram.backgroundColor.b,
                       1.00)
        radius: 2
        border.color: main.theme.meteogram.textColor
        border.width: 1

        anchors.fill: hoverItem
        anchors.topMargin: -2
        anchors.bottomMargin: -2
        anchors.leftMargin: -5
        anchors.rightMargin: -5
    }

    ColumnLayout {
        id: hoverItem
        anchors.margins: anchorsMargins
        spacing: 0

        width: dateLabel.width + textPad

        Label {
            id: dateLabel
            text: ""
            color: main.theme.meteogram.textColor
            Layout.alignment: Qt.AlignHCenter
        }

        ManagedListModel {
            id: model

            defaultModel: ListModel {
                ListElement {
                    nameStr: ""
                    valueStr: ""
                    valueColor: ""
                }
            }
        }

        ListView {
            id: listView

            spacing: 0

            implicitHeight: contentItem.childrenRect.height
            implicitWidth: contentItem.childrenRect.width

            model: model.model

            interactive: false

            delegate: GridLayout {
                id: valueItem
                width: hoverItem.width

                Label {
                    id: nameLabel
                    text: nameStr
                    color: main.theme.meteogram.textColor
                    font.pixelSize: 11 * 1
                    font.pointSize: -1
                    verticalAlignment: Text.AlignTop

                    Layout.fillHeight: true
                }
                Label {
                    id: valueLabel
                    text: valueStr
                    color: valueColor && valueColor != "" ?
                            valueColor : main.theme.meteogram.textColor
                    font.pixelSize: 11 * 1
                    font.pointSize: -1
                    wrapMode: Text.WordWrap

                    Layout.alignment: Qt.AlignRight
                    Layout.maximumWidth: hoverItem.width - textMetrics.width
                }

                TextMetrics {
                    id: textMetrics
                    font.family: nameLabel.font.family
                    font.pixelSize: nameLabel.font.pixelSize
                    text: nameStr
                }
            }
        }


        states: [
            State {
                name: "anchorTopLeft"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: hoverPoint.top
                    anchors.bottom: undefined
                    anchors.left: hoverPoint.left
                    anchors.right: undefined
                }
            },
            State {
                name: "anchorBottomLeft"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: undefined
                    anchors.bottom: hoverPoint.bottom
                    anchors.left: hoverPoint.left
                    anchors.right: undefined
                }
            },
            State {
                name: "anchorTopRight"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: hoverPoint.top
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: hoverPoint.right
                }
            },
            State {
                name: "anchorBottomRight"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: undefined
                    anchors.bottom: hoverPoint.bottom
                    anchors.left: undefined
                    anchors.right: hoverPoint.right
                }
            }
        ]
    }

    onHourModelChanged: {
        if (!hourModel) {
            return
        }

        model.beginList()

        var dateFrom = hourModel.from
        var hourFrom = dateFrom.getHours()
        var dateStr = dateFrom.toLocaleDateString(Qt.locale(), 'ddd d MMM') +
                            " " + i18n("at") + " " +
                            timeUtils.getHourText(hourFrom) + " " +
                            (timeUtils.twelveHourClockEnabled ? timeUtils.getAmOrPm(hourFrom) : '00')
        dateLabel.text = dateStr

        var y2VarName = plasmoid.configuration.y2VarName
        var y2Color = colorPalette.pressureColor().toString()

        var iconNameStr = ""
        if (hourModel.iconName) {
            var sunRise = main.currentWeatherModel.sunRise
            var sunSet = main.currentWeatherModel.sunSet
            var iconNameStr = currentProvider.getIconDescription(hourModel.iconName)
            model.addItem({
                nameStr: i18n("Conditions") + ":",
                valueStr: iconNameStr,
                valueColor: ""
            })
        }

        model.addItem({
            nameStr: i18n("Temperature") + ":",
            valueStr: unitUtils.getTemperatureText(hourModel.temperature, temperatureType, 2),
            valueColor: (hourModel.temperature >= 0 ? colorPalette.temperatureWarmColor() :
                                                     colorPalette.temperatureColdColor()).toString()
        })

        if (isFinite(hourModel.feelsLike)) {
            model.addItem({
                nameStr: i18n("Feels Like") + ":",
                valueStr: unitUtils.getTemperatureText(hourModel.feelsLike, temperatureType, 2),
                valueColor: (hourModel.feelsLike >= 0 ? colorPalette.temperatureWarmColor() :
                                                         colorPalette.temperatureColdColor()).toString()
            })
        }

        if (isFinite(hourModel.dewPoint)) {
            model.addItem({
                nameStr: i18n("Dew Point") + ":",
                valueStr: unitUtils.getTemperatureText(hourModel.dewPoint, temperatureType, 2),
                valueColor: (hourModel.dewPoint >= 0 ? colorPalette.temperatureWarmColor() :
                                                         colorPalette.temperatureColdColor()).toString()
            })
        }

        model.addItem({
            nameStr: i18n("Pressure") + ":",
            valueStr: unitUtils.getPressureText(hourModel.pressure, pressureType),
            valueColor: y2VarName == "pressure" ? y2Color : ""
        })

        var windStr = unitUtils.getWindSpeedText(hourModel.windSpeed, windSpeedType)
        model.addItem({
            nameStr: i18n("Wind Speed") + ":",
            valueStr: windStr,
            valueColor: y2VarName == "windSpeed" ? y2Color : ""
        })

        if (isFinite(hourModel.windGust)) {
            var gustStr = unitUtils.getWindSpeedText(hourModel.windGust, windSpeedType)
            model.addItem({
                nameStr: i18n("Wind Gust") + ":",
                valueStr: gustStr,
                valueColor: y2VarName == "windGust" ? y2Color : ""
            })
        }

        var cloudAreaStr = ""
        if (isFinite(hourModel.cloudArea)) {
            cloudAreaStr = hourModel.cloudArea + " %"
            model.addItem({
                nameStr: i18n("Cloud Area") + ":",
                valueStr: cloudAreaStr,
                valueColor: ""
            })
        }

        var humidityStr = ""
        if (isFinite(hourModel.humidity)) {
            humidityStr = hourModel.humidity + " %"
            model.addItem({
                nameStr: i18n("Relative Humidity") + ":",
                valueStr: humidityStr,
                valueColor: colorPalette.humidityColor().toString()
            })
        }

        var precipitationStr = ""
        if (isFinite(hourModel.precipitationAmount) && hourModel.precipitationAmount > 0) {
            precipitationStr = unitUtils.getPrecipitationText(hourModel.precipitationAmount,
                                                              precipitationType)
            model.addItem({
                nameStr: i18n("Precipitation") + ":",
                valueStr: precipitationStr,
                valueColor: colorPalette.rainColor().toString()
            })
        }

        if (isFinite(hourModel.precipitationProb) && hourModel.precipitationProb > 0) {
            model.addItem({
                nameStr: i18n("PoP") + ":",
                valueStr: unitUtils.getPopText(hourModel.precipitationProb),
                valueColor: y2VarName == "precipitationProb" ? y2Color :
                                colorPalette.rainColor().toString()
            })
        }

       if (isFinite(hourModel.uvi) && hourModel.uvi > 0) {
            model.addItem({
                nameStr: i18n("UV Index") + ":",
                valueStr: hourModel.uvi.toFixed(2),
                valueColor: y2VarName == "uvi" ? y2Color : ""
            })
        }

        model.endList()
    }


    Component.onCompleted: updateState()
    onIsAnchorTopChanged: updateState()
    onIsAnchorLeftChanged: updateState()

    function updateState() {
        if (isAnchorTop && isAnchorLeft) {
            hoverItem.state = "anchorTopLeft"
        } else if (isAnchorTop && !isAnchorLeft) {
            hoverItem.state = "anchorTopRight"
        } else if (!isAnchorTop && isAnchorLeft) {
            hoverItem.state = "anchorBottomLeft"
        } else {
            hoverItem.state = "anchorBottomRight"
        }
    }
}
