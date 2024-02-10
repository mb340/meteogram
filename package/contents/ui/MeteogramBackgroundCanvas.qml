import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0


Canvas {
    id: backgroundCanvas

    required property var colors

    required property var currentWeatherModel
    required property var meteogramModel
    required property var scale

    property real shadeFactor: plasmoid.configuration.lightModeShadeFactor / 100
    property real darkShadeFactor: plasmoid.configuration.darkModeShadeFactor / 100

    property color bgColor: (plasmoid.configuration.renderSunsetShade &&
                                colors.meteogram.isDarkMode) ?
                                    Qt.rgba(shadeColor.r + darkShadeFactor,
                                            shadeColor.g + darkShadeFactor,
                                            shadeColor.b + darkShadeFactor,
                                            shadeColor.a) :
                                    colorPalette.backgroundColor()

    property color shadeColor: colors.meteogram.isDarkMode ?
                                colorPalette.backgroundColor() :
                                Qt.darker(bgColor, 1.0 + shadeFactor)

    property bool renderSunsetShade: plasmoid.configuration.renderSunsetShade


    onRenderSunsetShadeChanged: requestPaint()

    onShadeFactorChanged: {
        if (!colors || !colors.meteogram) {
            return
        }
        if (!colors.meteogram.isDarkMode) {
            requestPaint()
        }
    }

    onDarkShadeFactorChanged: {
        if (!colors || !colors.meteogram) {
            return
        }
        if (colors.meteogram.isDarkMode) {
            requestPaint()
        }
    }

    onPaint: {
        let context = getContext("2d")
        context.clearRect(0, 0, width, height)

        context.fillStyle = bgColor
        context.fillRect(0, 0, width, height)

        if (meteogramModel.count <= 0) {
            return
        }

        if (!plasmoid.configuration.renderSunsetShade) {
            return
        }

        let sunRise = currentWeatherModel.sunRise
        let sunSet = currentWeatherModel.sunSet

        let itemFirst = meteogramModel.get(0)
        let from = itemFirst.from

        let initialStep = 0
        if (from.getHours() <= sunRise.getHours()) {
            // Handle case where sunset was the previous day
            initialStep = -1
        }

        let currSet = new Date(from)
        currSet.setDate(from.getDate() + initialStep)
        currSet.setHours(sunSet.getHours(),
                         sunSet.getMinutes(),
                         sunSet.getSeconds())

        let currRise = new Date(from)
        currRise.setDate(from.getDate() + initialStep + 1)
        currRise.setHours(sunRise.getHours(),
                          sunRise.getMinutes(),
                          sunRise.getSeconds())

        let xInitial = scale.translate(currSet)

        context.fillStyle = shadeColor

        while (true) {
            let x0 = scale.translate(currSet)
            let x1 = scale.translate(currRise)

            let w = x1 - x0
            context.fillRect(x0, 0, w, height)

            if (x1 - xInitial >= width) {
                break
            }

            currRise.setDate(currRise.getDate() + 1)
            currSet.setDate(currSet.getDate() + 1)
        }

    }
}
