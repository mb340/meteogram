import QtQuick 2.0

QtObject {
    id: mockMain

    property var cacheKey: "123"

    property var currentProvider: null

    property string placeIdentifier: "Mock Place"
    property int timezoneID: 88


    function reloadData() {
        print("mockMain: reloadData")
    }

    function loadFromCache() {
        print("mockMain: loadFromCache")
    }
}
