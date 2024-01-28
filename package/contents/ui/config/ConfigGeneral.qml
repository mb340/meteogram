import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "../../code/config-utils.js" as ConfigUtils
import "../../code/placesearch-helpers.js" as Helper


KCM.SimpleKCM {
    id: configGeneral

    property alias cfg_reloadIntervalHours: reloadIntervalHours.value
    property string cfg_places
    property alias cfg_debugLogging: debugLogging.checked

    property var editEntryNumber: -1

    property bool isPlacesModelLoading: false
    property var placesModel: null

    Component {
        id: placesModelComponent
        ListModel {
            id: placesModel
            Component.onCompleted: {
                var places = ConfigUtils.getPlacesArray()
                places.forEach(function (placeObj) {
                    placesModel.append({
                           providerId: placeObj.providerId,
                           placeIdentifier: ConfigUtils.formatPlaceIdentifier(placeObj),
                           placeAlias: placeObj.placeAlias,
                           latitude: parseFloat(placeObj.latitude),
                           longitude: parseFloat(placeObj.longitude),
                           altitude: parseInt(placeObj.altitude),
                           timezoneID: (placeObj.timezoneID !== undefined) ?
                                        parseInt(placeObj.timezoneID) : -1,
                       })
                })
                configGeneral.placesModel = placesModel
            }
        }
    }

    Component.onCompleted: {
        if (!isPlacesModelLoading) {
            isPlacesModelLoading = true
            const incubator = placesModelComponent.incubateObject(this);
        }
    }


    function _placesModelChanged() {
        var newPlacesArray = []
        for (var i = 0; i < placesModel.count; i++) {
            var placeObj = placesModel.get(i)
            placeObj = JSON.stringify(placeObj)
            placeObj = JSON.parse(placeObj)
            newPlacesArray.push(placeObj)
        }
        cfg_places = JSON.stringify(newPlacesArray)
        print('[weatherWidget] places: ' + cfg_places)
    }

    function showEditDialog() {
        editEntryNumber = tableView.selectionModel.selectedIndexes[0].row
        let entry = placesModel.get(editEntryNumber)
        let hasAltitude = (entry.providerId === "metno")
        if (entry.providerId === "metno" ||
            entry.providerId === "openMeteo")
        {
            addMetnoCityIdDialog.hasAltitude = hasAltitude
            addMetnoCityIdDialog.populateFields(entry)
            addMetnoCityIdDialog.open()
        }
        if (entry.providerId === "owm") {
            newOwmCityIdField.text = "https://openweathermap.org/city/"+entry.placeIdentifier
            newOwmCityAlias.text = entry.placeAlias
            addOwmCityIdDialog.open()
        }
    }

    property alias newOwmCityIdField: addOwmCityIdDialog.newOwmCityIdField
    property alias newOwmCityAlias: addOwmCityIdDialog.newOwmCityAlias

    OwmDialog {
        id: addOwmCityIdDialog
    }

    property alias newMetnoCityAlias: addMetnoCityIdDialog.newMetnoCityAlias
    property alias newMetnoCityLatitudeField: addMetnoCityIdDialog.newMetnoCityLatitudeField
    property alias newMetnoCityLongitudeField: addMetnoCityIdDialog.newMetnoCityLongitudeField
    property alias newMetnoCityAltitudeField: addMetnoCityIdDialog.newMetnoCityAltitudeField

    MetNoDialog {
        id: addMetnoCityIdDialog
    }

    Dialog {
        id: testDialog
        title: i18n("Add Place")

        modal: true

        standardButtons: Dialog.Ok | Dialog.Cancel

    }


    Kirigami.FormLayout {
        ColumnLayout {
            id: rhsColumn
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.minimumHeight: childrenRect.height

            Label {
                text: i18n("Location")
                font.bold: true
                Layout.alignment: Qt.AlignLeft
            }

            HorizontalHeaderView {
                id: horizontalHeader
                syncView: tableView
                Layout.preferredHeight: contentHeight
                Layout.fillWidth: true

                model: [
                    i18n("Source"),
                    i18n("Displayed as"),
                    i18n("Place Identifier"),
                ]
            }

            TableView {
                id: tableView
                Layout.minimumHeight: 150
                Layout.fillWidth: true
                clip: true

                selectionBehavior: TableView.SelectRows
                selectionModel: ItemSelectionModel {
                    model: tableView.model
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded 
                }

                model: placesModel

                property var columnWidths: [0.1, 0.3, 0.6]
                columnWidthProvider: function (column) {
                    return tableView.width * columnWidths[column]
                }

                onWidthChanged: tableView.forceLayout()

                component TableRow: Label {
                    property int column: -1

                    text: text
                    elide: Text.ElideRight
                    Layout.fillHeight: true
                    Layout.preferredWidth: tableView.width * tableView.columnWidths[column]

                    background: Rectangle {
                        anchors.fill: parent
                        color: selected ? Kirigami.Theme.highlightColor :
                                         ((row % 2 === 0) ? Kirigami.Theme.backgroundColor :
                                            Qt.darker(Kirigami.Theme.backgroundColor, 1.05))
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            let index = tableView.model.index(row, 0)
                            if (!tableView.selectionModel.isSelected(index)) {
                                tableView.selectionModel.clear()
                                tableView.selectionModel.select(index, ItemSelectionModel.SelectCurrent | ItemSelectionModel.Row)
                            } else {
                                tableView.selectionModel.select(index, ItemSelectionModel.Deselect)
                            }
                        }
                        onDoubleClicked: {
                            showEditDialog()
                        }
                    }
                }

                delegate: Rectangle {
                    id: rowRoot
                    implicitHeight: providerIdLabel.contentHeight + (11 * 1)
                    implicitWidth: tableView.width

                    required property bool selected
                    required property bool current

                    RowLayout {
                        id: tableRow
                        spacing: 1
                        anchors.fill: parent

                        TableRow {
                            id: providerIdLabel
                            text: providerId
                            column: 0
                        }

                        TableRow {
                            text: placeAlias
                            column: 1
                        }

                        TableRow {
                            text: placeIdentifier
                            column: 2
                        }
                    }
                }
            }

            RowLayout {
                Button {
                    icon.name: 'list-add'
                    text: 'OWM'
                    width: 100
                    onClicked: {
                        editEntryNumber = -1
                        addOwmCityIdDialog.open()
                        newOwmCityIdField.text = ''
                        newOwmCityAlias.text = ''
                        newOwmCityIdField.focus = true
                    }
                }

                Button {
                    icon.name: 'list-add'
                    text: 'metno'
                    width: 100
                    onClicked: {
                        addMetnoCityIdDialog.hasAltitude = true
                        addMetnoCityIdDialog.clearFields()
                        addMetnoCityIdDialog.providerId = 'metno'
                        addMetnoCityIdDialog.open()
                    }
                }

                Button {
                    icon.name: 'list-add'
                    text: 'Open Meteo'
                    width: 100
                    onClicked: {
                        editEntryNumber = -1
                        addMetnoCityIdDialog.hasAltitude = false
                        addMetnoCityIdDialog.clearFields()
                        addMetnoCityIdDialog.providerId = 'openMeteo'
                        addMetnoCityIdDialog.open()
                    }
                }


                Rectangle {
                    Layout.fillWidth: true
                }

                GridLayout {
                    height: parent.height
                    columns: 4
                    rowSpacing: 0

                    Button {
                        icon.name: 'go-up'
                        Layout.fillHeight: true
                        onClicked: {
                            let row = tableView.selectionModel.selectedIndexes.length === 0 ? -1 :
                                        tableView.selectionModel.selectedIndexes[0].row
                            if (row <= 0 || row > placesModel.count) {
                                return
                            }
                            placesModel.move(row, row - 1, 1)

                            _placesModelChanged()
                        }
                        enabled: (tableView.selectionModel.hasSelection &&
                                    tableView.selectionModel.selectedIndexes.length > 0 &&
                                    tableView.selectionModel.selectedIndexes[0].row > 0)
                    }

                    Button {
                        icon.name: 'go-down'
                        Layout.fillHeight: true
                        onClicked: {
                            let row = tableView.selectionModel.selectedIndexes.length === 0 ? -1 :
                                        tableView.selectionModel.selectedIndexes[0].row
                            if (row < 0 || row >= placesModel.count - 1) {
                                return
                            }
                            placesModel.move(row, row + 1, 1)

                            _placesModelChanged()
                        }
                        enabled: (tableView.selectionModel.hasSelection &&
                                    tableView.selectionModel.selectedIndexes.length > 0 &&
                                    (tableView.selectionModel.selectedIndexes[0].row <
                                        (placesModel.count - 1))
                                    )
                    }

                    Button {
                        icon.name: 'list-remove'
                        Layout.fillHeight: true
                        onClicked: {
                            if (!tableView.selectionModel.hasSelection) {
                                return
                            }
                            let index = tableView.selectionModel.selectedIndexes[0].row
                            placesModel.remove(index)
                            _placesModelChanged()

                            tableView.selectionModel.clear()
                        }
                        enabled: (tableView.selectionModel.hasSelection &&
                                    tableView.selectionModel.selectedIndexes.length > 0 &&
                                    (tableView.selectionModel.selectedIndexes[0].row < placesModel.count)
                                    )
                    }

                    Button {
                        icon.name: 'entry-edit'
                        Layout.fillHeight: true
                        enabled: tableView.selectionModel.hasSelection
                        onClicked: {
                            if (!tableView.selectionModel.hasSelection) {
                                return
                            }
                            showEditDialog()
                        }
                    }
                }
            }

            Label {
                topPadding: 16
                bottomPadding: 4
                text: i18n("Miscellaneous")
                font.bold: true
                Layout.alignment: Qt.AlignLeft
            }

            RowLayout {
                Label {
                    text: i18n("Reload interval:")
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    rightPadding: 6
                }
                SpinBox {
                    id: reloadIntervalHours
                    property int decimals: 0
                    stepSize: 1
                    from: 1
                    to: 24
                    textFromValue: function(value, locale) {
                        var num = Number(value).toLocaleString(locale, 'f', reloadIntervalHours.decimals)
                        var suffix = i18nc("Abbreviation for hours", "hrs")
                        return qsTr("%1 %2").arg(num).arg(suffix)
                    }
                    valueFromText: function(text) {
                        let data = text.split(" ")
                        if (data.length < 1) {
                            return 4
                        }
                        return Number.fromLocaleString(data[0])
                    }
                }
            }

            CheckBox {
                id: debugLogging
                checked: false
                text: "Debug"
                Layout.alignment: Qt.AlignLeft
                visible: false
            }
        }

        /* spacer */
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Column {
            Layout.fillWidth: true
            Layout.minimumHeight: childrenRect.height

            Repeater {
                model: [
                    {
                        text: i18n("%1 weather forecast data provided by %2.", "Met.no",
                                   "The Norwegian Meteorological Institute"),
                        url: 'https://www.met.no/en/About-us'
                    },
                    {
                        text: i18n("Sunrise/sunset data provided by %1.", "Sunrise - Sunset"),
                        url: 'https://sunrise-sunset.org/about'
                    },
                    {
                        text: i18n("%1 weather forecast data provided by %2.", "OWM", "OpenWeather"),
                        url: 'https://openweathermap.org/about-us'
                    },
                    {
                        text: i18n("%1 weather forecast data provided by %2.", "Open-Meteo",
                                   "Open-Meteo.com"),
                        url: "https://open-meteo.com/"
                    },
                    {
                        text: i18n("Weather icons created by %1.", "Erik Flowers"),
                        url: 'https://erikflowers.github.io/weather-icons/'
                    },
                    {
                        text: i18n("Weather icons created by %1.", "Bas Milius"),
                        url: 'https://basmilius.github.io/weather-icons/'
                    },
                    {
                        text: i18n("Weather icons created by %1.", "Norwegian National Broadcasting"),
                        url: 'https://nrkno.github.io/yr-weather-symbols/'
                    },
                    {
                        text: i18n("Wind speed icons created by %1.", "Qulle"),
                        url: 'https://github.com/qulle/svg-wind-barbs/'
                    }
                ]
                delegate: Label {
                    id: attribution
                    anchors.bottomMargin: 2
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    text: modelData.text

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Qt.openUrlExternally(modelData.url)
                        onEntered: parent.font.underline = true
                        onExited: parent.font.underline = false
                    }
                }
            }
        }
    }
}
