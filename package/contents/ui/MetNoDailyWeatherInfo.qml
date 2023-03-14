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
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
// import org.kde.plasma.components 2.0 as PlasmaComponents
import "../code/unit-utils.js" as UnitUtils
import "../code/icons.js" as IconTools

Item {

    property int nColumns: 5
    property color lineColor: theme.textColor

    property var model: null
    property var dayParts: model ? model.models : null

    property var dayPartHeaders: [
        i18n("Night"),
        i18n("Morning"),
        i18n("Day"),
        i18n("Evening"),
    ]

    property var dayPartVars: [
        "iconName",
        "iconName",
        "temperature",
        "temperatureHigh",
        "temperatureLow",
        // "feelsLike",
        "precipitationAmount",
        "windSpeed",
        "pressure",
        "humidity",
        "cloudArea",
        // "uvi"
    ]

    property var dayPartTitles: [
        "",
        i18n("Conditions"),
        i18n("Temperature"),
        i18n("High"),
        i18n("Low"),
        // i18n("Feels Like"),
        i18n("Precipitation"),
        i18n("Wind"),
        i18n("Pressure"),
        i18n("Relative Humidity"),
        i18n("Cloud Cover"),
        // i18n("UV Index"),
    ]

    ColumnLayout {
        anchors.fill: parent

        Label {
            id: dateLabel
            text: !model ? "" : model.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
            font.pointSize: units.iconSizes.small + (units.iconSizes.smallMedium - units.iconSizes.small) / 2

            Layout.fillWidth: false
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignVTop | Qt.AlignHRight

            Layout.bottomMargin: units.smallSpacing
        }

        Row {
            Layout.fillWidth: true
            Layout.fillHeight: false
            height: childrenRect.height
            
            Repeater {
                model: 5

                delegate: ColumnLayout {
                    id: headerItem
                    width: parent.width / nColumns
                    height: childrenRect.height
                    spacing: 0

                    Label {
                        id: headerLabel
                        text: index === 0 ? "" : dayPartHeaders[index - 1]
                        Layout.alignment: Qt.AlignHLeft | Qt.AlignVCenter
                        Layout.leftMargin: units.smallSpacing
                    }

                    Item {
                        id: dayTitleLine
                        height: 1 * units.devicePixelRatio

                        Layout.fillWidth: true

                        LinearGradient {
                            anchors.fill: parent
                            start: Qt.point(0, 0)
                            end: Qt.point(parent.width, 0)
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0) }
                                GradientStop { position: 0.1; color: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 1) }
                                GradientStop { position: 1.0; color: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0) }
                            }
                        }

                        visible: index !== 0
                    }
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: units.smallSpacing

            model: dayPartVars

            Component {
                id: rowComponent
                Row {
                    id: tableRow

                    property string varName: dayPartVars[index]
                    property int rowIndex: index

                    visible: dailyWeatherModels.hasVariable(varName)

                    anchors.left: parent.left
                    anchors.right: parent.right

                    RowLayout {
                        width: parent.width / nColumns
                        height: childrenRect.height
                        Label {
                            text: dayPartTitles[index] ? dayPartTitles[index] : ""
                            Layout.alignment: Qt.AlignHLeft | Qt.AlignVBottom
                        }

                        visible: tableRow.visible
                    }

                    Repeater {

                        model: 4

                        delegate: Loader {
                            asynchronous: true

                            property int dayPart: modelData
                            property string varName: tableRow.varName
                            property var model: dayParts ? dayParts.get(dayPart) : null

                            width: parent.width / nColumns
                            height: childrenRect.height

                            visible: tableRow.visible

                            sourceComponent: {
                                if (varName === "iconName" && tableRow.rowIndex == 0) {
                                    return weatherIconComponent
                                }
                                return defaultCellComponent
                            }
                        }
                    }
                }
            }

            delegate: rowComponent
        }

        Component {
            id: defaultCellComponent

            RowLayout {
                width: parent.width / nColumns
                height: childrenRect.height
                Label {

                    property var value: (model && model[varName] != undefined) ? model[varName] : null
                    property int partOfDay: model ? model["partOfDay"] : 0
                    property var iconDesc: (value && varName !== "iconName") ? null :
                                                currentProvider ? currentProvider.getIconDescription(value) : ""
                    property string valueStr: isNaN(value) || value === null ? "-" :
                                                UnitUtils.formatValue(value, varName,
                                                                      main.getUnitType(varName),
                                                                      dayPart)

                    text: varName === "iconName" ? (iconDesc ? iconDesc : "-") : valueStr
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    // visible: dayParts && dayParts[dayPart]["temperature"]
                }
            }

        }

        Component {
            id: weatherIconComponent

            Item {
                height: 3 * PlasmaCore.Theme.defaultFont.pixelSize
                anchors.left: parent.left
                anchors.right: parent.right

                WeatherIcon {
                    iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                                   plasmoid.configuration.iconSetType : 0
                    iconModel: ({
                        iconName: model ? model[varName] : null,
                        iconX: 0,
                        iconY: 0,
                        iconDim: units.iconSizes.large,
                        partOfDay: model ? model["partOfDay"] : 0,
                    })

                    width: iconModel.iconDim
                    height: iconModel.iconDim

                    anchors.centerIn: parent
                    centerInParent: true

                }
            }
        }
    }
}
