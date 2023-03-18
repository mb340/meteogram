import QtQuick 2.0

QtObject {
    id: mockMain

    property var plasmoidCacheId: 0

    property var cacheKey: "123"

    property var currentProvider: null

    property string placeIdentifier: "Mock Place"
    property int timezoneID: 88

    function loadFromCache() {
        print("mockMain: loadFromCache")
    }
}
