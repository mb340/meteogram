import QtQuick.XmlListModel 2.0

XmlListModel {
    id: xmlListModel

    required property var handleStatusChanged

    onStatusChanged: {
        handleStatusChanged(xmlListModel)
    }
}
