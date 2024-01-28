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
        font.pixelSize: 11 * units.devicePixelRatio
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
    ListView {
        id: horizontalLines1
        model: horizontalLinesModel.model
        anchors.left: graphArea.left
        anchors.top: graphArea.top
//         anchors.bottom: graphArea.bottom + labelHeight
//         anchors.fill: graphArea
        height: graphArea.height + labelHeight
        interactive: false

        property double itemHeight: graphArea.height / (temperatureYGridCount)


        ManagedListModel {
            id: horizontalLinesModel
        }

        function setModel(count) {
            horizontalLinesModel.beginList()
            for (var i = 0; i <= count; i++) {
                if (i % temperatureYGridStep !== 0) {
                    continue
                }
                let y1 = temperatureAxisScale.invert(i)
                let y2 = rightGridScale.invert(i)
                if (!Number.isInteger(y1)) {
                    throw new Error("Temperature axis tick is not integer.")
                }
                horizontalLinesModel.addItem({
                    temperatureLabel: y1.toFixed(0),
                    rightAxisLabel: y2.toFixed(rightAxisDecimals)

                })
            }
            horizontalLinesModel.endList()
        }

        delegate: Item {
            height: horizontalLines1.itemHeight * temperatureYGridStep
            width: graphArea.width

            Rectangle {
                id: gridLine
                width: parent.width
                height: 1 * units.devicePixelRatio
                color: gridColor
            }
            Label {
                text: temperatureLabel
                height: labelHeight
                width: labelWidth
                horizontalAlignment: Text.AlignRight
                anchors.left: gridLine.left
                anchors.top: gridLine.top
                anchors.leftMargin: -labelWidth - 2
                anchors.topMargin: -labelHeight / 2
                font.pixelSize: 11 * units.devicePixelRatio
                font.pointSize: -1
            }
            Label {
                text: rightAxisLabel
                height: labelHeight
                width: labelWidth
                anchors.top: gridLine.top
                anchors.topMargin: -labelHeight / 2
                anchors.left: gridLine.right
                anchors.leftMargin: 2
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 11 * units.devicePixelRatio
                font.pointSize: -1
                color: colorPalette.pressureColor(main.colors.isDarkMode)

                visible: y2AxisVisble
            }
        }
    }
    Label {
        text: unitUtils.formatUnits(y2VarName, unitUtils.getUnitType(y2VarName))
        height: labelHeight
        width: labelWidth
        horizontalAlignment: (text.length > 4) ? Text.AlignRight : Text.AlignLeft
        anchors.right: (graphArea.right)
        anchors.rightMargin: -labelWidth
        font.pixelSize: 11 * units.devicePixelRatio
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
        font.pixelSize: 11 * units.devicePixelRatio
        font.pointSize: -1
        anchors.bottom: graphArea.top
        anchors.bottomMargin: 6
    }

    ListView {
        id: hourGrid
        model: hourGridModel.model
        property double hourItemWidth: nHours < 2 ? 0 : imageWidth / (nHours - 1)
        anchors.fill: graphArea
        interactive: false
        orientation: ListView.Horizontal

        property var startTime: new Date(0)

        ManagedListModel {
            id: hourGridModel
        }

        function setModel(startTime) {
            hourGrid.startTime = startTime

            hourGridModel.beginList()
            for (var i = 0; i < root.nHours; i++) {
                hourGridModel.addItem({ index: i })
            }
            hourGridModel.endList()
        }

        delegate: Item {
            height: labelHeight
            width: hourGrid.hourItemWidth

            property int onHourMs: 60 * 60 * 1000
            property var date: new Date(Number(hourGrid.startTime) + (model.index * onHourMs))

            property int hourFrom: date.getHours()
            property string hourFromStr: timeUtils.getHourText(hourFrom)
            property string hourFromEnding: timeUtils.twelveHourClockEnabled ?
                                                timeUtils.getAmOrPm(hourFrom) : '00'
            property bool dayBegins: hourFrom === 0
            property bool hourVisible: (hourFrom + 0) % meteogramCanvas.hourStep === 0
            property bool textVisible: hourVisible && model.index < root.nHours - 1

            Rectangle {
                id: verticalLine
                width: dayBegins ? 2 : 1
                height: imageHeight
                color: dayBegins ? gridColorHighlight : gridColor
                visible: hourVisible
                anchors.leftMargin: labelWidth
                anchors.top: parent.top
            }
            anchors.leftMargin: labelWidth
            Label {
                id: hourText
                text: hourFromStr
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
                height: labelHeight
                width: hourGrid.hourItemWidth
                anchors.top: verticalLine.bottom
                anchors.topMargin: 2
                //                anchors.horizontalCenter: verticalLine.left
                anchors.horizontalCenter: verticalLine.horizontalCenter
                anchors.rightMargin: 1 * units.devicePixelRatio
                font.pixelSize: 11 * units.devicePixelRatio
                font.pointSize: -1
                visible: textVisible
            }
            Label {
                text: hourFromEnding
                color: main.colors.isShowBackground ?
                            main.colors.disabledTextColor :
                            main.colors.textColor
                opacity: main.colors.isShowBackground ? 1.0 : 0.60
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                anchors.top: hourText.top
                anchors.left: hourText.right
                font.pixelSize: 7 * units.devicePixelRatio
                font.pointSize: -1
                visible: textVisible
            }
            Label {
                id: dayTest
                text: Qt.locale().dayName(date.getDay(), Locale.LongFormat)
                height: labelHeight
                anchors.top: parent.top
                anchors.topMargin: -labelHeight
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 2
                font.pixelSize: 11 * units.devicePixelRatio
                font.pointSize: -1
                visible: date.getHours() === 0 && (itemEndX < hourGrid.width)

                property double itemEndX: timeScale.translate(date) + dayTest.width
            }
        }
    }

    Item {
        id: windSpeedArea
        width: imageWidth
        height: windarea
        anchors.top: hourGrid.bottom
        anchors.left: hourGrid.left
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
                        rotation: windFrom(windDirection, windSpeedRepeater.iconSetType)
                        fillMode: Image.PreserveAspectFit

                        width: height
                        height: windarea
                        anchors.centerIn: parent

                        opacity: 0

                        asynchronous: true
                    }

                    ColorOverlay {
                        anchors.fill: wind
                        source: wind
                        rotation: wind.rotation
                        color: main.colors.isShowBackground ?
                                    main.colors.disabledTextColor :
                                    main.colors.textColor
                        opacity: main.colors.isShowBackground ? 1.0 : 0.60
                        antialiasing: true
                        visible: true
                    }

                    ToolTip{
                        id: windspeedhover
                        text: unitUtils.getWindSpeedText(windSpeed, windSpeedType)
                        padding: 4
                        x: windspeedAnchor.width + 6
                        y: (windspeedAnchor.height / 2)
                        opacity: 1
                        visible: false
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            windspeedhover.visible = (windspeedhover.text.length > 0)
                        }

                        onExited: {
                            windspeedhover.visible = false
                        }
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
