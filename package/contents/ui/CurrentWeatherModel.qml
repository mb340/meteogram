import QtQuick 2.0

QtObject {
    property bool valid: false

    property double temperature: NaN
    property var iconName: null
    property double windDirection: NaN
    property double windSpeedMps: NaN
    property double pressureHpa: NaN
    property double humidity: NaN
    property double cloudArea: NaN

    property date sunRise: new Date(0)
    property date sunSet: new Date(0)

    property var nearFuture: ({
        iconName: null,
        temperature: NaN
    })

    function clear() {
        valid = false

        temperature = NaN
        iconName = null
        windDirection = NaN
        windSpeedMps = NaN
        pressureHpa = NaN
        humidity = NaN
        cloudArea = NaN

        sunRise = new Date(0)
        sunSet = new Date(0)

        nearFuture = {
            iconName: null,
            temperature: NaN
        }
    }
}
