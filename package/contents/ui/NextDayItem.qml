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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Item {
    id: root

    property double periodFontSize: theme.defaultFont.pixelSize
    property color lineColor: main.textColor

    property double titleHeight: NaN
    property double rowHeight: NaN

    property bool mainInTray: main.inTray

    required property var now

    required property int index
    required property var date
    required property var models


    Label {
        id: dayTitleText
        text: date.toLocaleDateString(Qt.locale(), 'ddd d MMM')
        anchors.top: parent.top
        anchors.topMargin: mainInTray ? dayTitleLine.height : 0
        anchors.bottomMargin: 0
        height: !isNaN(titleHeight) ? titleHeight : null
        verticalAlignment: Text.AlignBottom
    }

    Item {
        id: dayTitleLine
        width: parent.width
        height: 1 * units.devicePixelRatio
        anchors.top: mainInTray ? dayTitleText.top : dayTitleText.bottom
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0) }
                GradientStop { position: 0.1; color: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 1) }
                GradientStop { position: 1.0; color: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0) }
            }
        }

    }

    Grid {
        id: itemGrid
        anchors.top: dayTitleText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 0

        spacing: 0

        columns: mainInTray ? 4 : 1

        height: parent.height - (dayTitleText.height + dayTitleLine.height)


        Repeater {
            model: models

            NextDayPeriodItem {
                width: parent.width / parent.columns
                height: rowHeight

                now: root.now

                pixelFontSize: periodFontSize
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: !mainInTray

        onEntered: {
            if (mainInTray) {
                return
            }
            if (currentProvider.providerId === "metno" || currentProvider.providerId === "openMeteo") {
                metnoDailyWeatherInfo.model = dailyWeatherModels.get(index)
            } else if (currentProvider.providerId === "owm") {
                owmDailyWeatherInfo.model = dailyWeatherModels.get(index)
            }
        }

        onExited: {
            if (mainInTray) {
                return
            }
            metnoDailyWeatherInfo.model = null
            owmDailyWeatherInfo.model = null
        }
    }
}
