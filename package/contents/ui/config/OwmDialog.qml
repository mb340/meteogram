import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2


Dialog {
    title: i18n("Add Open Weather Map Place")

    width: 500

    standardButtons: StandardButton.Ok | StandardButton.Cancel

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
        placesModelChanged()
        close()
    }

    TextField {
        id: newOwmCityIdField
        placeholderText: i18n("Paste URL here")
        width: parent.width
    }

    TextField {
        id: newOwmCityAlias
        anchors.top: newOwmCityIdField.bottom
        anchors.topMargin: 10
        placeholderText: i18n("City alias")
        width: parent.width
    }

    Label {
        id: owmInfo
        anchors.top: newOwmCityAlias.bottom
        anchors.topMargin: 10
        font.italic: true
        text: i18n("Find your city ID by searching here:")
    }

    Label {
        id: owmLink
        anchors.top: owmInfo.bottom
        font.italic: true
        text: 'http://openweathermap.org/find'
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: owmLink

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

    Label {
        anchors.top: owmLink.bottom
        font.italic: true
        text: i18n("...and paste here the whole URL\ne.g. http://openweathermap.org/city/2946447 for Bonn, Germany.")
    }

}
