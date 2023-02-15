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

    iconNameByYrNoCode: {
        '1':  ['wi-day-sunny', 'wi-night-clear'],
        '2':  ['wi-day-sunny-overcast', 'wi-night-partly-cloudy'],
        '3':  ['wi-day-cloudy', 'wi-night-cloudy'],
        '4':  ['wi-cloudy', 'wi-cloudy'],
        '5':  ['wi-day-showers', 'wi-night-showers'],
        '6':  ['wi-day-storm-showers', 'wi-night-storm-showers'],
        '7':  ['wi-day-rain-mix', 'wi-night-rain-mix'],
        '8':  ['wi-day-snow', 'wi-night-snow'],
        '9':  ['wi-showers', 'wi-showers'],
        '10': ['wi-rain', 'wi-rain'],
        '11': ['wi-thunderstorm', 'wi-thunderstorm'],
        '12': ['wi-sleet', 'wi-sleet'],
        '13': ['wi-snow', 'wi-snow'],
        '14': ['wi-day-snow-thunderstorm', 'wi-night-snow-thunderstorm'], //TODO no icon in fonts! using SnowSunThunder
        '15': ['wi-fog', 'wi-fog'],
        '20': ['wi-day-sleet-storm', 'wi-night-sleet-storm'],
        '21': ['wi-day-snow-thunderstorm', 'wi-night-snow-thunderstorm'],
        '22': ['wi-storm-showers', 'wi-storm-showers'],
        '23': ['wi-day-sleet-storm', 'wi-night-sleet-storm'],
        '24': ['wi-day-storm-showers', 'wi-night-storm-showers'],
        '25': ['wi-day-thunderstorm', 'wi-night-thunderstorm'],
        '26': ['wi-day-sleet-storm', 'wi-night-sleet-storm'], //TODO used SleetSunThunder
        '27': ['wi-day-sleet-storm', 'wi-night-sleet-storm'], //TODO used SleetSunThunder
        '28': ['wi-day-snow-thunderstorm', 'wi-night-snow-thunderstorm'], //TODO no icon in fonts! using SnowSunThunder
        '29': ['wi-day-snow-thunderstorm', 'wi-night-snow-thunderstorm'], //TODO no icon in fonts! using SnowSunThunder
        '30': ['wi-sprinkle', 'wi-sprinkle'], //TODO used Drizzle
        '31': ['wi-day-sleet-storm', 'wi-night-sleet-storm'],
        '32': ['wi-day-sleet-storm', 'wi-night-sleet-storm'],
        '33': ['wi-day-snow-thunderstorm', 'wi-night-snow-thunderstorm'], //TODO no icon in fonts! using SnowSunThunder
        '34': ['wi-day-snow-thunderstorm', 'wi-night-snow-thunderstorm'], //TODO no icon in fonts! using SnowSunThunder
        '40': ['wi-day-sprinkle', 'wi-night-sprinkle'],
        '41': ['wi-day-rain', 'wi-night-rain'],
        '42': ['wi-day-rain-mix', 'wi-night-rain-mix'], //TODO used SleetSun
        '43': ['wi-day-rain-mix', 'wi-night-rain-mix'], //TODO used SleetSun
        '44': ['wi-day-snow', 'wi-night-snow'], //TODO used SnowSun
        '45': ['wi-day-snow', 'wi-night-snow'], //TODO used SnowSun
        '46': ['wi-sprinkle', 'wi-sprinkle'],
        '47': ['wi-sleet', 'wi-sleet'], //TODO same as Sleet for now
        '48': ['wi-sleet', 'wi-sleet'], //TODO same as Sleet for now
        '49': ['wi-snow', 'wi-snow'], //TODO used Snow
        '50': ['wi-snow', 'wi-snow']  //TODO used Snow
    },

    // http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
    iconNameByOwmCode: {
        '200': ['wi-storm-showers', 'wi-storm-showers'],
        '201': ['wi-thunderstorm', 'wi-thunderstorm'],
        '202': ['wi-storm-showers', 'wi-storm-showers'],
        '210': ['wi-lightning', 'wi-lightning'],
        '211': ['wi-lightning', 'wi-lightning'],
        '212': ['wi-lightning', 'wi-lightning'],
        '221': ['wi-lightning', 'wi-lightning'],
        '230': ['wi-storm-showers', 'wi-storm-showers'],
        '231': ['wi-storm-showers', 'wi-storm-showers'],
        '232': ['wi-storm-showers', 'wi-storm-showers'],

        '300': ['wi-sprinkle', 'wi-sprinkle'],
        '301': ['wi-sprinkle', 'wi-sprinkle'],
        '302': ['wi-sprinkle', 'wi-sprinkle'],
        '310': ['wi-sprinkle', 'wi-sprinkle'],
        '311': ['wi-sprinkle', 'wi-sprinkle'],
        '312': ['wi-sprinkle', 'wi-sprinkle'],
        '313': ['wi-sprinkle', 'wi-sprinkle'],
        '314': ['wi-sprinkle', 'wi-sprinkle'],
        '321': ['wi-sprinkle', 'wi-sprinkle'],

        '500': ['wi-showers', 'wi-showers'],
        '501': ['wi-rain', 'wi-rain'],
        '502': ['wi-rain', 'wi-rain'],
        '503': ['wi-rain', 'wi-rain'],
        '504': ['wi-rain', 'wi-rain'],
        '511': ['wi-rain', 'wi-rain'],
        '520': ['wi-rain', 'wi-rain'],
        '521': ['wi-rain', 'wi-rain'],
        '522': ['wi-rain', 'wi-rain'],
        '531': ['wi-rain', 'wi-rain'],

        '600': ['wi-snow', 'wi-snow'],
        '601': ['wi-snow', 'wi-snow'],
        '602': ['wi-snow', 'wi-snow'],
        '611': ['wi-sleet', 'wi-sleet'],
        '612': ['wi-sleet', 'wi-sleet'],
        '615': ['wi-rain-mix', 'wi-rain-mix'],
        '616': ['wi-rain-mix', 'wi-rain-mix'],
        '620': ['wi-rain-mix', 'wi-rain-mix'],
        '621': ['wi-rain-mix', 'wi-rain-mix'],
        '622': ['wi-rain-mix', 'wi-rain-mix'],

        '701': ['wi-fog', 'wi-fog'],
        '711': ['wi-smoke', 'wi-smoke'],
        '721': ['wi-fog', 'wi-fog'],
        '731': ['wi-dust', 'wi-dust'],
        '741': ['wi-fog', 'wi-fog'],
        '751': ['wi-dust', 'wi-dust'],
        '761': ['wi-dust', 'wi-dust'],
        '762': ['wi-volcano', 'wi-volcano'],
        '771': ['wi-strong-wind', 'wi-strong-wind'],
        '781': ['wi-tornado', 'wi-tornado'],

        '800': ['wi-day-sunny', 'wi-night-clear'],
        '801': ['wi-day-sunny-overcast', 'wi-night-partly-cloudy'],
        '802': ['wi-day-cloudy', 'wi-night-cloudy'],
        '803': ['wi-cloudy', 'wi-cloudy'],
        '804': ['wi-cloudy', 'wi-cloudy'],

        '900': ['wi-tornado', 'wi-tornado'],
        '901': ['wi-windy', 'wi-windy'],
        '902': ['wi-hurricane', 'wi-hurricane'],
        '903': ['wi-snowflake-cold', 'wi-snowflake-cold'],
        '904': ['wi-hot', 'wi-hot'],
        '905': ['wi-windy', 'wi-windy'],
        '906': ['wi-hail', 'wi-hail'],

        // TODO better understand and fill proper icons
        '950': ['wi-sunset', 'wi-sunset'],
        '951': ['wi-day-sunny', 'wi-night-clear'],
        '952': ['wi-windy', 'wi-windy'],
        '953': ['wi-windy', 'wi-windy'],
        '954': ['wi-windy', 'wi-windy'],
        '955': ['wi-windy', 'wi-windy'],
        '956': ['wi-windy', 'wi-windy'],
        '957': ['wi-windy', 'wi-windy'],
        '958': ['wi-windy', 'wi-windy'],
        '959': ['wi-windy', 'wi-windy'],
        '960': ['wi-windy', 'wi-windy'],
        '961': ['wi-windy', 'wi-windy'],
        '962': ['wi-windy', 'wi-windy']
    }
}

var MetNo = {
    IconCode: null,
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

MetNo.IconCode = Object.keys(MetNo.NameToCode).map(function(iconName){
    return parseInt(MetNo.NameToCode[iconName]);
});

var MetNoWeatherIcon = {
    iconIdByOwmCode: {
        200: /*rainshowersandthunder*/ 6,
        201: /*lightrainshowersandthunder*/ 24,
        202: /*heavyrainshowersandthunder*/ 25,
        210: /*rainshowersandthunder*/ 6,
        211: /*lightrainshowersandthunder*/ 24,
        212: /*heavyrainshowersandthunder*/ 25,
        221: /*heavyrainshowersandthunder*/ 25,
        230: /*rainshowersandthunder*/ 6,
        231: /*lightrainshowersandthunder*/ 24,
        232: /*heavyrainshowersandthunder*/ 25,

        300: /*lightrainshowers*/ 40,
        301: /*rainshowers*/ 5,
        302: /*heavyrainshowers*/ 41,
        310: /*lightrainshowers*/ 40,
        311: /*rainshowers*/ 5,
        312: /*heavyrainshowers*/ 41,
        313: /*rainshowers*/ 5,
        314: /*heavyrainshowers*/ 41,
        321: /*rainshowers*/ 5,

        500: /*lightrainshowers*/ 40,
        501: /*rainshowers*/ 5,
        502: /*heavyrainshowers*/ 41,
        503: /*heavyrainshowers*/ 41,
        504: /*heavyrainshowers*/ 41,
        511: /*sleetshowers*/ 7,
        520: /*lightrainshowers*/ 40,
        521: /*rainshowers*/ 5,
        522: /*heavyrainshowers*/ 41,
        531: /*heavyrainshowers*/ 41,

        600: /*lightsnowshowers*/ 44,
        601: /*snowshowers*/ 8,
        602: /*heavysnowshowers*/ 45,
        611: /*sleet*/ 12,
        612: /*lightsleetshowers*/ 42,
        613: /*sleetshowers*/ 7,
        615: /*lightsleetshowers*/ 42,
        616: /*sleetshowers*/ 7,
        620: /*lightsnowshowers*/ 44,
        621: /*snowshowers*/ 8,
        622: /*heavysnowshowers*/ 45,

        701: /*fog*/ 15,
        711: /*fog*/ 15,
        721: /*fog*/ 15,
        731: /*fog*/ 15,
        741: /*fog*/ 15,
        751: /*fog*/ 15,
        761: /*fog*/ 15,
        762: /*fog*/ 15,
        771: /*fog*/ 15,
        781: /*fog*/ 15,

        800: /*clearsky*/ 1,

        801: /*partlycloudy*/ 4,
        802: /*partlycloudy*/ 4,
        803: /*partlycloudy*/ 4,
        804: /*partlycloudy*/ 4
    }
}

var BasmiliusWeatherIcon = {
    IconNames: null,
    iconNameByYrNoCode: {
        '1':  ['clear-day', 'clear-night'],
        '2':  ['overcast-day', 'overcast-night'],
        '3':  ['partly-cloudy-day', 'partly-cloudy-night'],
        '4':  ['cloudy', 'cloudy'],
        '5':  ['partly-cloudy-day-rain', 'partly-cloudy-night-rain'],
        '6':  ['thunderstorms-day-overcast-rain', 'thunderstorms-night-overcast-rain'],
        '7':  ['overcast-day-sleet', 'overcast-night-sleet'],
        '8':  ['overcast-day-snow', 'overcast-night-snow'],
        '9':  ['rain', 'rain'],
        '10': ['extreme-rain', 'extreme-rain'],
        '11': ['thunderstorms-extreme-rain', 'thunderstorms-extreme-rain'],
        '12': ['sleet', 'sleet'],
        '13': ['snow', 'snow'],
        '14': ['thunderstorms-snow', 'thunderstorms-snow'],
        '15': ['fog', 'fog'],
        '20': ['overcast-day-sleet', 'overcast-night-sleet'],
        '21': ['thunderstorms-day-snow', 'thunderstorms-night-snow'],
        '22': ['thunderstorms-rain', 'thunderstorms-rain'],
        '23': ['thunderstorms-rain', 'thunderstorms-rain'],   // TODO no icon for Sleet and thunder
        '24': ['thunderstorms-day-rain', 'thunderstorms-night-rain'],
        '25': ['thunderstorms-day-extreme-rain', 'thunderstorms-night-extreme-rain'],
        '26': ['thunderstorms-day-rain', 'thunderstorms-night-rain'], //TODO no icon for Light sleet showers and thunder
        '27': ['thunderstorms-day-extreme-rain', 'thunderstorms-night-extreme-rain'], // TODO no icon for Heavy sleet showers and thunder
        '28': ['thunderstorms-day-snow', 'thunderstorms-night-snow'],
        '29': ['thunderstorms-day-extreme-snow', 'thunderstorms-night-extreme-snow'],
        '30': ['thunderstorms-rain', 'thunderstorms-rain'],
        '31': ['thunderstorms-rain', 'thunderstorms-rain'], // TODO no icon for Light sleet and thunder
        '32': ['thunderstorms-extreme-rain', 'thunderstorms-extreme-rain'], // TODO no icon for Heavy sleet and thunder
        '33': ['thunderstorms-snow', 'thunderstorms-snow'],
        '34': ['thunderstorms-extreme-snow', 'thunderstorms-extreme-snow'],
        '40': ['overcast-day-rain', 'overcast-night-rain'],
        '41': ['extreme-day-rain', 'extreme-night-rain'],
        '42': ['partly-cloudy-day-sleet', 'partly-cloudy-night-sleet'],
        '43': ['extreme-day-sleet', 'extreme-night-sleet'],
        '44': ['overcast-day-sleet', 'overcast-night-sleet'],
        '45': ['extreme-day-snow', 'extreme-night-snow'],
        '46': ['rain', 'rain'],
        '47': ['sleet', 'sleet'],
        '48': ['extreme-sleet', 'extreme-sleet'],
        '49': ['snow', 'snow'],
        '50': ['extreme-snow', 'extreme-snow']
    },

    iconNameByOwmCode: {
        200: ['thunderstorms-day-rain', 'thunderstorms-night-rain'],
        201: ['thunderstorms-day-overcast-rain', 'thunderstorms-night-overcast-rain'],
        202: ['thunderstorms-day-extreme-rain', 'thunderstorms-day-extreme-rain'],
        210: ['thunderstorms-day', 'thunderstorms-night'],
        211: ['thunderstorms-day-overcast', 'thunderstorms-night-overcast'],
        212: ['thunderstorms-day-extreme', 'thunderstorms-night-extreme'],
        221: ['thunderstorms-day-extreme', 'thunderstorms-night-extreme'],
        230: ['thunderstorms-day-rain', 'thunderstorms-night-rain'],
        231: ['thunderstorms-day-overcast-rain', 'thunderstorms-night-overcast-rain'],
        232: ['thunderstorms-day-extreme-rain', 'thunderstorms-day-extreme-rain'],

        300: ['partly-cloudy-day-rain', 'partly-cloudy-night-rain'],
        301: ['overcast-day-rain', 'overcast-night-rain'],
        302: ['extreme-day-rain', 'extreme-night-rain'],
        310: ['extreme-day-rain', 'extreme-night-rain'],
        311: ['partly-cloudy-day-rain', 'partly-cloudy-night-rain'],
        312: ['extreme-day-rain', 'extreme-night-rain'],
        313: ['overcast-day-rain', 'overcast-night-rain'],
        314: ['extreme-day-rain', 'extreme-night-rain'],
        321: ['overcast-day-rain', 'overcast-night-rain'],

        500: ['partly-cloudy-day-rain', 'partly-cloudy-night-rain'],
        501: ['overcast-day-rain', 'overcast-night-rain'],
        502: ['extreme-day-rain', 'extreme-night-rain'],
        503: ['extreme-day-rain', 'extreme-night-rain'],
        504: ['extreme-day-rain', 'extreme-night-rain'],
        511: ['overcast-day-sleet', 'overcast-night-sleet'],
        520: ['partly-cloudy-day-rain', 'partly-cloudy-night-rain'],
        521: ['overcast-day-rain', 'overcast-night-rain'],
        522: ['extreme-day-rain', 'extreme-night-rain'],
        531: ['extreme-day-rain', 'extreme-night-rain'],

        600: ['partly-cloudy-day-snow', 'partly-cloudy-night-snow'],
        601: ['overcast-day-snow', 'overcast-night-snow'],
        602: ['extreme-day-snow', 'extreme-night-snow'],
        611: ['extreme-day-snow', 'extreme-night-snow'],
        612: ['partly-cloudy-day-sleet', 'partly-cloudy-night-sleet'],
        613: ['overcast-day-sleet', 'overcast-night-sleet'],
        615: ['partly-cloudy-day-sleet', 'partly-cloudy-night-sleet'],
        616: ['overcast-day-sleet', 'overcast-night-sleet'],
        620: ['partly-cloudy-day-sleet', 'partly-cloudy-night-sleet'],
        621: ['overcast-day-sleet', 'overcast-night-sleet'],
        622: ['extreme-day-sleet', 'extreme-night-sleet'],

        701: ['mist', 'mist'],
        711: ['partly-cloudy-day-smoke', 'partly-cloudy-night-smoke'],
        721: ['partly-cloudy-day-haze', 'partly-cloudy-night-haze'],
        731: ['dust-day', 'dust-night'],
        741: ['fog-day', 'fog-night'],
        751: ['dust-day', 'dust-night'],
        761: ['dust-day', 'dust-night'],
        762: ['dust-day', 'dust-night'],
        771: ['dust-day', 'dust-night'],
        781: ['tornado', 'tornado'],

        800: ['clear-day', 'clear-night'],
        801: ['partly-cloudy-day', 'partly-cloudy-night'],
        802: ['partly-cloudy-day', 'partly-cloudy-night'],
        803: ['partly-cloudy-day', 'partly-cloudy-night'],
        804: ['partly-cloudy-day', 'partly-cloudy-night'],
    }
}

if (BasmiliusWeatherIcon.IconNames === null) {
    print("BasmiliusWeatherIcon.IconNames")
    BasmiliusWeatherIcon.IconNames = []
    Object.keys(BasmiliusWeatherIcon.iconNameByYrNoCode).forEach(function(yrNoCode){
        let iconName = BasmiliusWeatherIcon.iconNameByYrNoCode[yrNoCode][0]
        if (!BasmiliusWeatherIcon.IconNames.includes(iconName)) {
            BasmiliusWeatherIcon.IconNames.push(iconName)
        }
        iconName = BasmiliusWeatherIcon.iconNameByYrNoCode[yrNoCode][1]
        if (!BasmiliusWeatherIcon.IconNames.includes(iconName)) {
            BasmiliusWeatherIcon.IconNames.push(iconName)
        }
    });

    Object.keys(BasmiliusWeatherIcon.iconNameByOwmCode).forEach(function(yrNoCode){
        let iconName = BasmiliusWeatherIcon.iconNameByOwmCode[yrNoCode][0]
        if (!BasmiliusWeatherIcon.IconNames.includes(iconName)) {
            BasmiliusWeatherIcon.IconNames.push(iconName)
        }
        iconName = BasmiliusWeatherIcon.iconNameByOwmCode[yrNoCode][1]
        if (!BasmiliusWeatherIcon.IconNames.includes(iconName)) {
            BasmiliusWeatherIcon.IconNames.push(iconName)
        }
    });
}

var BreezeIcons = {

    iconNameByYrNoCode: {
        '1': ['weather-clear', 'weather-clear-night'],
        '4': ['weather-clouds', 'weather-clouds-night'],
        '2': ['weather-few-clouds', 'weather-few-clouds-night'],
        '15': ['weather-fog', 'weather-fog'],
        '10': ['weather-showers', 'weather-showers'],
        '11': ['weather-storm-day', 'weather-storm-night'],
        '41': ['weather-showers-day', 'weather-showers-night'],
        '25': ['weather-storm-day', 'weather-storm-night'],
        '48': ['weather-snow-rain', 'weather-snow-rain'],
        '32': ['weather-storm', 'weather-storm'],
        '43': ['weather-snow-rain', 'weather-snow-rain'],
        '27': ['weather-storm-day', 'weather-storm-night'],
        '50': ['weather-snow', 'weather-snow'],
        '34': ['weather-storm', 'weather-storm'],
        '45': ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        '29': ['weather-storm-day', 'weather-storm-night'],
        '46': ['weather-showers-scattered', 'weather-showers-scattered'],
        '30': ['weather-storm', 'weather-storm'],
        '40': ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        '24': ['weather-storm-day', 'weather-storm-night'],
        '47': ['weather-snow-rain', 'weather-snow-rain'],
        '24': ['weather-storm-day', 'weather-storm-night'],
        '47': ['weather-snow-rain', 'weather-snow-rain'],
        '31': ['weather-storm', 'weather-storm'],
        '42': ['weather-snow-rain', 'weather-snow-rain'],
        '49': ['weather-snow-scattered', 'weather-snow-scattered'],
        '33': ['weather-storm', 'weather-storm'],
        '44': ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        '26': ['weather-storm-day', 'weather-storm-night'],
        '28': ['weather-storm-day', 'weather-storm-night'],
        '3': ['weather-few-clouds', 'weather-few-clouds-night'],
        '9': ['weather-showers', 'weather-showers'],
        '22': ['weather-storm', 'weather-storm'],
        '5': ['weather-showers-day', 'weather-showers-night'],
        '6': ['weather-storm-day', 'weather-storm-night'],
        '12': ['weather-snow-rain', 'weather-snow-rain'],
        '23': ['weather-storm', 'weather-storm'],
        '7': ['weather-snow-rain', 'weather-snow-rain'],
        '20': ['weather-storm-day', 'weather-storm-night'],
        '13': ['weather-snow', 'weather-snow'],
        '14': ['weather-storm', 'weather-storm'],
        '8': ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        '21': ['weather-storm-day', 'weather-storm-night']
    },

    iconNameByOwmCode: {
        200: ['weather-storm-day', 'weather-storm-night'],
        201: ['weather-storm-day', 'weather-storm-night'],
        202: ['weather-storm-day', 'weather-storm-night'],
        210: ['weather-storm-day', 'weather-storm-night'],
        211: ['weather-storm-day', 'weather-storm-night'],
        212: ['weather-storm-day', 'weather-storm-night'],
        221: ['weather-storm-day', 'weather-storm-night'],
        230: ['weather-storm-day', 'weather-storm-night'],
        231: ['weather-storm-day', 'weather-storm-night'],
        232: ['weather-storm-day', 'weather-storm-night'],

        300: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        301: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        302: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        310: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        311: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        312: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        313: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        314: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],
        321: ['weather-showers-scattered-day', 'weather-showers-scattered-night'],

        500: ['weather-showers-day', 'weather-showers-night'],
        501: ['weather-showers-day', 'weather-showers-night'],
        502: ['weather-showers-day', 'weather-showers-night'],
        503: ['weather-showers-day', 'weather-showers-night'],
        504: ['weather-showers-day', 'weather-showers-night'],
        511: ['weather-showers-day', 'weather-showers-night'],
        520: ['weather-showers-day', 'weather-showers-night'],
        521: ['weather-showers-day', 'weather-showers-night'],
        522: ['weather-showers-day', 'weather-showers-night'],
        531: ['weather-showers-day', 'weather-showers-night'],

        600: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        601: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        602: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        611: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        612: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        613: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        615: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        616: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        620: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        621: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],
        622: ['weather-snow-scattered-day', 'weather-snow-scattered-night'],

        701: ['weather-mist', 'weather-mist'],
        711: ['weather-fog', 'weather-fog'],
        721: ['weather-fog', 'weather-fog'],
        731: ['weather-fog', 'weather-fog'],
        741: ['weather-fog', 'weather-fog'],
        751: ['weather-fog', 'weather-fog'],
        761: ['weather-fog', 'weather-fog'],
        762: ['weather-fog', 'weather-fog'],
        771: ['weather-fog', 'weather-fog'],
        781: ['weather-fog', 'weather-fog'],

        800: ['weather-clear', 'weather-clear-night'],
        801: ['weather-few-clouds', 'weather-few-clouds-night'],
        802: ['weather-few-clouds', 'weather-few-clouds-night'],
        803: ['weather-clouds', 'weather-clouds-night'],
        804: ['weather-clouds', 'weather-clouds-night'],
    }
}

function getIconCode(iconName, providerId, partOfDay) {
    var iconCodeParts = null
    if (providerId === 'yrno') {
        iconCodeParts = WeatherFont.iconNameByYrNoCode[iconName]
    } else if (providerId === 'owm') {
        iconCodeParts = WeatherFont.iconNameByOwmCode[iconName]
    } else if (providerId === 'metno') {
        iconCodeParts = WeatherFont.iconNameByYrNoCode[iconName]
    }
    if (!iconCodeParts) {
        return '\uf07b'
    }
    return WeatherFont.codeByName[iconCodeParts[partOfDay]]
}

function getSunriseIcon() {
    return '\uf052'
}

function getSunsetIcon() {
    return '\uf051'
}

function getYrNoDescription(code) {
    const descriptionByCode = {
        1: i18n("Clear sky"),
        4: i18n("Cloudy"),
        2: i18n("Fair"),
        15: i18n("Fog"),
        10: i18n("Heavy rain"),
        11: i18n("Heavy rain and thunder"),
        41: i18n("Heavy rain showers"),
        25: i18n("Heavy rain showers and thunder"),
        48: i18n("Heavy sleet"),
        32: i18n("Heavy sleet and thunder"),
        43: i18n("Heavy sleet showers"),
        27: i18n("Heavy sleet showers and thunder"),
        50: i18n("Heavy snow"),
        34: i18n("Heavy snow and thunder"),
        45: i18n("Heavy snow showers"),
        29: i18n("Heavy snow showers and thunder"),
        46: i18n("Light rain"),
        30: i18n("Light rain and thunder"),
        40: i18n("Light rain showers"),
        24: i18n("Light rain showers and thunder"),
        47: i18n("Light sleet"),
        31: i18n("Light sleet and thunder"),
        42: i18n("Light sleet showers"),
        49: i18n("Light snow"),
        33: i18n("Light snow and thunder"),
        44: i18n("Light snow showers"),
        26: i18n("Light sleet showers and thunder"),
        28: i18n("Light snow showers and thunder"),
        3: i18n("Partly cloudy"),
        9: i18n("Rain"),
        22: i18n("Rain and thunder"),
        5: i18n("Rain showers"),
        6: i18n("Rain showers and thunder"),
        12: i18n("Sleet"),
        23: i18n("Sleet and thunder"),
        7: i18n("Sleet showers"),
        20: i18n("Sleet showers and thunder"),
        13: i18n("Snow"),
        14: i18n("Snow and thunder"),
        8: i18n("Snow showers"),
        21: i18n("Snow showers and thunder")
    }
    return descriptionByCode[code]
}

function getOwmDescription(code) {
    const descriptionByCode = {
        200: i18n("Thunderstorm with light rain"),
        201: i18n("Thunderstorm with rain"),
        202: i18n("Thunderstorm with heavy rain"),
        210: i18n("Light thunderstorm"),
        211: i18n("Thunderstorm"),
        212: i18n("Heavy thunderstorm"),
        221: i18n("Ragged thunderstorm"),
        230: i18n("Thunderstorm with light drizzle"),
        231: i18n("Thunderstorm with drizzle"),
        232: i18n("Thunderstorm with heavy drizzle "),
        300: i18n("Light intensity drizzle"),
        301: i18n("Drizzle"),
        302: i18n("Heavy intensity drizzle"),
        310: i18n("Light intensity drizzle rain"),
        311: i18n("Drizzle rain"),
        312: i18n("Heavy intensity drizzle rain"),
        313: i18n("Shower rain and drizzle"),
        314: i18n("Heavy shower rain and drizzle"),
        321: i18n("Shower drizzle "),
        500: i18n("Light rain"),
        501: i18n("Moderate rain"),
        502: i18n("Heavy intensity rain"),
        503: i18n("Very heavy rain"),
        504: i18n("Extreme rain"),
        511: i18n("Freezing rain"),
        520: i18n("Light intensity shower rain"),
        521: i18n("Shower rain"),
        522: i18n("Heavy intensity shower rain"),
        531: i18n("Ragged shower rain "),
        600: i18n("Light snow"),
        601: i18n("Snow"),
        602: i18n("Heavy snow"),
        611: i18n("Sleet"),
        612: i18n("Light shower sleet"),
        613: i18n("Shower sleet"),
        615: i18n("Light rain and snow"),
        616: i18n("Rain and snow"),
        620: i18n("Light shower snow"),
        621: i18n("Shower snow"),
        622: i18n("Heavy shower snow "),
        701: i18n("Mist"),
        711: i18n("Smoke"),
        721: i18n("Haze"),
        731: i18n("Sand/ dust whirls"),
        741: i18n("Fog"),
        751: i18n("Sand"),
        761: i18n("Dust"),
        762: i18n("Volcanic ash"),
        771: i18n("Squalls"),
        781: i18n("Tornado "),
        800: i18n("Clear sky "),
        801: i18n("Few clouds: 11-25%"),
        802: i18n("Scattered clouds: 25-50%"),
        803: i18n("Broken clouds: 51-84%"),
        804: i18n("Overcast clouds: 85-100%")
    }
    return descriptionByCode[code]
}

function getIconDescription(iconName, providerId, partOfDay) {
    if (providerId === 'yrno') {
        return getYrNoDescription(iconName)
    } else if (providerId === 'owm') {
        return getOwmDescription(iconName)
    } else if (providerId === 'metno') {
        return getYrNoDescription(iconName)
    }
    return 'N/A'
}

function hasMetNoPartOfDay(iconId) {
    const p = [1, 2, 3, 5, 6, 7, 8, 20, 21, 24, 25, 26, 27, 28, 29, 40, 41, 42, 43, 44, 45]
    return p.includes(iconId)
}

function getMetNoIconImage(iconName, providerId, partOfDay) {
    let iconId = null

    if (providerId === 'yrno' || providerId === 'metno') {
        iconId = parseInt(iconName)
    } else if (providerId === 'owm') {
        iconId = MetNoWeatherIcon.iconIdByOwmCode[iconName]
    }

    if (!MetNo.IconCode.includes(iconId)) {
        return null
    }

    let filename = iconId.toString().padStart(2, '0')
    let pod = !hasMetNoPartOfDay(iconId) ? "" : (partOfDay == 0 ? "d" : "n")
    let path = "yr-weather-symbols/" + filename + pod + ".png"
    return path
}

function getBasmiliusIconImage(iconName, providerId, partOfDay) {
    var iconCodeParts = null
    if (providerId === 'yrno' || providerId === 'metno') {
        iconCodeParts = BasmiliusWeatherIcon.iconNameByYrNoCode[iconName]
    } else if (providerId === 'owm') {
        iconCodeParts = BasmiliusWeatherIcon.iconNameByOwmCode[iconName]
    }

    if (!iconCodeParts) {
        return null
    }

    let filename = iconCodeParts[partOfDay]
    if (!BasmiliusWeatherIcon.IconNames.includes(filename)) {
        return null
    }

    return "basmilius/weather-icons/" + filename + ".png"
}

function getBreezeIcon(iconName, providerId, partOfDay) {
    var iconCodeParts = null
    if (providerId === 'yrno' || providerId === 'metno') {
        iconCodeParts = BreezeIcons.iconNameByYrNoCode[iconName]
    } else if (providerId === 'owm' || providerId === 'owm2') {
        iconCodeParts = BreezeIcons.iconNameByOwmCode[iconName]
    }

    if (!iconCodeParts) {
        return null
    }

    return iconCodeParts[partOfDay]
}
