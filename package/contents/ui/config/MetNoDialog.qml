import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../code/config-utils.js" as ConfigUtils
import "../../code/placesearch-helpers.js" as Helper
import "../../code/db/timezoneData.js" as TZData


Dialog {
    id: addMetnoCityIdDialog
    title: i18n("Add Place")

    property int timezoneID: -1
    property string providerId: ''

    // width: 500

    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true

    property alias newMetnoCityAlias: newMetnoCityAlias
    property alias newMetnoCityLatitudeField: newMetnoCityLatitudeField
    property alias newMetnoCityLongitudeField: newMetnoCityLongitudeField
    property alias newMetnoCityAltitudeField: newMetnoCityAltitudeField
    property alias tzComboBox: tzComboBox

    property bool isLoadingTimeZoneModel: false
    property var timezoneDataModel: null

    property bool hasAltitude: true

    Component {
        id: timezoneLoaderComponent

        ListModel {
            id: timezoneDataModel
            Component.onCompleted: {
                let timezoneArray = TZData.TZData.sort(dynamicSort("displayName"))
                timezoneArray.forEach(function (tz) {
                    timezoneDataModel.append({
                        displayName: tz.displayName.replace(/_/gi, " "),
                        id: tz.id
                    });
                })
                addMetnoCityIdDialog.timezoneDataModel = timezoneDataModel
                addMetnoCityIdDialog.setTimezone(addMetnoCityIdDialog.timezoneID)
            }
        }
    }

    onVisibleChanged: {
        // Initialize list model the first time the dialog is opened
        if (!isLoadingTimeZoneModel && visible === true && timezoneDataModel === null) {
            isLoadingTimeZoneModel = true
            timezoneLoaderComponent.incubateObject(addMetnoCityIdDialog);
        }

        if (visible && timezoneDataModel) {
            addMetnoCityIdDialog.setTimezone(addMetnoCityIdDialog.timezoneID)
        }
    }

    function validateFields() {
        var reason=""
        var reasoncount=0;
        var latValid = newMetnoCityLatitudeField.acceptableInput
        var longValid = newMetnoCityLongitudeField.acceptableInput
        var altValid = newMetnoCityAltitudeField.acceptableInput


        if (!(latValid)) {
            reason+=i18n("The Latitude is not valid.")+"\n"
            reason+=i18n("The Latitude is not between -90 and 90.")+"\n"
            reasoncount++
        }

        if (!(longValid)) {
            reason+=i18n("The Longitude is not valid.")+"\n"
            reason+=i18n("The Longitude is not between -180 and 180.")+"\n"
            reasoncount++
        }

        if (hasAltitude && !altValid) {
            reason+=i18n("The Altitude is not valid.")+"\n"
            reason+=i18n("The Altitude is not between -999 and 5000.")+"\n"
            reasoncount++
        }

        if (newMetnoCityAlias.text.length === 0) {
            reason+=i18n("The Place Name is empty.")+"\n"
            reasoncount++
        }

        if (reasoncount > 0) {
            standardButtons = Dialog.Cancel
        } else {
            standardButtons = Dialog.Ok | Dialog.Cancel
        }
    }

    onAccepted: {
        var data = {
            providerId: addMetnoCityIdDialog.providerId,
            placeAlias: newMetnoCityAlias.text,
            longitude: Number.fromLocaleString(newMetnoCityLongitudeField.text),
            latitude: Number.fromLocaleString(newMetnoCityLatitudeField.text),
            timezoneID: timezoneDataModel.get(tzComboBox.currentIndex).id,
            selected: false
        }

        if (hasAltitude) {
            data["altitude"] = Number.fromLocaleString(newMetnoCityAltitudeField.text)
        }

        data["placeIdentifier"] = ConfigUtils.formatPlaceIdentifier(data)

        if (editEntryNumber === -1) {
            placesModel.append(data)
        } else {
            placesModel.set(editEntryNumber, data)
        }
        _placesModelChanged()
        cleanUp()
    }

    onRejected: {
        cleanUp()
    }

    Dialog {
        id: saveSearchedData
        title: i18n("Confirmation")
        standardButtons: MessageDialog.Ok | MessageDialog.Cancel
        visible: false
        Label {
            text: i18n("Do you want to select this place?")
            anchors.fill: parent
        }

        onAccepted: {
            // let data = filteredCSVData.get(searchWindow.tableView.currentRow)
            let index = searchWindow.getSelectedRowIndex()
            print("onAccepted index = " + index)
            let data = filteredCSVData.get(index)
            
            newMetnoCityLatitudeField.text=data["latitude"]
            newMetnoCityLongitudeField.text=data["longitude"]
            if (hasAltitude) {
                newMetnoCityAltitudeField.text=data["altitude"]
            }
            print("saveSearchedData: providerId = " +  addMetnoCityIdDialog.providerId)
            let loc=data["locationName"]+", "+Helper.getshortCode(countryList.textAt(countryList.currentIndex))
            newMetnoCityAlias.text=loc
            setTimezone(data["timezoneId"])
            searchWindow.close()
        }
        onRejected: {
            searchWindow.close()
        }
    }

    property alias filteredCSVData: searchWindow.filteredCSVData
    property alias tableView: searchWindow.tableView
    property alias countryList: searchWindow.countryList

    LocationSearch {
        id: searchWindow
    }

    GridLayout {
        id: metNoRowLayout
        anchors.fill: parent
        columns: 8
        Label {
            id: newMetnoCityLatitudeLabel
            text: i18n("Latitude")+":"
        }

        TextField {
            id: newMetnoCityLatitudeField
            Layout.fillWidth: true
            validator: DoubleValidator { bottom: -90; top: 90; decimals: 5 }
            color: acceptableInput ? newMetnoCityLatitudeLabel.color : "red"
            onAcceptableInputChanged: validateFields()
        }

        Item {
            width: 20
        }

        Label {
            id: newMetnoCityLongitudeLabel
            text: i18n("Longitude")+":"
        }

        TextField {
            id: newMetnoCityLongitudeField
            Layout.fillWidth: true
            validator: DoubleValidator { bottom: -180; top: 180; decimals: 5 }
            color: acceptableInput ? newMetnoCityLongitudeLabel.color : "red"
            onAcceptableInputChanged: validateFields()
        }

        Item {
            width: 20
        }

        Label {
            id: newMetnoCityAltitudeLabel
            text: i18n("Altitude")+":"
            enabled: hasAltitude
        }

        TextField {
            id: newMetnoCityAltitudeField
            Layout.fillWidth: true
            validator: IntValidator { bottom: -999; top: 5000 }
            color: acceptableInput ? newMetnoCityAltitudeLabel.color : "red"
            enabled: hasAltitude
            onAcceptableInputChanged: validateFields()
        }

        Label {
            text: i18n("Time Zone")+":"
        }
        ComboBox {
            id: tzComboBox
            model: timezoneDataModel
            currentIndex: -1
            textRole: "displayName"
            Layout.columnSpan: 4
            Layout.fillWidth: true
            onModelChanged: {
                currentIndex = -1
            }
        }
        Item {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.preferredHeight: tzComboBox.height
        }
        Label {
            id: newMetnoCityAliasLabel
            text: i18n("City Alias")+":"
        }
        TextField {
            id: newMetnoCityAlias
            Layout.columnSpan: 6
            Layout.fillWidth: true
            validator: RegularExpressionValidator { regularExpression: /\S.*/  }
            color: acceptableInput ? newMetnoCityAliasLabel.color : "red"
            onAcceptableInputChanged: validateFields()
        }
        Button {
            text: i18n("Search")
            Layout.alignment: Qt.AlignRight
            onClicked: {
                searchWindow.open()
            }
        }
    }

    function dynamicSort(property) {
        var sortOrder = 1;

        if (property[0] === "-") {
            sortOrder = -1;
            property = property.substr(1);
        }

        return function (a,b) {
            if (sortOrder == -1){
                return b[property].localeCompare(a[property]);
            } else {
                return a[property].localeCompare(b[property]);
            }
        }
    }

    function setTimezone(timezoneID) {
        if (!timezoneDataModel) {
            return
        }
        for (var i = 0; i < timezoneDataModel.count; i++) {
            if (parseInt(timezoneDataModel.get(i).id) === parseInt(timezoneID)) {
                tzComboBox.currentIndex = i
                break
            }
        }
    }

    function clearFields() {
        newMetnoCityAlias.text = ''
        newMetnoCityLatitudeField.text = ''
        newMetnoCityLongitudeField.text = ''
        newMetnoCityAltitudeField.text = ''
        newMetnoCityLatitudeField.focus = true
    }

    function populateFields(placeObject) {
        newMetnoCityLatitudeField.text = Number(placeObject.latitude)
                                            .toLocaleString(Qt.locale(),"f",5)
        newMetnoCityLongitudeField.text = Number(placeObject.longitude)
                                            .toLocaleString(Qt.locale(),"f",5)

        if (hasAltitude) {
            newMetnoCityAltitudeField.text = (placeObject.altitude === undefined) ?
                                                0 : placeObject.altitude
        }
        addMetnoCityIdDialog.timezoneID = parseInt(placeObject.timezoneID)
        setTimezone(addMetnoCityIdDialog.timezoneID)
        newMetnoCityAlias.text = placeObject.placeAlias
        addMetnoCityIdDialog.providerId = placeObject.providerId
    }

    function cleanUp() {
        tzComboBox.currentIndex = -1
        addMetnoCityIdDialog.timezoneID = -1
    }
}
