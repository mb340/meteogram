.pragma library

var hourDurationMs = 1000 * 60 * 60
var wholeDayDurationMs = hourDurationMs * 24

/*
 tempInfoArray of objects: {
    temperature: '23'
    iconName: '45'
    isPast: false
 }
 */
function createEmptyNextDaysObject() {
    return {
        tempInfoArray: [],
        dayTitle: ''
    }
}

function populateNextDaysObject(nextDaysObj) {
    for (var i = 0; i < 4; i++) {
        var tempInfo = nextDaysObj.tempInfoArray[i]
        var hidden = false
        if (tempInfo === null) {
            tempInfo = {
                temperature: NaN,
                iconName: "",
                isPast: true
            }
            hidden = true
        }
        nextDaysObj['temperature' + i] = tempInfo.temperature
        nextDaysObj['temperature_min' + i] = NaN
        nextDaysObj['temperature_max' + i] = NaN
        nextDaysObj['iconName' + i] = tempInfo.iconName
        nextDaysObj['hidden' + i] = hidden
        nextDaysObj['isPast' + i] = tempInfo.isPast
    }
}
