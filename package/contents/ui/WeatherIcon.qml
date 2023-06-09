import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
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
            width: iconDim
            height: width

            Label {
                id: textItem
                text: IconTools.getIconResource(iconName, currentProvider, iconSetType, partOfDay)
                font.family: 'weathericons'

                width: parent.width
                height: parent.height

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 1024
                minimumPixelSize: 1
                fontSizeMode: Text.Fit
            }
        }
    }

    Component {
        id: iconImageComponent
        Item {
            x: iconX ? iconX : 0
            y: iconY ? iconY : 0
            width: isFinite(iconDim) ? iconDim  : parent.width

            height: width

            property var imgSrc: IconTools.getIconResource(iconName,
                                                           currentProvider,
                                                           iconSetType,
                                                           partOfDay)

            Image {
                id: image
                source: imgSrc ? imgSrc : "images/placeholder.svg"
                smooth: true
                asynchronous: true
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
                visible: plasmoid.configuration.iconDropShadow
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
                visible: plasmoid.configuration.iconDropShadow
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
}
