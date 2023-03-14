import QtQuick 2.0

QtObject {
    id: mockPlasmoid

    property int id: 10

    property var configuration: ({
        reloadIntervalMin: 1
    })
}
