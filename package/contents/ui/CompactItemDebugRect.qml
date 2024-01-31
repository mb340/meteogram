import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami


Rectangle {
    anchors.fill: parent
    color: Kirigami.Theme.highlightColor
    border.color: Kirigami.Theme.textColor
    border.width: 1
    z: -1
    visible: plasmoid.configuration.debugLayoutBoundaries
}
