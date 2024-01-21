import QtQuick 2.5
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0


// Handles the case where the widget background is hidden. In this case
// Plasma uses dark mode text color on a light theme. In other words white text
// against light backgrounds. The PlasmaCore.Theme properties cannot be
// relied upon for distinguish the correct light or dark mode colors.
// This Item is a utility object intended to supply the correct light or dark
// mode.
Item {

    property bool isShowBackground: true

    property bool isLightMode: isShowBackground ?
                                    (((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5) :
                                    ((label.color.r + label.color.g + label.color.b) / 3) > 0.5

    property bool isMeteogramLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5

    property var textColor: isShowBackground ? theme.textColor : label.color
    property var disabledTextColor: isShowBackground ? theme.disabledTextColor :
                                                       disabledLabel.color

    property var themeTextColor: theme.textColor

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

        if (doReload) {
            main.reloadMeteogram()
        }
    }
}
