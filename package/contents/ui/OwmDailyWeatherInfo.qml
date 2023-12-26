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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import QtGraphicalEffects 1.0
import Qt5Compat.GraphicalEffects
import org.kde.plasma.core as PlasmaCore
import "../code/icons.js" as IconTools
import org.kde.kirigami as Kirigami


ColumnLayout {
    id: root
    clip: true

    property var model: null

    Label {
        id: dateLabel
        text: !model ? "" : model.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
        font.pointSize: Kirigami.Units.iconSizes.small + (Kirigami.Units.iconSizes.smallMedium - Kirigami.Units.iconSizes.small) / 2

        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignVTop | Qt.AlignHLeft

        Layout.bottomMargin: Kirigami.Units.smallSpacing
    }

    RowLayout {

        Layout.preferredWidth: Layout.preferredHeight
        Layout.preferredHeight: Kirigami.Units.iconSizes.medium

        Layout.fillWidth: true
        Layout.fillHeight: false

        Layout.alignment: Qt.AlignVTop | Qt.AlignHLeft

        Layout.leftMargin: 2 * Kirigami.Units.smallSpacing

        Item {
            Layout.preferredWidth: parent.height
            Layout.fillHeight: true

            WeatherIcon {
                iconDim: Kirigami.Units.iconSizes.large
                width: iconDim
                height: iconDim

                anchors.centerIn: parent

                iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                               plasmoid.configuration.iconSetType : 0
                iconName: model ? model.iconName : null
            }
        }

        Label {
            text: model ? currentProvider.getIconDescription(model.iconName) : ""
            font.pixelSize: Kirigami.Units.iconSizes.small
            Layout.leftMargin: Kirigami.Units.smallSpacing
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Kirigami.Units.smallSpacing
    }

    GridLayout {
        id: temperatureRoot
        Layout.fillWidth: true

        columns: 8
        rows: 4

        property double iconWidth: 0.5 * (root.width / temperatureRoot.columns)
        property double titleWidth: 1 * (root.width / temperatureRoot.columns)
        property double itemWidth: ((root.width - titleWidth - iconWidth) / (temperatureRoot.columns - 2))

        Item {
            Layout.row: 0
            Layout.column: 0
            Layout.rowSpan: 4
            Layout.preferredWidth: width
            width: temperatureRoot.iconWidth

            Label {
                id: temperatureIcon
                text: "\uf055"
                font.family: 'weathericons'
                font.pixelSize: Kirigami.Units.iconSizes.medium
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        /* column headings */
        Repeater {
            model: [
                i18n("Low"),
                i18n("High"),
                i18n("Night"),
                i18n("Morning"),
                i18n("Day"),
                i18n("Evening")
            ]

            delegate: Item {
                width: temperatureRoot.itemWidth
                height: childrenRect.height
                Layout.row: 0
                Layout.column: index + 2
                Layout.preferredWidth: width
                Label {
                    text: modelData
                    color: Kirigami.Theme.disabledTextColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        /* row headings */
        Label {
            text: "Temperature"
            color: Kirigami.Theme.disabledTextColor
            Layout.row: 1
            Layout.rowSpan: 2
            Layout.column: 1
            Layout.alignment: Qt.AlignVTop | Qt.AlignHLeft
        }

        Label {
            text: "Feels Like"
            color: Kirigami.Theme.disabledTextColor
            Layout.row: 3
            Layout.rowSpan: 2
            Layout.column: 1
            Layout.alignment: Qt.AlignVTop | Qt.AlignHLeft
        }

        /* table cells */
        Repeater {
            model: [
                { varName: "temperatureMin", row: 1, col: 2},
                { varName: "temperatureMax", row: 1, col: 3},
                { varName: "temperatureNight", row: 1, col: 4},
                { varName: "temperatureMorn", row: 1, col: 5},
                { varName: "temperatureDay", row: 1, col: 6},
                { varName: "temperatureEve", row: 1, col: 7},

                { varName: "feelsLikeNight", row: 3, col: 4},
                { varName: "feelsLikeMorn", row: 3, col: 5},
                { varName: "feelsLikeDay", row: 3, col: 6},
                { varName: "feelsLikeEve", row: 3, col: 7},
            ]

            delegate: temperatureComponent
        }

        Component {
            id: temperatureComponent
            Item {
                width: temperatureRoot.itemWidth
                height: childrenRect.height
                Layout.row: modelData.row
                Layout.column: modelData.col
                Layout.preferredWidth: width

                Label {
                    text: !root.model ? "" :
                            unitUtils.getTemperatureText(
                                root.model[modelData.varName],
                                temperatureType, 2)
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Kirigami.Units.smallSpacing
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false

        Repeater {
            model: [
                { tileSymbol: "\uf084", tileTitle: i18n("Precipitation"),
                    varNames: ["precipitationProb", "precipitationAmount"],
                },
                { tileSymbol: "\uf07a", tileTitle: i18n("Relative Humidity"), varName: "humidity" },
                { tileSymbol: "\uf079", tileTitle: i18n("Pressure"), varName: "pressure" },
                { tileSymbol: "\uf041", tileTitle: i18n("Cloud Cover"), varName: "cloudArea" },
                { tileSymbol: "\uf0b1", tileTitle: i18n("Wind"), varName: "windDirection",
                    varNames: ["windDirection", "windSpeed", "windGust"],
                    varTitles: { windGust: i18n("Gust") }
                },
            ]

            delegate: Loader {
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: 2 * Kirigami.Units.iconSizes.huge

                sourceComponent: tileComponent

                property string tileSymbol: !root.model ? "" : formatSymbol(root.model[modelData.varName], modelData.varName)
                property string tileTitle: modelData.tileTitle
                property string tileValue: !root.model || !modelData.varName || modelData.varNames ? "" :
                                                unitUtils.formatValue(root.model[modelData.varName],
                                                                      modelData.varName,
                                                                      unitUtils.getUnitType(modelData.varName))
                property var tileValuesArr: !root.model || !modelData.varNames ? null :
                                                formatValues(root.model, modelData.varNames, modelData.varTitles)

                function formatSymbol(value, varName) {
                    if (varName === "windDirection") {
                        return IconTools.getWindDirectionIconCode(root.model["windDirection"])
                    }
                    return modelData.tileSymbol
                }

                function formatValues(model, varNames, varTitles) {
                    let valueStrings = []
                    for (var i = 0; i < varNames.length; i++) {
                        let varName = varNames[i]
                        let unitType = unitUtils.getUnitType(varName)
                        let varTitle = varTitles && varTitles[varName] ? varTitles[varName] : null
                        let text = unitUtils.formatValue(model[varName], varName, unitType)
                        valueStrings.push({ valueStr: text, titleStr: varTitle })
                    }
                    return valueStrings
                }
            }
        }
    }

    Component {
        id: tileComponent

        ColumnLayout {
            spacing: 0

            Item {
                Layout.fillWidth: true
                height: Kirigami.Units.iconSizes.medium
                Label {
                    text: tileSymbol
                    font.family: 'weathericons'
                    font.pixelSize: Kirigami.Units.iconSizes.medium
                    anchors.centerIn: parent
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height

                Label {
                    text: tileTitle
                    color: Kirigami.Theme.disabledTextColor
                    anchors.centerIn: parent
                }
            }

            Repeater {
                model: tileValuesArr ? tileValuesArr : [tileValue]

                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: childrenRect.height

                    Column {
                        height: childrenRect.height
                        width: parent.width

                        Label {
                            text: modelData.titleStr ? modelData.titleStr : ""
                            font.italic: true
                            color: Kirigami.Theme.disabledTextColor
                            anchors.topMargin: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: !!modelData.titleStr
                        }
                        Label {
                            text: modelData.valueStr ? modelData.valueStr :
                                    (modelData ? modelData : "")
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
    }
}