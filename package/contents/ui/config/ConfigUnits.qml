import QtQuick
import QtQuick.Controls
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami


KCM.SimpleKCM {
    id: configUnits

    property int cfg_temperatureType
    property int cfg_pressureType
    property int cfg_windSpeedType
    property int cfg_windDirectionType
    property int cfg_timezoneType
    property int cfg_precipitationType


    Kirigami.FormLayout {
        Component.onCompleted: {
            cfg_temperatureTypeChanged()
            cfg_pressureTypeChanged()
            cfg_windSpeedTypeChanged()
            cfg_windDirectionTypeChanged()
            cfg_timezoneTypeChanged()
            cfg_precipitationTypeChanged()
        }

        property var model: [
            {
                varLabel: i18n("Temperature") + ":",
                varName: "cfg_temperatureType",
                labels: [
                    i18n("°C"),
                    i18n("°F"),
                    i18n("K")
                ],
            },
            {
                varLabel: i18n("Pressure") + ":",
                varName: "cfg_pressureType",
                labels: [
                    i18n("hPa"),
                    i18n("inHg"),
                    i18n("mmHg")
                ],
            },
            {
                varLabel: i18n("Wind speed") + ":",
                varName: "cfg_windSpeedType",
                labels: [
                    i18n("m/s"),
                    i18n("mph"),
                    i18n("km/h"),
                    i18n("kn")
                ],
            },
            {
                varLabel: i18n("Wind direction") + ":",
                varName: "cfg_windDirectionType",
                labels: [
                    i18n("Azimuth"),
                    i18n("Cardinal")
                ],
            },
            {
                varLabel: i18n("Precipitation") + ":",
                varName: "cfg_precipitationType",
                labels: [
                    i18n("Millimeter"),
                    i18n("Centimeter"),
                    i18n("Mil"),
                    i18n("Inch")
                ],
            },
            {
                varLabel: i18n("Time zone") + ":",
                varName: "cfg_timezoneType",
                labels: [
                    i18n("System local-time"),
                    i18n("UTC"),
                    i18n("Location local-time"),
                ],
            },
        ]

        Repeater {
            model: parent.model
            ComboBox {
                Kirigami.FormData.label: modelData.varLabel

                currentIndex: configUnits[modelData.varName]
                model: modelData.labels

                onCurrentIndexChanged: {
                    if (currentIndex < 0 || currentIndex >= model.length) {
                        return
                    }
                    configUnits[modelData.varName] = currentIndex
                }
            }
        }
    }
}
