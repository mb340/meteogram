import QtQuick 2.0

QtObject {
    id: mockMain

    function reloadData() {
        print("mockMain: reloadData")
    }

    function loadFromCache() {
        print("mockMain: loadFromCache")
    }
}
