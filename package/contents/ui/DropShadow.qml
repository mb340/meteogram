import QtQuick
import QtQuick.Effects

Loader {
    sourceComponent: show ? dropShadowComponent : undefined

    property bool show: plasmoid.configuration.iconDropShadow

    Component {
        id: dropShadowComponent
        MultiEffect {
            source: image

            colorization: 1.0
            colorizationColor: !main.theme?.isDarkMode ? "#80000000" : "#80ffffff"

            scale: 1.1
            opacity: !main.theme?.isDarkMode ? 0.25 : 1.0

            // blurEnabled: true
            // blur: 0.1
            // blurMax: 4
        }
    }
}
