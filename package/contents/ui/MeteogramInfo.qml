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
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import "../code/unit-utils.js" as UnitUtils


Item {
    id: meteogramInfo
    visible: false

    property bool isAnchorTop: true
    property bool isAnchorLeft: true

    property double anchorsMargins: 0.0

    property double idx: -1
    property var hourModel: undefined

    readonly property double textPad: 16 * units.devicePixelRatio

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
        color: Qt.rgba(theme.backgroundColor.r,
                       theme.backgroundColor.g,
                       theme.backgroundColor.b,
                       1.00)
        radius: 2
        border.color: theme.textColor
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

        PlasmaComponents.Label {
            id: dateLabel
            text: ""
            Layout.alignment: Qt.AlignHCenter
        }

        ListModel {
            id: model
        }

        ListView {
            id: listView

            spacing: 0

            implicitWidth: dateLabel.width
            implicitHeight: contentItem.childrenRect.height

            model: model

            interactive: false

            delegate: Item {
                height: valueItem.implicitHeight
                width: dateLabel.width + textPad

                GridLayout {
                    id: valueItem
                    width: parent.width

                    PlasmaComponents.Label {
                        id: nameLabel
                        text: nameStr
                        font.pixelSize: 11 * units.devicePixelRatio
                        font.pointSize: -1
                    }
                    PlasmaComponents.Label {
                        id: valueLabel
                        text: valueStr
                        color: valueColor ? valueColor : theme.textColor
                        font.pixelSize: 11 * units.devicePixelRatio
                        font.pointSize: -1
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
        }


        states: [
            State {
                name: "anchorTopLeft"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: undefined
                    anchors.bottom: hoverPoint.bottom
                    anchors.left: hoverPoint.left
                    anchors.right: undefined
                }
            },
            State {
                name: "anchorBottomLeft"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: hoverPoint.top
                    anchors.bottom: undefined
                    anchors.left: hoverPoint.left
                    anchors.right: undefined
                }
            },
            State {
                name: "anchorTopRight"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: undefined
                    anchors.bottom: hoverPoint.bottom
                    anchors.left: undefined
                    anchors.right: hoverPoint.right
                }
            },
            State {
                name: "anchorBottomRight"
                AnchorChanges {
                    target: hoverItem
                    anchors.top: hoverPoint.top
                    anchors.bottom: undefined
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

        model.clear()

        var dateFrom = hourModel.dateFrom
        var hourFrom = dateFrom.getHours()
        var dateStr = dateFrom.toLocaleDateString(Qt.locale(), 'ddd d MMM') +
                            " " + i18n("at") + " " +
                            UnitUtils.getHourText(hourFrom, twelveHourClockEnabled) + " " +
                            (twelveHourClockEnabled ? UnitUtils.getAmOrPm(hourFrom) : '00')
        dateLabel.text = dateStr

        model.append({
            nameStr: i18n("Temperature:"),
            valueStr: hourModel.temperature.toFixed(2) +
                        UnitUtils.getTemperatureEnding(temperatureType),
            valueColor: (hourModel.temperature >= 0 ? temperatureWarmColor :
                                                      temperatureColdColor).toString()
        })


        var pressureStr = UnitUtils.convertPressure(hourModel.pressureHpa, pressureType).toFixed(2)
        model.append({
            nameStr: i18n("Pressure:"),
            valueStr: pressureStr + " " + UnitUtils.getPressureEnding(pressureType),
            valueColor: pressureColor.toString()
        })

        var windStr = UnitUtils.getWindSpeedText(hourModel.windSpeedMps, windSpeedType)
        model.append({
            nameStr: i18n("Wind speed:"),
            valueStr: windStr
        })

        var cloudAreaStr = ""
        if (isFinite(hourModel.cloudArea)) {
            cloudAreaStr = hourModel.cloudArea + " %"
            model.append({
                nameStr: i18n("Cloud area:"),
                valueStr: cloudAreaStr,
            })
        }

        var humidityStr = ""
        if (isFinite(hourModel.humidity)) {
            humidityStr = hourModel.humidity + " %"
            model.append({
                nameStr: i18n("Relative humidity:"),
                valueStr: humidityStr,
                valueColor: humidityColor.toString()
            })
        }

        var precipitationStr = ""
        if (hourModel.precipitationAvg >= precipitationMinVisible) {
            precipitationStr = UnitUtils.precipitationFormat(hourModel.precipitationAvg,
                                                             hourModel.precipitationLabel) +
                               " " + hourModel.precipitationLabel
            model.append({
                nameStr: i18n("Precipitation:"),
                valueStr: precipitationStr,
                valueColor: rainColor.toString()
            })
        }
    }


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
