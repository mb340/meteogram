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

    // Component.onCompleted: {
    //     print("WeatherIcon " + iconSetType + ", " + iconName + ", " + iconX + ", " + iconY + ", " + iconDim)
    // }

    Component {
        id: iconLabelComponent

        Item {
            x: iconX
            y: iconY
            width: isFinite(iconDim) ? adjustDim(iconDim)  : parent.width
            height: width

            PlasmaComponents.Label {
                text: IconTools.getIconResource(iconName, currentProvider,
                                                iconSetType, partOfDay)

                // Re-usable components need a custom icon to avoid the same
                // font size for ever instance of the component.
                font: Qt.font({
                        pixelSize: Math.max(1, parent.width),
                        family: 'weathericons',
                })

                anchors.centerIn: parent
            }
        }
    }

    Component {
        id: iconImageComponent
        Item {
            x: iconX
            y: iconY
            width: isFinite(iconDim) ? adjustDim(iconDim)  : parent.width
            height: width

            property var imgSrc: IconTools.getIconResource(iconName,
                                                           currentProvider,
                                                           iconSetType,
                                                           partOfDay)

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

            width: isFinite(iconDim) ? adjustDim(iconDim) : parent.width
            height: width

            PlasmaCore.IconItem {
                id: image
                source: IconTools.getIconResource(iconName,
                                                  currentProvider,
                                                  iconSetType,
                                                  partOfDay)

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

        // anchors.fill: parent

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

    // Empirically determined size adjustements
    function adjustDim(dim) {
        if (iconSetType === 0) {
            return dim * 0.75
        }
        if (iconSetType === 1) {
            return dim * (1.75 / 2.0)
        }
        if (iconSetType === 2) {
            return dim * (2.5 / 2.0)
        }
        if (iconSetType === 3) {
            return 1.00 * dim
        }
        return dim
    }
}
