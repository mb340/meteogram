import QtQml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

import "../code/icons.js" as IconTools


Item {

    implicitWidth: mainLayout.implicitWidth + (2 * Kirigami.Units.gridUnit)
    implicitHeight: mainLayout.implicitHeight + (2 *  Kirigami.Units.gridUnit)

    property var hasHumidity: currentWeatherModel.humidity !== undefined
    property var hasCloudArea: currentWeatherModel.cloudArea !== undefined
    property var hasSunriseSunset: timeUtils.hasSunriseSunsetData(currentWeatherModel)


    ColumnLayout {
        id: mainLayout

        spacing: 0

        anchors {
            left: parent.left
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }

        Kirigami.Heading {
            level: 2
            font.bold: true
            text: main.placeAlias
        }

        Kirigami.Heading {
            level: 5
            font.italic: true
            text: !currentWeatherModel.date ? "" :
                    currentWeatherModel.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
        }

        Kirigami.Heading {
            level: 5
            font.italic: true
            text: !currentWeatherModel.date ? "" :
                    currentWeatherModel.date.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
        }

        Item {
            Layout.preferredHeight: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
        }

        RowLayout {
            WeatherIcon {
                iconSetType: plasmoid.configuration.iconSetType
                iconName: currentWeatherModel.iconName

                iconDim: Kirigami.Units.iconSizes.medium

                Layout.preferredWidth: iconDim
                centerInParent: true
            }

            Kirigami.Heading {
                level: 3
                text: currentProvider.getIconDescription(currentWeatherModel.iconName)

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            Layout.preferredHeight: Kirigami.Units.smallSpacing
            Layout.fillWidth: true
        }

        component WeatherItem: RowLayout {

            required property string iconText
            required property string valueText

            RowLayout {
                Label {
                    font.family: 'weathericons'
                    font.pointSize: 1.5 * Kirigami.Units.iconSizes.tiny
                    text: iconText
                    horizontalAlignment: Text.AlignHCenter

                    Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                }
                Label {
                    text: valueText
                }
            }
        }

        WeatherItem {
            iconText: '\uf055'
            valueText: unitUtils.formatValue(currentWeatherModel.temperature,
                                             "temperature",
                                             temperatureType)
        }

        WeatherItem {
            iconText: IconTools.getWindDirectionIconCode(
                                    currentWeatherModel.windDirection)
            valueText: unitUtils.getWindDirectionText(currentWeatherModel.windDirection,
                                                      windDirectionType) + " " +
                  unitUtils.getWindSpeedText(currentWeatherModel.windSpeedMps,
                                             windSpeedType)
        }

        WeatherItem {
            iconText: '\uf079'
            valueText: unitUtils.getPressureText(currentWeatherModel.pressureHpa,
                                                 pressureType)
        }

        WeatherItem {
            visible: hasHumidity

            iconText: '\uf07a'
            valueText: !hasHumidity ? "" :
                        unitUtils.formatValue(currentWeatherModel.humidity,
                                             "humidity")
        }

        WeatherItem {
            visible: hasCloudArea

            iconText: '\uf041'
            valueText: !hasCloudArea ? "" :
                        unitUtils.formatValue(currentWeatherModel.cloudArea,
                                             "cloudArea")
        }

        WeatherItem {
            visible: hasSunriseSunset

            iconText: '\uf051'
            valueText: !hasSunriseSunset ? "" :
                        Qt.formatTime(currentWeatherModel.sunRise,
                                      Qt.locale().timeFormat(Locale.ShortFormat)) +
                        " " +
                        timezoneShortName
        }

        WeatherItem {
            visible: hasSunriseSunset

            iconText: '\uf052'
            valueText: !hasSunriseSunset ? "" :
                        Qt.formatTime(currentWeatherModel.sunSet,
                                      Qt.locale().timeFormat(Locale.ShortFormat)) +
                        " " +
                        timezoneShortName
        }
    }
}
