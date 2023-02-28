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
import QtQuick.Window 2.5
import QtQml.Models 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 2.5
import "../code/unit-utils.js" as UnitUtils
import "../code/icons.js" as IconTools

Item {
    id: root
    visible: true

    property int imageWidth: width - (labelWidth * 2)
    property int imageHeight: height - labelHeight - cloudarea - windarea
    property int labelWidth: textMetrics.width
    property int labelHeight: textMetrics.height

    property int cloudarea: 0
    property int windarea: 28 * units.devicePixelRatio

    readonly property int minTemperatureYGridCount: 20

    property double temperatureYGridStep: 1.0
    property int temperatureYGridCount: minTemperatureYGridCount   // Number of vertical grid Temperature elements

    // Decimal places for pressure y-axis labels
    property int rightAxisDecimals: 0

    readonly property double precipitationMinVisible: 0.05
    property double precipitationMaxGraphY: 10

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5
    property color gridColor: textColorLight ? Qt.tint(theme.textColor, '#80000000') : Qt.tint(theme.textColor, '#80FFFFFF')
    property color gridColorHighlight: textColorLight ? Qt.tint(theme.textColor, '#50000000') : Qt.tint(theme.textColor, '#50FFFFFF')

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

    Component.onCompleted: {
        UnitUtils.precipitationMinVisible = precipitationMinVisible
        meteogramCanvas.fullRedraw()
    }

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
        color: palette.backgroundColor()
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
                horizontalLinesModel.addItem({
                    temperatureLabel: temperatureAxisScale.invert(i).toFixed(0),
                    rightAxisLabel: rightGridScale.invert(i).toFixed(rightAxisDecimals)

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
            PlasmaComponents.Label {
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
            PlasmaComponents.Label {
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
                color: palette.pressureColor()

                visible: y2AxisVisble
            }
        }
    }
    PlasmaComponents.Label {
        text: UnitUtils.formatUnits(y2VarName)
        height: labelHeight
        width: labelWidth
        horizontalAlignment: (text.length > 4) ? Text.AlignRight : Text.AlignLeft
        anchors.right: (graphArea.right)
        anchors.rightMargin: -labelWidth
        font.pixelSize: 11 * units.devicePixelRatio
        font.pointSize: -1
        color: palette.pressureColor()
        anchors.bottom: graphArea.top
        anchors.bottomMargin: 6
        visible: y2AxisVisble
    }
    PlasmaComponents.Label {
        text: UnitUtils.getTemperatureEnding(temperatureType)
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
            property string hourFromStr: UnitUtils.getHourText(hourFrom, twelveHourClockEnabled)
            property string hourFromEnding: twelveHourClockEnabled ? UnitUtils.getAmOrPm(hourFrom) : '00'
            property bool dayBegins: hourFrom === 0
            property bool hourVisible: hourFrom % 2 === 0
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
            PlasmaComponents.Label {
                id: hourText
                text: hourFromStr
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                height: labelHeight
                width: hourGrid.hourItemWidth
                anchors.top: verticalLine.bottom
                anchors.topMargin: 2
                //                anchors.horizontalCenter: verticalLine.left
                anchors.horizontalCenter: verticalLine.horizontalCenter
                font.pixelSize: 11 * units.devicePixelRatio
                font.pointSize: -1
                visible: textVisible
            }
            PlasmaComponents.Label {
                text: hourFromEnding
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                anchors.top: hourText.top
                anchors.left: hourText.right
                font.pixelSize: 7 * units.devicePixelRatio
                font.pointSize: -1
                visible: textVisible
            }
            PlasmaComponents.Label {
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

                property double itemEndX: dayTest.parent.x + dayTest.x + dayLabelMetrics.width
            }

            TextMetrics {
                id: dayLabelMetrics
                font.family: dayTest.font.family
                font.pixelSize: dayTest.font.pixelSize
                text: dayTest.text
            }
        }
    }

    Item {
        id: windSpeedArea
        width: imageWidth
        height: windarea
        anchors.top: hourGrid.bottom
        anchors.left: hourGrid.left
        anchors.topMargin: labelHeight

        ManagedListModel {
            id: windSpeedModel
        }

        function setModel(count) {
            windSpeedModel.beginList()
            for (var i = 0; i < count; i++) {
                let item = meteogramModel.get(i)
                if (!item || !isFinite(item.windSpeed)) {
                    continue
                }

                let t = item.from
                if (meteogramModel.hourInterval === 1 && (t.getHours()) % 2 === 0) {
                    continue
                }

                windSpeedModel.addItem({
                    xPos: timeScale.translate(t.getTime()) - (windSpeedRepeater.rectWidth / 2),
                    windSpeed: parseFloat(item.windSpeed),
                    windDirection: parseFloat(item.windDirection),
                })
            }
            windSpeedModel.endList()
        }

        Repeater {
            id: windSpeedRepeater
            model: windSpeedModel.model
            delegate: windIconDelegate

            property double rectWidth: 2 * (meteogramCanvas.rectWidth)

            Component {
                id: windIconDelegate

                Item {
                    id: windspeedAnchor
                    width: windSpeedRepeater.rectWidth
                    height: labelHeight
                    x: xPos
                    y: 0

                    Image {
                        id: wind
                        source: !isNaN(windSpeed) ? windStrength(windSpeed, textColorLight) : ""
                        rotation: windFrom(windDirection)
                        fillMode: Image.PreserveAspectFit

                        width: Math.min(16 * units.devicePixelRatio, windSpeedRepeater.rectWidth)
                        height: width
                        anchors.centerIn: parent
                    }

                    ToolTip{
                        id: windspeedhover
                        text: UnitUtils.getWindSpeedText(windSpeed, windSpeedType)
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

                    function windFrom(rotation) {
                        rotation = (Math.round( rotation / 22.5 ) * 22.5)
                        rotation = (rotation >= 180) ? rotation - 180 : rotation + 180
                        return rotation
                    }
                    function windStrength(windspeed,themecolor) {
                        var img = "images/"
                        img += (themecolor) ? "light" : "dark"
                        img += Math.min(5,Math.trunc(windspeed / 5) + 1)
                        return img
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
                if (!meteogramInfo.visible) {
                    return
                }

                context.fillStyle = Qt.rgba(theme.highlightColor.r,
                                            theme.highlightColor.g,
                                            theme.highlightColor.b,
                                            0.25)

                var [x0, x1] = meteogramCanvas.getItemIntervalX(meteogramInfo.idx)
                context.fillRect(x0, 0, x1 - x0, height);
            }
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                meteogramInfo.visible = true
                update(mouse)
                meteogramInfoCanvas.requestPaint()
            }

            onReleased: {
                meteogramInfo.visible = false
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

                var globalCoord = mapToItem(main, 0, 0)
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
