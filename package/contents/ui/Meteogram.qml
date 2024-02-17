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
import org.kde.plasma.plasmoid 2.0
import "../code/icons.js" as IconTools
import "data_models"
import "utils"


Item {
    id: root

    property int imageWidth: width - (2 * labelWidth)
    property int imageHeight: height - (2 * labelHeight)

    readonly property int minTemperatureYGridCount: 20

    property double temperatureYGridStep: 1.0
    property int temperatureYGridCount: minTemperatureYGridCount   // Number of vertical grid Temperature elements

    // Decimal places for pressure y-axis labels
    property int rightAxisDecimals: 0

    property double precipitationMaxGraphY: 10

    property color gridColor: main.colors.meteogram.isDarkMode ?
                                Qt.tint(main.colors.meteogram.textColor, '#A0000000') :
                                Qt.tint(main.colors.meteogram.textColor, '#A0FFFFFF')
    property color gridColorHighlight: main.colors.meteogram.isDarkMode ?
                                        Qt.tint(main.colors.meteogram.textColor, '#90000000') :
                                        Qt.tint(main.colors.meteogram.textColor, '#90FFFFFF')

    property string y2VarName: plasmoid.configuration.y2VarName
    property bool y2AxisVisble: meteogramModel.hasVariable(y2VarName)

    property string y1VarName: plasmoid.configuration.y1VarName

    property alias temperatureScale: meteogramCanvas.temperatureScale
    property alias temperatureAxisScale: meteogramCanvas.temperatureAxisScale
    property alias rightAxisScale: meteogramCanvas.rightAxisScale
    property alias rightGridScale: meteogramCanvas.rightGridScale
    property alias precipitationScale: meteogramCanvas.precipitationScale
    property alias cloudAreaScale: meteogramCanvas.cloudAreaScale
    property alias humidityScale: meteogramCanvas.humidityScale
    property alias xIndexScale: meteogramCanvas.xIndexScale
    property alias xAxisScale: meteogramCanvas.xAxisScale
    property alias yAxisScale: meteogramCanvas.yAxisScale
    property alias timeScale: meteogramCanvas.timeScale

    property alias nHours: meteogramCanvas.nHours
    property alias hourStep: meteogramCanvas.hourStep

    property alias rectWidth: meteogramCanvas.rectWidth

    property alias backgroundCanvas: backgroundCanvas


    onY2VarNameChanged: {
        plasmoid.configuration.y2VarName = y2VarName
        fullRedraw()
    }

    onY1VarNameChanged: {
        plasmoid.configuration.y1VarName = y1VarName
        fullRedraw()
    }

    MeteogramBackgroundCanvas {
        id: backgroundCanvas
        anchors.fill: meteogramCanvas

        colors: main.colors
        currentWeatherModel: main.currentWeatherModel
        meteogramModel: main.meteogramModel
        scale: meteogramCanvas.timeScale

        z: 1
    }

    VerticalAxisLabels {
        id: horizontalLines
        anchors.fill: meteogramCanvas
        z: 2
    }

    Label {
        text: unitUtils.formatUnits(y2VarName, unitUtils.getUnitType(y2VarName))
        height: labelHeight
        width: labelWidth
        horizontalAlignment: (text.length > 4) ? Text.AlignRight : Text.AlignLeft
        anchors.right: (meteogramCanvas.right)
        anchors.rightMargin: -labelWidth
        font.pixelSize: theme.smallestFont.pixelSize
        font.pointSize: -1
        color: colorPalette.pressureColor()
        anchors.bottom: meteogramCanvas.top
        anchors.bottomMargin: 6
        visible: y2AxisVisble
    }
    Label {
        text: unitUtils.getTemperatureEnding(temperatureType)
        height: labelHeight
        width: labelWidth
        horizontalAlignment: Text.AlignHCenter
        anchors.right: (meteogramCanvas.left)
        font.pixelSize: theme.smallestFont.pixelSize
        font.pointSize: -1
        anchors.bottom: meteogramCanvas.top
        anchors.bottomMargin: 6
    }

    HorizontalAxisLabels {
        id: hourGrid2
        anchors.fill: meteogramCanvas
        z: 2
    }

    MeteogramCanvas {
        id: meteogramCanvas

        anchors.fill: parent

        anchors.leftMargin: labelWidth
        anchors.rightMargin: labelWidth
        anchors.topMargin: labelHeight
        anchors.bottomMargin: labelHeight

        z: 3
    }

    Canvas {
        id: meteogramInfoCanvas
        contextType: '2d'

        anchors.fill: meteogramCanvas
        z: 4

        onPaint: {
            var context = getContext("2d")
            context.clearRect(0, 0, width, height)
            if (!meteogramInfo || !meteogramInfo.visible) {
                return
            }

            context.fillStyle = Qt.rgba(main.colors.meteogram.highlightColor.r,
                                        main.colors.meteogram.highlightColor.g,
                                        main.colors.meteogram.highlightColor.b,
                                        0.25)

            var [x0, x1] = meteogramCanvas.getItemIntervalX(meteogramInfo.idx)
            context.fillRect(x0, 0, x1 - x0, height);
        }
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: meteogramCanvas

        onPressed: {
            fullRepresentation.showMeteogramInfo = true
            cursorShape = Qt.CrossCursor
            update(mouse)
            meteogramInfoCanvas.requestPaint()
        }

        onReleased: {
            fullRepresentation.showMeteogramInfo = false
            cursorShape = Qt.PointingHandCursor
            meteogramInfoCanvas.requestPaint()
        }

        onExited: {
            fullRepresentation.showMeteogramInfo = false
            meteogramInfoCanvas.requestPaint()
        }

        onPositionChanged: {
            update(mouse)
            if (meteogramInfo && meteogramInfo.visible) {
                meteogramInfoCanvas.requestPaint()
            }
        }

        function update(mouse) {
            if (!meteogramInfo) {
                return
            }

            var idx = Math.round(xIndexScale.invert(mouse.x) - 0.5)
            if (idx < 0 || idx >= meteogramModel.count) {
                return
            }

            var [x0, x1] = meteogramCanvas.getItemIntervalX(idx)
            var rectWidth = x1 - x0

            var globalCoord = mapToItem(fullRepresentation, 0, 0)
            meteogramInfo.x = globalCoord.x + mouse.x
            meteogramInfo.y = globalCoord.y + mouse.y

            meteogramInfo.isAnchorLeft = mouse.x < (imageWidth - meteogramInfo.boxWidth - (1.5 * rectWidth))
            meteogramInfo.isAnchorTop = mouse.y < (globalCoord.y + meteogramInfo.boxHeight + (1.5 * rectWidth))

            if (meteogramInfo.idx !== idx) {
                meteogramInfo.anchorsMargins = 1.5 * rectWidth

                meteogramInfo.idx = idx
                meteogramInfo.hourModel = meteogramModel.get(idx)
            }
        }
    }


    function fullRedraw() {
        meteogramCanvas.fullRedraw()
        backgroundCanvas.requestPaint()
    }
}
