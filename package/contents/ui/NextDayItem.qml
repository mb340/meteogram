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
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {

    property int itemRowSpacing: 5 * units.devicePixelRatio
    property double periodFontSize: theme.defaultFont.pixelSize
    property double periodHeight: (height - periodFontSize - itemRowSpacing * 4) / 4
    property color lineColor: theme.textColor

    PlasmaComponents.Label {
        id: dayTitleText
        text: date.toLocaleDateString(Qt.locale(), 'ddd d MMM')
        anchors.top: parent.top
        height: periodFontSize
        verticalAlignment: Text.AlignBottom
    }

    Item {
        id: dayTitleLine
        width: parent.width
        height: 1 * units.devicePixelRatio
        anchors.top: parent.top
        anchors.topMargin: periodFontSize * 0.8

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

    property var periodModels: model.models

    ManagedListModel {
        id: _periodModels
    }

    onPeriodModelsChanged: {
        if (!periodModels || !periodModels.count) {
            return
        }
        _periodModels.beginList()
        for (var i = 0; i < periodModels.count; i++) {
            _periodModels.addItem(periodModels.get(i))
        }
        _periodModels.endList()
    }

    GridLayout {
        anchors.fill: parent
        anchors.topMargin: periodFontSize

        columns: 1
        rowSpacing: 5 * units.devicePixelRatio

        height: parent.height - anchors.topMargin
        width: parent.width

        Repeater {
            model: _periodModels.model

            NextDayPeriodItem {
                width: parent.width
                height: periodHeight
                temperature: model.temperature
                temperature_min: model.temperatureLow
                temperature_max: model.temperatureHigh
                iconName: model.iconName
                hidden: !isFinite(model.temperature)
                // past: isPast0
                partOfDay: (index == 0 || index == 3) ? 1 : 0
                pixelFontSize: periodFontSize
            }
        }
    }

}
