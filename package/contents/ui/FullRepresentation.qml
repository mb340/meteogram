/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: fullRepresentation

    property int preferredImageWidth: 800 * units.devicePixelRatio // Makes yr.no images grainy,
    property int preferredImageHeight: 320 * units.devicePixelRatio + defaultFontPixelSize// prefer rendering meteograms

    Layout.preferredWidth: preferredImageWidth
    Layout.preferredHeight: headingHeight + preferredImageHeight + footerHeight + nextDaysHeight + 14
    Layout.minimumWidth: Layout.preferredWidth * 3 / 4
    Layout.minimumHeight: Layout.preferredHeight * 3 / 4

    width: Layout.preferredWidth
    height: Layout.preferredHeight

    property double defaultFontPixelSize: theme.defaultFont.pixelSize
    property double footerHeight: defaultFontPixelSize

    property int nextDayItemSpacing: defaultFontPixelSize * 0.5
    property int nextDaysHeight: defaultFontPixelSize * 9
    property int nextDaysVerticalMargin: defaultFontPixelSize
    property int hourLegendMargin: defaultFontPixelSize * 2
    property double nextDayItemWidth: (width / nextDaysCount) - (2 * nextDayItemSpacing)
    property int headingHeight: defaultFontPixelSize * 2

    property alias meteogram: meteogram2

    property bool isShowAlertClicked: false
    property bool hasAlerts: weatherAlertsModel.count > 0
    property bool isShowAlert: isShowAlertClicked && hasAlerts

    PlasmaComponents.Label {
        id: currentLocationText

        anchors.left: parent.left
        anchors.top: parent.top
        verticalAlignment: Text.AlignTop

        text: main.placeAlias
    }

    PlasmaComponents.Label {
        id: weatherAlertNotifierText

        anchors.left: currentLocationText.right
        anchors.leftMargin: 5 * units.devicePixelRatio
        verticalAlignment: Text.AlignTop

        text: "\u26A0"
        color: "#986f00"
        visible: hasAlerts
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: weatherAlertNotifierText

        hoverEnabled: true

        onClicked: {
            isShowAlertClicked = !isShowAlertClicked
        }

        onEntered: {
            weatherAlertNotifierText.font.bold = true
        }

        onExited: {
            weatherAlertNotifierText.font.bold = false
        }
    }

    /* select right axis weather variable */
    RowLayout {
        spacing: 0
        anchors.top: parent.top
        anchors.right: parent.right

        ChartSelectorButtons {
            selectedVarName: meteogram.y1VarName
            meteogram: fullRepresentation.meteogram
            meteogramModel: main.meteogramModel
            model: [
                { label: String.fromCodePoint(0xf078), varName: "dewPoint",
                    tooltip: i18n("Dew Point")
                },
                { label: String.fromCodePoint(0xf055), varName: "feelsLike",
                    tooltip: i18n("Feels Like")
                },
            ]
            callback: function callback(varName) {
                if (meteogram.y1VarName === varName) {
                    meteogram.y1VarName = ""
                } else {
                    meteogram.y1VarName = varName
                }
            }

            Layout.alignment: Qt.AlignCenter
        }

        Label {
            text: "\uFF5C"
            color: PlasmaCore.Theme.disabledTextColor
            Layout.leftMargin: 0
            Layout.rightMargin: 0
        }

        ChartSelectorButtons {
            selectedVarName: "precipitationAmount"
            meteogram: fullRepresentation.meteogram
            meteogramModel: main.meteogramModel
            model: [
                { label: String.fromCodePoint(0x1F3F7), varName: "precipitationAmount",
                    tooltip: i18n("Precipitation Labels")
                },
            ]
            callback: function callback(varName) {
                if (varName === "precipitationAmount") {
                    let val = plasmoid.configuration.renderPrecipitationLabels
                    plasmoid.configuration.renderPrecipitationLabels = !val
                    main.reloadMeteogram()
                }
            }

            Layout.alignment: Qt.AlignCenter
        }

        Label {
            text: "\uFF5C"
            color: PlasmaCore.Theme.disabledTextColor
            Layout.leftMargin: 0
            Layout.rightMargin: 0
        }

        ChartSelectorButtons {
            selectedVarName: meteogram.y2VarName
            meteogram: fullRepresentation.meteogram
            meteogramModel: main.meteogramModel
            model: [
                { label: "\uf079", varName: "pressure", tooltip: i18n("Pressure") },
                { label: "\uf050", varName: "windSpeed", tooltip: i18n("Wind Speed") },
                { label: "\uf0cc", varName: "windGust", tooltip: i18n("Wind Gust") },
                { label: "\uf084", varName: "precipitationProb", tooltip: i18n("POP") },
                { label: "\uf00d", varName: "uvi", tooltip: i18n("UV Index") },
            ]
            callback: function callback(varName) {
                if (meteogram.y2VarName === varName) {
                    meteogram.y2VarName = ""
                } else {
                    meteogram.y2VarName = varName
                }
            }

            Layout.alignment: Qt.AlignCenter
        }
    }

    /* next location buttons */
    RowLayout {
        visible: !onlyOnePlace

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            Layout.alignment: Qt.AlignCenter

            Component {
                id: buttonComponent

                Label {
                    text: modelData.label
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: main.setNextPlace(false, modelData.direction)
                        onEntered: parent.color = theme.highlightColor
                        onExited: parent.color = theme.textColor
                    }
                }
            }

            Repeater {
                model: [
                    { label: "     \u25C4", direction: "-" },
                    { label: "\u25BA     ", direction: "+" }
                ]

                delegate: buttonComponent
            }
        }
    }

    MeteogramColors {
        id: palette
    }

    Meteogram {
        id: meteogram2
        anchors.top: parent.top
        anchors.topMargin: headingHeight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: nextDaysView.top
        anchors.bottomMargin: 14 /* wind area */
        visible: !isShowAlert && !metnoDailyWeatherInfo.visible && !owmDailyWeatherInfo.visible
     }

    MeteogramInfo {
        id: meteogramInfo
        z: 1
    }

     MetNoDailyWeatherInfo {
        id: metnoDailyWeatherInfo

        anchors.top: parent.top
        anchors.topMargin: headingHeight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: nextDaysView.top
        anchors.bottomMargin: 14 /* wind area */

        anchors.leftMargin: units.largeSpacing
        anchors.rightMargin: units.largeSpacing

        model: null
        visible: model != null
     }

     OwmDailyWeatherInfo {
        id: owmDailyWeatherInfo

        anchors.top: parent.top
        anchors.topMargin: headingHeight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: nextDaysView.top
        anchors.bottomMargin: 14 /* wind area */

        anchors.leftMargin: units.largeSpacing
        anchors.rightMargin: units.largeSpacing

        model: null
        visible: model != null
     }

    Rectangle {
        anchors.top: weatherAlertsView.top
        anchors.left: weatherAlertsView.left
        anchors.right: weatherAlertsView.right
        anchors.bottom: weatherAlertsView.bottom

        color: 'transparent'
        border.color: theme.borderColor ? theme.borderColor : "black"
        border.width: 1

        visible: isShowAlert
    }

    ColumnLayout {
        id: weatherAlertsView
        visible: isShowAlert

        anchors.fill: meteogram2

        ListView {
            model: weatherAlertsModel
            clip: true

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 5

            header: Rectangle {
                width: weatherAlertsView.width - 10
                height: childrenRect.height

                border.width: 1
                border.color: 'red'
                color: 'transparent'

                Text {
                    text: i18n("Weather Alerts")
                    color: theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }

            }


            delegate: AlertItem {
                width: weatherAlertsView.width
            }
        }
    }

  /*
     *
     * NEXT DAYS
     *
     */
    ListView {
        id: nextDaysView
        anchors.bottom: parent.bottom
        anchors.bottomMargin: footerHeight + nextDaysVerticalMargin
        anchors.left: parent.left
        anchors.leftMargin: hourLegendMargin
        anchors.right: parent.right
        anchors.rightMargin: hourLegendMargin
        height: nextDaysHeight
        clip: true

        model: dailyWeatherModels.model
        orientation: Qt.Horizontal
        spacing: nextDayItemSpacing
        interactive: false

        delegate: NextDayItem {
            width: nextDayItemWidth
            height: nextDaysHeight
        }
    }

    Column {
        id: hourLegend
        anchors.bottom: parent.bottom
        anchors.bottomMargin: footerHeight + nextDaysVerticalMargin
        spacing: 1 * units.devicePixelRatio
        width: hourLegendMargin
        height: nextDaysHeight - defaultFontPixelSize

        PlasmaComponents.Label {
            text: i18n("NGT")
            width: parent.width
            height: parent.height / 4
            font.pixelSize: defaultFontPixelSize * 0.8
            font.pointSize: -1
            horizontalAlignment: Text.AlignRight
            opacity: 0.6
        }
        PlasmaComponents.Label {
            text: i18n("MRNG")
            width: parent.width
            height: parent.height / 4
            font.pixelSize: defaultFontPixelSize * 0.8
            font.pointSize: -1
            horizontalAlignment: Text.AlignRight
            opacity: 0.6
        }
        PlasmaComponents.Label {
            text: i18n("AFTN")
            width: parent.width
            height: parent.height / 4
            font.pixelSize: defaultFontPixelSize * 0.8
            font.pointSize: -1
            horizontalAlignment: Text.AlignRight
            opacity: 0.6
        }
        PlasmaComponents.Label {
            text: i18n("EVE")
            width: parent.width
            height: parent.height / 4
            font.pixelSize: defaultFontPixelSize * 0.8
            font.pointSize: -1
            horizontalAlignment: Text.AlignRight
            opacity: 0.6
        }
    }


    /*
     *
     * FOOTER
     *
     */
    MouseArea {
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        width: lastReloadedTextComponent.contentWidth
        height: lastReloadedTextComponent.contentHeight

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        PlasmaComponents.Label {
            id: lastReloadedTextComponent
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignBottom

            text: lastReloadedText

            Connections {
                target: plasmoid
                function onExpandedChanged() {
                    isShowAlertClicked = false
                    main.updateLastReloadedText()
                }
            }
        }

        PlasmaComponents.Label {
            id: reloadTextComponent
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignBottom

            text: !pressAndHoldTimer.running ? '\u21bb '+ i18n("Reload") :
                                               '\u21bb '+ i18n("Reloading in ") + pressCountdownTimer.reloadTimerTs
            visible: false
        }

        onEntered: {
            reloadTime.updateNextReloadText(cacheKey)
            lastReloadedTextComponent.text = reloadTime.nextReloadText
            lastReloadedTextComponent.visible = true
            reloadTextComponent.visible = false
        }

        onExited: {
            lastReloadedTextComponent.text = lastReloadedText
            lastReloadedTextComponent.visible = true
            reloadTextComponent.visible = false
            pressAndHoldTimer.stop()
        }

        onClicked: {
            main.tryReload()
        }

        onPressed: {
            pressCountdownTimer.reloadTimerStartTs = Date.now() + (pressAndHoldTimer.interval)
            pressAndHoldTimer.restart()
            lastReloadedTextComponent.visible = false
            reloadTextComponent.visible = true
        }

        onReleased: {
            pressAndHoldTimer.stop()
            lastReloadedTextComponent.visible = true
            reloadTextComponent.visible = false
        }

        Timer {
            id: pressAndHoldTimer
            interval: 5 * 1000
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: {
                main.reloadData()
            }
        }

        Timer {
            id: pressCountdownTimer
            interval: 100
            repeat: true
            running: pressAndHoldTimer.running
            triggeredOnStart: true


            property double reloadTimerStartTs: 0
            property double reloadTimerTs: 0

            onTriggered: {
                reloadTimerTs = Math.round((reloadTimerStartTs - Date.now()) / 100) / 10
            }
        }
    }


    PlasmaComponents.Label {
        id: creditText

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        verticalAlignment: Text.AlignBottom

        text: creditLabel
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: creditText

        hoverEnabled: true

        onClicked: {
            dbgprint('opening: ', creditLink)
            Qt.openUrlExternally(creditLink)
        }

        onEntered: {
            creditText.font.underline = true
        }

        onExited: {
            creditText.font.underline = false
        }
    }
}
