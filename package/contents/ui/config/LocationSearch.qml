import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import "../../code/config-utils.js" as ConfigUtils
import "../../code/placesearch-helpers.js" as Helper


Dialog {
    title: i18n("Location Search")
    id: searchWindow
    width: 640
    height: 400
    standardButtons: StandardButton.Ok | StandardButton.Cancel

    property alias filteredCSVData: filteredCSVData
    property alias tableView: tableView
    property alias countryList: countryList

    property var myCSVData: ([])

    ListModel {
        id: countryCodesModel
    }
    ListModel {
        id: filteredCSVData
    }

    onAccepted: {
        if(tableView.currentRow > -1) {
            saveSearchedData.open()
        }
    }

    function initPlaceSearchHelper() {
        if (!Helper.initialized) {
            Helper.myCSVData = searchWindow.myCSVData
            Helper.locationEdit = locationEdit
            Helper.filteredCSVData = searchWindow.filteredCSVData
            Helper.initialized = true
        }
    }

    Component.onCompleted: {
        initPlaceSearchHelper()

        let locale=Qt.locale().name.substr(3,2)
        let userCountry=Helper.getDisplayName(locale)
        let tmpDB=Helper.getDisplayNames()
        for (var i=0; i < tmpDB.length - 1 ; i++) {
            countryCodesModel.append({ id: tmpDB[i] })
        }
    }

    onVisibleChanged: {
        if (!visible || countryList.currentIndex !== -1) {
            return
        }
        let locale=Qt.locale().name.substr(3,2)
        let userCountry=Helper.getDisplayName(locale)
        let tmpDB=Helper.getDisplayNames()
        for (var i=0; i < tmpDB.length - 1 ; i++) {
            if (tmpDB[i] === userCountry) {
                countryList.currentIndex = i
            }
        }
    }

    HorizontalHeaderView {
        id: horizontalHeader
        syncView: tableView
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        implicitHeight: contentHeight

        model: [
            i18n("Location"),
            i18n("Area"),
            i18n("Latitude"),
            i18n("Longitude"),
            i18n("Altitude"),
            i18n("Timezone")
        ]
    }

    TableView {
        id: tableView
        height: 140
        anchors.bottom: row2.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: horizontalHeader.bottom
        anchors.bottomMargin: 10
        clip: true

        property int currentRow: -1

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
                color: selected ? PlasmaCore.Theme.highlightColor :
                                 ((row % 2 === 0) ? PlasmaCore.Theme.viewBackgroundColor :
                                    Qt.darker(PlasmaCore.Theme.viewBackgroundColor, 1.05))
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    tableView.clearSelection()
                    selected = true
                    tableView.currentRow = row
                }
                onDoubleClicked: {
                    saveSearchedData.open()
                }
            }
        }

        delegate: Rectangle {
            id: rowRoot
            implicitHeight: providerIdLabel.contentHeight + (11 * units.devicePixelRatio)
            implicitWidth: tableView.width

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

        function clearSelection() {
            if (tableView.currentRow < 0) {
                return;
            }
            let data = filteredCSVData.get(tableView.currentRow)
            if (!data) {
                return
            }
            data.selected = false
            tableView.currentRow = -1
        }
    }
    Item {
        id: row1
        anchors.bottom: parent.bottom
        height: 20
        width: parent.width
        Label {
            id:locationDataCredit
            text: i18n("Search data extracted from data provided by Geonames.org.")
            anchors.horizontalCenter: parent.horizontalCenter
        }
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

    Item {
        id: row2
        x: 0
        y: 0
        height: 54
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: row1.top
        anchors.bottomMargin: 0
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
                tableView.clearSelection()
                if (countryList.currentIndex > 0) {
                    Helper.loadCSVDatabase(countryList.textAt(countryList.currentIndex))
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
                tableView.clearSelection()
                Helper.updateListView(locationEdit.text)
                tableView.contentY = 0
            }
        }
    }
}