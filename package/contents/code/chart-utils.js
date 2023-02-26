.pragma library

var initialized = false
var main = null


function getValueRange(varName) {
    if (varName === "windSpeed" || varName === "windGust") {
        return [0, Infinity]
    } else if (varName === "cloudArea") {
        return [0, 100]
    } else if (varName === "precipitationProb") {
        return [0, 100]
    } else if (varName === "uvi") {
        return [0, Infinity]
    }
    return [-Infinity, Infinity]
}

function getMinGridRange(varName) {
    if (varName === "pressure") {
        const minPressureYGridCount = {
            0: 30,
            1: 0.5,
            2: 20,
        }
        return minPressureYGridCount[main.pressureType]
    }
    return 0.0
}


function getMagnitude(val) {
    var decimalPlace = Math.floor(Math.log10(val))
    decimalPlace = (Math.abs(decimalPlace) === Infinity) ? 0 : decimalPlace
    var mult = Math.pow(10, -decimalPlace)
    return [decimalPlace, mult]
}

/* Round a value in base number system */
function roundBase(val, base) {
    return base * Math.round(val / base)
}

function ceilBase(val, base) {
    return base * Math.ceil(val / base)
}

function floorBase(val, base) {
    return base * Math.floor(val / base)
}

/*
 * Compute y-axis scale. Right axis shares y-axis grid lines with temperature graph.
 * This imposes a constraint of right axis steps being bound to temperature axis steps.
 */
function computeRightAxisRange(minValue, maxValue, minGridRange, fixedMin, fixedMax, gridCount)
{

    if (!isFinite(minValue) || !isFinite(maxValue)) {
        return [minValue, maxValue]
    }

    let _minValue = minValue
    let _maxValue = maxValue
    let dP = maxValue - minValue
    let [decimalPlace, mult] = getMagnitude(dP)
    // print(" ")
    // print("fixedMin, fixedMax " + fixedMin + ", " + fixedMax)
    // print("maxValue = " + maxValue + ", minValue = " + minValue)
    // print("dP = " + dP)
    // print("decimalPlace = " + decimalPlace + ", mult = " + mult)

    dP = ceilBase(dP * mult, 0.5) / mult
    // print("rounded dP = " + dP)

    dP = Math.max(minGridRange, dP)
    // print("dP = " + dP)

    if (fixedMin === true && fixedMax === true) {
        return [minValue, maxValue]
    }

    let stepSize
    if (decimalPlace > 0) {
        stepSize = 10 * mult
    } else {
        stepSize = 1 / (10 * mult)
    }

    let count = Math.ceil(dP / stepSize)
    let nSteps = Math.ceil(count / gridCount) * gridCount
    let valueRange = stepSize * nSteps

    // print("mult = " + mult)
    // print("stepSize = " + stepSize)
    // print("valueRange = " + valueRange)
    // print("gridCount = " + gridCount)

    if (fixedMin) {
        maxValue = minValue + (nSteps * stepSize)
        return [minValue, maxValue]
    }

    if (fixedMax) {
        minValue = maxValue - (nSteps * stepSize)
        return [minValue, maxValue]
    }


    let iter = 0
    let baseStepSize = stepSize
    let s = stepSize
    // print("baseStepSize = " + baseStepSize)

    var [_, roundMult] = getMagnitude(stepSize)
    // print("decimalPlace_ = " + decimalPlace_)
    // print("roundMult = " + roundMult)

    // Find an appropriate step size by 0.5 and 1.0 increments per order of magnitude.
    while (true) {
        let c = Math.floor(dP / s)
        let ns = Math.ceil(c / gridCount) * gridCount
        let pr = s * ns

        // print("stepSize = " + s + ", nSteps = " + ns + ", valueRange = " + pr)
        if (c <= 0 || ns <= 0) {
            print("c = " + c + ", ns = " + ns)
            break
        }
        if (nSteps >= gridCount && pr <= 2.0 * dP) {
            break
        }

        stepSize = s

        count = c
        nSteps = ns
        valueRange = pr

        if (iter >= 1) {
            baseStepSize  /= 10
            s = baseStepSize
            iter = 0
        } else {
            s = s / 2
            iter++
        }

    }

    // print('done')
    // print("stepSize = " + stepSize + ", nSteps = " + nSteps +
    //       ", valueRange = " + valueRange)

    let mid = minValue + ((maxValue - minValue) / 2.0)
    minValue = mid - (valueRange / 2.0)
    maxValue = mid + (valueRange / 2.0)
    // print("mid = " + mid + ", maxValue = " + maxValue + ", minValue = " + minValue)

    // Find the highest order of magnitude that fits the data
    let m = roundMult
    while (true) {
        let base = m >= 1 ? 5 : 0.5
        let maxV = floorBase(maxValue * m, base) / m
        let minV = maxV - (nSteps * stepSize)

        if (_minValue < minV || _maxValue > maxV) {
            maxV = ceilBase(maxValue * m, base) / m
            minV = maxV - (nSteps * stepSize)
        }

        // print("m minV maxV " + m + ", " + minV + ", " + maxV)

        if (_minValue < minV || _maxValue > maxV) {
            break
        }

        minValue = minV
        maxValue = maxV
        m = m / 10
        if (m < mult) {
            break
        }
    }

    // print("maxValue = " + maxValue + ", minValue = " + minValue)
    return [minValue, maxValue]
}

function countDecimalPlaces(value) {
    if (isNaN(value)) {
        return 0
    }
    let strNum = value.toString()
    if (strNum.includes('.')) {
        return strNum.split('.')[1].length
    }
    return 0
}
