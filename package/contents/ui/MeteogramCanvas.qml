/*
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
import QtQuick 2.0
import "../code/unit-utils.js" as UnitUtils
import "../code/icons.js" as IconTools
import "../code/chart-utils.js" as ChartUtils


Canvas {
    id: root

    contextType: '2d'
    renderStrategy: Canvas.Threaded

    property bool initialized: false

    property double fontSize: 14 * units.devicePixelRatio
    property var precLabelPositions: ({})

    property bool graphCurvedLine: plasmoid.configuration.graphCurvedLine
    property bool hasGraphCurvedLineChanged: false

    property int nHours: 0
    property double rectWidth: width / nHours

    property alias temperatureScale: temperatureScale
    property alias temperatureAxisScale: temperatureAxisScale
    property alias rightAxisScale: rightAxisScale
    property alias rightGridScale: rightGridScale
    property alias precipitationScale: precipitationScale
    property alias cloudAreaScale: cloudAreaScale
    property alias humidityScale: humidityScale
    property alias xIndexScale: xIndexScale
    property alias timeScale: timeScale

    LinearScale {
        id: temperatureScale
        range: [height, 0]
    }

    LinearScale {
        id: temperatureAxisScale
        range: [1, 0]
    }

    LinearScale {
        id: rightAxisScale
        range: [height, 0]
    }

    LinearScale {
        id: rightGridScale
        range: [1, 0]
    }

    LinearScale {
        id: precipitationScale
        range: [height, 0]
    }

    LinearScale {
        id: cloudAreaScale
        property var offset: 5
        domain: [0, 100]
        range: [offset + (height / 8), offset]
    }

    LinearScale {
        id: humidityScale
        domain: [0, 100]
        range: [height, 0]
    }

    LinearScale {
        id: xIndexScale
        range: [0, width]
    }

    LinearScale {
        id: timeScale
        range: [0, width]
    }

    Path {
        id: y2Path
        startX: 0
        pathElements: []
    }
    Path {
        id: temperaturePath
        startX: 0
        pathElements: []
    }

    Path {
        id: y1Path
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

    MeteogramIconOverlay {
        id: iconOverlay
        anchors.fill: parent
        clip: true
    }

    Connections {
        target: plasmoid
        function onExpandedChanged() {
            root.markDirty(Qt.rect(0, 0, width, height))
        }
    }

    onRectWidthChanged: {
        computeFontSize()
    }

    onGraphCurvedLineChanged: {
        hasGraphCurvedLineChanged = true
        fullRedraw()
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
                requestPaint()
                stop()
            }
            prevWidth = width
            prevHeight = height
        }
    }

    /*
     * Load weather icons
     */
    property int iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                                plasmoid.configuration.iconSetType : 0

    function computeFontSize() {
        if (!available) {
            return
        }

        let ctx = context ? context : getContext("2d")
        if (!ctx) {
            return
        }

        let size = 1
        while (true) {
            ctx.font = 'bold ' + size + 'px "' + theme.defaultFont.family + '"'
            let lineHeight = context.measureText('M').width;
            if (lineHeight >= rectWidth) {
                break
            }
            size += 0.5
        }
        fontSize = size
    }

    function drawPrecipitationBars(context, rectWidth) {
        precLabelPositions = ({})
        context.fillStyle = palette.rainColor()
        for (var i = 0; i < meteogramModel.count; i++) {
            var item = meteogramModel.get(i)
            if (item.precipitationAmount <= 0) {
                continue
            }

            var x = timeScale.translate(item.from) + (0.5 * units.devicePixelRatio)
            var prec = Math.min(precipitationMaxGraphY, item.precipitationAmount)
            var y = precipitationScale.translate(prec)

            let barWidth = rectWidth
            if (i < meteogramModel.count - 1) {
                var nexItem = meteogramModel.get(i + 1)
                var x1 = timeScale.translate(nexItem.from) + (0.5 * units.devicePixelRatio)
                barWidth = x1 - x
            } else {
                barWidth = width - x
            }

            var h = (precipitationScale.range[0]) - y
            var w = barWidth - (0.5 * units.devicePixelRatio)
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

        context.font = (fontSize * 0.75) + 'px "' + theme.defaultFont.family + '"'
        let lineHeight = context.measureText('M').width;

        var prevPrecStr = undefined

        let pType = UnitUtils.getSmallestPrecipitationType(precipitationType)


        for (var i = 0; i < meteogramModel.count; i++) {
            var item = meteogramModel.get(i)
            var prec = item.precipitationAmount
            var showPrecExcess = prec > precipitationMaxGraphY
            var showPrec = prec > 0

            // Show precipitation unit on first hour with non-zero value
            counter = showPrec ? counter + 1 : 0
            var showPrecUnit = counter === 1

            if (!showPrec) {
                continue
            }

            var x = timeScale.translate(item.from)
            var y = precipitationScale.translate(Math.min(precipitationMaxGraphY, prec))
            var precStr = UnitUtils.formatPrecipitationStr(prec, pType)
            const textPad = 2
            var y0 = y - textPad

            if (precStr === prevPrecStr && counter > 1) {
                prevPrecStr = precStr
                continue
            }
            prevPrecStr = precStr

            if (showPrecUnit) {
                precStr = precStr + " " + UnitUtils.getPrecipitationUnit(pType)
            }

            // Show arrow to indicate truncation at max value
            if (showPrecExcess) {
                var precExcessStr = '\u25B2'
                var metrics = context.measureText(precExcessStr)
                var x0 = x - (metrics.width / 2) + (rectWidth / 2)
                drawShadowText(context, precExcessStr, x0, y0)
                context.fillStyle = theme.textColor
                context.fillText(precExcessStr, x0, y0)
                y0 -= lineHeight
            }

            var xOffs = 0
            var yOffs = (lineHeight / 2) + (rectWidth / 2)

            context.save()
            context.translate(x, y0)
            context.rotate((-90 * Math.PI) / 180);
            drawShadowText(context, precStr, xOffs, yOffs)
            context.fillStyle = theme.textColor
            context.fillText(precStr, xOffs, yOffs)
            context.restore()
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
        var freezing_temp = UnitUtils.convertTemperature(0, temperatureType)
        var h = temperatureScale.translate(freezing_temp);
        if (h <= 0.0) {
            return;
        }
        context.save()
        context.beginPath()
        context.strokeStyle = 'transparent'
        context.lineWidth = 0
        context.rect(0, 0, width, h);
        context.closePath()
        context.stroke();
        context.clip();
        drawPath(context, path, color, lineWidth)
        context.restore()
    }

    function drawColdTemp(context, path, color, lineWidth) {
        var freezing_temp = UnitUtils.convertTemperature(0, temperatureType)
        var y0 = temperatureScale.translate(freezing_temp);
        var h = height - y0;
        if (h <= 0.0) {
            return;
        }
        context.save()
        context.beginPath()
        context.strokeStyle = 'transparent'
        context.lineWidth = 0
        context.rect(0, y0, width, h);
        context.closePath()
        context.stroke();
        context.clip();
        drawPath(context, path, color, lineWidth)
        context.restore()
    }

    function invertColor(color) {
        const NCHANNELS = 3
        const STRIDE = 2
        if (color[0] !== '#' && color.length !== 9 && color.length !== 7) {
            return null
        }
        var first_ch = color.length === 9 ? 3 : 1
        var res = color.substr(0, first_ch)
        for (var i = 0; i < NCHANNELS; i++) {
            let si = first_ch + (STRIDE * i)
            let ei = si + STRIDE
            let hex = color.substring(si, ei)
            let inv = 255 - parseInt(hex, 16)
            res = res + inv.toString(16).padStart(STRIDE, "0")
        }
        return res
    }

    function drawWeatherIcons(context, rectWidth) {
        context.font =  (fontSize + 1) + 'px "%1"'.arg(weatherIconFont.name)

        var bgColor = palette.backgroundColor()
        var dropShadowColor = invertColor(bgColor)

        iconOverlay.beginList()

        for (var i = 0; i < meteogramModel.count; i++) {
            var item = meteogramModel.get(i)
            var iconName = item.iconName
            var hourFrom = item.from.getHours()
            var textVisible = meteogramModel.hourInterval > 1 || ((hourFrom % 2 === 1) && iconName != '')
            if (!textVisible) {
                continue
            }

            var t = item.from
            t.setMinutes(0, 0, 0)
            var x = timeScale.translate(t)
            var y = temperatureScale.translate(UnitUtils.convertTemperature(
                                               item.temperature, temperatureType))
            var timePeriod = UnitUtils.isSunRisen(item.from) ? 0 : 1
            var str = IconTools.getIconResource(iconName, currentProvider, iconSetType,
                                                timePeriod)

            var x0 = x
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

            if (iconSetType === 0) {
                var metrics = context.measureText(str)
                var textWidth = metrics.width
                x0 = x - (textWidth / 2.0)
                context.fillStyle = theme.textColor
                context.fillText(str, x0, y0)
            } else if (iconSetType === 1 || iconSetType === 2 || iconSetType === 3) {
                x0 = x - rectWidth
                y0 -= 1.5 * rectWidth

                iconOverlay.addItem({
                    iconSetType: iconSetType,
                    iconName: iconName,
                    iconX: x0,
                    iconY: y0,
                    iconDim: 2 * rectWidth,
                    partOfDay: timePeriod
                })
            }
        }

        iconOverlay.endList()
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

    function drawAlerts(context) {
        if (!weatherAlertsModel || weatherAlertsModel.count === 0) {
            return
        }

        for (var i = 0; i < weatherAlertsModel.count; i++) {
            var a = weatherAlertsModel.get(i)
            context.fillStyle = textColorLight ? "#33ff7751" :  "#22ee3800"
            var x0 = timeScale.translate(a.alertStart.getTime())
            var x1 = timeScale.translate(a.alertEnd.getTime())
            var w = x1 - x0
            var y = 0
            var h = height
            context.fillRect(x0, y, w, h)
        }
    }

    onPaint: {
        if (!root.initialized) {
            root.fullRedraw()
            return
        }

        var context = getContext("2d")
        context.clearRect(0, 0, width, height)

        if (meteogramModel.count == 0) {
            return
        }


        context.globalCompositeOperation = "source-over"


        if (plasmoid.configuration.renderAlerts) {
            context.globalCompositeOperation = "source-over"
            drawAlerts(context)
        }

        if (plasmoid.configuration.renderPrecipitation) {
            drawPrecipitationBars(context, rectWidth)
        }

        // Carve out negative space when weather icons overlap precipitation bars
        if (plasmoid.configuration.renderIcons && iconSetType === 0) {
            context.globalCompositeOperation = "xor"
            drawWeatherIcons(context, rectWidth)
        }

        context.globalCompositeOperation = "source-over"
        if (plasmoid.configuration.renderCloudCover) {
            drawCloudArea(context)
        }
        if (plasmoid.configuration.renderHumidity) {
            drawPath(context, humidityPath, palette.humidityColor(), 1 * units.devicePixelRatio)
        }
        if (plasmoid.configuration.renderPressure) {
            drawPath(context, y2Path, palette.pressureColor(), 1 * units.devicePixelRatio)
        }
        if (plasmoid.configuration.renderTemperature) {
            drawWarmTemp(context, temperaturePath, palette.temperatureWarmColor(), 2 * units.devicePixelRatio)
            drawColdTemp(context, temperaturePath, palette.temperatureColdColor(), 2 * units.devicePixelRatio)

            let color = !textColorLight ? 'black' : 'white'
            drawPath(context, y1Path, color, 1 * units.devicePixelRatio)
        }

        if (plasmoid.configuration.renderIcons) {
            // Ensure weather icons atop graph lines without drawing over carve out
            context.globalCompositeOperation = "source-atop"
            drawWeatherIcons(context, rectWidth)
        } else {
            iconOverlay.beginList()
            iconOverlay.endList()
        }

        if (plasmoid.configuration.renderPrecipitation &&
            plasmoid.configuration.renderPrecipitationLabels)
        {
            context.globalCompositeOperation = "source-over"
            drawPrecipitationText(context, rectWidth)
        }
    }

    function buildCurves() {
        var newPathElements = temperaturePath.pathElements
        var newY1Elements = y1Path.pathElements
        var newY2Elements = y2Path.pathElements
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
            newY1Elements = []
            newY2Elements = []
            newCloudElements = []
            newCloudElements2 = []
            newHumidityElements = []
        }

        for (var i = 0; i < meteogramModel.count; i++) {
            var dataObj = meteogramModel.get(i)

            var t = dataObj.from
            var x = timeScale.translate(t)

            let y2Value = dataObj[y2VarName]

            var temperatureY = temperatureScale.translate(UnitUtils.convertTemperature(dataObj.temperature, temperatureType))
            var y2 = rightAxisScale.translate(UnitUtils.convertValue(y2Value, y2VarName))
            var humidityY = humidityScale.translate(dataObj.humidity)

            var y1 = y1VarName === "" ? NaN :
                        temperatureScale.translate(
                            UnitUtils.convertValue(dataObj[y1VarName], y1VarName))

            if (i === 0) {
                temperaturePath.startY = temperatureY
                y2Path.startY = y2
                humidityPath.startY = isFinite(humidityY) ? humidityY : 0
                y1Path.startY = y1
            }

            if (!reuse) {
                newPathElements.push(Qt.createQmlObject('import QtQuick 2.0; ' + pathType +
                                     '{ x: ' + x + '; y: ' + temperatureY + ' }',
                                     graphArea, "dynamicTemperature" + i))
            } else {
                newPathElements[i].x = x
                newPathElements[i].y = temperatureY
            }

            if (!reuse) {
                newY1Elements.push(Qt.createQmlObject('import QtQuick 2.0; ' + pathType +
                                     '{ x: ' + x + '; y: ' + y1 + ' }',
                                     graphArea, "dynamicFeelsLike" + i))
            } else {
                newY1Elements[i].x = x
                newY1Elements[i].y = y1
            }

            if (!reuse) {
                newY2Elements.push(Qt.createQmlObject('import QtQuick 2.0; '+ pathType +
                                         '{ x: ' + x + '; y: ' + y2 + ' }',
                                         graphArea, "dynamicY2" + i))
            } else {
                newY2Elements[i].x = x
                newY2Elements[i].y = y2
            }

            if (isFinite(dataObj.cloudArea)) {
                var cloudY0 = cloudAreaScale.translate(50 + (dataObj.cloudArea / 2))
                var cloudY1 = cloudAreaScale.translate(50 - ((dataObj.cloudArea) / 4))
                if (i === 0) {
                    cloudAreaPath.startY = cloudY0
                }

                if (!reuse) {
                    newCloudElements.push(Qt.createQmlObject('import QtQuick 2.0; ' + 'PathCurve' +
                                         '{ x: ' + x + '; y: ' + cloudY1 + ' }',
                                         graphArea, "dynamicCloudArea" + i))
                    newCloudElements2.push(Qt.createQmlObject('import QtQuick 2.0; ' + 'PathLine' +
                                         '{ x: ' + x + '; y: ' + cloudY0 + ' }',
                                         graphArea, "dynamicCloudArea" + (meteogramModel.count + i)))
                } else {
                    newCloudElements[i].x = x
                    newCloudElements[i].y = cloudY1
                    newCloudElements[(2 * meteogramModel.count) - 1 - i].x = x
                    newCloudElements[(2 * meteogramModel.count) - 1 - i].y = cloudY0
                }
            } else {
                if (i < newCloudElements.length) {
                    newCloudElements[i].x = NaN
                    newCloudElements[i].y = NaN
                    newCloudElements[(2 * meteogramModel.count) - 1 - i].x = NaN
                    newCloudElements[(2 * meteogramModel.count) - 1 - i].y = NaN
                }
            }
            if (isFinite(humidityY)) {
                if (!reuse) {
                    newHumidityElements.push(Qt.createQmlObject('import QtQuick 2.0; ' + pathType +
                                             '{ x: ' + x + '; y: ' + humidityY + ' }',
                                             graphArea, "dynamicHumidity" + i))
                } else {
                    newHumidityElements[i].x = x
                    newHumidityElements[i].y = humidityY
                }
            } else {
                if (i < newHumidityElements.length) {
                    newHumidityElements[i].x = NaN
                    newHumidityElements[i].y = NaN
                }
            }
        }

        // Don't paint unused elements
        for (var i = meteogramModel.count; i < newCloudElements.length; i++) {
            if (i < newPathElements.length) {
                newPathElements[i].x = NaN
                newPathElements[i].y = NaN
                newY1Elements[i].x = NaN
                newY1Elements[i].y = NaN
                newY2Elements[i].x = NaN
                newY2Elements[i].y = NaN
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
            y2Path.pathElements = newY2Elements
            cloudAreaPath.pathElements = newCloudElements.concat(newCloudElements2.reverse())
            humidityPath.pathElements = newHumidityElements
            y1Path.pathElements = newY1Elements
        }
    }

    function processMeteogramData() {
        if (meteogramModel.count === 0) {
            dbgprint('model is empty -> clearing canvas and exiting')
            requestPaint()
            return
        }

        var minValue = +Infinity
        var maxValue = -Infinity
        var minY1 = +Infinity
        var maxY1 = -Infinity
        var minY2 = +Infinity
        var maxY2 = -Infinity

        for (var i = 0; i < meteogramModel.count; i++) {
            var obj = meteogramModel.get(i)
            minValue = Math.min(minValue,  obj.temperature)
            maxValue = Math.max(maxValue, obj.temperature)

            let val = obj[y1VarName]
            if (y1VarName !== "" && isFinite(val)) {
                minY1 = Math.min(minY1,  val)
                maxY1 = Math.max(maxY1, val)
            }

            minY2 = Math.min(minY2,  obj[y2VarName])
            maxY2 = Math.max(maxY2, obj[y2VarName])
        }

        minValue = UnitUtils.convertTemperature(minValue, temperatureType)
        maxValue = UnitUtils.convertTemperature(maxValue, temperatureType)
        var [minT, maxT] = computeTemperatureAxisRange(minValue, maxValue)

        if (isFinite(minY1) && isFinite(maxY1)) {
            minY1 = UnitUtils.convertValue(minY1, y1VarName)
            maxY1 = UnitUtils.convertValue(maxY1, y1VarName)

            if (minY1 < minT || maxY1 > maxT) {
                minValue = Math.min(minValue, minY1)
                maxValue = Math.max(maxValue, maxY1)
                var [minT, maxT] = computeTemperatureAxisRange(minValue, maxValue)
            }
        }

        temperatureScale.setDomain(minT, maxT)
        temperatureAxisScale.setDomain(minT, maxT)
        temperatureAxisScale.setRange(temperatureYGridCount, 0)

        minY2 = UnitUtils.convertValue(minY2, y2VarName)
        maxY2 = UnitUtils.convertValue(maxY2, y2VarName)

        var minGridRange = ChartUtils.getMinGridRange(y2VarName)
        // var [minP, maxP, decimalPlaces] = ChartUtils.computeRightAxisRange(minY2, maxY2,
        //                                                                    minGridRange,
        //                                                                    false, false,
        //                                                                    temperatureYGridCount)
        let [fixedMinY2, fixedMaxY2] = ChartUtils.getValueRange(y2VarName)
        let fixedMin = isFinite(fixedMinY2)
        let fixedMax = isFinite(fixedMaxY2)
        if (fixedMin) {
            minY2 = fixedMinY2
        }
        if (fixedMax) {
            maxY2 = fixedMaxY2
        }

        var [minP, maxP] = ChartUtils.computeRightAxisRange(minY2, maxY2,
                                                            minGridRange,
                                                            fixedMin, fixedMax,
                                                            temperatureYGridCount)

        while (isFinite(minP) && isFinite(maxP) && !fixedMin && !fixedMax) {
            const minSpace = 0.80
            if (((maxY2 - minY2) / (maxP - minP)) < minSpace) {
                break
            }
            let stepSize = (maxP - minP) / temperatureYGridCount
            let pad = 1 * stepSize
            var [minP, maxP] = ChartUtils.computeRightAxisRange(minP - pad, maxP + pad,
                                                                minGridRange,
                                                                fixedMin, fixedMax,
                                                                temperatureYGridCount)
        }

        let stepSize = (maxP - minP) / temperatureYGridCount
        let gridStepSize = temperatureYGridStep * stepSize

        // Limit to 2 decimal places
        gridStepSize = Math.round(gridStepSize * 100) / 100

        var decimalPlaces = Math.max(ChartUtils.countDecimalPlaces(maxP),
                                     ChartUtils.countDecimalPlaces(minP))
        decimalPlaces = Math.max(ChartUtils.countDecimalPlaces(gridStepSize), decimalPlaces)

        rightAxisDecimals = decimalPlaces
        rightAxisScale.setDomain(minP, maxP)
        rightGridScale.setDomain(minP, maxP)
        rightGridScale.setRange(temperatureYGridCount, 0)
    }

    /*
     * Compute y-axis scale for temperature graph
     */
    function computeTemperatureAxisRange(minValue, maxValue) {

        // Convert window size from Celsius
        var minGridCount = minTemperatureYGridCount
        // print('minGridCount = ' + minGridCount)

        var dV = maxValue - minValue
        var mid = minValue + (dV / 2)

        // Pad the window size so the min/max value isn't on the edge of the graph area
        const coverageRatio = 0.80
        var roundedDv = ChartUtils.ceilBase(dV, 10)
        while (dV / roundedDv > coverageRatio) {
            roundedDv = ChartUtils.ceilBase(roundedDv + 10, 10)
        }

        roundedDv = Math.max(minGridCount, roundedDv)
        roundedDv = ChartUtils.ceilBase(roundedDv, 10)

        minValue = mid - (roundedDv / 2)
        maxValue = mid + (roundedDv / 2)

        temperatureYGridCount = roundedDv
        // print("temperatureYGridCount = " + temperatureYGridCount)

        // y-axis ticks
        temperatureYGridStep = Math.max(1, Math.round(temperatureYGridCount / 10))
        // print("temperatureYGridStep = " + temperatureYGridStep)

        return [minValue, maxValue]
    }

    function buildMetogramData() {
        if (meteogramModel.count <= 0) {
            return
        }

        const ONE_HOUR_MS = 60 * 60 * 1000

        var startTime = meteogramModel.get(0).from
        var endTime = meteogramModel.get(meteogramModel.count - 1).from

        var dt = endTime.getTime() - startTime.getTime()
        root.nHours = Math.floor(dt / ONE_HOUR_MS) + 1

        precipitationScale.setDomain(0, 50)
        precipitationMaxGraphY = 15

        xIndexScale.setDomain(0, meteogramModel.count - 1)
        timeScale.setDomain(startTime.getTime(), endTime.getTime())
        windSpeedArea.setModel(meteogramModel.count)
        horizontalLines1.setModel(temperatureYGridCount)
        hourGrid.setModel(startTime)
    }

    function fullRedraw() {
        processMeteogramData()
        buildMetogramData()
        buildCurves()
        initialized = true
        requestPaint()
    }

    function getItemIntervalX(index) {
        /*
         * Get the x-axis drawing coordinates of a meteogram item.
         */
        if (index < 0 || index > meteogramModel.count - 1) {
            return null
        }

        var d0 = meteogramModel.get(index)
        var t0 = d0.from

        var x0 = timeScale.translate(t0)
        var x1 = NaN

        if (index < meteogramModel.count - 1) {
            var d1 = meteogramModel.get(index + 1)
            var t1 = d1.from
            x1 = timeScale.translate(t1)
        } else {
            x1 = meteogramCanvas.width
        }
        return [x0, x1]
    }
}
