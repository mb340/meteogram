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
    visible: true
    width: imageWidth
    height: imageHeight + labelHeight// Day Label + Time Label

    property int imageWidth: 800 * units.devicePixelRatio - (labelWidth * 2)
    property int imageHeight: 320 * units.devicePixelRatio  - labelHeight - cloudarea - windarea
    property int labelWidth: textMetrics.width
    property int labelHeight: textMetrics.height

    property int cloudarea: 0
    property int windarea: 28

        property bool meteogramModelChanged: main.meteogramModelChanged


    readonly property int minTemperatureYGridCount: 20
    readonly property int minPressureYGridCount: 30
    property double temperatureYGridStep: 1.0
    property int temperatureYGridCount: minTemperatureYGridCount   // Number of vertical grid Temperature elements

    // Decimal places for pressure y-axis labels
    property int pressureDecimals: 0

    readonly property double precipitationMinVisible: 0.05

    property int dataArraySize: 2

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5
    property color gridColor: textColorLight ? Qt.tint(theme.textColor, '#80000000') : Qt.tint(theme.textColor, '#80FFFFFF')
    property color gridColorHighlight: textColorLight ? Qt.tint(theme.textColor, '#50000000') : Qt.tint(theme.textColor, '#50FFFFFF')
    property color pressureColor: textColorLight ? Qt.rgba(0.3, 1, 0.3, 1) : Qt.rgba(0.0, 0.6, 0.0, 1)
    property color temperatureWarmColor: textColorLight ? Qt.rgba(1, 0.3, 0.3, 1) : Qt.rgba(1, 0.0, 0.0, 1)
    property color temperatureColdColor: textColorLight ? Qt.rgba(0.2, 0.7, 1, 1) : Qt.rgba(0.1, 0.5, 1, 1)
    property color rainColor: textColorLight ? Qt.rgba(0.33, 0.66, 1, 1) : Qt.rgba(0, 0.33, 1, 1)


    property int precipitationFontPixelSize: 8 * units.devicePixelRatio
    property int precipitationHeightMultiplier: 15 * units.devicePixelRatio
    property int precipitationLabelMargin: 8 * units.devicePixelRatio

/*
    property int temperatureType: 0
    property int pressureType: 0
    property int timezoneType: 0
    property bool twelveHourClockEnabled: false
    property int windSpeedType: 0
*/
    property double sampleWidth: imageWidth / (meteogramModel.count - 1)

    onMeteogramModelChangedChanged: {
        dbgprint('meteogram changed')
        buildMetogramData()
        processMeteogramData()
        buildCurves()
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
        color: "transparent"
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
                color: pressureColor
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
        color: pressureColor
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
            property bool isLastHour: index === hourGridModel.count-1
            property bool textVisible: hourVisible && index < hourGridModel.count-1
            property int timePeriod: hourFrom >= 6 && hourFrom <= 18 ? 0 : 1


            property double precAvg: parseFloat(precipitationAvg) || 0
            property double precMax: parseFloat(precipitationMax) || 0

            property bool precLabelVisible: precAvg >= precipitationMinVisible ||
                                            precMax >= precipitationMinVisible

            property string precAvgStr: precipitationFormat(precAvg, precipitationLabel)
            property string precMaxStr: precipitationFormat(precMax, precipitationLabel)



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
            function precipitationFormat(precFloat, precipitationLabel) {
                if (precipitationLabel === i18n('%')) {
                    return (precFloat * 100).toFixed(0)
                }
                if (precFloat >= precipitationMinVisible) {
                    var result = Math.round(precFloat * 10) / 10
                    return result.toFixed(1)
                }
                return ''
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
            Rectangle {
                id: precipitationMaxRect
                width: parent.width
                height: (precMax < precAvg ? precAvg : precMax) * precipitationHeightMultiplier
                color: rainColor
                anchors.left: verticalLine.left
                anchors.bottom: verticalLine.bottom
                visible: !isLastHour
            }
            PlasmaComponents.Label {
                width: parent.width
                text: precMaxStr || precAvgStr
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                anchors.bottom: precipitationUnitVisible ? precLabel.top : precipitationMaxRect.top
                anchors.horizontalCenter: precipitationMaxRect.horizontalCenter
                font.pixelSize: precipitationFontPixelSize
                font.pointSize: -1
                visible: precLabelVisible && !isLastHour
            }
            PlasmaComponents.Label {
                function localisePrecipitationUnit(unitText) {
                    switch (unitText) {
                    case "mm":
                        return i18n("mm")
                    case "cm":
                        return i18n("cm")
                    case "in":
                        return i18n("in")
                    default:
                        return unitText
                    }
                }
                id: precLabel
                text: localisePrecipitationUnit(precipitationLabel)
                width: parent.width
                height: precipitationFontPixelSize
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                anchors.left: verticalLine.left
                anchors.bottom: precipitationMaxRect.top
                //                anchors.bottom: verticalLine.bottom
                //                anchors.horizontalCenter: precipitationMaxRect.horizontalCenter
                font.pixelSize: precipitationFontPixelSize - 1
                font.pointSize: -1
                visible: precLabelVisible && precipitationUnitVisible && !isLastHour
            }
            PlasmaComponents.Label {
                font.pixelSize: 14 * units.devicePixelRatio
                font.pointSize: -1
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: temperatureScale.translate(UnitUtils.convertTemperature(temperature, temperatureType)) - (font.pixelSize * 2.5)
                anchors.left: verticalLine.left
                anchors.leftMargin: -8
                z: 999
                font.family: 'weathericons'
                text: (differenceHours === 1 && textVisible) || index === hourGridModel.count-1 || index === 0 || iconName === '' ? '' : IconTools.getIconCode(iconName, currentProvider.providerId, timePeriod)
                visible: iconName != "\uf07b"
            }
            /*
            Item {
                visible: canShowPrec
//                anchors.fill: parent
                anchors.bottom: verticalLine.bottom



                Rectangle {
                    id: precipitationAvgRect
                    width: parent.width
                    height: precAvg * precipitationHeightMultiplier
                    color: theme.highlightColor
                    anchors.left: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: precipitationLabelMargin
                }

                PlasmaComponents.Label {
                    function localisePrecipitationUnit(unitText) {
                        switch (unitText) {
                        case "mm":
                            return i18n("mm")
                        case "cm":
                            return i18n("cm")
                        case "in":
                            return i18n("in")
                        default:
                            return unitText
                        }
                    }
                    text: localisePrecipitationUnit(precipitationLabel)
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: parent.bottom
                    anchors.topMargin: -precipitationLabelMargin
                    anchors.horizontalCenter: precipitationAvgRect.horizontalCenter
                    font.pixelSize: precipitationFontPixelSize
                    font.pointSize: -1
                    visible: precLabelVisible
                }
        }
*/

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

        Canvas {
            id: meteogramCanvas
            anchors.fill: parent
            contextType: '2d'

            Path {
                id: pressurePath
                startX: 0
            }
            Path {
                id: temperaturePathWarm
                startX: 0
            }

            Path {
                id: temperaturePathCold
                startX: 0
            }

            onPaint: {
                var context = getContext("2d")
                context.clearRect(0, 0, width, height)

                context.save()
                context.beginPath()
                context.strokeStyle = pressureColor
                context.lineWidth = 1 * units.devicePixelRatio;
                context.path = pressurePath
                context.stroke()
                context.restore()

                context.save()
                context.beginPath()
                context.strokeStyle = 'transparent'
                context.lineWidth = 0
                context.rect(0, 0, width, temperatureScale.translate(0));
                context.closePath()
                context.stroke();
                context.clip();
                context.save()
                    context.beginPath();
                    context.strokeStyle = temperatureWarmColor
                    context.lineWidth = 2 * units.devicePixelRatio;
                    context.path = temperaturePathWarm
                    context.stroke()
                context.restore()
                context.restore()

                context.save()
                context.beginPath()
                context.strokeStyle = 'transparent'
                context.lineWidth = 0
                context.rect(0, temperatureScale.translate(0), width, height);
                context.closePath()
                context.stroke();
                context.clip();
                context.save()
                    context.beginPath();
                    context.strokeStyle = temperatureColdColor
                    context.lineWidth = 2 * units.devicePixelRatio;
                    context.path = temperaturePathCold
                    context.stroke()
                context.restore()
                context.restore()
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

            for (var j = 0; j < differenceHours; j++) {
                counter = (prec >= precipitationMinVisible) ? counter + 1 : 0
                var preparedDate = new Date(dateFrom.getTime() + (j * oneHourMs))

                hourGridModel.append({
                                      dateFrom: UnitUtils.convertDate(preparedDate, timezoneType),
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
                                      differenceHours: differenceHours
                                  })
            }
            i++
        }
        for (i = Math.max(0, hourGridModel.count - 5); i < hourGridModel.count; i++) {
            hourGridModel.setProperty(i, 'canShowDay', false)
        }
    }

    function buildCurves() {
        var newPathElements = []
        var newPressureElements = []

        if (meteogramModel.count === 0) {
            return
        }
        for (var i = 0; i < meteogramModel.count; i++) {
            var dataObj = meteogramModel.get(i)

            var temperatureY = temperatureScale.translate(UnitUtils.convertTemperature(dataObj.temperature, temperatureType))
            var pressureY = pressureScale.translate(UnitUtils.convertPressure(dataObj.pressureHpa, pressureType))
            if (i === 0) {
                temperaturePathWarm.startY = temperatureY
                temperaturePathCold.startY = temperatureY
                pressurePath.startY = pressureY
            }
            newPathElements.push(Qt.createQmlObject('import QtQuick 2.0; PathCurve { x: ' + (i * sampleWidth) + '; y: ' + temperatureY + ' }', graphArea, "dynamicTemperature" + i))
            newPressureElements.push(Qt.createQmlObject('import QtQuick 2.0; PathCurve { x: ' + (i * sampleWidth) + '; y: ' + pressureY + ' }', graphArea, "dynamicPressure" + i))
        }
        temperaturePathWarm.pathElements = newPathElements
        temperaturePathCold.pathElements = newPathElements
        pressurePath.pathElements = newPressureElements
        repaintCanvas()
    }

    function processMeteogramData() {
        dataArraySize = meteogramModel.count

        if (dataArraySize === 0) {
            dbgprint('model is empty -> clearing canvas and exiting')
            clearCanvas()
            return
        }

        var minValue = +Infinity
        var maxValue = -Infinity
        var minPressure = +Infinity
        var maxPressure = -Infinity

        for (var i = 0; i < dataArraySize; i++) {
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
