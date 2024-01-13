import QtQml.XmlListModel

XmlListModelAdapter {
    query: '/current'

    XmlListModelRole {
        name: 'timezone'
        elementName: 'city/timezone'
    }

    XmlListModelRole {
        name: 'temperature'
        // query: 'temperature/@value/number()'
        elementName: 'temperature'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'iconName'
        // query: 'weather/@number/string()'
        elementName: 'weather'
        attributeName: 'number'
    }
    XmlListModelRole {
        name: 'humidity'
        // query: 'humidity/@value/number()'
        elementName: 'humidity'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'pressureHpa'
        // query: 'pressure/@value/number()'
        elementName: 'pressure'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'windSpeedMps'
        // query: 'wind/speed/@value/number()'
        elementName: 'wind/speed'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'windDirection'
        // query: 'wind/direction/@value/number()'
        elementName: 'wind/direction'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'cloudiness'
        // query: 'clouds/@value/number()'
        elementName: 'clouds'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'updated'
        // query: 'lastupdate/@value/string()'
        elementName: 'lastupdate'
        attributeName: 'value'
    }
    XmlListModelRole {
        name: 'rise'
        // query: 'city/sun/@rise/string()'
        elementName: 'city/sun'
        attributeName: 'rise'
    }
    XmlListModelRole {
        name: 'set'
        // query: 'city/sun/@set/string()'
        elementName: 'city/sun'
        attributeName: 'set'
    }
}