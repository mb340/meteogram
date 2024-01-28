import QtQuick 2.0

QtObject {
    property bool valid: false

    // Date
    property var date: null

    // Celsius
    property double temperature: NaN

    // String
    property var iconName: null

    // Degrees
    property double windDirection: NaN

    // meters per second
    property double windSpeedMps: NaN

    // hPa
    property double pressureHpa: NaN

    // [0 - 100]%
    property double humidity: NaN

    // [0 - 100]%
    property double cloudArea: NaN

    // [0 - 1]
    property double precipitationProb: NaN

    // Millimeters
    property double precipitationAmount: NaN

    // Date
    property var sunRise: null

    // Date
    property var sunSet: null


    function clear() {
        valid = false

        date = null

        temperature = NaN
        iconName = null
        windDirection = NaN
        windSpeedMps = NaN
        pressureHpa = NaN
        humidity = NaN
        cloudArea = NaN

        precipitationProb = NaN
        precipitationAmount = NaN

        sunRise = null
        sunSet = null
    }
}
