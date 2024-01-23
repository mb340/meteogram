import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.extras 2.0 as PlasmaExtras

import "../code/icons.js" as IconTools


Item {

    implicitWidth: mainLayout.implicitWidth + (2 * units.largeSpacing)
    implicitHeight: mainLayout.implicitHeight + (2 * units.largeSpacing)

    property var hasHumidity: currentWeatherModel.humidity !== undefined
    property var hasCloudArea: currentWeatherModel.cloudArea !== undefined
    property var hasPrecipitationAmount: !isNaN(currentWeatherModel.precipitationAmount) &&
                                            currentWeatherModel.precipitationAmount > 0
    property var hasPrecipitationProb: !isNaN(currentWeatherModel.precipitationProb) &&
                                            currentWeatherModel.precipitationProb > 0


    property bool hasWindSpeed: !isNaN(currentWeatherModel.windSpeedMps)
    property bool hasWindDirection: !isNaN(currentWeatherModel.windDirection)

    property var hasSunriseSunset: timeUtils.hasSunriseSunsetData(currentWeatherModel)

    ColumnLayout {
        id: mainLayout
        spacing: 0

        anchors {
            left: parent.left
            top: parent.top
            margins: units.largeSpacing
        }

        PlasmaExtras.Heading {
            level: 2
            font.bold: true
            text: main.placeAlias
        }

        PlasmaExtras.Heading {
            level: 5
            font.italic: true
            text: !currentWeatherModel.date ? "" :
                    currentWeatherModel.date.toLocaleDateString(Qt.locale(), 'dddd, dd MMMM')
        }

        PlasmaExtras.Heading {
            level: 5
            font.italic: true
            text: !currentWeatherModel.date ? "" :
                    currentWeatherModel.date.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
        }

        Item {
            Layout.preferredHeight: units.largeSpacing
            Layout.fillWidth: true
        }

        RowLayout {
            WeatherIcon {
                iconSetType: plasmoid.configuration.iconSetType
                iconName: currentWeatherModel.iconName
                partOfDay: timeUtils.isSunRisen(currentWeatherModel.date,
                                                currentWeatherModel.sunRise,
                                                currentWeatherModel.sunSet) ? 0 : 1

                iconDim: units.iconSizes.medium

                Layout.preferredWidth: iconDim
                centerInParent: true
            }

            PlasmaExtras.Heading {
                level: 3
                text: !currentProvider ? "" :
                        currentProvider.getIconDescription(currentWeatherModel.iconName)

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            Layout.preferredHeight: units.smallSpacing
            Layout.fillWidth: true
        }

        component WeatherItem: RowLayout {

            required property string iconText
            required property string valueText

            RowLayout {
                Label {
                    font.family: 'weathericons'
                    font.pointSize: 1.5 * units.iconSizes.tiny
                    text: iconText
                    horizontalAlignment: Text.AlignHCenter

                    visible: iconText && iconText.length > 0

                    Layout.preferredWidth: units.iconSizes.medium
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
            visible: hasHumidity

            iconText: '\uf07a'
            valueText: !hasHumidity ? "" :
                        unitUtils.formatValue(currentWeatherModel.humidity,
                                             "humidity")
        }

        RowLayout {
            spacing: 0

            WeatherItem {
                visible: hasPrecipitationAmount

                iconText: '\uf084'
                valueText: unitUtils.formatValue(currentWeatherModel.precipitationAmount,
                                                 "precipitationAmount",
                                                 precipitationType)
            }

            Label {
                text: " | "
                color: theme.disabledTextColor
                visible: hasPrecipitationAmount && hasPrecipitationProb
            }

            WeatherItem {
                visible: hasPrecipitationProb

                iconText: hasPrecipitationAmount ? '' : '\uf084'
                valueText: unitUtils.formatValue(currentWeatherModel.precipitationProb,
                                                 "precipitationProb")
            }
        }

        WeatherItem {
            iconText: '\uf079'
            valueText: unitUtils.getPressureText(currentWeatherModel.pressureHpa,
                                                 pressureType)
        }

        WeatherItem {
            visible: hasCloudArea

            iconText: '\uf041'
            valueText: !hasCloudArea ? "" :
                        unitUtils.formatValue(currentWeatherModel.cloudArea,
                                             "cloudArea")
        }

        RowLayout {
            spacing: 0

            WeatherItem {
                iconText: IconTools.getWindDirectionIconCode(
                                        currentWeatherModel.windDirection)
                valueText: unitUtils.getWindSpeedText(currentWeatherModel.windSpeedMps,
                                                 windSpeedType)
            }

            Label {
                text: " | "
                color: theme.disabledTextColor
                visible: hasWindSpeed && hasWindDirection
            }

            WeatherItem {
                iconText: hasWindSpeed ? '' :
                            IconTools.getWindDirectionIconCode(
                                        currentWeatherModel.windDirection)
                valueText: unitUtils.getWindDirectionText(currentWeatherModel.windDirection,
                                                          windDirectionType)
            }

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
