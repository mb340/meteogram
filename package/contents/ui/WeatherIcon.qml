import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

import "../code/icons.js" as IconTools


Item {
    id: root

    property int iconSetType


    property var iconModel: ({
        iconName: "",
        partOfDay: 0,
        iconX: 0,
        iconY: 0,
        iconDim: 0,
    })

    property bool centerInParent: false

    // Component.onCompleted: {
    //     print("WeatherIcon " + iconSetType + ", " + iconName + ", " + iconX + ", " + iconY + ", " + iconDim)
    // }

    Component {
        id: iconLabelComponent

        Item {
            x: iconModel.iconX
            y: iconModel.iconY
            width: isFinite(iconModel.iconDim) ? adjustDim(iconModel.iconDim)  : parent.width
            height: width

            PlasmaComponents.Label {
                id: textItem
                text: IconTools.getIconResource(iconModel.iconName, currentProvider,
                                                iconSetType, iconModel.partOfDay)

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
            x: iconModel.iconX ? iconModel.iconX : 0
            y: iconModel.iconY ? iconModel.iconY : 0
            width: isFinite(iconModel.iconDim) ? adjustDim(iconModel.iconDim)  : parent.width
            height: width

            property var imgSrc: IconTools.getIconResource(iconModel.iconName,
                                                           currentProvider,
                                                           iconSetType,
                                                           iconModel.partOfDay)

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
            x: iconModel.iconX
            y: iconModel.iconY

            width: isFinite(iconModel.iconDim) ? adjustDim(iconModel.iconDim) : parent.width
            height: width

            PlasmaCore.IconItem {
                id: image
                source: IconTools.getIconResource(iconModel.iconName,
                                                  currentProvider,
                                                  iconSetType,
                                                  iconModel.partOfDay)

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
