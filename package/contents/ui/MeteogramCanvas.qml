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

    property var y2VarName: "pressure"

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
        var rectWidth = width / root.nHours
        var rectHeight = Math.abs(temperatureScale.translate(temperatureYGridStep) -
                                  temperatureScale.translate(0))
        var dim = Math.min(rectWidth, rectHeight / 2)
        fontSize = Math.round(dim) * units.devicePixelRatio
    }

    function drawPrecipitationBars(context, rectWidth) {
        precLabelPositions = ({})
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

            context.fillStyle = palette.rainColor()
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

        context.font = ((fontSize / 2) + 1) + 'px "' + theme.defaultFont.family + '"'

        var prevIdx = -1
        var prevY = NaN
        var prevShowPrecUnit = false
        var prevPrecStr = undefined

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
            var precStr = UnitUtils.precipitationFormat(prec)
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
                var precUnitStr = UnitUtils.localisePrecipitationUnit("mm")
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
            t.setHours(hourFrom - 1, 0, 0, 0)
            var x = timeScale.translate(t)
            var y = temperatureScale.translate(UnitUtils.convertTemperature(
                                               item.temperature, temperatureType))
            var timePeriod = UnitUtils.isSunRisen(item.from) ? 0 : 1
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

            if (iconSetType === 0) {
                context.fillStyle = theme.textColor
                context.fillText(str, x0, y0)
            } else if (iconSetType === 1 || iconSetType === 2) {
                let dim = (iconSetType === 1) ? (1.75 * rectWidth) :
                            ((iconSetType === 2) ? (2.5 * rectWidth) : 1.0)

                x0 = x - (dim / 2.0) + (rectWidth)
                y0 -= dim

                iconOverlay.addItem({
                    iconSetType: iconSetType,
                    iconName: iconName,
                    iconX: x0,
                    iconY: y0,
                    iconDim: dim,
                    partOfDay: timePeriod
                })
            } else if (iconSetType === 3) {
                let padding = (0.05 * rectWidth)   // padding determined by hand
                x0 = x + padding
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

        computeFontSize()

        context.globalCompositeOperation = "source-over"

        var rectWidth = width / root.nHours

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
        }

        if (plasmoid.configuration.renderIcons) {
            // Ensure weather icons atop graph lines without drawing over carve out
            context.globalCompositeOperation = "source-atop"
            drawWeatherIcons(context, rectWidth)
        } else {
            iconOverlay.beginList()
            iconOverlay.endList()
        }

        if (plasmoid.configuration.renderPrecipitation) {
            context.globalCompositeOperation = "source-over"
            drawPrecipitationText(context, rectWidth)
        }
    }

    function buildCurves() {
        var newPathElements = temperaturePath.pathElements
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
            if (i === 0) {
                temperaturePath.startY = temperatureY
                y2Path.startY = y2
                humidityPath.startY = isFinite(humidityY) ? humidityY : 0
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
        var minY2 = +Infinity
        var maxY2 = -Infinity

        for (var i = 0; i < meteogramModel.count; i++) {
            var obj = meteogramModel.get(i)
            minValue = Math.min(minValue,  obj.temperature)
            maxValue = Math.max(maxValue, obj.temperature)
            minY2 = Math.min(minY2,  obj[y2VarName])
            maxY2 = Math.max(maxY2, obj[y2VarName])
        }

        minValue = UnitUtils.convertTemperature(minValue, temperatureType)
        maxValue = UnitUtils.convertTemperature(maxValue, temperatureType)
        let [minT, maxT] = processTemperatureData(minValue, maxValue)

        temperatureScale.setDomain(minT, maxT)
        temperatureAxisScale.setDomain(minT, maxT)
        temperatureAxisScale.setRange(temperatureYGridCount, 0)


        function getValueRange(varName) {
            if (varName === "windSpeed") {
                return [0, Infinity]
            }
            return [-Infinity, Infinity]
        }

        function getMinGridRange(varName) {
            if (varName === "pressure") {
                const minPressureYGridCount = {
                    0: 30,
                    1: 0.5,
                    2: 10,
                }
                return minPressureYGridCount[main.pressureType]
            }
            return 1.0
        }

        minY2 = UnitUtils.convertValue(minY2, y2VarName)
        maxY2 = UnitUtils.convertValue(maxY2, y2VarName)

        var minGridRange = getMinGridRange(y2VarName)
        let [minP, maxP, decimalPlaces] = computeRightAxisRange(minY2, maxY2, minGridRange,
                                                                false, false)

        let [fixedMinY2, fixedMaxY2] = getValueRange(y2VarName)
        if (isFinite(fixedMinY2) || isFinite(fixedMaxY2)) {
            let fixedMin = false
            if (minP < fixedMinY2) {
                fixedMin = true
                minY2 = fixedMinY2
            }
            let fixedMax = false
            if (maxP > fixedMaxY2) {
                fixedMax = true
                maxY2 = fixedMaxY2
            }
            if (fixedMin === true || fixedMax === true) {
                [minP, maxP, decimalPlaces] = computeRightAxisRange(minY2, maxY2, minGridRange,
                                                                    fixedMin, fixedMax)
            }
        }

        pressureDecimals = decimalPlaces
        rightAxisScale.setDomain(minP, maxP)
        rightGridScale.setDomain(minP, maxP)
        rightGridScale.setRange(temperatureYGridCount, 0)
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

        return [minValue, maxValue]
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
     * Compute y-axis scale.
     * Right axis shares y-axis grid lines with temperature graph. This imposes a constraint of
     * which right axis steps are bound to temperature axis steps.
     */
    function computeRightAxisRange(minValue, maxValue, minGridRange, fixedMin, fixedMax) {

        var dP = maxValue - minValue
        var [decimalPlace, mult] = getMagnitude(dP)
        // print(" ")
        // print("maxValue = " + maxValue + ", minValue = " + minValue)
        // print("dP = " + dP)
        // print("decimalPlace = " + decimalPlace + ", mult = " + mult)

        if (fixedMin === true && fixedMax === true) {
            return [minValue, maxValue, decimalPlace]
        }

        var stepSize = 1 / mult
        if ((dP / stepSize) < 2) {
            // Ensure at least 2 steps
            mult *= 100
            decimalPlace -= 2
            // print("decimalPlace = " + decimalPlace + ", mult = " + mult)
        }

        decimalPlace = Math.max(-2, decimalPlace)
        decimalPlace = Math.min(4, decimalPlace)

        dP = Math.max(minGridRange, dP)
        if (decimalPlace >= 0) {
             dP += (2 * (mult * 100) / temperatureYGridCount)
        } else {
             dP += (2 * (mult / 100) / temperatureYGridCount)
        }
        dP = Math.ceil(dP * mult * 10) / (mult * 10)
        // print("minGridRange = " + minGridRange + ", dP = " + dP)

        var stepSize = 1 / mult
        var count = Math.ceil(dP / stepSize)
        var nSteps = Math.ceil(count / temperatureYGridCount) * temperatureYGridCount
        var valueRange = stepSize * nSteps
        // print("valueRange = " + valueRange)
        // print("temperatureYGridCount = " + temperatureYGridCount)

        while (true) {
            var s = stepSize * 2
            var c = Math.floor(dP / s)
            var ns = Math.ceil(c / temperatureYGridCount) * temperatureYGridCount
            var pr = s * ns

            // print("stepSize = " + stepSize + ", nSteps = " + nSteps +
            //       ", valueRange = " + valueRange + ", dP = " + dP)
            if (c <= 0 || ns <= 0) {
                print("c = " + c + ", ns = " + ns)
                break
            }
            if (nSteps <= temperatureYGridCount && valueRange >= dP) {
                break
            }
            stepSize = s
            count = c
            nSteps = ns
            valueRange = pr
        }

        // Pressure scale domain
        var mid = minValue + ((maxValue - minValue) / 2.0)
        mid = Math.round(mid * mult) / mult
        minValue = fixedMin ? minValue : (mid - (valueRange / 2.0))
        maxValue = fixedMax ? maxValue : (mid + (valueRange / 2.0))
        if (mult != 1) {
            minValue = fixedMin ? minValue : (Math.ceil(minValue * mult) / mult)
            maxValue = fixedMax ? maxValue : (Math.floor(maxValue * mult) / mult)
        }

        // print("mid = " + mid + ", maxValue = " + maxValue + ", minValue = " + minValue)

        /*
         * Round min/max values at one higher order of magnitude
         */
        var decimalPlace_ = Math.floor(Math.log10(stepSize))
        var mult = decimalPlace_ + 1
        if (decimalPlace_ >= 0) {
            mult = Math.pow(10, mult)
        } else {
            // Whole numbers are the upper bound for rounding when the step size is less than zero.
            mult = mult < 1 ? Math.pow(10, mult) : mult
        }

        var ceilMaxP = Math.ceil(maxValue / mult) * mult
        var floorMaxP = Math.floor(maxValue / mult) * mult
        // print("ceilMaxP = " + ceilMaxP)
        // print("floorMaxP = " + floorMaxP)
        if (maxValue - floorMaxP <= ceilMaxP - maxValue) {
            var dp = maxValue - floorMaxP
            maxValue = fixedMax ? maxValue : (maxValue - dp)
            minValue = fixedMin ? minValue : (minValue - dp)
        } else {
            var dp = ceilMaxP - maxValue
            maxValue = fixedMax ? maxValue : (maxValue + dp)
            minValue = fixedMin ? minValue : (minValue + dp)
        }
        // print("mult = " + mult)
        // print("maxValue = " + maxValue + ", minValue = " + minValue)

        let decimalPlaces = -1 * Math.min(0, decimalPlace)

        return [minValue, maxValue, decimalPlaces]
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
