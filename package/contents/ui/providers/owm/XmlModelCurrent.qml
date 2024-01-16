import QtQuick.XmlListModel 2.0

XmlListModelAdapter {
    id: xmlModelCurrent
    query: '/current'

    XmlRole {
        name: 'temperature'
        query: 'temperature/@value/number()'
    }
    XmlRole {
        name: 'iconName'
        query: 'weather/@number/string()'
    }
    XmlRole {
        name: 'humidity'
        query: 'humidity/@value/number()'
    }
    XmlRole {
        name: 'pressureHpa'
        query: 'pressure/@value/number()'
    }
    XmlRole {
        name: 'windSpeedMps'
        query: 'wind/speed/@value/number()'
    }
    XmlRole {
        name: 'windDirection'
        query: 'wind/direction/@value/number()'
    }
    XmlRole {
        name: 'cloudiness'
        query: 'clouds/@value/number()'
    }
    XmlRole {
        name: 'updated'
        query: 'lastupdate/@value/string()'
    }
    XmlRole {
        name: 'rise'
        query: 'city/sun/@rise/string()'
    }
    XmlRole {
        name: 'set'
        query: 'city/sun/@set/string()'
    }
}
