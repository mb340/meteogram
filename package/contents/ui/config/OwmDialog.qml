import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts


Dialog {
    title: i18n("Add Open Weather Map Place")

    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true

    property alias newOwmCityIdField: newOwmCityIdField
    property alias newOwmCityAlias: newOwmCityAlias

    onAccepted: {
        var url = newOwmCityIdField.text
        var match = /https?:\/\/openweathermap\.org\/city\/([0-9]+)(\/)?/.exec(url)
        var resultString = null
        if (match !== null) {
            resultString = match[1]
        }

        if (resultString === null) {
            return
        }

        if (editEntryNumber === -1) {
            placesModel.append({
                                   providerId: 'owm',
                                   placeIdentifier: resultString,
                                   placeAlias: newOwmCityAlias.text
                               })
        } else {
            placesModel.set(editEntryNumber,{
                                providerId: 'owm',
                                placeIdentifier: resultString,
                                placeAlias: newOwmCityAlias.text
                            })
        }
        _placesModelChanged()
        close()
    }

    GridLayout {
        anchors.fill: parent
        columns: 2

        TextField {
            id: newOwmCityIdField
            placeholderText: i18n("Paste URL here")
            Layout.row: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        TextField {
            id: newOwmCityAlias
            placeholderText: i18n("City alias")
            Layout.row: 1
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        Label {
            id: owmInfo
            font.italic: true
            text: i18n("Find your city ID by searching here:")
            Layout.row: 2
        }

        Label {
            id: owmLink
            font.italic: true
            text: 'http://openweathermap.org/find'
            Layout.row: 3

            MouseArea {
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent

                hoverEnabled: true

                onClicked: {
                    Qt.openUrlExternally(owmLink.text)
                }

                onEntered: {
                    owmLink.font.underline = true
                }

                onExited: {
                    owmLink.font.underline = false
                }
            }
        }


        Label {
            font.italic: true
            text: i18n("...and paste here the whole URL\ne.g. http://openweathermap.org/city/2946447 for Bonn, Germany.")
            Layout.row: 4
        }

    }

}
