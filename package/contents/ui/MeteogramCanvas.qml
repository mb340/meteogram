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
import "../code/icons.js" as IconTools
import "../code/chart-utils.js" as ChartUtils


Canvas {
    id: root

    contextType: '2d'
    renderStrategy: Canvas.Threaded

    property bool initialized: false

    property double fontSize: computeFontSize(available, rectWidth)
    property var precLabelPositions: ({})

    property int nHours: 0
    property double rectWidth: width / nHours

    property string pathChartName: ""

    property var pathLineConfigs: ({
        "temperature": {
            scale: temperatureScale,
            varName: "temperature",
            unitType: main.temperatureType
        },
        "humidity": {
            scale: humidityScale,
            varName: "humidity",
            unitType: -1
        },
        "y1Chart": {
            scale: temperatureScale,
            varName: y1VarName,
            unitType: main.temperatureType
        },
        "y2Chart": {
            scale: rightAxisScale,
            varName: y2VarName,
            unitType: unitUtils.getUnitType(y2VarName)
        }
    })

    property double hourStrWidth: computeHourStrWidth(theme.smallestFont)
    property int hourStep: computeHourStep(hourStrWidth, rectWidth)

    property alias temperatureScale: temperatureScale
    property alias temperatureAxisScale: temperatureAxisScale
    property alias rightAxisScale: rightAxisScale
    property alias rightGridScale: rightGridScale
    property alias precipitationScale: precipitationScale
    property alias cloudAreaScale: cloudAreaScale
    property alias humidityScale: humidityScale
    property alias xIndexScale: xIndexScale
    property alias timeScale: timeScale
    property alias xAxisScale: xAxisScale
    property alias yAxisScale: yAxisScale

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
        id: xAxisScale
        range: [0, width]
    }

    LinearScale {
        id: yAxisScale
        range: [0, height]
    }

    LinearScale {
        id: timeScale
        range: [0, width]
    }

    Path {
        id: meteogramPath
        startX: 0
        pathElements: []

    }

    Path {
        id: cloudAreaPath
        startX: 0
        pathElements: []
    }

    Component {
        id: pathLine
        PathLine {
            x: !pathLineConfig || !model ? NaN : timeScale.translate(model.from)
            y: !pathLineConfig || !model ? NaN :
                    pathLineConfig.scale.translate(
                        unitUtils.convertValue(model[pathLineConfig.varName],
                                               pathLineConfig.varName,
                                               pathLineConfig.unitType ? pathLineConfig.unitType : -1))

            property int i
            property var pathLineConfig: pathLineConfigs[pathChartName]
            property var model: meteogramModel.get(i)
        }
    }

    Component {
        id: cloudPathLine
        PathLine {
            x: !model ? NaN : timeScale.translate(model.from)

            y: !model ? NaN :
                isCloudTop ? cloudAreaScale.translate(50 + (model.cloudArea / 2)) :
                             cloudAreaScale.translate(50 - ((model.cloudArea) / 4))

            property int i
            property bool isCloudTop: (i >= meteogramModel.count)

            property var model: meteogramModel.get(i < meteogramModel.count ? i :
                                                   meteogramModel.count -
                                                   (i - meteogramModel.count) - 1)
        }
    }

    MeteogramIconOverlay {
        id: iconOverlay
        anchors.fill: parent
        clip: true

        iconSetType: root.iconSetType
        iconDim: hourStep === 1 ? root.rectWidth : 2 * root.rectWidth
    }

    Connections {
        target: plasmoid
        // function onExpandedChanged() {
        //     if (!available || !plasmoid.expanded) {
        //         return
        //     }
        //     root.markDirty(Qt.rect(0, 0, width, height))
        // }
    }

    Connections {
        target: plasmoid.configuration

        onRenderTemperatureChanged: Qt.callLater(fullRedraw)
        onRenderPressureChanged: Qt.callLater(fullRedraw)
        onRenderHumidityChanged: Qt.callLater(fullRedraw)
        onRenderPrecipitationChanged: Qt.callLater(fullRedraw)
        onRenderCloudCoverChanged: Qt.callLater(fullRedraw)
        onRenderIconsChanged: Qt.callLater(fullRedraw)
        onRenderAlertsChanged: Qt.callLater(fullRedraw)
        onRenderSunsetShadeChanged: Qt.callLater(fullRedraw)

        onColorPaletteTypeChanged: Qt.callLater(fullRedraw)

        onBackgroundColorChanged: Qt.callLater(fullRedraw)
        onPressureColorChanged: Qt.callLater(fullRedraw)
        onTemperatureWarmColorChanged: Qt.callLater(fullRedraw)
        onTemperatureColdColorChanged: Qt.callLater(fullRedraw)
        onRainColorChanged: Qt.callLater(fullRedraw)
        onCloudAreaColorChanged: Qt.callLater(fullRedraw)
        onCloudAreaColor2Changed: Qt.callLater(fullRedraw)
        onHumidityColorChanged: Qt.callLater(fullRedraw)
        onBackgroundColorDarkChanged: Qt.callLater(fullRedraw)
        onPressureColorDarkChanged: Qt.callLater(fullRedraw)
        onTemperatureWarmColorDarkChanged: Qt.callLater(fullRedraw)
        onTemperatureColdColorDarkChanged: Qt.callLater(fullRedraw)
        onRainColorDarkChanged: Qt.callLater(fullRedraw)
        onCloudAreaColorDarkChanged: Qt.callLater(fullRedraw)
        onCloudAreaColor2DarkChanged: Qt.callLater(fullRedraw)
        onHumidityColorDarkChanged: Qt.callLater(fullRedraw)
    }

    /*
     * Repaint canvas on resize.
     */
    onWidthChanged: Qt.callLater(fullRedraw)
    onHeightChanged: Qt.callLater(fullRedraw)

    /*
     * Load weather icons
     */
    property int iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                                plasmoid.configuration.iconSetType : 0

    function computeFontSize(available, rectWidth) {
        if (!available) {
            return theme.defaultFont.pixelSize
        }

        if (!isFinite(rectWidth) || rectWidth <= 0) {
            return theme.defaultFont.pixelSize
        }

        let ctx = context ? context : getContext("2d")
        if (!ctx) {
            return theme.defaultFont.pixelSize
        }

        let size = 1
        let w = Math.min(hourStrWidth / 1.75, rectWidth * meteogramModel.hourInterval)
        while (true) {
            ctx.font = 'bold ' + size + 'px "' + theme.defaultFont.family + '"'
            let lineHeight = context.measureText('M').width;
            if (lineHeight >= w) {
                break
            }
            size += 0.5
        }
        return size
    }

    function drawPrecipitationBars(context, rectWidth) {
        precLabelPositions = ({})
        context.fillStyle = colorPalette.rainColor()
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
        context.shadowColor = main.colors.meteogram.isDarkMode ?
                                'black' : 'white';
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

        let pType = unitUtils.getSmallestPrecipitationType(precipitationType)


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
            var precStr = unitUtils.formatPrecipitationStr(prec, pType)
            const textPad = 2
            var y0 = y - textPad

            if (precStr === prevPrecStr && counter > 1) {
                prevPrecStr = precStr
                continue
            }
            prevPrecStr = precStr

            if (showPrecUnit) {
                precStr = precStr + " " + unitUtils.getPrecipitationUnit(pType)
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
        var freezing_temp = unitUtils.convertTemperature(0, temperatureType)
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
        var freezing_temp = unitUtils.convertTemperature(0, temperatureType)
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

    function drawWeatherIcons(context, rectWidth) {

        // Avoid icons overlapping with precipitation labels.
        // Estimate the typical height of a precipitation label
        var labelHeight = 0.
        if (plasmoid.configuration.renderPrecipitationLabels) {
            let pType = unitUtils.getSmallestPrecipitationType(precipitationType)
            var precStr = unitUtils.getPrecipitationText(0.1, pType, 1)
            context.font = (fontSize * 0.75).toFixed(2) + 'px "' + theme.defaultFont.family + '"'
            var metrics = context.measureText(precStr)
            labelHeight = metrics.width
        }

        if (iconSetType === 0) {
            context.font =  '%1px "%2"'.arg((fontSize + 1)).arg(weatherIconFont.name)
        }

        iconOverlay.beginList()

        var sunRise = timeUtils.roundToHour(main.currentWeatherModel.sunRise)
        var sunSet = timeUtils.roundToHour(main.currentWeatherModel.sunSet)

        var offset = (hourStep === 1) ? (rectWidth / 2) : rectWidth

        for (var i = 0; i < meteogramModel.count; i++) {
            var item = meteogramModel.get(i)
            var iconName = item.iconName
            var hourFrom = item.from.getHours()

            if (!iconName) {
                continue
            }

            var textVisible = meteogramModel.hourInterval > 1 ||
                                (hourStep > 1 && hourFrom % 2 === 1) ||
                                (hourStep === 1)
            if (!textVisible) {
                continue
            }

            var t = item.from
            var x = timeScale.translate(t)
            var y = temperatureScale.translate(unitUtils.convertTemperature(
                                               item.temperature, temperatureType))
            var timePeriod = timeUtils.isSunRisen(item.from, sunRise, sunSet) ? 0 : 1

            var x0 = x
            var y0 = y - offset

            // Avoid overlapping precipitation labels.
            // Shifting from one label position may result in overlap of other label or vice
            // versa. Hence peform the check twice to cover both cases.
            var labelPosY0 = precLabelPositions[i - 1]
            var labelPosY1 = precLabelPositions[i]
            var newY0 = y0
            var newY1 = y0

            if (labelPosY0 - (2 * offset) <= y0 && y0 <= labelPosY0 + (2 * offset)) {
                newY0 = Math.min(y0, labelPosY0 - (labelHeight))
                if (labelPosY1 - (2 * offset) <= newY0 && newY0 <= labelPosY1 + (1 * offset)) {
                    newY0 = Math.min(newY0, labelPosY1 - (labelHeight))
                }
            }
            if (labelPosY1 - (2 * offset) <= y0 && y0 <= labelPosY1 + (2 * offset)) {
                newY1 = Math.min(y0, labelPosY1 - (labelHeight))
                if (labelPosY0 - (2 * offset) <= newY1 && newY1 <= labelPosY0 + (1 * offset)) {
                    newY1 = Math.min(newY1, labelPosY0 - (labelHeight))
                }
            }
            y0 = Math.min(newY0, newY1)

            if (iconSetType === 0) {
                var iconIr = currentProvider.getIconIr(iconName)
                var str = IconTools.getIconResource(iconIr, iconSetType, timePeriod)

                var metrics = context.measureText(str)
                var textWidth = metrics.width
                x0 = x - (textWidth / 2.0)
                context.fillStyle = theme.textColor
                context.fillText(str, x0, y0)
            } else if (iconSetType === 1 || iconSetType === 2 || iconSetType === 3) {
                x0 = x - offset
                y0 -= 1.5 * offset

                iconOverlay.addItem({
                    iconName: iconName,
                    iconX: x0,
                    iconY: y0,
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

        let count = cloudAreaPath.pathElements.length
        cloudAreaPath.startY = cloudAreaPath.pathElements[count - 1].y

        context.beginPath()

        var y0 = cloudAreaScale.translate(50 - (100 / 2))
        var y1 = cloudAreaScale.translate(50 + (100 / 4))
        var gradient = context.createLinearGradient(0, y1, 0, y0);
        gradient.addColorStop(0, colorPalette.cloudAreaColor());
        gradient.addColorStop(1, colorPalette.cloudAreaColor2());
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
            context.fillStyle = main.colors.meteogram.isDarkMode ?
                                    "#33ff7751" :  "#22ee3800"
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
        }

        buildCurves()

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
            pathChartName = "humidity"
            meteogramPath.startY = meteogramPath.pathElements[0].y
            drawPath(context, meteogramPath, colorPalette.humidityColor(), 1 * units.devicePixelRatio)
        }
        if (plasmoid.configuration.renderPressure && y2VarName && y2VarName !== "") {
            pathChartName = "y2Chart"
            meteogramPath.startY = meteogramPath.pathElements[0].y
            drawPath(context, meteogramPath, colorPalette.pressureColor(), 1 * units.devicePixelRatio)
        }
        if (plasmoid.configuration.renderTemperature) {
            pathChartName = "temperature"
            meteogramPath.startY = meteogramPath.pathElements[0].y
            drawWarmTemp(context, meteogramPath, colorPalette.temperatureWarmColor(), 2 * units.devicePixelRatio)
            drawColdTemp(context, meteogramPath, colorPalette.temperatureColdColor(), 2 * units.devicePixelRatio)

            if (y1VarName && y1VarName !== "") {
                let color = !main.colors.meteogram.isDarkMode ?
                                'black' : 'white'
                pathChartName = "y1Chart"
                meteogramPath.startY = meteogramPath.pathElements[0].y
                drawPath(context, meteogramPath, color, 1 * units.devicePixelRatio)
            }
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

        let i = 0
        for (; i < meteogramPath.pathElements.length; i++) {
            meteogramPath.pathElements[i].destroy()
        }
        meteogramPath.pathElements = []

        for (i = 0; i < cloudAreaPath.pathElements.length; i++) {
            cloudAreaPath.pathElements[i].destroy()
        }
        cloudAreaPath.pathElements = []
    }

    function buildCurves() {
        let count = meteogramModel.count
        if (plasmoid.configuration.renderCloudCover) {
            count *= 2
        }
        for (let i = 0; i < count; i++) {
            let props = { i: i }
            if (i < meteogramModel.count) {
                meteogramPath.pathElements.push(
                                pathLine.createObject(meteogramPath, props))
            }
            if (plasmoid.configuration.renderCloudCover) {
                cloudAreaPath.pathElements.push(
                                cloudPathLine.createObject(root, props))
            }
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


        minValue = unitUtils.convertTemperature(minValue, temperatureType)
        maxValue = unitUtils.convertTemperature(maxValue, temperatureType)

        var [minT, maxT] = computeTemperatureAxisRange(minValue, maxValue)

        // Account for icon height
        temperatureScale.setDomain(minT, maxT)
        let heightInT = temperatureScale.invertUnitStep(2 * rectWidth)
        if ((maxValue + heightInT) - minValue > minTemperatureYGridCount) {
            maxT = maxT + heightInT
        }

        if (isFinite(minY1) && isFinite(maxY1)) {
            minY1 = unitUtils.convertValue(minY1, y1VarName, unitUtils.getUnitType(y1VarName))
            maxY1 = unitUtils.convertValue(maxY1, y1VarName, unitUtils.getUnitType(y1VarName))

            if (minY1 < minT || maxY1 > maxT) {
                minValue = Math.min(minValue, minY1)
                maxValue = Math.max(maxValue, maxY1)
                var [minT, maxT] = computeTemperatureAxisRange(minValue, maxValue)
            }
        }

        temperatureScale.setDomain(minT, maxT)
        temperatureAxisScale.setDomain(minT, maxT)
        temperatureAxisScale.setRange(temperatureYGridCount, 0)

        minY2 = unitUtils.convertValue(minY2, y2VarName, unitUtils.getUnitType(y2VarName))
        maxY2 = unitUtils.convertValue(maxY2, y2VarName, unitUtils.getUnitType(y2VarName))

        var minGridRange = ChartUtils.getMinGridRange(y2VarName, unitUtils.getUnitType(y2VarName))
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

        let prevRatio = NaN
        while (isFinite(minP) && isFinite(maxP) && !fixedMin && !fixedMax) {
            const minSpace = 0.80
            let ratio = ((maxY2 - minY2) / (maxP - minP))
            if (ratio < minSpace || ratio === prevRatio) {
                break
            }
            prevRatio = ratio
            let stepSize = (maxP - minP) / temperatureYGridCount
            let pad = 1 * stepSize
            var [minP, maxP] = ChartUtils.computeRightAxisRange(minP - pad, maxP + pad,
                                                                minGridRange,
                                                                fixedMin, fixedMax,
                                                                temperatureYGridCount)
        }

        let stepSize = (maxP - minP) / temperatureYGridCount

        let [stepDp, stepMult] = ChartUtils.getMagnitude(stepSize)
        stepDp *= -1

        let decimalPlaces = stepDp
        decimalPlaces = !isNaN(decimalPlaces) ? decimalPlaces : 0
        decimalPlaces = Math.max(0, Math.min(decimalPlaces, 3))

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

        var roundedDv = ChartUtils.ceilBase(dV, 10)
        roundedDv = Math.max(minGridCount, roundedDv)
        roundedDv = ChartUtils.ceilBase(roundedDv, 10)

        minValue = Math.floor(mid - (roundedDv / 2))
        maxValue = Math.ceil(mid + (roundedDv / 2))

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

        var startTime = meteogramModel.get(0).from
        var endTime = meteogramModel.get(meteogramModel.count - 1).from

        precipitationScale.setDomain(0, 50)
        precipitationMaxGraphY = 15

        xIndexScale.setDomain(0, meteogramModel.count - 1)

        yAxisScale.setDomain(0, temperatureYGridCount)
        xAxisScale.setDomain(0, root.nHours - 1)
        timeScale.setDomain(startTime.getTime(), endTime.getTime())
        windSpeedArea.setModel(meteogramModel.count)
        horizontalLines.setModel(temperatureYGridCount)
        hourGrid2.setModel(startTime)
    }

    function computeHourStrWidth(font) {
        if (!available || !context || !font) {
            return 0
        }
        let ctx = root.context ? root.context : getContext("2d")
        if (!ctx) {
            return theme.defaultFont.pixelSize
        }
        let hourStrWidth = 0
        let fontSize = font.pixelSize
        context.font = fontSize + 'px "' + font.family + '"'
        let metrics = context.measureText("00")
        hourStrWidth = 2 * metrics.width

        // print("hourStrWidth ", hourStrWidth)
        return hourStrWidth
    }

    function computeHourStep(hourStrWidth, rectWidth) {
        let hourStep = Math.ceil(hourStrWidth / rectWidth)
        if (!isFinite(hourStep)) {
            return 2
        }
        if (hourStep <= 0) {
            hourStep = 1
        } else if (hourStep <= 4) {
            // hourStep
        } else if (hourStep <= 6) {
            hourStep = 6
        } else if (hourStep <= 8) {
            hourStep = 8
        } else if (hourStep <= 12) {
            hourStep = 12
        } else {
            hourStep = 24
        }
        // print("hourStep ", hourStep)
        return hourStep
    }

    function fullRedraw() {
        if (!available) {
            return
        }

        if (meteogramModel.count > 0) {
            const ONE_HOUR_MS = 60 * 60 * 1000
            let startTime = meteogramModel.get(0).from
            let endTime = meteogramModel.get(meteogramModel.count - 1).from
            let dt = endTime.getTime() - startTime.getTime()
            root.nHours = Math.floor(dt / ONE_HOUR_MS) + 1
        } else {
            root.nHours = 0
        }

        processMeteogramData()
        buildMetogramData()

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
