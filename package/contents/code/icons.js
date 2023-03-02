.pragma library

var initialized = false
var i18n = null

function getWindDirectionIconCode(angle) {
    const iconCodes = ['\uf060', '\uf05e', '\uf061', '\uf05b', '\uf05c', '\uf05a', '\uf059', '\uf05d']
    let n = Math.round((angle + 22.5) / 45) - 1
    var iconCode = iconCodes[n]
    if (!iconCode) {
        iconCode = '\uf073'
    }
    return iconCode
}


const IconSetType = {
    WEATHERFONT: 0,
    METNO: 1,
    BASMILIUS: 2,
    BREEZE: 3,
}

// Intermediate representation
const Ir = {

    ToMetNo: {
        "clearsky":                     "clearsky",
        "cloudy":                       "cloudy",
        "fair":                         "fair",
        "fog":                          "fog",
        "heavyrain":                    "heavyrain",
        "heavyrainandthunder":          "heavyrainandthunder",
        "heavyrainshowers":             "heavyrainshowers",
        "heavyrainshowersandthunder":   "heavyrainshowersandthunder",
        "heavysleet":                   "heavysleet",
        "heavysleetandthunder":         "heavysleetandthunder",
        "heavysleetshowers":            "heavysleetshowers",
        "heavysleetshowersandthunder":  "heavysleetshowersandthunder",
        "heavysnow":                    "heavysnow",
        "heavysnowandthunder":          "heavysnowandthunder",
        "heavysnowshowers":             "heavysnowshowers",
        "heavysnowshowersandthunder":   "heavysnowshowersandthunder",
        "lightrain":                    "lightrain",
        "lightrainandthunder":          "lightrainandthunder",
        "lightrainshowers":             "lightrainshowers",
        "lightrainshowersandthunder":   "lightrainshowersandthunder",
        "lightsleet":                   "lightsleet",
        "lightsleetandthunder":         "lightsleetandthunder",
        "lightsleetshowers":            "lightsleetshowers",
        "lightsnow":                    "lightsnow",
        "lightsnowandthunder":          "lightsnowandthunder",
        "lightsnowshowers":             "lightsnowshowers",
        "lightssleetshowersandthunder": "lightssleetshowersandthunder",
        "lightssnowshowersandthunder":  "lightssnowshowersandthunder",
        "partlycloudy":                 "partlycloudy",
        "rain":                         "rain",
        "rainandthunder":               "rainandthunder",
        "rainshowers":                  "rainshowers",
        "rainshowersandthunder":        "rainshowersandthunder",
        "sleet":                        "sleet",
        "sleetandthunder":              "sleetandthunder",
        "sleetshowers":                 "sleetshowers",
        "sleetshowersandthunder":       "sleetshowersandthunder",
        "snow":                         "snow",
        "snowandthunder":               "snowandthunder",
        "snowshowers":                  "snowshowers",
        "snowshowersandthunder":        "snowshowersandthunder"
    },

    ToWeatherFont: {
        "clearsky":                     ["wi-day-sunny", "wi-night-clear"],
        "cloudy":                       ["wi-cloudy", "wi-cloudy"],
        "fair":                         ["wi-day-cloudy", "wi-night-cloudy"],
        "fog":                          ["wi-fog", "wi-fog"],
        "heavyrain":                    ["wi-rain", "wi-rain"],
        "heavyrainandthunder":          ["wi-thunderstorm", "wi-thunderstorm"],
        "heavyrainshowers":             ["wi-day-rain", "wi-night-rain"],
        "heavyrainshowersandthunder":   ["wi-day-thunderstorm", "wi-night-thunderstorm"],
        "heavysleet":                   ["wi-sleet", "wi-sleet"],
        "heavysleetandthunder":         ["wi-storm-showers", "wi-storm-showers"],
        "heavysleetshowers":            ["wi-day-sleet", "wi-night-sleet"],
        "heavysleetshowersandthunder":  ["wi-day-sleet-storm", "wi-night-sleet-storm"],
        "heavysnow":                    ["wi-snow", "wi-snow"],
        "heavysnowandthunder":          ["wi-thunderstorm", "wi-thunderstorm"],
        "heavysnowshowers":             ["wi-day-snow", "wi-night-snow"],
        "heavysnowshowersandthunder":   ["wi-day-snow-thunderstorm", "wi-night-snow-thunderstorm"],
        "lightrain":                    ["wi-showers", "wi-showers"],
        "lightrainandthunder":          ["wi-storm-showers", "wi-storm-showers"],
        "lightrainshowers":             ["wi-day-showers", "wi-night-showers"],
        "lightrainshowersandthunder":   ["wi-day-storm-showers", "wi-night-storm-showers"],
        "lightsleet":                   ["wi-sleet", "wi-sleet"],
        "lightsleetandthunder":         ["wi-storm-showers", "wi-storm-showers"],
        "lightsleetshowers":            ["wi-day-sleet", "wi-night-sleet"],
        "lightsnow":                    ["wi-snow", "wi-snow"],
        "lightsnowandthunder":          ["wi-storm-showers", "wi-storm-showers"],
        "lightsnowshowers":             ["wi-day-snow", "wi-night-snow"],
        "lightssleetshowersandthunder": ["wi-day-sleet-storm", "wi-night-sleet-storm"],
        "lightssnowshowersandthunder":  ["wi-day-storm-showers", "wi-night-storm-showers"],
        "partlycloudy":                 ["wi-day-cloudy", "wi-night-cloudy"],
        "rain":                         ["wi-rain", "wi-rain"],
        "rainandthunder":               ["wi-thunderstorm", "wi-thunderstorm"],
        "rainshowers":                  ["wi-day-showers", "wi-night-showers"],
        "rainshowersandthunder":        ["wi-day-storm-showers", "wi-night-storm-showers"],
        "sleet":                        ["wi-sleet", "wi-sleet"],
        "sleetandthunder":              ["wi-storm-showers", "wi-storm-showers"],
        "sleetshowers":                 ["wi-day-sleet", "wi-night-sleet"],
        "sleetshowersandthunder":       ["wi-day-sleet-storm", "wi-night-sleet-storm"],
        "snow":                         ["wi-snow", "wi-snow"],
        "snowandthunder":               ["wi-storm-showers", "wi-storm-showers"],
        "snowshowers":                  ["wi-day-snow", "wi-night-snow"],
        "snowshowersandthunder":        ["wi-day-snow-thunderstorm", "wi-night-snow-thunderstorm"]
    },

    ToBasmilius: {
        "clearsky":                     ["clear-day", "clear-night"],
        "cloudy":                       ["cloudy", "cloudy",],
        "fair":                         ["partly-cloudy-day", "partly-cloudy-night"],
        "fog":                          ["fog-day", "fog-night"],
        "heavyrain":                    ["rain", "rain",],
        "heavyrainandthunder":          ["thunderstorms-rain", "thunderstorms-rain"],
        "heavyrainshowers":             ["partly-cloudy-day-rain", "partly-cloudy-night-rain"],
        "heavyrainshowersandthunder":   ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        "heavysleet":                   ["sleet", "sleet",],
        "heavysleetandthunder":         ["thunderstorms-rain", "thunderstorms-rain"],
        "heavysleetshowers":            ["partly-cloudy-day-sleet", "partly-cloudy-night-sleet"],
        "heavysleetshowersandthunder":  ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        "heavysnow":                    ["snow", "snow",],
        "heavysnowandthunder":          ["thunderstorms-snow", "thunderstorms-snow"],
        "heavysnowshowers":             ["partly-cloudy-day-snow", "partly-cloudy-night-snow"],
        "heavysnowshowersandthunder":   ["thunderstorms-day-snow", "thunderstorms-night-snow"],
        "lightrain":                    ["rain", "rain",],
        "lightrainandthunder":          ["thunderstorms-rain", "thunderstorms-rain"],
        "lightrainshowers":             ["partly-cloudy-day-rain", "partly-cloudy-night-rain"],
        "lightrainshowersandthunder":   ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        "lightsleet":                   ["sleet", "sleet",],
        "lightsleetandthunder":         ["thunderstorms-snow", "thunderstorms-snow"],
        "lightsleetshowers":            ["partly-cloudy-day-sleet", "partly-cloudy-night-sleet"],
        "lightsnow":                    ["snow", "snow",],
        "lightsnowandthunder":          ["thunderstorms-rain", "thunderstorms-rain"],
        "lightsnowshowers":             ["partly-cloudy-day-snow", "partly-cloudy-night-snow"],
        "lightssleetshowersandthunder": ["thunderstorms-day-snow", "thunderstorms-night-snow"],
        "lightssnowshowersandthunder":  ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        "partlycloudy":                 ["partly-cloudy-day", "partly-cloudy-night"],
        "rain":                         ["partly-cloudy-day-rain", "partly-cloudy-night-rain"],
        "rainandthunder":               ["thunderstorms-rain", "thunderstorms-rain"],
        "rainshowers":                  ["partly-cloudy-day-rain", "partly-cloudy-night-rain"],
        "rainshowersandthunder":        ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        "sleet":                        ["sleet", "sleet",],
        "sleetandthunder":              ["thunderstorms-snow", "thunderstorms-snow"],
        "sleetshowers":                 ["partly-cloudy-day-sleet", "partly-cloudy-night-sleet"],
        "sleetshowersandthunder":       ["thunderstorms-day-snow", "thunderstorms-night-snow"],
        "snow":                         ["snow", "snow",],
        "snowandthunder":               ["thunderstorms-snow", "thunderstorms-snow"],
        "snowshowers":                  ["partly-cloudy-day-snow", "partly-cloudy-night-snow"],
        "snowshowersandthunder":        ["thunderstorms-day-snow", "thunderstorms-night-snow"]
    },

    ToBreeze: {
        "clearsky":                     ["weather-clear", "weather-clear-night"],
        "cloudy":                       ["weather-overcast", "weather-overcast"],
        "fair":                         ["weather-clouds", "weather-clouds-night"],
        "fog":                          ["weather-fog", "weather-fog"],
        "heavyrain":                    ["weather-showers", "weather-showers"],
        "heavyrainandthunder":          ["weather-storm", "weather-storm"],
        "heavyrainshowers":             ["weather-showers-day", "weather-showers-night"],
        "heavyrainshowersandthunder":   ["weather-storm-day", "weather-storm-night"],
        "heavysleet":                   ["weather-snow-rain", "weather-snow-rain"],
        "heavysleetandthunder":         ["weather-storm", "weather-storm"],
        "heavysleetshowers":            ["weather-snow-scattered-day", "weather-snow-scattered-night"],
        "heavysleetshowersandthunder":  ["weather-storm-day", "weather-storm-night"],
        "heavysnow":                    ["weather-snow", "weather-snow"],
        "heavysnowandthunder":          ["weather-storm", "weather-storm"],
        "heavysnowshowers":             ["weather-snow-scattered-day", "weather-snow-scattered-night"],
        "heavysnowshowersandthunder":   ["weather-storm-day", "weather-storm-night"],
        "lightrain":                    ["weather-showers", "weather-showers"],
        "lightrainandthunder":          ["weather-storm", "weather-storm"],
        "lightrainshowers":             ["weather-showers-scattered-day", "weather-showers-scattered-night"],
        "lightrainshowersandthunder":   ["weather-storm-day", "weather-storm-night"],
        "lightsleet":                   ["weather-snow-rain", "weather-snow-rain"],
        "lightsleetandthunder":         ["weather-storm", "weather-storm"],
        "lightsleetshowers":            ["weather-snow-scattered-day", "weather-snow-scattered-night"],
        "lightsnow":                    ["weather-snow", "weather-snow"],
        "lightsnowandthunder":          ["weather-storm", "weather-storm"],
        "lightsnowshowers":             ["weather-snow-scattered-day", "weather-snow-scattered-night"],
        "lightssleetshowersandthunder": ["weather-storm-day", "weather-storm-night"],
        "lightssnowshowersandthunder":  ["weather-storm-day", "weather-storm-night"],
        "partlycloudy":                 ["weather-clouds", "weather-clouds-night"],
        "rain":                         ["weather-showers", "weather-showers"],
        "rainandthunder":               ["weather-storm", "weather-storm"],
        "rainshowers":                  ["weather-showers-day", "weather-showers-night"],
        "rainshowersandthunder":        ["weather-storm-day", "weather-storm-night"],
        "sleet":                        ["weather-snow-rain", "weather-snow-rain"],
        "sleetandthunder":              ["weather-storm", "weather-storm"],
        "sleetshowers":                 ["weather-snow-scattered-day", "weather-snow-scattered-night"],
        "sleetshowersandthunder":       ["weather-storm", "weather-storm"],
        "snow":                         ["weather-snow", "weather-snow"],
        "snowandthunder":               ["weather-storm", "weather-storm"],
        "snowshowers":                  ["weather-snow-scattered-day", "weather-snow-scattered-night"],
        "snowshowersandthunder":        ["weather-storm-day", "weather-storm-night"]
    }
}

var OwmToIr = {
    200:"lightrainandthunder",
    201:"rainandthunder",
    202:"heavyrainandthunder",
    210:"lightrainandthunder",
    211:"rainandthunder",
    212:"heavyrainandthunder",
    221:"heavyrainandthunder",
    230:"lightrainandthunder",
    231:"rainandthunder",
    232:"heavyrainandthunder",
    300:"lightrain",
    301:"lightrainshowers",
    302:"heavyrain",
    310:"rain",
    311:"rain",
    312:"heavyrain",
    313:"rain",
    314:"heavyrain",
    321:"rain",
    500:"lightrain",
    501:"lightrainshowers",
    502:"heavyrain",
    503:"heavyrain",
    504:"heavyrain",
    511:"sleet",
    520:"lightsleet",
    521:"rain",
    522:"heavyrain",
    531:"heavyrain",
    600:"lightsnow",
    601:"snow",
    602:"heavysnow",
    611:"sleet",
    612:"lightsleet",
    613:"lightsleetshowers",
    615:"lightsleet",
    616:"sleet",
    620:"lightsleet",
    621:"heavysleet",
    622:"heavysleetshowers",
    701:"fog",
    711:"fog",
    721:"fog",
    731:"fog",
    741:"fog",
    751:"fog",
    761:"fog",
    762:"",
    771:"snow",
    781:"",
    800:"clearsky",
    801:"fair",
    802:"fair",
    803:"cloudy",
    804:"cloudy",
}

function getIconResource(iconVal, providerId, iconSetType, partOfDay) {
    if (partOfDay === undefined) {
        partOfDay = 0
    }

    let irName = null
    if (providerId === "metno") {
        irName = iconVal
    } else if (providerId === "owm" || providerId === "owm2") {
        irName = OwmToIr[iconVal]
    }

    if (irName === null || irName === "") {
        return null
    }

    // print('irName = ' + irName)

    if (iconSetType === IconSetType.WEATHERFONT) {
        let parts = Ir.ToWeatherFont[irName]
        if (!parts) {
            return null
        }

        let fontSymbol = parts[partOfDay]
        if (!fontSymbol) {
            return null
        }
        return WeatherFont.codeByName[fontSymbol]
    }
    if (iconSetType === IconSetType.METNO) {
        let metNoName = Ir.ToMetNo[irName]
        let metNoId = parseInt(MetNo.NameToCode[metNoName])

        if (isNaN(metNoId)) {
            return null
        }

        let filename = metNoId.toString().padStart(2, '0')
        let pod = !hasMetNoPartOfDay(metNoId) ? "" : (partOfDay == 0 ? "d" : "n")
        let path = "yr-weather-symbols/" + filename + pod + ".png"
        return path
    }
    if (iconSetType === IconSetType.BASMILIUS) {
        let parts = Ir.ToBasmilius[irName]
        if (!parts) {
            return null
        }

        let filename = parts[partOfDay]
        return "basmilius/weather-icons/" + filename + ".png"
    }
    if (iconSetType === IconSetType.BREEZE) {
        let parts = Ir.ToBreeze[irName]
        if (!parts) {
            return null
        }

        let breezeIconName = parts[partOfDay]
        return breezeIconName
    }

    return null
}

var WeatherFont = {

    // https://erikflowers.github.io/weather-icons/
    codeByName: {
        'wi-day-sunny': '\uf00d',
        'wi-night-clear': '\uf02e',
        'wi-day-sunny-overcast': '\uf00c',
        'wi-night-partly-cloudy': '\uf083',
        'wi-day-cloudy': '\uf002',
        'wi-night-cloudy': '\uf031',
        'wi-cloudy': '\uf013',
        'wi-day-showers': '\uf009',
        'wi-night-showers': '\uf037',
        'wi-day-storm-showers': '\uf00e',
        'wi-night-storm-showers': '\uf03a',
        'wi-day-rain-mix': '\uf006',
        'wi-night-rain-mix': '\uf034',
        'wi-day-snow': '\uf00a',
        'wi-night-snow': '\uf038',
        'wi-showers': '\uf01a',
        'wi-rain': '\uf019',
        'wi-thunderstorm': '\uf01e',
        'wi-rain-mix': '\uf017',
        'wi-snow': '\uf01b',
        'wi-day-snow-thunderstorm': '\uf06b',
        'wi-night-snow-thunderstorm': '\uf06c',
        'wi-dust': '\uf063',
        'wi-day-sleet-storm': '\uf068',
        'wi-night-sleet-storm': '\uf069',
        'wi-storm-showers': '\uf01d',
        'wi-day-sprinkle': '\uf00b',
        'wi-night-sprinkle': '\uf039',
        'wi-day-thunderstorm': '\uf010',
        'wi-night-thunderstorm': '\uf03b',
        'wi-sprinkle': '\uf01c',
        'wi-day-rain': '\uf008',
        'wi-night-rain': '\uf036',
        'wi-lightning': '\uf016',
        'wi-sleet': '\uf0b5',
        'wi-fog': '\uf014',
        'wi-smoke': '\uf062',
        'wi-volcano': '\uf0c8',
        'wi-strong-wind': '\uf050',
        'wi-tornado': '\uf056',
        'wi-windy': '\uf021',
        'wi-hurricane': '\uf073',
        'wi-snowflake-cold': '\uf076',
        'wi-hot': '\uf072',
        'wi-hail': '\uf015',
        'wi-sunset': '\uf052'
    },
}

var MetNo = {
    NameToCode: {
        "clearsky":    "1",
        "cloudy":    "4",
        "fair":    "2",
        "fog":    "15",
        "heavyrain":    "10",
        "heavyrainandthunder":    "11",
        "heavyrainshowers":    "41",
        "heavyrainshowersandthunder":    "25",
        "heavysleet":    "48",
        "heavysleetandthunder":    "32",
        "heavysleetshowers":    "43",
        "heavysleetshowersandthunder":    "27",
        "heavysnow":    "50",
        "heavysnowandthunder":    "34",
        "heavysnowshowers":    "45",
        "heavysnowshowersandthunder":    "29",
        "lightrain":    "46",
        "lightrainandthunder":    "30",
        "lightrainshowers":    "40",
        "lightrainshowersandthunder":    "24",
        "lightsleet":    "47",
        "lightsleetandthunder":    "31",
        "lightsleetshowers":    "42",
        "lightsnow":    "49",
        "lightsnowandthunder":    "33",
        "lightsnowshowers":    "44",
        "lightssleetshowersandthunder":    "26",
        "lightssnowshowersandthunder":    "28",
        "partlycloudy":    "3",
        "rain":    "9",
        "rainandthunder":    "22",
        "rainshowers":    "5",
        "rainshowersandthunder":    "6",
        "sleet":    "12",
        "sleetandthunder":    "23",
        "sleetshowers":    "7",
        "sleetshowersandthunder":    "20",
        "snow":    "13",
        "snowandthunder":    "14",
        "snowshowers":    "8",
        "snowshowersandthunder":    "21"
    }
}

function getIconCode(iconVal, providerId, partOfDay) {
    if (partOfDay === undefined) {
        partOfDay = 0
    }

    let irName = null
    if (providerId === "metno") {
        irName = iconVal
    } else if (providerId === "owm" || providerId === "owm2") {
        irName = OwmToIr[iconVal]
    }

    if (irName === null) {
        return "\uf07b"  // wi-na
    }

    let fontSymbol = Ir.ToWeatherFont[irName][partOfDay]
    return WeatherFont.codeByName[fontSymbol]
}

function getSunriseIcon() {
    return '\uf052'
}

function getSunsetIcon() {
    return '\uf051'
}

function hasMetNoPartOfDay(iconId) {
    const p = [1, 2, 3, 5, 6, 7, 8, 20, 21, 24, 25, 26, 27, 28, 29, 40, 41, 42, 43, 44, 45]
    return p.includes(iconId)
}
