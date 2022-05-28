import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import "../../code/config-utils.js" as ConfigUtils
import "../../code/placesearch-helpers.js" as Helper
import "../../code/db/timezoneData.js" as TZData

Dialog {
    title: i18n("Location Search")
    id: searchWindow
    width: 640
    height: 400
    standardButtons: StandardButton.Ok | StandardButton.Cancel

    property alias countryCodesModel: countryCodesModel
    property alias filteredCSVData: filteredCSVData
    property alias timezoneDataModel: timezoneDataModel
    property alias tableView: tableView
    property alias countryList: countryList

    onAccepted: {
        if(tableView.currentRow > -1) {
            saveSearchedData.open()
        }
    }
    Component.onCompleted: {
        let locale=Qt.locale().name.substr(3,2)
        let userCountry=Helper.getDisplayName(locale)
        let tmpDB=Helper.getDisplayNames()
        for (var i=0; i < tmpDB.length - 1 ; i++) {
            countryCodesModel.append({ id: tmpDB[i] })
            if (tmpDB[i] === userCountry) {
                countryList.currentIndex = i
            }
        }
    }
    TableView {
        id: tableView
        height: 140
        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
        highlightOnFocus: true
        anchors.bottom: row2.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 10
        model: filteredCSVData
        TableViewColumn { role: "locationName"; title: i18n("Location") }
        TableViewColumn { role: "region"; title: i18n("Area"); width :75 }
        TableViewColumn { role: "latitude"; title: i18n("Latitude"); width :75 }
        TableViewColumn { role: "longitude"; title: i18n("Longitude"); width :75 }
        TableViewColumn { role: "altitude"; title: i18n("Altitude"); width :75}
        TableViewColumn { role: "timezoneName"; title: i18n("Timezone"); width :100}
        onDoubleClicked: {
            saveSearchedData.open()
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
            text: i18n("Country:")
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
                if (countryList.currentIndex > 0) {
                    Helper.loadCSVDatabase(countryList.textAt(countryList.currentIndex))
                }
            }
        }
        Label {
            id: locationLabel
            anchors.right: locationEdit.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: i18n("Filter:")
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
                Helper.updateListView(locationEdit.text)
            }
        }
    }

    ListModel {
        id: myCSVData
    }
    ListModel {
        id: countryCodesModel
    }
    ListModel {
        id: filteredCSVData
    }
    ListModel {
        id: timezoneDataModel
    }
}