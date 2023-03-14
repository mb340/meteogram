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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.0 as QtQuickOne
import org.kde.plasma.plasmoid 2.0


Item {
    id: fullRepresentation

    width: parent ? parent.width : 1

    property double nextDayRowFontPixelSize: 24 * units.devicePixelRatio

    property double defaultFontPixelSize: theme.defaultFont.pixelSize
    property double footerHeight: defaultFontPixelSize * 3.5

    property int headingHeight: defaultFontPixelSize * 3

    property double headingTopMargin: defaultFontPixelSize

    property color lineColor: theme.textColor

    Label {
        id: currentLocationText

        anchors.left: parent.left
        anchors.top: parent.top

        text: main.placeAlias
    }

    Label {
        id: nextLocationText

        anchors.right: parent.right
        anchors.top: parent.top
        visible: !onlyOnePlace

        text: i18n("Next Location")
        color: theme.textColor
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: nextLocationText

        hoverEnabled: true

        onClicked: {
            dbgprint('clicked next location')
            main.setNextPlace()
        }

        onEntered: {
            nextLocationText.font.underline = true
        }

        onExited: {
            nextLocationText.font.underline = false
        }
    }




    /*
     *
     * NEXT DAYS
     *
     */
    QtQuickOne.ScrollView {
        id: nextDays

        anchors.top: parent.top
        anchors.topMargin: headingHeight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: footerHeight

        width: parent.width

        ListView {
            id: nextDaysView

            anchors.fill: parent
            width: parent.width
            height: parent.height

            model: dailyWeatherModels.model
            orientation: Qt.Vertical
            spacing: 0
            interactive: false

            delegate: NextDayItem {
                width: parent.width
                height: titleHeight + rowHeight

                titleHeight: nextDayTitleMetrics.height
                rowHeight: nextDayRowMetrics.height

                periodFontSize: nextDayRowMetrics.font.pixelSize
            }
        }

    }

    TextMetrics {
        id: nextDayRowMetrics
        font.family: theme.defaultFont.family
        font.pixelSize: nextDayRowFontPixelSize
        text: "MMMMMM"
    }

    TextMetrics {
        id: nextDayTitleMetrics
        font.family: theme.defaultFont.family
        font.pixelSize: theme.defaultFont.pixelSize
        text: "MMMMMM"
    }

    /*
     *
     * FOOTER
     *
     */
    MouseArea {
        id: reloadMouseArea

        anchors.top: nextDays.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.topMargin: units.smallSpacing

        width: lastReloadedTextComponent.contentWidth
        height: lastReloadedTextComponent.contentHeight

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        Label {
            id: lastReloadedTextComponent
            anchors.fill: parent

            verticalAlignment: Text.AlignTop

            text: lastReloadedText
        }

        Label {
            id: reloadTextComponent
            anchors.fill: parent

            verticalAlignment: Text.AlignTop

            text: '\u21bb '+ i18n("Reload")
            visible: false
        }

        onEntered: {
            lastReloadedTextComponent.visible = false
            reloadTextComponent.visible = true
        }

        onExited: {
            lastReloadedTextComponent.visible = true
            reloadTextComponent.visible = false
            pressAndHoldTimer.stop()
        }

        onClicked: {
            main.tryReload()
        }

        onPressed: {
            pressAndHoldTimer.restart()
        }

        onReleased: {
            pressAndHoldTimer.stop()
        }

        Timer {
            id: pressAndHoldTimer
            interval: 2 * 1000
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: {
                main.reloadData()
            }
        }
    }


    Label {
        id: creditText

        anchors.top: nextDays.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: reloadMouseArea.right
        anchors.topMargin: units.smallSpacing
        anchors.leftMargin: units.largeSpacing

        text: creditLabel
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        elide: Text.ElideRight
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
