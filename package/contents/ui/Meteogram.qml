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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 2.5
import "../code/unit-utils.js" as UnitUtils
import "../code/icons.js" as IconTools

Item {
    id: root
    visible: true

    property bool initialized: false

    property int imageWidth: width - (labelWidth * 2)
    property int imageHeight: height - labelHeight - cloudarea - windarea
    property int labelWidth: textMetrics.width
    property int labelHeight: textMetrics.height

    property int cloudarea: 0
    property int windarea: 28

    readonly property int minTemperatureYGridCount: 20
    readonly property int minPressureYGridCount: 30
    property double temperatureYGridStep: 1.0
    property int temperatureYGridCount: minTemperatureYGridCount   // Number of vertical grid Temperature elements

    // Decimal places for pressure y-axis labels
    property int pressureDecimals: 0

    readonly property double precipitationMinVisible: 0.05
    property double precipitationMaxGraphY: 10

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5
    property color gridColor: textColorLight ? Qt.tint(theme.textColor, '#80000000') : Qt.tint(theme.textColor, '#80FFFFFF')
    property color gridColorHighlight: textColorLight ? Qt.tint(theme.textColor, '#50000000') : Qt.tint(theme.textColor, '#50FFFFFF')
/*    property color pressureColor: textColorLight ? Qt.rgba(0.3, 1, 0.3, 1) : Qt.rgba(0.0, 0.6, 0.0, 1)
    property color temperatureWarmColor: textColorLight ? Qt.rgba(1, 0.3, 0.3, 1) : Qt.rgba(1, 0.0, 0.0, 1)
    property color temperatureColdColor: textColorLight ? Qt.rgba(0.2, 0.7, 1, 1) : Qt.rgba(0.1, 0.5, 1, 1)
    property color rainColor: textColorLight ? Qt.rgba(0.33, 0.66, 1, 1) : Qt.rgba(0, 0.33, 1, 1)
    property color cloudAreaColor: textColorLight ? Qt.rgba(1.0, 1.0, 1.0, 0.2) : Qt.rgba(0.5, 0.5, 0.5, 0.2)
    property color cloudAreaColor2: textColorLight ? Qt.rgba(0.5, 0.5, 0.5, 0.2) : Qt.rgba(0.0, 0.0, 0.0, 0.2)
    property color humidityColor: textColorLight ?  Qt.rgba(0.0/255, 206/255, 209/255, 1.0) : // DarkTurquoise
                                                    Qt.rgba(0.0/255, 98/255, 134/255, 1.0)   // Cerulean
*/

/*
    property int temperatureType: 0
    property int pressureType: 0
    property int timezoneType: 0
    property bool twelveHourClockEnabled: false
    property int windSpeedType: 0
*/
    property double sampleWidth: imageWidth / (meteogramModel.count - 1)

    property bool hasGraphCurvedLineChanged: false

    Component.onCompleted: {
        fullRedraw()
    }

    function fullRedraw() {
        buildMetogramData()
        processMeteogramData()
        buildCurves()
        initialized = true
        repaintCanvas()
    }

    MeteogramColors {
        id: palette
    }


    ListModel {
        id: horizontalGridModel
    }
    ListModel {
        id: hourGridModel
    }
    ListModel {
        id: actualWeatherModel
    }
    ListModel {
        id: nextDaysModel
    }
//     ListModel {
//         id: meteogramModel
//     }

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
        color: textColorLight ? 'black' : 'white'
    }
    ListView {
        id: horizontalLines1
        model: horizontalGridModel
        anchors.left: graphArea.left
        anchors.top: graphArea.top
//         anchors.bottom: graphArea.bottom + labelHeight
//         anchors.fill: graphArea
        height: graphArea.height + labelHeight
        interactive: false

        property double itemHeight: graphArea.height / (temperatureYGridCount)

        delegate: Item {
            height: horizontalLines1.itemHeight
            width: graphArea.width
            visible: num % temperatureYGridStep === 0

            Rectangle {
                id: gridLine
                width: parent.width
                height: 1 * units.devicePixelRatio
                color: gridColor
            }
            PlasmaComponents.Label {
                text: UnitUtils.formatTemperatureStr(temperatureAxisScale.invert(num), temperatureType)
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
                text: UnitUtils.formatPressureStr(pressureAxisScale.invert(num), pressureDecimals)
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
            }
        }
    }
    PlasmaComponents.Label {
        text: UnitUtils.getPressureEnding(pressureType)
        height: labelHeight
        width: labelWidth
        horizontalAlignment: (UnitUtils.getPressureEnding(pressureType).length > 4) ? Text.AlignRight : Text.AlignLeft
        anchors.right: (graphArea.right)
        anchors.rightMargin: -labelWidth
        font.pixelSize: 11 * units.devicePixelRatio
        font.pointSize: -1
        color: palette.pressureColor()
        anchors.bottom: graphArea.top
        anchors.bottomMargin: 6
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
        model: hourGridModel
        property double hourItemWidth: hourGridModel.count === 0 ? 0 : imageWidth / (hourGridModel.count - 1)
        anchors.fill: graphArea
        interactive: false
        orientation: ListView.Horizontal
        delegate: Item {
            height: labelHeight
            width: hourGrid.hourItemWidth

            property int hourFrom: dateFrom.getHours()
            property string hourFromStr: UnitUtils.getHourText(hourFrom, twelveHourClockEnabled)
            property string hourFromEnding: twelveHourClockEnabled ? UnitUtils.getAmOrPm(hourFrom) : '00'
            property bool dayBegins: hourFrom === 0
            property bool hourVisible: hourFrom % 2 === 0
            property bool textVisible: hourVisible && index < hourGridModel.count-1

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
            Item {
                id: windspeedAnchor
                width: parent.width
                height: 32
                anchors.top: hourText.bottom
                anchors.left: hourText.left

                ToolTip{
                    id: windspeedhover
                    text: (index % 2 == 1) ? UnitUtils.getWindSpeedText(windSpeedMps, windSpeedType) : ""
                    padding: 4
                    x: windspeedAnchor.width + 6
                    y: (windspeedAnchor.height / 2)
                    opacity: 1
                    visible: false
                }

                Image {
                    id: wind
                    source: windStrength(windSpeedMps,textColorLight)
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: windFrom(windDirection)
                    anchors.top: windspeedAnchor.top
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    visible: (index % 2 == 1) && (index < hourGridModel.count-1)
                    anchors.leftMargin: -8
                    anchors.left: parent.left
                    //                    visible: ((windDirection > 0) || (windSpeedMps > 0)) && (! textVisible) && (index > 0) && (index < hourGridModel.count-1)
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
            }
            PlasmaComponents.Label {
                id: dayTest
                text: Qt.locale().dayName(dateFrom.getDay(), Locale.LongFormat)
                height: labelHeight
                anchors.top: parent.top
                anchors.topMargin: -labelHeight
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 2
                font.pixelSize: 11 * units.devicePixelRatio
                font.pointSize: -1
                visible: dayBegins && canShowDay
            }
        }
    }

    Item {
        z: 1
        id: canvases
        anchors.fill: graphArea
        anchors.topMargin: 0

        LinearScale {
            id: temperatureScale
            range: [imageHeight, 0]
        }

        LinearScale {
            id: temperatureAxisScale
            range: [1, 0]
        }

        LinearScale {
            id: pressureScale
            range: [imageHeight, 0]
        }

        LinearScale {
            id: pressureAxisScale
            range: [1, 0]
        }

        LinearScale {
            id: precipitationScale
            range: [imageHeight, 0]
        }

        LinearScale {
            id: cloudAreaScale
            property var offset: 5
            domain: [0, 100]
            range: [offset + (imageHeight / 8), offset]
        }

        LinearScale {
            id: humidityScale
            domain: [0, 100]
            range: [imageHeight, 0]
        }

        LinearScale {
            id: timeScale
            range: [0, imageWidth]
        }

        Canvas {
            id: meteogramCanvas
            anchors.fill: parent
            contextType: '2d'

            readonly property double weatherFontSize: (14 * units.devicePixelRatio)
            property double fontSize: 14 * units.devicePixelRatio
            property var precLabelPositions: ({})

            Path {
                id: pressurePath
                startX: 0
                pathElements: []
            }
            Path {
                id: temperaturePath
                startX: 0
                pathElements: []
            }

            Path {
                id: cloudAreaPath
                startX: 0
                pathElements: []
            }

            Path {
                id: humidityPath
                startX: 0
                pathElements: []
            }

            Connections {
                target: plasmoid
                function onExpandedChanged() {
                    meteogramCanvas.requestPaint()
                }
            }

            function computeFontSize() {
                var rectWidth = timeScale.translate(1) - timeScale.translate(0)
                var rectHeight = Math.abs(temperatureScale.translate(temperatureYGridStep) -
                                          temperatureScale.translate(0))
                var dim = Math.min(rectWidth, rectHeight / 2)
                fontSize = Math.round(dim) * units.devicePixelRatio
            }

            function drawPrecipitationBars(context, rectWidth) {
                precLabelPositions = ({})
                for (var i = 0; i < hourGridModel.count; i++) {
                    var hourModel = hourGridModel.get(i)
                    if (hourModel.precipitationAvg <= 0) {
                        continue
                    }
                    var x = timeScale.translate(i) + (0.5 * units.devicePixelRatio)
                    var prec = Math.min(precipitationMaxGraphY, hourModel.precipitationAvg)
                    var y = precipitationScale.translate(prec)
                    context.fillStyle = palette.rainColor()
                    var h = (precipitationScale.range[0]) - y
                    var w = rectWidth - (0.5 * units.devicePixelRatio)
                    context.fillRect(x, y, w, h)

                    var fontSize = Math.round(rectWidth / 2) + 1
                    precLabelPositions[i] = y - fontSize
                }
            }

            function drawShadowText(context, str, x, y) {
                context.strokeStyle = theme.textColor
                context.shadowColor = textColorLight ? 'black' : 'white';
                context.shadowBlur = 0.5;
                context.lineWidth = 0.5;
                context.strokeText(str, x, y)
                context.shadowBlur = 0;
            }

            function drawPrecipitationText(context, rectWidth) {
                context.save()
                var counter = 0

                context.font = ((fontSize / 2) + 1) + 'px "' + theme.defaultFont.family + '"'

                var prevIdx = -1
                var prevY = NaN
                var prevShowPrecUnit = false
                var prevPrecStr = undefined

                for (var i = 0; i < hourGridModel.count; i++) {
                    var hourModel = hourGridModel.get(i)
                    var prec = hourModel.precipitationAvg
                    var showPrecExcess = prec > precipitationMaxGraphY
                    var showPrec = prec > 0

                    // Show precipitation unit on first hour with non-zero value
                    counter = showPrec ? counter + 1 : 0
                    var showPrecUnit = counter === 1


                    if (!showPrec) {
                        continue
                    }

                    var x = timeScale.translate(i)
                    var y = precipitationScale.translate(Math.min(precipitationMaxGraphY, prec))
                    var precStr = UnitUtils.precipitationFormat(prec, hourModel.precipitationLabel)
                    const textPad = 2
                    var y0 = y - textPad

                    // Stagger vertically when two labels are consecutively in the same y position
                    const marginPx = 0
                    if (i - prevIdx === 1 && (prevY-marginPx <= y0 && y0 <= prevY+marginPx)) {
                        y0 = y0 - (fontSize / 2)
                    }
                    prevIdx = i
                    prevY = y0

                    // if (prevShowPrecUnit) {
                    //     y0 -= fontSize / 2
                    // }
                    prevShowPrecUnit = showPrecUnit

                    if (precStr === prevPrecStr && counter > 1) {
                        prevPrecStr = precStr
                        continue
                    }
                    prevPrecStr = precStr

                    if (showPrecUnit) {
                        var precUnitStr = UnitUtils.localisePrecipitationUnit(
                                            hourModel.precipitationLabel)
                        var metrics = context.measureText(precUnitStr)
                        var x0 = x - (metrics.width / 2) + (rectWidth / 2)

                        drawShadowText(context, precUnitStr, x0, y0)
                        context.fillStyle = theme.textColor
                        context.fillText(precUnitStr, x0, y0)

                        y0 -= fontSize/2
                    }

                    var metrics = context.measureText(precStr)
                    var x0 = x - (metrics.width / 2) + (rectWidth / 2)
                    drawShadowText(context, precStr, x0, y0)
                    context.fillStyle = theme.textColor
                    context.fillText(precStr, x0, y0)
                    y0 -= fontSize/2

                    // Show arrow to indicate truncation at max value
                    if (showPrecExcess) {
                        var precExcessStr = '\u25B2'
                        var metrics = context.measureText(precExcessStr)
                        var x0 = x - (metrics.width / 2) + (rectWidth / 2)
                        drawShadowText(context, precExcessStr, x0, y0)
                        context.fillStyle = theme.textColor
                        context.fillText(precExcessStr, x0, y0)
                    }
                }
                context.restore()
            }

            function drawPath(context, path, color, lineWidth) {
                context.beginPath()
                context.strokeStyle = color
                context.lineWidth = lineWidth;
                context.path = path
                context.stroke()
            }

            function drawWarmTemp(context, path, color, lineWidth) {
                context.save()
                context.beginPath()
                context.strokeStyle = 'transparent'
                context.lineWidth = 0
                context.rect(0, 0, width, temperatureScale.translate(0));
                context.closePath()
                context.stroke();
                context.clip();
                drawPath(context, path, color, lineWidth)
                context.restore()
            }

            function drawColdTemp(context, path, color, lineWidth) {
                context.save()
                context.beginPath()
                context.strokeStyle = 'transparent'
                context.lineWidth = 0
                context.rect(0, temperatureScale.translate(0), width, height);
                context.closePath()
                context.stroke();
                context.clip();
                drawPath(context, path, color, lineWidth)
                context.restore()
            }

            function drawWeatherIcons(context, rectWidth) {
                context.font =  (fontSize + 1) + 'px "%1"'.arg(weatherIconFont.name)

                for (var i = 0; i < hourGridModel.count; i++) {
                    var hourModel = hourGridModel.get(i)
                    var iconName = hourModel.iconName
                    var hourFrom = hourModel.dateFrom.getHours()
                    var textVisible = (hourFrom % 2 === 1)
                    if (!textVisible) {
                        continue
                    }

                    var x = timeScale.translate(i - 1)
                    var y = temperatureScale.translate(UnitUtils.convertTemperature(
                                                        hourModel.temperature, temperatureType))
                    var timePeriod = UnitUtils.isSunRisen(hourModel.dateFrom) ? 0 : 1
                    var str = IconTools.getIconCode(iconName, currentProvider.providerId, timePeriod)

                    var metrics = context.measureText(str)
                    var textWidth = metrics.width
                    var x0 = x - (textWidth / 2.0) + (rectWidth)
                    var y0 = y - rectWidth

                    // Avoid overlapping precipitation labels.
                    // Shifting from one label position may result in overlap of other label or vice
                    // versa. Hence peform the check twice to cover both cases.
                    var labelPosY0 = precLabelPositions[i - 1]
                    var labelPosY1 = precLabelPositions[i]
                    var newY0 = y0
                    var newY1 = y0
                    if (labelPosY0 - (2 * rectWidth) <= y0 && y0 <= labelPosY0 + (2 * rectWidth)) {
                        newY0 = Math.min(y0, labelPosY0 - (1.0 * rectWidth))
                        if (labelPosY1 - (2 * rectWidth) <= newY0 && newY0 <= labelPosY1 + (1 * rectWidth)) {
                            newY0 = Math.min(newY0, labelPosY1 - (1.0 * rectWidth))
                        }
                    }
                    if (labelPosY1 - (2 * rectWidth) <= y0 && y0 <= labelPosY1 + (2 * rectWidth)) {
                        newY1 = Math.min(y0, labelPosY1 - (1.0 * rectWidth))
                        if (labelPosY0 - (2 * rectWidth) <= newY1 && newY1 <= labelPosY0 + (1 * rectWidth)) {
                            newY1 = Math.min(newY1, labelPosY0 - (1.0 * rectWidth))
                        }
                    }
                    y0 = Math.min(newY0, newY1)

                    context.fillStyle = theme.textColor
                    context.fillText(str, x0, y0)
                }
            }

            function drawCloudArea(context) {
                if (cloudAreaPath.pathElements.length === 0) {
                    return
                }
                context.beginPath()

                var y0 = cloudAreaScale.translate(50 - (100 / 2))
                var y1 = cloudAreaScale.translate(50 + (100 / 4))
                var gradient = context.createLinearGradient(0, y1, 0, y0);
                gradient.addColorStop(0, palette.cloudAreaColor());
                gradient.addColorStop(1, palette.cloudAreaColor2());
                context.fillStyle = gradient;
                context.path = cloudAreaPath
                context.closePath()
                context.fill()
            }

            onPaint: {
                if (!root.initialized) {
                    root.fullRedraw()
                    return
                }

                computeFontSize()

                var context = getContext("2d")
                context.clearRect(0, 0, width, height)
                context.globalCompositeOperation = "source-over"

                var rectWidth = timeScale.translate(1) - timeScale.translate(0)

                context.globalCompositeOperation = "source-over"
                drawPrecipitationBars(context, rectWidth)

                // Carve out negative space when weather icons overlap precipitation bars
                context.globalCompositeOperation = "xor"
                drawWeatherIcons(context, rectWidth)

                context.globalCompositeOperation = "source-over"
                drawCloudArea(context)
                drawPath(context, humidityPath, palette.humidityColor(), 1 * units.devicePixelRatio)
                drawPath(context, pressurePath, palette.pressureColor(), 1 * units.devicePixelRatio)
                drawWarmTemp(context, temperaturePath, palette.temperatureWarmColor(), 2 * units.devicePixelRatio)
                drawColdTemp(context, temperaturePath, palette.temperatureColdColor(), 2 * units.devicePixelRatio)

                // Ensure weather icons atop graph lines without drawing over carve out
                context.globalCompositeOperation = "source-atop"
                drawWeatherIcons(context, rectWidth)

                context.globalCompositeOperation = "source-over"
                drawPrecipitationText(context, rectWidth)
            }

            /*
             * Repaint canvas on resize.
             */
            onWidthChanged: redrawTimer.restart()
            onHeightChanged: redrawTimer.restart()

            Timer {
                id: redrawTimer
                interval: 300
                repeat: true
                running: false
                triggeredOnStart: true
                property double prevHeight: -1
                property double prevWidth: -1
                onTriggered: {
                    if (prevHeight === height && prevWidth === width) {
                        buildCurves()
                        repaintCanvas()
                        stop()
                    }
                    prevWidth = width
                    prevHeight = height
                }
            }
        }

        MeteogramInfo {
            id: meteogramInfo
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

                var rectWidth = timeScale.translate(1) - timeScale.translate(0)
                context.fillStyle = Qt.rgba(theme.highlightColor.r,
                                            theme.highlightColor.g,
                                            theme.highlightColor.b,
                                            0.25)
                var x0 = timeScale.translate(meteogramInfo.idx)
                context.fillRect(x0, 0, rectWidth, height);
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
                var idx = Math.round(timeScale.invert(mouse.x) - 0.5)
                if (idx < 0 || idx >= hourGridModel.count) {
                    return
                }

                var x0 = timeScale.translate(meteogramInfo.idx)
                var x1 = timeScale.translate(meteogramInfo.idx + 1)
                var rectWidth = x1 - x0

                meteogramInfo.x = mouse.x
                meteogramInfo.y = mouse.y

                meteogramInfo.isAnchorLeft = mouse.x < (imageWidth - meteogramInfo.boxWidth - rectWidth)
                meteogramInfo.isAnchorTop = mouse.y > (imageHeight - meteogramInfo.boxHeight - rectWidth)

                if (meteogramInfo.idx !== idx) {
                    meteogramInfo.anchorsMargins = 1.5 * rectWidth

                    meteogramInfo.idx = idx
                    meteogramInfo.hourModel = hourGridModel.get(idx)
                }
            }
        }
    }
    function repaintCanvas() {
        meteogramCanvas.requestPaint()
    }

    function parseISOString(s) {
        var b = s.split(/\D+/)
        return new Date(Date.UTC(b[0], --b[1], b[2], b[3], b[4], b[5], b[6]))
    }

    function buildMetogramData() {
        var precipitation_unit = meteogramModel.get(0).precipitationLabel
        var counter = 0
        var i = 0
        const oneHourMs = 3600000
        hourGridModel.clear()

        while (i < meteogramModel.count) {
            var obj = meteogramModel.get(i)
            var dateFrom = obj.from
            var dateTo = obj.to
            dateFrom.setMinutes(0)
            dateFrom.setSeconds(0)
            dateFrom.setMilliseconds(0)
            var differenceHours = Math.floor((dateTo.getTime() - dateFrom.getTime()) / oneHourMs)
            dbgprint(dateFrom + "\t" + dateTo + "\t" + differenceHours)
            var differenceHoursMid = Math.ceil(differenceHours / 2) - 1
            var wd = obj.windDirection
            var ws = obj.windSpeedMps
            var ap = obj.pressureHpa
            var airtmp = parseFloat(obj.temperature)
            var icon = obj.iconName
            var prec = parseFloat(obj.precipitationAvg) / differenceHours
            var preclabel = obj.precipitationLabel
            var hm = obj.humidity
            var cld = obj.cloudArea

            for (var j = 0; j < differenceHours; j++) {
                counter = (prec >= precipitationMinVisible) ? counter + 1 : 0
                var preparedDate = new Date(dateFrom.getTime() + (j * oneHourMs))

                hourGridModel.append({
                                      dateFrom: preparedDate,
                                      iconName: j === differenceHoursMid ? icon : '',
                                      temperature: airtmp,
                                      precipitationAvg: prec,
                                      precipitationLabel: preclabel,
                                      precipitationUnitVisible: counter === 1,
                                      precipitationMax: prec,
                                      canShowDay: true,
                                      windDirection: parseFloat(wd),
                                      windSpeedMps: parseFloat(ws),
                                      pressureHpa: parseFloat(ap),
                                      humidity: hm,
                                      cloudArea: cld,
                                      differenceHours: differenceHours
                                  })
            }
            i++
        }
        for (i = Math.max(0, hourGridModel.count - 5); i < hourGridModel.count; i++) {
            hourGridModel.setProperty(i, 'canShowDay', false)
        }

        if (hourGridModel.count > 0) {
            var model = hourGridModel.get(0)
            if (model.precipitationLabel === i18n("%")) {
                precipitationScale.setDomain(0, 8.0)
                precipitationMaxGraphY = 100
            } else {
                precipitationScale.setDomain(0, 25)
                precipitationMaxGraphY = 15
            }
        }
    }

    property bool graphCurvedLine: plasmoid.configuration.graphCurvedLine

    onGraphCurvedLineChanged: {
        hasGraphCurvedLineChanged = true
        fullRedraw()
    }

    function buildCurves() {
        var newPathElements = temperaturePath.pathElements
        var newPressureElements = pressurePath.pathElements
        var newCloudElements = cloudAreaPath.pathElements
        var newCloudElements2 = []
        var newHumidityElements = humidityPath.pathElements

        if (meteogramModel.count === 0) {
            return
        }
        var pathType = 'PathCurve'
        if (!graphCurvedLine) {
            pathType = 'PathLine'
        }

        var reuse = meteogramModel.count <= newPathElements.length
        reuse &= !hasGraphCurvedLineChanged
        hasGraphCurvedLineChanged = false

        if (!reuse) {
            newPathElements = []
            newPressureElements = []
            newCloudElements = []
            newCloudElements2 = []
            newHumidityElements = []
        }

        for (var i = 0; i < meteogramModel.count; i++) {
            var dataObj = meteogramModel.get(i)

            var temperatureY = temperatureScale.translate(UnitUtils.convertTemperature(dataObj.temperature, temperatureType))
            var pressureY = pressureScale.translate(UnitUtils.convertPressure(dataObj.pressureHpa, pressureType))
            var humidityY = humidityScale.translate(dataObj.humidity)
            if (i === 0) {
                temperaturePath.startY = temperatureY
                pressurePath.startY = pressureY
                humidityPath.startY = isFinite(humidityY) ? humidityY : 0
            }

            if (!reuse) {
                newPathElements.push(Qt.createQmlObject('import QtQuick 2.0; ' + pathType +
                                     '{ x: ' + (i * sampleWidth) + '; y: ' + temperatureY + ' }',
                                     graphArea, "dynamicTemperature" + i))
            } else {
                newPathElements[i].x = i * sampleWidth
                newPathElements[i].y = temperatureY
            }

            if (!reuse) {
                newPressureElements.push(Qt.createQmlObject('import QtQuick 2.0; '+ pathType +
                                         '{ x: ' + (i * sampleWidth) + '; y: ' + pressureY + ' }',
                                         graphArea, "dynamicPressure" + i))
            } else {
                newPressureElements[i].x = i * sampleWidth
                newPressureElements[i].y = pressureY
            }

            if (isFinite(dataObj.cloudArea)) {
                var cloudY0 = cloudAreaScale.translate(50 + (dataObj.cloudArea / 4))
                var cloudY1 = cloudAreaScale.translate(50 - ((dataObj.cloudArea) / 2))
                if (i === 0) {
                    cloudAreaPath.startY = cloudY0
                }

                if (!reuse) {
                    newCloudElements.push(Qt.createQmlObject('import QtQuick 2.0; ' + 'PathCurve' +
                                         '{ x: ' + (i * sampleWidth) + '; y: ' + cloudY1 + ' }',
                                         graphArea, "dynamicCloudArea" + i))
                    newCloudElements2.push(Qt.createQmlObject('import QtQuick 2.0; ' + 'PathLine' +
                                         '{ x: ' + (i * sampleWidth) + '; y: ' + cloudY0 + ' }',
                                         graphArea, "dynamicCloudArea" + (meteogramModel.count + i)))
                } else {
                    newCloudElements[i].x = i * sampleWidth
                    newCloudElements[i].y = cloudY1
                    newCloudElements[(2 * meteogramModel.count) - 1 - i].x = i * sampleWidth
                    newCloudElements[(2 * meteogramModel.count) - 1 - i].y = cloudY0
                }
            }
            if (isFinite(humidityY)) {
                if (!reuse) {
                    newHumidityElements.push(Qt.createQmlObject('import QtQuick 2.0; ' + pathType +
                                             '{ x: ' + (i * sampleWidth) + '; y: ' + humidityY + ' }',
                                             graphArea, "dynamicHumidity" + i))
                } else {
                    newHumidityElements[i].x = i * sampleWidth
                    newHumidityElements[i].y = humidityY
                }
            }
        }

        // Don't paint unused elements
        for (var i = meteogramModel.count; i < newCloudElements.length; i++) {
            if (i < newPathElements.length) {
                newPathElements[i].x = NaN
                newPathElements[i].y = NaN
                newPressureElements[i].x = NaN
                newPressureElements[i].y = NaN
                newHumidityElements[i].x = NaN
                newHumidityElements[i].y = NaN
            }
            if (i >= 2 * meteogramModel.count) {
                newCloudElements[i].x = NaN
                newCloudElements[i].y = NaN
            }
        }

        if (!reuse) {
            temperaturePath.pathElements = newPathElements
            pressurePath.pathElements = newPressureElements
            cloudAreaPath.pathElements = newCloudElements.concat(newCloudElements2.reverse())
            humidityPath.pathElements = newHumidityElements
        }
    }

    function processMeteogramData() {
        if (meteogramModel.count === 0) {
            dbgprint('model is empty -> clearing canvas and exiting')
            clearCanvas()
            return
        }

        var minValue = +Infinity
        var maxValue = -Infinity
        var minPressure = +Infinity
        var maxPressure = -Infinity

        for (var i = 0; i < meteogramModel.count; i++) {
            var obj = meteogramModel.get(i)
            minValue = Math.min(minValue,  obj.temperature)
            maxValue = Math.max(maxValue, obj.temperature)
            minPressure = Math.min(minPressure,  obj.pressureHpa)
            maxPressure = Math.max(maxPressure, obj.pressureHpa)
        }

        minValue = UnitUtils.convertTemperature(minValue, temperatureType)
        maxValue = UnitUtils.convertTemperature(maxValue, temperatureType)
        processTemperatureData(minValue, maxValue)

        minPressure = UnitUtils.convertPressure(minPressure, pressureType)
        maxPressure = UnitUtils.convertPressure(maxPressure, pressureType)
        processPressureData(minPressure, maxPressure)
    }

    /*
     * Compute y-axis scale for temperature graph
     */
    function processTemperatureData(minValue, maxValue) {
        // print("orig: maxValue = " + maxValue + ", minValue = " + minValue)

        // Convert window size from Celsius
        var minGridCount = minTemperatureYGridCount
        var dF = UnitUtils.convertTemperature(minTemperatureYGridCount, temperatureType) -
                    UnitUtils.convertTemperature(0, temperatureType)
        minGridCount = minGridCount * (minTemperatureYGridCount / dF)
        // print('minGridCount = ' + minGridCount)

        // Pad the window size so the min/max value isn't on the edge of the graph area
        const gridCountMargin = 1.250
        var dV = maxValue - minValue
        var temperatureRange = Math.max(minGridCount, Math.ceil(dV * gridCountMargin))
        var pad = temperatureRange - dV
        minValue = Math.floor(minValue - (pad / 2.0))
        maxValue = Math.ceil(maxValue + (pad / 2.0))
        // print("padd: maxValue = " + maxValue + ", minValue = " + minValue)

        temperatureYGridCount = maxValue - minValue
        // print("temperatureYGridCount = " + temperatureYGridCount)

        // y-axis ticks
        // var step = (temperatureYGridCount + (minGridCount / 2)) / minGridCount
        // temperatureYGridStep = Math.ceil(step)
        temperatureYGridStep = Math.max(1, Math.round(temperatureYGridCount / 10))
        // print("temperatureYGridStep = " + temperatureYGridStep)

        temperatureScale.setDomain(minValue, maxValue)
        temperatureAxisScale.setDomain(minValue, maxValue)
        temperatureAxisScale.setRange(temperatureYGridCount, 0)

        timeScale.setDomain(0, hourGridModel.count - 1)

        horizontalGridModel.clear()
        for (var i = 0; i <= temperatureYGridCount; i++) {
            horizontalGridModel.append({
                num: i
            })
        }
    }

    function logn(x, base) {
        return Math.log(x) / Math.log(base)
    }

    function getMagnitude(val) {
        var decimalPlace = Math.floor(logn(val, 100))
        decimalPlace = (Math.abs(decimalPlace) === Infinity) ? 0 : decimalPlace
        var mult = Math.pow(100, -decimalPlace)
        decimalPlace *= 2
        return [decimalPlace, mult]
    }

    function roundBase(val, base) {
        return base * Math.round(val / base)
    }

    /*
     * Compute y-axis scale for pressure graph.
     * Pressure graph shares y-axis grid lines with temperature graph. This imposes a constraint of
     * which pressure axis steps are bound to temperature axis steps.
     */
    function processPressureData(minPressure, maxPressure) {
        var dP = maxPressure - minPressure
        var [decimalPlace, mult] = getMagnitude(dP)
        // print("maxPressure = " + maxPressure + ", minPressure = " + minPressure)
        // print("dP = " + dP)
        // print("decimalPlace = " + decimalPlace + ", mult = " + mult)

        decimalPlace = Math.max(-2, decimalPlace)
        decimalPlace = Math.min(4, decimalPlace)

        const pad = 1.25
        var minP = UnitUtils.convertPressure(minPressureYGridCount, pressureType)
        dP = Math.max(minP, pad * dP)
        dP = Math.ceil(dP * mult * 10) / (mult * 10)
        // print("minP = " + minP + ", dP = " + dP)

        var stepSize = 1 / mult
        var count = Math.floor(dP / stepSize)
        var nSteps = Math.round(count / temperatureYGridCount) * temperatureYGridCount
        var pressureRange = stepSize * nSteps

        // print("initial: stepSize = " + stepSize + ", count = " + count)
        if (count < temperatureYGridCount && pressureRange < dP) {
            while (true) {
                var s = stepSize / 2
                var c = Math.floor(dP / s)
                var ns = Math.round(c / temperatureYGridCount) * temperatureYGridCount
                var pr = s * ns

                if (count >= temperatureYGridCount && pressureRange >= dP) {
                    break
                }

                stepSize = s
                count = c
                nSteps = ns
                pressureRange = pr
                decimalPlace -= 1
                // print("stepSize = " + s + ", count = " + count)
                // print("pressureRange = " + pressureRange + ", dP = " + dP)
            }
        } else if (count >= temperatureYGridCount && pressureRange < dP) {
            while (true) {
                var s = stepSize * 2
                var c = Math.floor(dP / s)
                var ns = Math.round(c / temperatureYGridCount) * temperatureYGridCount
                var pr = s * ns

                if (count < temperatureYGridCount && pressureRange >= dP) {
                    break
                }
                stepSize = s
                count = c
                nSteps = ns
                pressureRange = pr
                // print("stepSize = " + stepSize + ", count = " + count)
            }
        }
        // print("final: stepSize = " + stepSize + ", count = " + count)

        // Pressure scale domain
        var mid = minPressure + ((maxPressure - minPressure) / 2.0)
        mid = Math.round(mid * mult) / mult
        minPressure = mid - (pressureRange / 2.0)
        minPressure = Math.ceil(minPressure * mult) / mult
        maxPressure = mid + (pressureRange / 2.0)
        maxPressure = Math.ceil(maxPressure * mult) / mult

        // print("stepSize = " + stepSize)
        // print("nSteps = " + nSteps)
        // print("pressureRange = " + pressureRange)
        // print("mid = " + mid)
        // print("maxPressure = " + maxPressure + ", minPressure = " + minPressure)

        /*
         * Round min/max pressure at one higher order of magnitude
         */
        mult = (mult > 1) ? (10 / mult) : (10 * mult)
        var ceilMaxP = Math.ceil(maxPressure / mult) * mult
        var floorMaxP = Math.floor(maxPressure / mult) * mult
        if (maxPressure - floorMaxP <= ceilMaxP - maxPressure) {
            var dp = maxPressure - floorMaxP
            maxPressure = maxPressure - dp
            minPressure = minPressure - dp
        } else {
            var dp = ceilMaxP - maxPressure
            maxPressure = maxPressure + dp
            minPressure = minPressure + dp
        }
        // print("mult = " + mult)
        // print("maxPressure = " + maxPressure + ", minPressure = " + minPressure)

        pressureScale.setDomain(minPressure, maxPressure)
        pressureAxisScale.setDomain(minPressure, maxPressure)
        pressureAxisScale.setRange(temperatureYGridCount, 0)

        pressureDecimals = -1 * Math.min(0, decimalPlace)
        // pressureDecimals = 3
    }
}
