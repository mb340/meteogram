.pragma library


function getColorF(color, idx) {
    if (color[0] !== '#' && color.length !== 9 && color.length !== 7) {
        return NaN
    }
    const STRIDE = 2
    var first_ch = color.length === 9 ? 3 : 1
    let si = first_ch + (STRIDE * idx)
    let ei = si + STRIDE
    let hex = color.substring(si, ei)
    let val = parseInt(hex, 16)
    return val / 255.0
}

function getAlphaF(color) {
    if (color[0] === '#' && color.length !== 7) {
        return 1.0
    }
    if (color[0] !== '#' && color.length !== 9) {
        return NaN
    }
    let hex = color.substring(1, 3)
    let val = parseInt(hex, 16)
    return val / 255.0
}

function getRedF(color) {
    return getColorF(color, 0)
}

function getGreenF(color) {
    return getColorF(color, 1)
}

function getBlueF(color) {
    return getColorF(color, 2)
}

function strToColor(colorStr) {
    return Qt.rgba(getRedF(colorStr),
                   getGreenF(colorStr),
                   getBlueF(colorStr),
                   getAlphaF(colorStr))
}

function sRGBtoLin(colorChannel) {
    if (colorChannel <= 0.04045 ) {
        return colorChannel / 12.92
    } else {
        return Math.pow((colorChannel + 0.055) / 1.055, 2.4)
    }
}

function linToSRgb(lin) {
    if (lin <= 0.0031308) {
        return lin * 12.92
    } else {
        return 1.055 * Math.pow(lin, 1 / 2.4) - 0.055
    }
}

function getLuminosity(color) {
    return 0.2126 * sRGBtoLin(color.r) +
            0.7152 * sRGBtoLin(color.g) +
            0.0722 * sRGBtoLin(color.b)
}

function getContrast(lum1, lum2) {
    var contrast =  lum1 > lum2 ? ((lum1 + 0.05) / (lum2 + 0.05)) :
                                   ((lum2 + 0.05) / (lum1 + 0.05))
    return contrast
}

function isValidContrast(contrast, targetContrast) {
    var upperContrast = targetContrast + 0.20
    // var upperContrast = targetContrast + (targetContrast * 0.10)
    return contrast >= targetContrast && contrast <= upperContrast
}

function equals(x, y) {
    if (x == null && y == null) {
        return true
    }
    if (x == null || y == null) {
        return false
    }
    return x.r === y.r && x.g === y.g && x.b === y.b && x.a === y.a
}


function getContrastingColor(color, bgColor, targetContrast) {
    var color_ = color

    var lum = getLuminosity(color_)
    var bgLum = getLuminosity(bgColor)
    var contrast =  getContrast(lum, bgLum)
    var validContrast = isValidContrast(contrast, targetContrast)
    var lightness = 0
    while (!validContrast && lightness < 1.0) {
        color_ = Qt.hsla(color_.hslHue, color_.hslSaturation, lightness)
        lum = getLuminosity(color_)
        contrast =  getContrast(lum, bgLum)
        validContrast = isValidContrast(contrast, targetContrast)
        lightness += 0.005
    }

    // if (!equals(color, color_)) {
    //     print("targetColor = " + color_)
    //     print("new contrast = " + contrast)
    // }

    return color_
}
