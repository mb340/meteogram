import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import "../../code/config-utils.js" as ConfigUtils
import "../../code/placesearch-helpers.js" as Helper
import "../../code/db/timezoneData.js" as TZData

Dialog {
    id: addMetnoCityIdDialog
    title: i18n("Add Met.no Map Place")

    property int timezoneID: -1
    property string providerId: ''

    width: 500

    standardButtons: StandardButton.Ok | StandardButton.Cancel

    property alias newMetnoCityAlias: newMetnoCityAlias
    property alias newMetnoCityLatitudeField: newMetnoCityLatitudeField
    property alias newMetnoCityLongitudeField: newMetnoCityLongitudeField
    property alias newMetnoCityAltitudeField: newMetnoCityAltitudeField
    property alias newMetnoUrl: newMetnoUrl
    property alias tzComboBox: tzComboBox

    onActionChosen: {

        function between(x, min, max) {
            return x >= min && x <= max;
        }

        if (action.button === Dialog.Ok) {
            var reason=""
            var reasoncount=0;
            var latValid = newMetnoCityLatitudeField.acceptableInput
            var longValid = newMetnoCityLongitudeField.acceptableInput
            var altValid = newMetnoCityAltitudeField.acceptableInput

            action.accepted = false

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

            if (! altValid) {
                reason+=i18n("The Altitude is not valid.")+"\n"
                reason+=i18n("The Altitude is not between -999 and 5000.")+"\n"
                reasoncount++
            }

            if (newMetnoCityAlias.text.length === 0) {
                reason+=i18n("The Place Name is empty.")+"\n"
                reasoncount++
            }

            if (reasoncount === 0 ) {
                action.accepted = true
            } else {
                action.accepted = false
                invalidData.text=i18np("There is an error!", "There are %1 errors!",reasoncount)
                invalidData.informativeText=reason
                invalidData.open()
            }
        }
    }

    onAccepted: {
        print("newMetnoUrl.text = " + newMetnoUrl.text)
        var resultString = newMetnoUrl.text
        if (resultString.length === 0) {
            if (addMetnoCityIdDialog.providerId === 'meto') {
                resultString="lat="+newMetnoCityLatitudeField.text+"&lon="+newMetnoCityLongitudeField.text+"&altitude="+newMetnoCityAltitudeField.text
            }
        }
        if (editEntryNumber === -1) {
            placesModel.append({
                                   providerId: addMetnoCityIdDialog.providerId,
                                   placeIdentifier: resultString,
                                   placeAlias: newMetnoCityAlias.text,
                                   timezoneID: addMetnoCityIdDialog.timezoneID
                               })
        } else {
            placesModel.set(editEntryNumber,{
                                providerId: addMetnoCityIdDialog.providerId,
                                placeIdentifier: resultString,
                                placeAlias: newMetnoCityAlias.text,
                                timezoneID: addMetnoCityIdDialog.timezoneID
                            })
        }
        placesModelChanged()
        close()
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
            textColor: acceptableInput ? newMetnoCityLatitudeLabel.color : "red"
            onTextChanged: {
                updateUrl()
            }
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
            textColor: acceptableInput ? newMetnoCityLongitudeLabel.color : "red"
            onTextChanged: {
                updateUrl()
            }

        }

        Item {
            width: 20
        }

        Label {
            id: newMetnoCityAltitudeLabel
            text: i18n("Altitude")+":"
        }

        TextField {
            id: newMetnoCityAltitudeField
            Layout.fillWidth: true
            validator: IntValidator { bottom: -999; top: 5000 }
            textColor: acceptableInput ? newMetnoCityAltitudeLabel.color : "red"
            onTextChanged: {
                updateUrl()
            }
        }

        Label {
            text: i18n("URL")+":"
        }
        TextField {
            id: newMetnoUrl
            placeholderText: i18n("URL")
            Layout.columnSpan: 5
            Layout.fillWidth: true
            textColor: acceptableInput ? newMetnoCityAltitudeLabel.color : "red"

            function updateFields() {
                function localiseFloat(data) {
                    return Number(data).toLocaleString(Qt.locale(),"f",5)
                }

                var data=newMetnoUrl.text.match(RegExp("([+-]?[0-9]{1,5}[.]?[0-9]{0,5})","g"))
                if (data === undefined)
                    return
                if (data.length === 3) {
                    var newlat = localiseFloat(data[0])
                    var newlon = localiseFloat(data[1])
                    var newalt = Number(data[2])
                    if ((! newMetnoCityLatitudeField.acceptableInput) || (newMetnoCityLatitudeField.text.length === 0) || (newMetnoCityLatitudeField.text !== newlat)) {
                        newMetnoCityLatitudeField.text = newlat
                    }
                    if ((! newMetnoCityLongitudeField.acceptableInput) || (newMetnoCityLongitudeField.text.length === 0) || (newMetnoCityLongitudeField.text !== newlon)) {
                        newMetnoCityLongitudeField.text = newlon
                    }
                    if ((! newMetnoCityAltitudeField.acceptableInput) || (newMetnoCityAltitudeField.text.length === 0)  || (newMetnoCityAltitudeField.text !== data[2])) {
//                             if ((newalt >= newMetnoCityAltitudeField.validator.bottom) && (newalt <= newMetnoCityAltitudeField.validator.top)) {
                            newMetnoCityAltitudeField.text = data[2]
//                             }
                    }
                }
            }



            onTextChanged: {
                updateFields()
            }

            onEditingFinished: {
                updateFields()
            }
        }
        ComboBox {
            id: tzComboBox
            model: timezoneDataModel
            currentIndex: -1
            textRole: "displayName"
            Layout.columnSpan: 2
            Layout.fillWidth: true
            onCurrentIndexChanged: {
                if (tzComboBox.currentIndex > 0) {
                    addMetnoCityIdDialog.timezoneID = timezoneDataModel.get(tzComboBox.currentIndex).id
                }
            }
        }
        Label {
            text: i18n("Place Identifier")+":"
        }
        TextField {
            id: newMetnoCityAlias
            placeholderText: i18n("City alias")
            Layout.columnSpan: 6
            Layout.fillWidth: true
        }
        Button {
            text: i18n("Search")
            Layout.alignment: Qt.AlignRight
            onClicked: {
                searchWindow.open()
            }
        }
    }
}