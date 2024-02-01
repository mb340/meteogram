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
import QtGraphicalEffects 1.12
import org.kde.plasma.plasmoid 2.0
import "../code/icons.js" as IconTools
import "data_models"
import "utils"


Item {
    id: root
    visible: true

    property int imageWidth: width - (labelWidth * 2)
    property int imageHeight: height - labelHeight - cloudarea - windarea
    property int labelWidth: textMetrics.width
    property int labelHeight: textMetrics.height

    property int cloudarea: 0
    property int windarea: units.largeSpacing

    readonly property int minTemperatureYGridCount: 20

    property double temperatureYGridStep: 1.0
    property int temperatureYGridCount: minTemperatureYGridCount   // Number of vertical grid Temperature elements

    // Decimal places for pressure y-axis labels
    property int rightAxisDecimals: 0

    property double precipitationMaxGraphY: 10

    property color gridColor: main.colors.meteogram.isDarkMode ?
                                Qt.tint(main.colors.meteogram.textColor, '#80000000') :
                                Qt.tint(main.colors.meteogram.textColor, '#80FFFFFF')
    property color gridColorHighlight: main.colors.meteogram.isDarkMode ?
                                        Qt.tint(main.colors.meteogram.textColor, '#50000000') :
                                        Qt.tint(main.colors.meteogram.textColor, '#50FFFFFF')

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


    onY2VarNameChanged: {
        plasmoid.configuration.y2VarName = y2VarName
        fullRedraw()
    }

    onY1VarNameChanged: {
        plasmoid.configuration.y1VarName = y1VarName
        fullRedraw()
    }

    TextMetrics {
        id: textMetrics
        font.family: theme.defaultFont.family
        font.pixelSize: theme.smallestFont.pixelSize
        text: "999999"
    }

    Item {
        id: meteogram
        width: imageWidth + (labelWidth * 2)
        height: imageHeight + (labelHeight) + cloudarea + windarea
    }

    property alias backgroundCanvas: backgroundCanvas

    Rectangle {
        id: graphArea
        width: imageWidth
        height: imageHeight
        anchors.top: meteogram.top
        anchors.left: meteogram.left
        anchors.leftMargin: labelWidth
        anchors.rightMargin: labelWidth
        anchors.topMargin: labelHeight  + cloudarea
        border.color:gridColor
        // color: colorPalette.backgroundColor()
        color: "transparent"

        MeteogramBackgroundCanvas {
            id: backgroundCanvas
            anchors.fill: parent

            colors: main.colors
            currentWeatherModel: main.currentWeatherModel
            meteogramModel: main.meteogramModel
            scale: meteogramCanvas.timeScale
        }
    }

    VerticalAxisLabels {
        id: horizontalLines
        anchors.left: graphArea.left
        anchors.top: graphArea.top
        height: graphArea.height + labelHeight
    }

    Label {
        text: unitUtils.formatUnits(y2VarName, unitUtils.getUnitType(y2VarName))
        height: labelHeight
        width: labelWidth
        horizontalAlignment: (text.length > 4) ? Text.AlignRight : Text.AlignLeft
        anchors.right: (graphArea.right)
        anchors.rightMargin: -labelWidth
        font.pixelSize: theme.smallestFont.pixelSize
        font.pointSize: -1
        color: colorPalette.pressureColor()
        anchors.bottom: graphArea.top
        anchors.bottomMargin: 6
        visible: y2AxisVisble
    }
    Label {
        text: unitUtils.getTemperatureEnding(temperatureType)
        height: labelHeight
        width: labelWidth
        horizontalAlignment: Text.AlignHCenter
        anchors.right: (graphArea.left)
        font.pixelSize: theme.smallestFont.pixelSize
        font.pointSize: -1
        anchors.bottom: graphArea.top
        anchors.bottomMargin: 6
    }

    HorizontalAxisLabels {
        id: hourGrid2
        anchors.fill: graphArea
    }

    Item {
        id: windSpeedArea
        width: imageWidth
        height: windarea
        anchors.top: hourGrid2.bottom
        anchors.left: hourGrid2.left
        anchors.topMargin: labelHeight + units.smallSpacing

        ManagedListModel {
            id: windSpeedModel
        }

        function setModel(count) {
            let xOffset = (windSpeedRepeater.rectWidth / 2)
            windSpeedModel.beginList()
            for (var i = 0; i < count; i++) {
                let item = meteogramModel.get(i)
                if (!item || !isFinite(item.windSpeed)) {
                    continue
                }

                let t = item.from
                if (meteogramModel.hourInterval === 1 && (t.getHours()) % meteogramCanvas.hourStep !== 0) {
                    continue
                }

                windSpeedModel.addItem({
                    xPos: timeScale.translate(t.getTime()) - xOffset,
                    windSpeed: item.windSpeed,
                    windDirection: item.windDirection,
                })
            }
            windSpeedModel.endList()
        }

        Repeater {
            id: windSpeedRepeater
            model: windSpeedModel.model
            delegate: windIconDelegate

            property double rectWidth: meteogramCanvas.hourStep * (meteogramCanvas.rectWidth)
            property int iconSetType: plasmoid.configuration.windIconSetType

            Component {
                id: windIconDelegate

                Item {
                    id: windspeedAnchor
                    width: windSpeedRepeater.rectWidth
                    height: labelHeight
                    x: xPos
                    y: 0

                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: wind
                        source: isNaN(windSpeed) ? "" :
                                    windStrength(windSpeed, windSpeedRepeater.iconSetType)
                        fillMode: Image.PreserveAspectFit

                        width: height
                        height: windarea
                        anchors.centerIn: parent

                        visible: false

                        asynchronous: true
                    }

                    ColorOverlay {
                        anchors.fill: wind
                        source: wind
                        rotation: windFrom(windDirection, windSpeedRepeater.iconSetType)
                        color: main.colors.isShowBackground ?
                                    main.colors.disabledTextColor :
                                    main.colors.textColor
                        opacity: main.colors.isShowBackground ? 1.0 : 0.60
                        antialiasing: true
                        visible: true
                    }

                    function windFrom(rotation, iconSetType) {
                        rotation = IconTools.translateWindDirection(rotation, iconSetType)

                        rotation = (Math.round( rotation / 22.5 ) * 22.5)
                        rotation = (rotation >= 180) ? rotation - 180 : rotation + 180
                        return rotation
                    }
                    function windStrength(windspeed, iconSetType) {
                        windspeed = unitUtils.convertWindspeed(windspeed,
                                                UnitUtils.WindSpeedType.KNOTS)
                        return IconTools.getWindSpeedIconResource(windspeed, iconSetType)
                    }
                }
            }
        }
    }

    Item {
        z: 1
        id: canvases
        anchors.fill: graphArea
        anchors.topMargin: 0

        MeteogramCanvas {
            id: meteogramCanvas
            anchors.fill: parent
        }

        Canvas {
            id: meteogramInfoCanvas
            anchors.fill: parent
            contextType: '2d'

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
            anchors.fill: parent

            onPressed: {
                meteogramInfo.visible = true
                cursorShape = Qt.CrossCursor
                update(mouse)
                meteogramInfoCanvas.requestPaint()
            }

            onReleased: {
                meteogramInfo.visible = false
                cursorShape = Qt.PointingHandCursor
                meteogramInfoCanvas.requestPaint()
            }

            onExited: {
                if (meteogramInfo.visible) {
                    meteogramInfo.idx = -1
                    meteogramInfo.visible = false
                    meteogramInfoCanvas.requestPaint()
                }
            }

            onPositionChanged: {
                update(mouse)
                if (meteogramInfo.visible) {
                    meteogramInfoCanvas.requestPaint()
                }
            }

            function update(mouse) {
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
    }

    function fullRedraw() {
        meteogramCanvas.fullRedraw()
    }
}
