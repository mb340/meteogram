import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1

Item {

    property int cfg_temperatureType
    property int cfg_pressureType
    property int cfg_windSpeedType
    property int cfg_timezoneType
    property int cfg_precipitationType

    onCfg_temperatureTypeChanged: {
        switch (cfg_temperatureType) {
        case 0:
            temperatureTypeRadioCelsius.checked = true;
            break;
        case 1:
            temperatureTypeRadioFahrenheit.checked = true;
            break;
        case 2:
            temperatureTypeRadioKelvin.checked = true;
            break;
        default:
        }
    }

    onCfg_pressureTypeChanged: {
        switch (cfg_pressureType) {
        case 0:
            pressureTypeRadioHpa.checked = true;
            break;
        case 1:
            pressureTypeRadioInhg.checked = true;
            break;
        case 2:
            pressureTypeRadioMmhg.checked = true;
            break;
        default:
        }
    }

    onCfg_windSpeedTypeChanged: {
        switch (cfg_windSpeedType) {
        case 0:
            windSpeedTypeRadioMps.checked = true;
            break;
        case 1:
            windSpeedTypeRadioMph.checked = true;
            break;
        case 2:
            windSpeedTypeRadioKmh.checked = true;
            break;
        default:
        }
    }

    onCfg_timezoneTypeChanged: {
        switch (cfg_timezoneType) {
        case 0:
            timezoneTypeRadioUserLocalTime.checked = true;
            break;
        case 1:
            timezoneTypeRadioUtc.checked = true;
            break;
        case 2:
            timezoneTypeRadioLocationLocalTime.checked = true;
            break;
        default:
        }
    }

    onCfg_precipitationTypeChanged: {
        switch (cfg_precipitationType) {
        default:
        case 0:
            precipitationTypeMM.checked = true;
            break;
        case 1:
            precipitationTypeCM.checked = true;
            break;
        case 2:
            precipitationTypeInch.checked = true;
            break;
        case 3:
            precipitationTypeMil.checked = true;
            break;
        }
    }

    Component.onCompleted: {
        cfg_temperatureTypeChanged()
        cfg_pressureTypeChanged()
        cfg_windSpeedTypeChanged()
        cfg_timezoneTypeChanged()
        cfg_precipitationTypeChanged()
    }

    ButtonGroup {
        id: temperatureTypeGroup
    }

    ButtonGroup {
        id: pressureTypeGroup
    }

    ButtonGroup {
        id: windSpeedTypeGroup
    }

    ButtonGroup {
        id: timezoneTypeGroup
    }

    ButtonGroup {
        id: precipitationTypeGroup
    }

    GridLayout {
        columns: 2

        Label {
            text: i18n("Temperature") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
        RadioButton {
            id: temperatureTypeRadioCelsius
            ButtonGroup.group: temperatureTypeGroup
            text: i18n("°C")
            onCheckedChanged: if (checked) cfg_temperatureType = 0
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: temperatureTypeRadioFahrenheit
            ButtonGroup.group: temperatureTypeGroup
            text: i18n("°F")
            onCheckedChanged: if (checked) cfg_temperatureType = 1
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: temperatureTypeRadioKelvin
            ButtonGroup.group: temperatureTypeGroup
            text: i18n("K")
            onCheckedChanged: if (checked) cfg_temperatureType = 2
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Pressure") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
        RadioButton {
            id: pressureTypeRadioHpa
            ButtonGroup.group: pressureTypeGroup
            text: i18n("hPa")
            onCheckedChanged: if (checked) cfg_pressureType = 0
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: pressureTypeRadioInhg
            ButtonGroup.group: pressureTypeGroup
            text: i18n("inHg")
            onCheckedChanged: if (checked) cfg_pressureType = 1
        }
        RadioButton {
            id: pressureTypeRadioMmhg
            ButtonGroup.group: pressureTypeGroup
            text: i18n("mmHg")
            onCheckedChanged: if (checked) cfg_pressureType = 2
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Wind speed") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
        RadioButton {
            id: windSpeedTypeRadioMps
            ButtonGroup.group: windSpeedTypeGroup
            text: i18n("m/s")
            onCheckedChanged: if (checked) cfg_windSpeedType = 0
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: windSpeedTypeRadioMph
            ButtonGroup.group: windSpeedTypeGroup
            text: i18n("mph")
            onCheckedChanged: if (checked) cfg_windSpeedType = 1
        }
        RadioButton {
            id: windSpeedTypeRadioKmh
            ButtonGroup.group: windSpeedTypeGroup
            text: i18n("km/h")
            onCheckedChanged: if (checked) cfg_windSpeedType = 2
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Timezone") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
        RadioButton {
            id: timezoneTypeRadioUserLocalTime
            ButtonGroup.group: timezoneTypeGroup
            text: i18n("System local-time")
            onCheckedChanged: if (checked) cfg_timezoneType = 0
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: timezoneTypeRadioUtc
            ButtonGroup.group: timezoneTypeGroup
            text: i18n("UTC")
            onCheckedChanged: if (checked) cfg_timezoneType = 1
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: timezoneTypeRadioLocationLocalTime
            ButtonGroup.group: timezoneTypeGroup
            text: i18n("Location local-time")
            onCheckedChanged: if (checked) cfg_timezoneType = 2
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Precipitation") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
        RadioButton {
            id: precipitationTypeMM
            ButtonGroup.group: precipitationTypeGroup
            text: i18n("Millimeter")
            onCheckedChanged: if (checked) cfg_precipitationType = 0
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: precipitationTypeCM
            ButtonGroup.group: precipitationTypeGroup
            text: i18n("Centimeter")
            onCheckedChanged: if (checked) cfg_precipitationType = 1
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: precipitationTypeInch
            ButtonGroup.group: precipitationTypeGroup
            text: i18n("Inch")
            onCheckedChanged: if (checked) cfg_precipitationType = 2
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        RadioButton {
            id: precipitationTypeMil
            ButtonGroup.group: precipitationTypeGroup
            text: i18n("Mil") + " (" + i18n("Thousandth of an inch") + ")"
            onCheckedChanged: if (checked) cfg_precipitationType = 3
        }
    }

}
