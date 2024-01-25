import QtQuick 2.5
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import "../code/color.js" as ColorTools


// Handles the case where the widget background is hidden. In this case
// Plasma uses dark mode text color on a light theme. In other words white text
// against light backgrounds. The PlasmaCore.Theme properties cannot be
// relied upon for distinguish the correct light or dark mode colors.
// This Item is a utility object intended to supply the correct light or dark
// mode.
Item {

    property bool isShowBackground: true

    property bool isLightMode: isShowBackground ?
                                    (((theme.textColor.r +
                                       theme.textColor.g +
                                       theme.textColor.b) / 3) > 0.5) :
                                    ((label.color.r +
                                      label.color.g +
                                      label.color.b) / 3) > 0.5

    property color textColor: isShowBackground ? theme.textColor : label.color
    property color disabledTextColor: isShowBackground ? theme.disabledTextColor :
                                                         disabledLabel.color

    property color highlightColor: theme.highlightColor

    property color themeTextColor: theme.textColor

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

    QtObject {
        id: _meteogram

        property bool isLightMode: ((theme.textColor.r +
                                     theme.textColor.g +
                                     theme.textColor.b) / 3) > 0.5

        property color textColor: theme.textColor
        property color disabledTextColor: theme.disabledTextColor
        property color highlightColor: theme.highlightColor
    }

    Label {
        id: label
        text: ""
        visible: false

        onColorChanged: update(true)
    }

    Label {
        id: disabledLabel
        text: ""
        width: 0
        height: 0
        visible: false
        enabled: false
    }

    Component.onCompleted: update(false)

    function update(doReload) {

        if (Plasmoid.effectiveBackgroundHints & PlasmaCore.Types.ShadowBackground) {
            isShowBackground = false
        } else {
            isShowBackground = true
        }

        let bgColor = isLightMode ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
        let contrast = isLightMode ? 3 : 10
        highlightColor = ColorTools.getContrastingColor(theme.highlightColor, bgColor, contrast)

        bgColor = _meteogram.isLightMode ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
        contrast = _meteogram.isLightMode ? 3 : 10
        _meteogram.highlightColor = ColorTools.getContrastingColor(theme.highlightColor, bgColor, contrast)

        if (doReload) {
            main.reloadMeteogram()
        }
    }
}
