import QtQuick 2.0

QtObject {
    property bool valid: false

    property var date: null

    property double temperature: NaN
    property var iconName: null
    property double windDirection: NaN
    property double windSpeedMps: NaN
    property double pressureHpa: NaN
    property double humidity: NaN
    property double cloudArea: NaN

    property var sunRise: null
    property var sunSet: null

    property var nearFuture: ({
        iconName: null,
        temperature: NaN
    })

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

        sunRise = null
        sunSet = null

        nearFuture = {
            iconName: null,
            temperature: NaN
        }
    }
}
