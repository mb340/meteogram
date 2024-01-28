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
import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "data_models"

Item {
    id: fullRepresentation

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
                                | PlasmaCore.Types.ConfigurableBackground

    property int preferredImageWidth: 800 * units.devicePixelRatio // Makes yr.no images grainy,
    property int preferredImageHeight: 320 * units.devicePixelRatio + defaultFontPixelSize// prefer rendering meteograms

    Layout.preferredWidth: preferredImageWidth
    Layout.preferredHeight: headingHeight + preferredImageHeight + footerHeight + nextDaysHeight + 14
    Layout.minimumWidth: main.isPanel ? Layout.preferredWidth * 3 / 4 : 0
    Layout.minimumHeight: main.isPanel ? Layout.preferredHeight * 3 / 4 : 0

    width: Layout.preferredWidth
    height: Layout.preferredHeight

    property double defaultFontPixelSize: theme.defaultFont.pixelSize
    property double footerHeight: defaultFontPixelSize

    property int nextDayItemSpacing: defaultFontPixelSize * 0.5
    property int nextDaysHeight: defaultFontPixelSize * 9
    property int nextDaysVerticalMargin: defaultFontPixelSize
    property int hourLegendMargin: defaultFontPixelSize * 2
    property double nextDayItemWidth: (width / dailyWeatherModels.count) - (2 * nextDayItemSpacing)
    property int headingHeight: defaultFontPixelSize * 2

    property alias meteogram: meteogram2

    property bool isShowAlertClicked: false
    property bool hasAlerts: weatherAlertsModel.count > 0
    property bool isShowAlert: isShowAlertClicked && hasAlerts

    Label {
        id: currentLocationText

        anchors.left: parent.left
        anchors.top: parent.top
        verticalAlignment: Text.AlignTop

        text: main.placeAlias
    }

    Label {
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
            callback: function callback(modelData) {
                if (meteogram.y1VarName === modelData.varName) {
                    meteogram.y1VarName = ""
                } else {
                    meteogram.y1VarName = modelData.varName
                }
            }

            Layout.alignment: Qt.AlignCenter
        }

        Label {
            text: "\uFF5C"
            color: main.colors.disabledTextColor
            Layout.leftMargin: 0
            Layout.rightMargin: 0
        }

        ChartSelectorButtons {
            radioButtonMode: false
            meteogram: fullRepresentation.meteogram
            meteogramModel: main.meteogramModel

            model: [
                { label: String.fromCodePoint(0x0023), varName: "precipitationAmount",
                    tooltip: i18n("Precipitation Labels"),
                    isSelected: plasmoid.configuration.renderPrecipitationLabels
                },
                { label: main.maxMeteogramHours === plasmoid.configuration.maxMeteogramHours ?
                            String.fromCodePoint(0xFF0B) :
                            String.fromCodePoint(0xFF0D) /*String.fromCodePoint(0x1F5D6)*/,
                    varName: "maxMeteogramHours",
                    tooltip: i18n("Chart all data"),
                    hasVariable: true,
                    isSelected: true,
                }
            ]
            callback: function callback(modelData, viewObj) {
                if (modelData.varName === "precipitationAmount") {
                    let val = plasmoid.configuration.renderPrecipitationLabels
                    plasmoid.configuration.renderPrecipitationLabels = !val
                    viewObj.isSelected = plasmoid.configuration.renderPrecipitationLabels
                    main.reloadMeteogram()
                } else if (modelData.varName === "maxMeteogramHours") {
                    if (main.maxMeteogramHours == 1000) {
                        main.maxMeteogramHours = plasmoid.configuration.maxMeteogramHours
                    } else {
                        main.maxMeteogramHours = 1000
                    }
                }
            }

            Layout.alignment: Qt.AlignCenter
        }

        Label {
            text: "\uFF5C"
            color: main.colors.disabledTextColor
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
            callback: function callback(modelData) {
                if (meteogram.y2VarName === modelData.varName) {
                    meteogram.y2VarName = ""
                } else {
                    meteogram.y2VarName = modelData.varName
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

                    ToolTip.text: modelData.tooltipText
                    ToolTip.visible: mouseArea.containsMouse

                    MouseArea {
                        id: mouseArea
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: main.setNextPlace(modelData.previous)
                        onEntered: parent.color = main.colors.highlightColor
                        onExited: parent.color = main.colors.textColor
                    }
                }
            }

            Repeater {
                model: [
                    {
                        label: "     \u140A",
                        previous: true,
                        tooltipText: i18n("Previous location")
                    },
                    {
                        label: "\u1405     ",
                        previous: false,
                        tooltipText: i18n("Next location")
                    }
                ]

                delegate: buttonComponent
            }
        }
    }

    Meteogram {
        id: meteogram2
        anchors.top: parent.top
        anchors.topMargin: headingHeight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: nextDaysView.top
        anchors.bottomMargin: windarea + units.smallSpacing
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
        anchors.bottomMargin: meteogram.windarea /* wind area */

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
        anchors.bottomMargin: meteogram.windarea /* wind area */

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
                    color: main.colors.textColor
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

        model: dailyWeatherModels.model
        orientation: Qt.Horizontal
        spacing: nextDayItemSpacing
        interactive: false

        property var now: undefined

        delegate: NextDayItem {
            width: nextDayItemWidth
            height: nextDaysView.height

            titleHeight: nextDayTitleMetrics.height
            rowHeight: (nextDaysView.height - titleHeight) / 4

            now: nextDaysView.now
        }

        Component.onCompleted: {
            main.beginLoadFromCache.connect(beginLoadFromCache)
            main.endLoadFromCache.connect(endLoadFromCache)
        }

        function beginLoadFromCache() {
            nextDaysView.model = null
        }

        function endLoadFromCache() {
            now = timeUtils.dateNow(timezoneType, main.timezoneOffset)
            nextDaysView.model = dailyWeatherModels.model
        }
    }

    TextMetrics {
        id: nextDayTitleMetrics
        font.family: theme.defaultFont.family
        font.pixelSize: theme.defaultFont.pixelSize
        text: "MMMMMM"
    }

    Column {
        id: hourLegend
        anchors.top: nextDaysView.top
        width: hourLegendMargin
        height: nextDaysView.height

        property double itemHeight: (hourLegend.height - nextDayTitleMetrics.height) / 4
        property double fontPixelSize: defaultFontPixelSize * 1.25

        Label {
            id: hourLegendSpacer
            text: " "
            height: nextDayTitleMetrics.height
        }

        Item {
            id: hourLegendLineSpacer
            width: 1
            height: 1
        }

        component HourLegendLabel: Label {
            height: parent.itemHeight
            font.family: 'weathericons'
            font.pixelSize: hourLegend.fontPixelSize
            font.pointSize: -1
            horizontalAlignment: Text.AlignCenter
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.6

            ToolTip.visible: mouseArea.containsMouse

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        HourLegendLabel {
            text: "\uf0d2"  // wi-moon-alt-waxing-crescent-3
            ToolTip.text: i18n("Night")
        }
        HourLegendLabel {
            text: "\uf051"  // wi-horizon-alt
            ToolTip.text: i18n("Morning")
        }
        HourLegendLabel {
            text: "\uf00d"  // wi-day-sunny
            ToolTip.text: i18n("Day")
        }
        HourLegendLabel {
            text: "\uf052"  // wi-horizon
            ToolTip.text: i18n("Evening")
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

        Label {
            id: lastReloadedTextComponent
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignBottom

            text: reloadTimer.lastLoadText

            Connections {
                target: plasmoid
                function onExpandedChanged() {
                    isShowAlertClicked = false
                }
            }
        }

        Label {
            id: reloadTextComponent
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignBottom

            text: !pressAndHoldTimer.running ? reloadTimer.nextLoadText :
                        '\u21bb '+ i18n("Reloading in ") + pressCountdownTimer.reloadTimerTs
            visible: false
        }

        onEntered: {
            reloadTimer.updateNextLoadText(cacheKey)
            lastReloadedTextComponent.visible = false
            reloadTextComponent.visible = true
        }

        onExited: {
            lastReloadedTextComponent.visible = true
            reloadTextComponent.visible = false
            pressAndHoldTimer.stop()
        }

        onClicked: {
        }

        onPressed: {
            // Disallow force reloading before API expire time
            // if (!reloadTime.isExpired(cacheKey)) {
            //     let ts = reloadTime.getExpireTime(cacheKey)
            //     let date = new Date(ts)
            //     print("Can't force reload until ", date)
            //     return
            // }

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
                reloadTimer.forceLoad(main.cacheKey)
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


    Label {
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
