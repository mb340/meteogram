import QtQuick 2.2
import org.kde.plasma.plasmoid 2.0


Rectangle {
    anchors.fill: parent
    color: theme.highlightColor
    border.color: theme.textColor
    border.width: 1
    z: -1
    visible: plasmoid.configuration.debugLayoutBoundaries
}
