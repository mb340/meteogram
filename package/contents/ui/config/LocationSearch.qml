import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import QtQuick.Dialogs
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "../../code/config-utils.js" as ConfigUtils
import "../../code/placesearch-helpers.js" as Helper


Dialog {
    title: i18n("Location Search")
    id: searchWindow

    contentWidth: 640
    // contentHeight: contentContainer.height

    standardButtons: MessageDialog.Ok | MessageDialog.Cancel
    modal: false

    property alias filteredCSVData: filteredCSVData
    property alias tableView: tableView
    property alias countryList: countryList

    property var myCSVData: ([])

    property bool isCountryCodesModelLoading: false
    property var countryCodesModel: null

    Component {
        id: countryCodesModelComponent
        ListModel {
            id: countryCodesModel

            Component.onCompleted: {
                let locale=Qt.locale().name.substr(3,2)
                let userCountry=Helper.getDisplayName(locale)
                let tmpDB=Helper.getDisplayNames()
                let currentIndex = -1
                for (var i=0; i < tmpDB.length; i++) {
                    this.append({ id: tmpDB[i] })
                    if (tmpDB[i] === userCountry) {
                        currentIndex = i
                    }
                }
                searchWindow.countryCodesModel = this
                countryList.currentIndex = currentIndex
            }
        }
    }

    ListModel {
        id: filteredCSVData
    }

    onAccepted: {
        if(tableView.selectionModel.hasSelection) {
            saveSearchedData.open()
        }
    }

    onVisibleChanged: {
        if (visible && !isCountryCodesModelLoading) {
            isCountryCodesModelLoading = true
            countryCodesModelComponent.incubateObject(searchWindow);
        }
    }

    ColumnLayout {
        id: contentContainer
        anchors.fill: parent

        HorizontalHeaderView {
            id: horizontalHeader
            syncView: tableView

            Layout.fillWidth: true

            model: [
                i18n("Location"),
                i18n("Area"),
                i18n("Latitude"),
                i18n("Longitude"),
                i18n("Altitude"),
                i18n("Time zone")
            ]
        }


        TableView {
            id: tableView

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 140

            clip: true

            selectionBehavior: TableView.SelectRows
            selectionModel: ItemSelectionModel {
                model: tableView.model
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            model: filteredCSVData

            property var columnWidths: [0.3, 0.1, 0.1, 0.1, 0.1, 0.3]
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
                        saveSearchedData.open()
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
                    spacing: 0
                    anchors.fill: parent

                    TableRow {
                        id: providerIdLabel
                        text: locationName
                        column: 0
                    }

                    TableRow {
                        text: region
                        column: 1
                    }

                    TableRow {
                        text: latitude
                        column: 2
                    }

                    TableRow {
                        text: longitude
                        column: 3
                    }

                    TableRow {
                        text: altitude
                        column: 4
                    }

                    TableRow {
                        text: timezoneName
                        column: 5
                    }
                }
            }
        }
        Item {
            id: row1

            Layout.fillWidth: true
            Layout.preferredHeight: 20

            Label {
                id:locationDataCredit
                text: i18n("Search data extracted from data provided by Geonames.org.")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                cursorShape: Qt.PointingHandCursor
                anchors.fill: row1

                hoverEnabled: true

                onClicked: {
                    Qt.openUrlExternally("https://www.geonames.org/")
                }

                onEntered: {
                    locationDataCredit.font.underline = true
                }

                onExited: {
                    locationDataCredit.font.underline = false
                }
            }
        }
        

        Item {
            id: row2

            Layout.fillWidth: true
            Layout.preferredHeight: 54

            Label {
                id: countryLabel
                text: i18n("Country") + ":"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox {
                id: countryList
                anchors.left: countryLabel.right
                anchors.leftMargin: 20
                anchors.verticalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                model: countryCodesModel
                width: 200
                editable: false
                onCurrentIndexChanged: {
                    tableView.selectionModel.clear()
                    if (countryList.currentIndex >= 0) {
                        let countryName = countryList.textAt(countryList.currentIndex)
                        Helper.loadCSVDatabase(myCSVData, countryName , this)
                        Helper.updateListView(myCSVData, locationEdit.text, filteredCSVData)
                        tableView.contentY = 0
                    }
                }
            }
            Label {
                id: locationLabel
                anchors.right: locationEdit.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: i18n("Filter") + ":"
            }
            TextField {
                id: locationEdit
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                width: 160
                height: 31
                text: ""
                focus: true
                font.capitalization: Font.Capitalize
                selectByMouse: true
                clip: false
                Keys.onReturnPressed: {
                    event.accepted = true
                }
                onTextChanged: {
                    tableView.selectionModel.clear()
                    Helper.updateListView(myCSVData, locationEdit.text, filteredCSVData)
                    tableView.contentY = 0
                }
            }
        }
    }

    function getSelectedRowIndex() {
        if (!tableView.selectionModel.hasSelection) {
            return -1
        }
        return tableView.selectionModel.selectedIndexes[0].row
    }
}