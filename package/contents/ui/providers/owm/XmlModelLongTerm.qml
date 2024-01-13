import QtQml.XmlListModel

XmlListModelAdapter {
    id: xmlModelLongTerm
    query: '/weatherdata/forecast/time'

    XmlListModelRole {
        name: 'date'
        attributeName: 'day'
    }
    XmlListModelRole {
        name: 'temperatureMin'
        // query: 'temperature/@min/number()'
        elementName: 'temperature'
        attributeName: 'min'
    }
    XmlListModelRole {
        name: 'temperatureMax'
        // query: 'temperature/@max/number()'
        elementName: 'temperature'
        attributeName: 'max'
    }
    XmlListModelRole {
        name: 'temperatureMorning'
        // query: 'temperature/@morn/number()'
        elementName: 'temperature'
        attributeName: 'morn'
    }
    XmlListModelRole {
        name: 'temperatureDay'
        // query: 'temperature/@day/number()'
        elementName: 'temperature'
        attributeName: 'day'
    }
    XmlListModelRole {
        name: 'temperatureEvening'
        // query: 'temperature/@eve/number()'
        elementName: 'temperature'
        attributeName: 'eve'
    }
    XmlListModelRole {
        name: 'temperatureNight'
        // query: 'temperature/@night/number()'
        elementName: 'temperature'
        attributeName: 'night'
    }
    XmlListModelRole {
        name: 'feelsLikeDay'
        // query: 'feels_like/@day/number()'
        elementName: 'feels_like'
        attributeName: 'day'
    }
    XmlListModelRole {
        name: 'feelsLikeEvening'
        // query: 'feels_like/@eve/number()'
        elementName: 'feels_like'
        attributeName: 'eve'
    }
    XmlListModelRole {
        name: 'feelsLikeNight'
        // query: 'feels_like/@night/number()'
        elementName: 'feels_like'
        attributeName: 'night'
    }
    XmlListModelRole {
        name: 'feelsLikeMorn'
        // query: 'feels_like/@morn/number()'
        elementName: 'feels_like'
        attributeName: 'morn'
    }
    XmlListModelRole {
        name: 'iconName'
        // query: 'symbol/@number/string()'
        elementName: 'symbol'
        attributeName: 'number'
    }
    XmlListModelRole {
        name: 'windDirection'
        // query: 'windDirection/@deg/number()'
        elementName: 'windDirection'
        attributeName: 'deg'
    }
    XmlListModelRole {
        name: 'windSpeedMps'
        // query: 'windSpeed/@mps/number()'
        elementName: 'windSpeed'
        attributeName: 'mps'
    }
    XmlListModelRole {
        name: 'windGust'
        // query: 'windGust/@gust/number()'
        elementName: 'windGust'
        attributeName: 'gust'
    }
    XmlListModelRole {
        name: 'pressureHpa'
        // query: 'pressure/@value/number()'
        elementName: 'pressure'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'humidity'
        // query: 'humidity/@value/number()'
        elementName: 'humidity'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'clouds'
        // query: 'clouds/@all/number()'
        elementName: 'clouds'
        attributeName: 'all'
    }
    XmlListModelRole {
        name: 'precipitationProb'
        // query: 'precipitation/@probability/number()'
        elementName: 'precipitation'
        attributeName: 'probability'
    }
    XmlListModelRole {
        name: 'precipitationValue'
        // query: 'precipitation/@value/number()'
        elementName: 'precipitation'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'precipitationType'
        // query: 'precipitation/@type/string()'
        elementName: 'precipitation'
        attributeName: 'type'
    }
}