import QtQuick.XmlListModel 2.0

XmlListModelAdapter {
    id: xmlModelLongTerm
    query: '/weatherdata/forecast/time'

    XmlRole {
        name: 'date'
        query: '@day/string()'
    }
    XmlRole {
        name: 'temperatureMin'
        query: 'temperature/@min/number()'
    }
    XmlRole {
        name: 'temperatureMax'
        query: 'temperature/@max/number()'
    }
    XmlRole {
        name: 'temperatureMorning'
        query: 'temperature/@morn/number()'
    }
    XmlRole {
        name: 'temperatureDay'
        query: 'temperature/@day/number()'
    }
    XmlRole {
        name: 'temperatureEvening'
        query: 'temperature/@eve/number()'
    }
    XmlRole {
        name: 'temperatureNight'
        query: 'temperature/@night/number()'
    }
    XmlRole {
        name: 'feelsLikeDay'
        query: 'feels_like/@day/number()'
    }
    XmlRole {
        name: 'feelsLikeEvening'
        query: 'feels_like/@eve/number()'
    }
    XmlRole {
        name: 'feelsLikeNight'
        query: 'feels_like/@night/number()'
    }
    XmlRole {
        name: 'feelsLikeMorn'
        query: 'feels_like/@morn/number()'
    }
    XmlRole {
        name: 'iconName'
        query: 'symbol/@number/string()'
    }
    XmlRole {
        name: 'windDirection'
        query: 'windDirection/@deg/number()'
    }
    XmlRole {
        name: 'windSpeedMps'
        query: 'windSpeed/@mps/number()'
    }
    XmlRole {
        name: 'windGust'
        query: 'windGust/@gust/number()'
    }
    XmlRole {
        name: 'pressureHpa'
        query: 'pressure/@value/number()'
    }
    XmlRole {
        name: 'humidity'
        query: 'humidity/@value/number()'
    }
    XmlRole {
        name: 'clouds'
        query: 'clouds/@all/number()'
    }
    XmlRole {
        name: 'precipitationProb'
        query: 'precipitation/@probability/number()'
    }
    XmlRole {
        name: 'precipitationValue'
        query: 'precipitation/@value/number()'
    }
    XmlRole {
        name: 'precipitationType'
        query: 'precipitation/@type/string()'
    }
}
