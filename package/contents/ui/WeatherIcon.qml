import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
// import QtGraphicalEffects 1.0
import Qt5Compat.GraphicalEffects
// import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

import "../code/icons.js" as IconTools


Loader {
    asynchronous: true
    visible: status == Loader.Ready

    property int iconSetType

    property var iconName
    property int partOfDay

    property double iconX: 0
    property double iconY: 0
    property double iconDim: NaN


    sourceComponent: (iconSetType === 0) ? iconLabelComponent :
                        ((iconSetType === 1 || iconSetType === 2) ? iconImageComponent :
                        ((iconSetType === 3) ? iconItemComponent : null))

    // Component.onCompleted: {
    //     print("WeatherIcon " + iconSetType + ", " + iconName + ", " + iconX + ", " + iconY + ", " + iconDim)
    // }

    Component {
        id: iconLabelComponent

        Label {
            id: textItem
            text: IconTools.getIconResource(iconName, currentProvider, iconSetType, partOfDay)
            font.family: 'weathericons'

            x: iconX
            y: iconY
            width: iconDim
            height: width

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 1024
            minimumPixelSize: 1
            fontSizeMode: Text.Fit
        }
    }

    Component {
        id: iconImageComponent
        Item {
            x: iconX ?? 0
            y: iconY ?? 0
            width: isFinite(iconDim) ? iconDim  : parent.width

            height: width

            property var imgSrc: IconTools.getIconResource(iconName,
                                                           currentProvider,
                                                           iconSetType,
                                                           partOfDay)

            Image {
                id: image
                source: imgSrc ?? "images/placeholder.svg"
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
                color: !main.theme?.isDarkMode ? "#80000000" : "#80ffffff"
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

            Kirigami.Icon {
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
                color: !main.theme?.isDarkMode ? "#80000000" : "#80ffffff"
                source: image
                visible: plasmoid.configuration.iconDropShadow
            }
        }
    }
}
