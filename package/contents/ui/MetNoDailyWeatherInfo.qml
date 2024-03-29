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
import org.kde.plasma.core as PlasmaCore
import "../code/icons.js" as IconTools
import org.kde.kirigami as Kirigami


Item {

    property int nColumns: 5

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
        "uvi"
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
        i18n("UV Index"),
    ]

    ColumnLayout {
        anchors.fill: parent

        Label {
            id: dateLabel
            text: !model ? "" : model.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
            font.pointSize: Kirigami.Units.iconSizes.small + (Kirigami.Units.iconSizes.smallMedium - Kirigami.Units.iconSizes.small) / 2

            Layout.fillWidth: false
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignVTop | Qt.AlignHRight

            Layout.bottomMargin: Kirigami.Units.smallSpacing
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
                        color: main.theme.textColor
                        Layout.alignment: Qt.AlignHLeft | Qt.AlignVCenter
                        Layout.leftMargin: Kirigami.Units.smallSpacing
                    }

                    GradientUnderline {
                        lineColor: main.theme.textColor
                        visible: index !== 0

                        Layout.preferredHeight: 1
                        Layout.fillWidth: true
                    }
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: Kirigami.Units.smallSpacing

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

                    Label {
                        text: dayPartTitles[index] ? dayPartTitles[index] : ""
                        width: parent.width / nColumns
                        height: contentHeight
                        visible: tableRow.visible
                        Layout.alignment: Qt.AlignHLeft | Qt.AlignVBottom
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

            Label {
                width: parent.width / nColumns
                height: contentHeight
                anchors.left: parent.left
                anchors.right: parent.right

                property var value: (model && model[varName] != undefined) ? model[varName] : null
                property int partOfDay: model ? model["partOfDay"] : 0
                property var iconDesc: (value && varName !== "iconName") ? null :
                                            currentProvider ? currentProvider.getIconDescription(value) : ""
                property string valueStr: isNaN(value) || value === null ? "-" :
                                            unitUtils.formatValue(value, varName,
                                                                  unitUtils.getUnitType(varName),
                                                                  dayPart)

                text: varName === "iconName" ? (iconDesc ? iconDesc : "-") : valueStr
                horizontalAlignment: Text.AlignHCenter

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: parent.width
                // visible: dayParts && dayParts[dayPart]["temperature"]
            }
        }

        Component {
            id: weatherIconComponent

            Item {
                height: 3 * Kirigami.Theme.defaultFont.pixelSize
                anchors.left: parent.left
                anchors.right: parent.right

                WeatherIcon {
                    iconDim: Kirigami.Units.iconSizes.large
                    width: iconDim
                    height: iconDim

                    anchors.centerIn: parent

                    partOfDay: model ? model["partOfDay"] : 0
                    iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                                   plasmoid.configuration.iconSetType : 0
                    iconName: model ? model[varName] : null
                }
            }
        }
    }
}
