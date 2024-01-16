import QtQuick.XmlListModel 2.0

XmlListModelAdapter {
    id: xmlModelHourByHour
    query: '/weatherdata/forecast/time'

    XmlRole {
        name: 'from'
        query: '@from/string()'
    }
    XmlRole {
        name: 'to'
        query: '@to/string()'
    }
    XmlRole {
        name: 'temperature'
        query: 'temperature/@value/number()'
    }
    XmlRole {
        name: 'feelsLike'
        query: 'feels_like/@value/number()'
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
        name: 'precipitationProb'
        query: 'precipitation/@probability/number()'
    }
    XmlRole {
        name: 'precipitationValue'
        query: 'precipitation/@value/number()'
    }
    XmlRole {
        name: 'humidity'
        query: 'humidity/@value/number()'
    }
    XmlRole {
        name: 'clouds'
        query: 'clouds/@all/number()'
    }
}
