import QtQuick

QtObject {
    id: mockPlasmoid

    property int id: 10

    property var configuration: ({
        reloadIntervalHours: 1
    })
}
