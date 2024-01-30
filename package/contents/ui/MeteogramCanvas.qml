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
import QtQuick
import org.kde.kirigami as Kirigami
import "../code/icons.js" as IconTools
import "../code/chart-utils.js" as ChartUtils


Canvas {
    id: root

    contextType: '2d'
    renderStrategy: Canvas.Threaded

    property bool initialized: false

    property double fontSize: 14 * 1
    property var precLabelPositions: ({})

    property int nHours: 0
    property double rectWidth: width / nHours

    property var temperaturePathItems: []
    property var humidityPathItems: []
    property var y1PathItems: []
    property var y2PathItems: []

    property var cloudPathItems: []


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

    property double hourStrWidth: NaN
    property int hourStep: 2

    property bool isRectWidthChanged: true

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
            property var pathLineConfig
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
            property bool isCloudTop: true

            property var model: meteogramModel.get(i)
        }
    }

    MeteogramIconOverlay {
        id: iconOverlay
        anchors.fill: parent
        clip: true

        iconSetType: root.iconSetType
        iconDim: 2 * root.rectWidth
    }

    Connections {
        target: main
        function onExpandedChanged() {
            root.markDirty(Qt.rect(0, 0, width, height))
        }
    }

    onRectWidthChanged: isRectWidthChanged = true
    onNHoursChanged: isRectWidthChanged = true

    /*
     * Repaint canvas on resize.
     */
    onWidthChanged: Qt.callLater(fullRedraw)
    onHeightChanged: Qt.callLater(fullRedraw)


    /*
     * Repaint canvas on config changes
     */
    property bool renderTemperature: plasmoid.configuration.renderTemperature
    property bool renderPressure: plasmoid.configuration.renderPressure
    property bool renderHumidity: plasmoid.configuration.renderHumidity
    property bool renderPrecipitation: plasmoid.configuration.renderPrecipitation
    property bool renderCloudCover: plasmoid.configuration.renderCloudCover
    property bool renderIcons: plasmoid.configuration.renderIcons
    property bool renderAlerts: plasmoid.configuration.renderAlerts
    property bool renderSunsetShade: plasmoid.configuration.renderSunsetShade

    property int colorPaletteType: plasmoid.configuration.colorPaletteType

    property string backgroundColor: plasmoid.configuration.backgroundColor
    property string pressureColor: plasmoid.configuration.pressureColor
    property string temperatureWarmColor: plasmoid.configuration.temperatureWarmColor
    property string temperatureColdColor: plasmoid.configuration.temperatureColdColor
    property string rainColor: plasmoid.configuration.rainColor
    property string cloudAreaColor: plasmoid.configuration.cloudAreaColor
    property string cloudAreaColor2: plasmoid.configuration.cloudAreaColor2
    property string humidityColor: plasmoid.configuration.humidityColor

    property string backgroundColorDark: plasmoid.configuration.backgroundColorDark
    property string pressureColorDark: plasmoid.configuration.pressureColorDark
    property string temperatureWarmColorDark: plasmoid.configuration.temperatureWarmColorDark
    property string temperatureColdColorDark: plasmoid.configuration.temperatureColdColorDark
    property string rainColorDark: plasmoid.configuration.rainColorDark
    property string cloudAreaColorDark: plasmoid.configuration.cloudAreaColorDark
    property string cloudAreaColor2Dark: plasmoid.configuration.cloudAreaColor2Dark
    property string humidityColorDark: plasmoid.configuration.humidityColorDark

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

    /*
     * Load weather icons
     */
    property int iconSetType: (plasmoid && plasmoid.configuration && plasmoid.configuration.iconSetType) ?
                                plasmoid.configuration.iconSetType : 0

    function computeFontSize() {
        if (!available || !isRectWidthChanged) {
            return
        }

        if (!isFinite(rectWidth) || rectWidth <= 0) {
            return
        }

        let ctx = context ? context : getContext("2d")
        if (!ctx) {
            return
        }

        let size = 1
        while (true) {
            ctx.font = 'bold ' + size + 'px "' + Kirigami.Theme.defaultFont.family + '"'
            let lineHeight = context.measureText('M').width;
            if (lineHeight >= rectWidth) {
                break
            }
            size += 0.5
        }
        fontSize = size
        isRectWidthChanged = false
    }

    function drawPrecipitationBars(context, rectWidth) {
        precLabelPositions = ({})
        context.fillStyle = colorPalette.rainColor()
        for (var i = 0; i < meteogramModel.count; i++) {
            var item = meteogramModel.get(i)
            if (item.precipitationAmount <= 0) {
                continue
            }

            var x = timeScale.translate(item.from) + (0.5 * 1)
            var prec = Math.min(precipitationMaxGraphY, item.precipitationAmount)
            var y = precipitationScale.translate(prec)

            let barWidth = rectWidth
            if (i < meteogramModel.count - 1) {
                var nexItem = meteogramModel.get(i + 1)
                var x1 = timeScale.translate(nexItem.from) + (0.5 * 1)
                barWidth = x1 - x
            } else {
                barWidth = width - x
            }

            var h = (precipitationScale.range[0]) - y
            var w = barWidth - (0.5 * 1)
            context.fillRect(x, y, w, h)

            var fontSize = Math.round(rectWidth / 2) + 1
            precLabelPositions[i] = y - fontSize
        }
    }

    function drawShadowText(context, str, x, y) {
        context.strokeStyle = main.theme.meteogram.textColor
        context.shadowColor = main.theme.meteogram.isDarkMode ? 'black' : 'white';
        context.shadowBlur = 0.5;
        context.lineWidth = 0.5;
        context.strokeText(str, x, y)
        context.shadowBlur = 0;
    }

    function drawPrecipitationText(context, rectWidth) {
        context.save()
        var counter = 0

        context.font = (fontSize * 0.75) + 'px "' + Kirigami.Theme.defaultFont.family + '"'
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
                context.fillStyle = main.theme.meteogram.textColor
                context.fillText(precExcessStr, x0, y0)
                y0 -= lineHeight
            }

            var xOffs = 0
            var yOffs = (lineHeight / 2) + (rectWidth / 2)

            context.save()
            context.translate(x, y0)
            context.rotate((-90 * Math.PI) / 180);
            drawShadowText(context, precStr, xOffs, yOffs)
            context.fillStyle = main.theme.meteogram.textColor
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

        // Avoid icons overlapping with precipitation labels.
        // Estimate the typical height of a precipitation label
        var labelHeight = 0.
        if (plasmoid.configuration.renderPrecipitationLabels) {
            let pType = unitUtils.getSmallestPrecipitationType(precipitationType)
            var precStr = unitUtils.getPrecipitationText(0.1, pType, 1)
            context.font = (fontSize * 0.75) + 'px "' + Kirigami.Theme.defaultFont.family + '"'
            var metrics = context.measureText(precStr)
            labelHeight = metrics.width
        }


        context.font =  (fontSize + 1) + 'px "%1"'.arg(weatherIconFont.name)

        var bgColor = colorPalette.backgroundColor()
        var dropShadowColor = invertColor(bgColor)

        iconOverlay.beginList()

        var sunRise = main.currentWeatherModel.sunRise
        var sunSet = main.currentWeatherModel.sunSet

        for (var i = 0; i < meteogramModel.count; i++) {
            var item = meteogramModel.get(i)
            var iconName = item.iconName
            var hourFrom = item.from.getHours()
            var textVisible = meteogramModel.hourInterval > 1 || ((hourFrom % 2 === 1) && iconName != '')
            if (!textVisible) {
                continue
            }

            var t = item.from
            var x = timeScale.translate(t)
            var y = temperatureScale.translate(unitUtils.convertTemperature(
                                               item.temperature, temperatureType))
            var timePeriod = timeUtils.isSunRisen(item.from, sunRise, sunSet) ? 0 : 1
            var iconIr = currentProvider.getIconIr(iconName)
            var str = IconTools.getIconResource(iconIr, iconSetType, timePeriod)

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
                newY0 = Math.min(y0, labelPosY0 - (labelHeight))
                if (labelPosY1 - (2 * rectWidth) <= newY0 && newY0 <= labelPosY1 + (1 * rectWidth)) {
                    newY0 = Math.min(newY0, labelPosY1 - (labelHeight))
                }
            }
            if (labelPosY1 - (2 * rectWidth) <= y0 && y0 <= labelPosY1 + (2 * rectWidth)) {
                newY1 = Math.min(y0, labelPosY1 - (labelHeight))
                if (labelPosY0 - (2 * rectWidth) <= newY1 && newY1 <= labelPosY0 + (1 * rectWidth)) {
                    newY1 = Math.min(newY1, labelPosY0 - (labelHeight))
                }
            }
            y0 = Math.min(newY0, newY1)

            if (iconSetType === 0) {
                var metrics = context.measureText(str)
                var textWidth = metrics.width
                x0 = x - (textWidth / 2.0)
                context.fillStyle = main.theme.meteogram.textColor
                context.fillText(str, x0, y0)
            } else if (iconSetType === 1 || iconSetType === 2 || iconSetType === 3) {
                x0 = x - rectWidth
                y0 -= 1.5 * rectWidth

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
            context.fillStyle = main.theme.meteogram.isDarkMode ? "#33ff7751" :  "#22ee3800"
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

        var context = getContext("2d")
        context.clearRect(0, 0, width, height)

        if (meteogramModel.count == 0) {
            return
        }

        context.globalCompositeOperation = "source-over"


        if (renderAlerts) {
            context.globalCompositeOperation = "source-over"
            drawAlerts(context)
        }

        if (renderPrecipitation) {
            drawPrecipitationBars(context, rectWidth)
        }

        // Carve out negative space when weather icons overlap precipitation bars
        if (renderIcons && iconSetType === 0) {
            context.globalCompositeOperation = "xor"
            drawWeatherIcons(context, rectWidth)
        }

        context.globalCompositeOperation = "source-over"
        if (renderCloudCover) {
            drawCloudArea(context)
        }
        if (renderHumidity) {
            drawPath(context, humidityPath, colorPalette.humidityColor(), 1 * 1)
        }
        if (renderPressure && y2VarName && y2VarName !== "") {
            drawPath(context, y2Path, colorPalette.pressureColor(), 1 * 1)
        }
        if (renderTemperature) {
            drawWarmTemp(context, temperaturePath, colorPalette.temperatureWarmColor(), 2 * 1)
            drawColdTemp(context, temperaturePath, colorPalette.temperatureColdColor(), 2 * 1)

            if (y1VarName && y1VarName !== "") {
                let color = !main.theme.meteogram.isDarkMode ? 'black' : 'white'
                drawPath(context, y1Path, color, 1 * 1)
            }
        }

        if (renderIcons) {
            // Ensure weather icons atop graph lines without drawing over carve out
            context.globalCompositeOperation = "source-atop"
            drawWeatherIcons(context, rectWidth)
        } else {
            iconOverlay.beginList()
            iconOverlay.endList()
        }

        if (renderPrecipitation &&
            plasmoid.configuration.renderPrecipitationLabels)
        {
            context.globalCompositeOperation = "source-over"
            drawPrecipitationText(context, rectWidth)
        }
    }

    function updatePathElement(index, chartName, pathList) {
        if (index >= pathList.length) {
            let obj = pathLine.createObject(root, {
                i: index,
                pathLineConfig: Qt.binding(function() { return pathLineConfigs[chartName] }),
            })
            if (obj != null) {
                pathList.push(obj)
            } else {
                print("Error: PathLine createObject returned null.")
            }
        } else {
            let item = pathList[index]
            let tmp = item.i
            item.i = index
            if (tmp === index) {
                item.iChanged()
            }
        }
    }

    function buildCurves() {
        if (meteogramModel.count <= 0) {
            temperaturePath.pathElements = []
            humidityPath.pathElements = []
            y1Path.pathElements = []
            y2Path.pathElements = []
            return
        }

        let y1Count = 0
        let y2Count = 0
        let hasY1Chart = y1VarName && y1VarName !== ""
        let hasY2Chart = y2VarName && y2VarName !== ""

        for (var i = 0; i < meteogramModel.count; i++) {
            updatePathElement(i, "temperature", temperaturePathItems)
            updatePathElement(i, "humidity", humidityPathItems)

            if (hasY1Chart) {
                updatePathElement(i, "y1Chart", y1PathItems)
                y1Count++
            }

            if (hasY2Chart) {
                updatePathElement(i, "y2Chart", y2PathItems)
                y2Count++
            }
        }

        temperaturePath.startY = temperaturePathItems[0].y
        temperaturePath.pathElements = temperaturePathItems.slice(0, meteogramModel.count)

        humidityPath.startY = humidityPathItems[0].y
        humidityPath.pathElements = humidityPathItems.slice(0, meteogramModel.count)

        y1Path.pathElements = y1PathItems.slice(0, y1Count)
        if (y1Count > 0) {
            y1Path.startY = y1PathItems[0].y
        }

        y2Path.pathElements = y2PathItems.slice(0, y2Count)
        if (y2Count > 0) {
            y2Path.startY = y2PathItems[0].y
        }
    }

    function buildCloudPath() {
        let count = 0
        for (var i = 0; i < meteogramModel.count; i++) {
            if (i >= cloudPathItems.length) {
                cloudPathItems.push(cloudPathLine.createObject(humidityPath, {
                    i: i,
                    isCloudTop: false
                }))
            } else {
                cloudPathItems[count].i = i
                cloudPathItems[count].isCloudTop = false
                cloudPathItems[count].iChanged()
                cloudPathItems[count].isCloudTopChanged()
            }

            count++
        }

        for (var i = meteogramModel.count - 1; i > -1; i--) {
            if (count >= cloudPathItems.length) {
                cloudPathItems.push(cloudPathLine.createObject(humidityPath, {
                    i: i,
                    isCloudTop: true
                }))
            } else {
                cloudPathItems[count].i = i
                cloudPathItems[count].isCloudTop = true
                cloudPathItems[count].iChanged()
                cloudPathItems[count].isCloudTopChanged()
            }

            count++
        }


        cloudAreaPath.pathElements = cloudPathItems.slice(0, count)
        if (count > 0) {
            cloudAreaPath.startY = cloudAreaPath.pathElements[count - 1].y
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

        // Pad the window size so the min/max value isn't on the edge of the graph area
        const coverageRatio = 0.80
        var roundedDv = ChartUtils.ceilBase(dV, 10)
        var prevRoundedDv = NaN
        while (dV / roundedDv > coverageRatio && roundedDv !== prevRoundedDv) {
            roundedDv = ChartUtils.ceilBase(roundedDv + 10, 10)
            prevRoundedDv = roundedDv
        }

        roundedDv = Math.max(minGridCount, roundedDv)
        roundedDv = ChartUtils.ceilBase(roundedDv, 10)

        minValue = Math.floor(mid - (roundedDv / 2))
        maxValue = minValue + roundedDv

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

        computeHourStep(root.hourStrWidth, root.rectWidth)

        xIndexScale.setDomain(0, meteogramModel.count - 1)
        timeScale.setDomain(startTime.getTime(), endTime.getTime())
        windSpeedArea.setModel(meteogramModel.count)
        horizontalLines1.setModel(temperatureYGridCount)
        hourGrid.setModel(startTime)
    }

    function computeHourStrWidth() {
        var context = root.context ? root.context : getContext("2d")
        if (!context) {
            return
        }
        hourStrWidth = 0
        let fontSize = 11 * 1
        context.font = fontSize + 'px "' + Kirigami.Theme.defaultFont.family + '"'
        let metrics = context.measureText("00")
        hourStrWidth += metrics.width

        fontSize = 7 * 1
        context.font = fontSize + 'px "' + Kirigami.Theme.defaultFont.family + '"'
        metrics = context.measureText("00")
        hourStrWidth += metrics.width

        // print("rectWidth ", rectWidth)
        // print("hourStrWidth ", hourStrWidth)
    }

    function computeHourStep(hourStrWidth, rectWidth) {
        hourStep = Math.ceil(meteogramCanvas.hourStrWidth / meteogramCanvas.rectWidth)
        if (hourStep <= 2) {
            hourStep = 2
        }
        if (hourStep <= 4) {
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
    }

    function fullRedraw() {
        if (!available) {
            return
        }

        processMeteogramData()
        buildMetogramData()

        computeFontSize()
        computeHourStrWidth()

        buildCurves()

        if (renderCloudCover) {
            buildCloudPath()
        }

        initialized = true
        backgroundCanvas.requestPaint()
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
