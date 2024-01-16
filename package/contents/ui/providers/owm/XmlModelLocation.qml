import QtQuick.XmlListModel 2.0

XmlListModelAdapter {
    id: xmlModelLocation
    query: '/weatherdata/location'

    XmlRole {
        name: 'name'
        query: 'name/string()'
    }

    XmlRole {
        name: 'timezone'
        query: 'timezone/number()'
    }
}
