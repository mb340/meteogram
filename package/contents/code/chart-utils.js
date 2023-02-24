.pragma library

var initialized = false
var main = null


function getValueRange(varName) {
    if (varName === "windSpeed") {
        return [0, Infinity]
    }
    return [-Infinity, Infinity]
}

function getMinGridRange(varName) {
    if (varName === "pressure") {
        const minPressureYGridCount = {
            0: 30,
            1: 0.5,
            2: 10,
        }
        return minPressureYGridCount[main.pressureType]
    }
    return 1.0
}

function logn(x, base) {
    return Math.log(x) / Math.log(base)
}

function getMagnitude(val) {
    var decimalPlace = Math.floor(logn(val, 100))
    decimalPlace = (Math.abs(decimalPlace) === Infinity) ? 0 : decimalPlace
    var mult = Math.pow(100, -decimalPlace)
    decimalPlace *= 2
    return [decimalPlace, mult]
}


/* Round a value in base number system */
function roundBase(val, base) {
    return base * Math.round(val / base)
}

/*
 * Compute y-axis scale.
 * Right axis shares y-axis grid lines with temperature graph. This imposes a constraint of
 * which right axis steps are bound to temperature axis steps.
 */
function computeRightAxisRange(minValue, maxValue, minGridRange, fixedMin, fixedMax, gridCount) {

    var dP = maxValue - minValue
    var [decimalPlace, mult] = getMagnitude(dP)
    // print(" ")
    // print("maxValue = " + maxValue + ", minValue = " + minValue)
    // print("dP = " + dP)
    // print("decimalPlace = " + decimalPlace + ", mult = " + mult)

    if (fixedMin === true && fixedMax === true) {
        return [minValue, maxValue, decimalPlace]
    }

    var stepSize = 1 / mult
    if ((dP / stepSize) < 2) {
        // Ensure at least 2 steps
        mult *= 100
        decimalPlace -= 2
        // print("decimalPlace = " + decimalPlace + ", mult = " + mult)
    }

    decimalPlace = Math.max(-2, decimalPlace)
    decimalPlace = Math.min(4, decimalPlace)

    dP = Math.max(minGridRange, dP)
    if (decimalPlace >= 0) {
         dP += (2 * (mult * 100) / gridCount)
    } else {
         dP += (2 * (mult / 100) / gridCount)
    }
    dP = Math.ceil(dP * mult * 10) / (mult * 10)
    // print("minGridRange = " + minGridRange + ", dP = " + dP)

    var stepSize = 1 / mult
    var count = Math.ceil(dP / stepSize)
    var nSteps = Math.ceil(count / gridCount) * gridCount
    var valueRange = stepSize * nSteps
    // print("valueRange = " + valueRange)
    // print("gridCount = " + gridCount)

    while (true) {
        var s = stepSize * 2
        var c = Math.floor(dP / s)
        var ns = Math.ceil(c / gridCount) * gridCount
        var pr = s * ns

        // print("stepSize = " + stepSize + ", nSteps = " + nSteps +
        //       ", valueRange = " + valueRange + ", dP = " + dP)
        if (c <= 0 || ns <= 0) {
            print("c = " + c + ", ns = " + ns)
            break
        }
        if (nSteps <= gridCount && valueRange >= dP) {
            break
        }
        stepSize = s
        count = c
        nSteps = ns
        valueRange = pr
    }

    // Pressure scale domain
    var mid = minValue + ((maxValue - minValue) / 2.0)
    mid = Math.round(mid * mult) / mult
    minValue = fixedMin ? minValue : (mid - (valueRange / 2.0))
    maxValue = fixedMax ? maxValue : (mid + (valueRange / 2.0))
    if (mult != 1) {
        minValue = fixedMin ? minValue : (Math.ceil(minValue * mult) / mult)
        maxValue = fixedMax ? maxValue : (Math.floor(maxValue * mult) / mult)
    }

    // print("mid = " + mid + ", maxValue = " + maxValue + ", minValue = " + minValue)

    /*
     * Round min/max values at one higher order of magnitude
     */
    var decimalPlace_ = Math.floor(Math.log10(stepSize))
    var mult = decimalPlace_ + 1
    if (decimalPlace_ >= 0) {
        mult = Math.pow(10, mult)
    } else {
        // Whole numbers are the upper bound for rounding when the step size is less than zero.
        mult = mult < 1 ? Math.pow(10, mult) : mult
    }

    var ceilMaxP = Math.ceil(maxValue / mult) * mult
    var floorMaxP = Math.floor(maxValue / mult) * mult
    // print("ceilMaxP = " + ceilMaxP)
    // print("floorMaxP = " + floorMaxP)
    if (maxValue - floorMaxP <= ceilMaxP - maxValue) {
        var dp = maxValue - floorMaxP
        maxValue = fixedMax ? maxValue : (maxValue - dp)
        minValue = fixedMin ? minValue : (minValue - dp)
    } else {
        var dp = ceilMaxP - maxValue
        maxValue = fixedMax ? maxValue : (maxValue + dp)
        minValue = fixedMin ? minValue : (minValue + dp)
    }
    // print("mult = " + mult)
    // print("maxValue = " + maxValue + ", minValue = " + minValue)

    let decimalPlaces = -1 * Math.min(0, decimalPlace)

    return [minValue, maxValue, decimalPlaces]
}