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
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "data_models"


Item {
    id: fullRepresentation

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
                                | PlasmaCore.Types.ConfigurableBackground

    property int preferredImageWidth: 800 * 1 // Makes yr.no images grainy,
    property int preferredImageHeight: 320 * 1 + defaultFontPixelSize// prefer rendering meteograms

    Layout.preferredWidth: preferredImageWidth
    Layout.preferredHeight: headingHeight + preferredImageHeight + footerHeight + nextDaysHeight + 14
    Layout.minimumWidth: Layout.preferredWidth * 3 / 4
    Layout.minimumHeight: Layout.preferredHeight * 3 / 4

    width: Layout.preferredWidth
    height: Layout.preferredHeight

    property double defaultFontPixelSize: Kirigami.Theme.defaultFont.pixelSize
    property double footerHeight: defaultFontPixelSize

    property int nextDaysHeight: defaultFontPixelSize * 9
    property int nextDaysVerticalMargin: defaultFontPixelSize

    property int headingHeight: defaultFontPixelSize * 2

    property alias meteogram: meteogram2

    property bool isShowAlertClicked: false
    property bool hasAlerts: weatherAlertsModel.count > 0
    property bool isShowAlert: isShowAlertClicked && hasAlerts

    property bool fillModels: main.expanded

    property Item meteogramInfo: meteogramInfoLoader.item
    property bool showMeteogramInfo: false

    property alias labelWidth: textMetrics.width
    property alias labelHeight: textMetrics.height


    onFillModelsChanged: {
        loadMetNoInfo(false)
        loadOwmInfo(false)
    }

    TextMetrics {
        id: textMetrics
        font.family: Kirigami.Theme.defaultFont.family
        font.pixelSize: Kirigami.Theme.smallFont.pixelSize
        text: "999999"
    }

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
        anchors.leftMargin: 5 * 1
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

    ChartSelectorBar {
        anchors.top: parent.top
        anchors.right: parent.right
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
                        onEntered: parent.color = main.theme.highlightColor
                        onExited: parent.color = main.theme.textColor
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
        anchors.bottom: windSpeedArea.top
        visible: !isShowAlert &&
                    (!metnoDailyWeatherInfo || !metnoDailyWeatherInfo.visible) &&
                    (!owmDailyWeatherInfo || !owmDailyWeatherInfo.visible)
    }

    WindSpeedArea {
        id: windSpeedArea

        width: meteogram2.imageWidth
        height: Kirigami.Units.largeSpacing + (2 * Kirigami.Units.smallSpacing)

        anchors.bottom: nextDaysView.top
        anchors.left: meteogram2.left
        anchors.leftMargin: labelWidth

        visible: meteogram2.visible

        hourStep: meteogram2.hourStep
        rectWidth: meteogram2.rectWidth

        timeScale: meteogram2.timeScale

    }


    Loader {
        id: meteogramInfoLoader
        sourceComponent: showMeteogramInfo ? meteogramInfoComponent : undefined

        Component {
            id: meteogramInfoComponent
            MeteogramInfo {
                id: meteogramInfo
                z: 1
            }
        }

        onLoaded: {
            item.parent = fullRepresentation
        }
    }

    function loadMetNoInfo(load) {
        if (load && metnoDailyWeatherInfo == null) {
            metnoDailyWeatherInfo = metnoInfoComponent.createObject(fullRepresentation)
            return
        } else if (!load && metnoDailyWeatherInfo != null) {
            metnoDailyWeatherInfo.destroy()
            metnoDailyWeatherInfo = null
        }
    }

    function loadOwmInfo(load) {
        if (load && owmDailyWeatherInfo == null) {
            owmDailyWeatherInfo = owmInfoComponent.createObject(fullRepresentation)
            return
        } else if (!load && owmDailyWeatherInfo != null) {
            owmDailyWeatherInfo.destroy()
            owmDailyWeatherInfo = null
        }
    }

    property Item metnoDailyWeatherInfo: null
    property Item owmDailyWeatherInfo: null

    Component {
        id: metnoInfoComponent

        MetNoDailyWeatherInfo {
            anchors.top: parent.top
            anchors.topMargin: headingHeight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: nextDaysView.top

            anchors.leftMargin: Kirigami.Units.largeSpacing
            anchors.rightMargin: Kirigami.Units.largeSpacing

            model: null
            visible: model != null
        }
    }

    Component {
        id: owmInfoComponent

        OwmDailyWeatherInfo {
            anchors.top: parent.top
            anchors.topMargin: headingHeight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: nextDaysView.top

            anchors.leftMargin: Kirigami.Units.largeSpacing
            anchors.rightMargin: Kirigami.Units.largeSpacing

            model: null
            visible: model != null
        }
     }

    Rectangle {
        anchors.top: weatherAlertsView.top
        anchors.left: weatherAlertsView.left
        anchors.right: weatherAlertsView.right
        anchors.bottom: weatherAlertsView.bottom

        color: 'transparent'
        border.color: Kirigami.Theme.borderColor ?? "black"
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
                    color: main.theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }

            }


            delegate: AlertItem {
                width: weatherAlertsView.width
            }
        }
    }


    NextDays {
        id: nextDaysView

        anchors.bottom: parent.bottom
        anchors.bottomMargin: footerHeight + nextDaysVerticalMargin
        anchors.left: parent.left
        anchors.right: parent.right

        height: nextDaysHeight
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
                target: main
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
