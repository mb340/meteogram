import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

import "../code/icons.js" as IconTools


Item {
    id: root

    property int iconSetType

    property var iconName
    property int partOfDay

    property double iconX: 0
    property double iconY: 0
    property double iconDim: NaN

    property bool centerInParent: false

    Component {
        id: iconLabelComponent

        PlasmaComponents.Label {
            x: iconX
            y: iconY

            font.pointSize: -1
            font.pixelSize: pixelFontSize > 0 ? pixelFontSize : undefined

            font.family: 'weathericons'
            text: hidden ? '' : IconTools.getIconCode(iconName, currentProvider.providerId, partOfDay)
        }
    }

    Component {
        id: iconImageComponent
        Item {
            x: iconX
            y: iconY
            width: isFinite(iconDim) ? iconDim : parent.width
            height: width

            property var imgSrc: (iconSetType === 1 ?
                                    IconTools.getMetNoIconImage(iconName, currentProvider.providerId, partOfDay) :
                                    (iconSetType === 2 ?
                                        IconTools.getBasmiliusIconImage(iconName, currentProvider.providerId, partOfDay) :
                                        null))

            Image {
                id: image
                source: imgSrc ? imgSrc : "images/placeholder.svg"
                smooth: true
                anchors.fill: parent
            }

            DropShadow {
                anchors.fill: image
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 17
                color: !textColorLight ? "#80000000" : "#80ffffff"
                source: image
            }
        }
    }

    Component {
        id: iconItemComponent

        Item {
            x: iconX
            y: iconY

            width: isFinite(iconDim) ? iconDim : parent.width
            height: width

            PlasmaCore.IconItem {
                id: image
                source: IconTools.getBreezeIcon(iconName, currentProvider.providerId, partOfDay)
                anchors.fill: parent
            }

            DropShadow {
                anchors.fill: image
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 17
                color: !textColorLight ? "#80000000" : "#80ffffff"
                source: image
            }
        }
    }

    Loader {
        asynchronous: true
        visible: status == Loader.Ready

        anchors.centerIn: centerInParent ? parent : null

        sourceComponent: {
            if (iconSetType === 0) {
                return iconLabelComponent
            }
            if (iconSetType === 1 || iconSetType === 2) {
                return iconImageComponent
            }
            if (iconSetType === 3) {
                return iconItemComponent
            }
            return null
        }
    }
}
