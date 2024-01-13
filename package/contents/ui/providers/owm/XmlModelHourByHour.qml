import QtQml.XmlListModel

XmlListModelAdapter {
    query: '/weatherdata/forecast/time'

    XmlListModelRole {
        name: 'from'
        // query: '@from/string()'
        attributeName: 'from'
    }
    XmlListModelRole {
        name: 'to'
        // query: '@to/string()'
        attributeName: 'to'
    }
    XmlListModelRole {
        name: 'temperature'
        // query: 'temperature/@value/number()'
        elementName: 'temperature'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'feelsLike'
        // query: 'feels_like/@value/number()'
        elementName: 'feels_like'
        attributeName: 'value'
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
}