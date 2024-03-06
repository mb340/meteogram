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
import org.kde.kirigami as Kirigami


Item {
    id: root

    property double periodFontSize: Kirigami.Theme.defaultFont.pixelSize

    property double titleHeight: NaN
    property double rowHeight: NaN

    required property var now

    required property int index
    required property var date
    required property var models


    Label {
        id: dayTitleText
        text: date.toLocaleDateString(Qt.locale(), 'ddd d MMM')
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        height: !isNaN(titleHeight) ? titleHeight : null
        verticalAlignment: Text.AlignBottom
    }

    GradientUnderline {
        id: dayTitleLine

        width: parent.width
        height: 1 * 1

        anchors.top: dayTitleText.bottom
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        lineColor: main.theme.textColor
    }

    Grid {
        id: itemGrid
        anchors.top: dayTitleText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 0

        spacing: 0

        columns: 1

        height: parent.height - (dayTitleText.height + dayTitleLine.height)


        Repeater {
            model: [0, 1, 2, 3]

            NextDayPeriodItem {
                width: parent.width / parent.columns
                height: rowHeight

                property var model: root.models.get(index)

                date: !model ? new Date(0) : model.date
                temperature: !model ? NaN : model.temperature
                temperatureLow: !model ? NaN : model.temperatureLow
                temperatureHigh: !model ? NaN : model.temperatureHigh
                iconName: !model ? "" : model.iconName

                now: root.now

                pixelFontSize: periodFontSize
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onEntered: {
            if (!currentProvider) {
                metnoDailyWeatherInfo.model = null
                owmDailyWeatherInfo.model = null
                return
            }
            if (currentProvider.providerId === "metno" || currentProvider.providerId === "openMeteo") {
                loadMetNoInfo(true)
                metnoDailyWeatherInfo.model = dailyWeatherModels.get(index)
            } else if (currentProvider.providerId === "owm") {
                loadOwmInfo(true)
                owmDailyWeatherInfo.model = dailyWeatherModels.get(index)
            }
        }

        onExited: {
            if (metnoDailyWeatherInfo) {
                metnoDailyWeatherInfo.model = null
            }
            if (owmDailyWeatherInfo) {
                owmDailyWeatherInfo.model = null
            }
        }
    }
}
