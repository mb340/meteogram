import QtQuick
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

import "../code/color.js" as ColorTools


// Handles the case where the widget background is hidden. In this case
// Plasma uses dark mode text color on a light theme. In other words white text
// against light backgrounds. The PlasmaCore.Theme properties cannot be
// relied upon for distinguish the correct light or dark mode colors.
// This Item is a utility object intended to supply the correct light or dark
// mode.
Item {
    id: root

    property bool isShowBackground: true

    property bool isDarkMode: (((Kirigami.Theme.textColor.r +
                                  Kirigami.Theme.textColor.g +
                                  Kirigami.Theme.textColor.b) / 3) > 0.5)

    property color textColor: Kirigami.Theme.textColor
    property color disabledTextColor: isShowBackground ? Kirigami.Theme.disabledTextColor :
                                                         Qt.rgba(Kirigami.Theme.disabledTextColor.r,
                                                                 Kirigami.Theme.disabledTextColor.g,
                                                                 Kirigami.Theme.disabledTextColor.b,
                                                                 0.50)
    property color highlightColor: Kirigami.Theme.highlightColor

    property color themeTextColor: systemPalette.text

    property alias meteogram: _meteogram


    // This event handles Plasma theme changes
    onThemeTextColorChanged: {
        update(true)
    }

    Connections {
        target: plasmoid

        // This event handles when the plasmoid show/hide background option changes
        function onEffectiveBackgroundHintsChanged() {
            update(true)
        }
    }

    SystemPalette {
        id: systemPalette

    }

    QtObject {
        id: _meteogram

        property bool isDarkMode: ((systemPalette.text.r +
                                     systemPalette.text.g +
                                     systemPalette.text.b) / 3) > 0.5


        property color textColor: !systemPalette ?  Kirigami.Theme.textColor :
                                                    systemPalette.text

        property color backgroundColor: !systemPalette ?  Kirigami.Theme.backgroundColor :
                                                          systemPalette.window
        property color highlightColor: Kirigami.Theme.highlightColor

    }

    Component.onCompleted: update(false)

    function update(doReload) {

        if (Plasmoid.effectiveBackgroundHints & PlasmaCore.Types.ShadowBackground) {
            isShowBackground = false
        } else {
            isShowBackground = true
        }

        let bgColor = isDarkMode ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
        let contrast = isDarkMode ? 3 : 10
        highlightColor = ColorTools.getContrastingColor(Kirigami.Theme.highlightColor, bgColor, contrast)

        bgColor = meteogram.isDarkMode ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
        contrast = meteogram.isDarkMode ? 3 : 10
        meteogram.highlightColor = ColorTools.getContrastingColor(Kirigami.Theme.highlightColor, bgColor, contrast)

        if (doReload) {
            main.reloadMeteogram()
        }
    }
}
