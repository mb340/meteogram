import QtQuick 2.0

QtObject {
    property bool valid: false

    property double temperature: NaN
    property var iconName: null
    property string windDirection: ""
    property string windSpeedMps: ""
    property string pressureHpa: ""
    property string humidity: ""
    property string cloudiness: ""

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
        windDirection = ""
        windSpeedMps = ""
        pressureHpa = ""
        humidity = ""
        cloudiness = ""

        sunRise = new Date(0)
        sunSet = new Date(0)

        nearFuture = {
            iconName: null,
            temperature: NaN
        }
    }
}
