import QtQuick 2.5
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import "../code/icons.js" as IconTools
import "data_models"
import "utils"


Item {

    ManagedListModel {
        id: windSpeedModel
    }

    function setModel(count) {
        windSpeedModel.beginList()
        for (var i = 0; i < count; i++) {
            let item = meteogramModel.get(i)
            if (!item || !isFinite(item.windSpeed)) {
                continue
            }

            let t = item.from
            if (meteogramModel.hourInterval === 1 && (t.getHours()) % meteogramCanvas.hourStep !== 0) {
                continue
            }

            windSpeedModel.addItem({
                index: i
            })
        }
        windSpeedModel.endList()
    }

    Repeater {
        id: windSpeedRepeater
        model: fillModels ? windSpeedModel.model : []
        delegate: windIconDelegate

        property double rectWidth: meteogramCanvas.hourStep * (meteogramCanvas.rectWidth)
        property double xOffset: (windSpeedRepeater.rectWidth / 2)
        property int iconSetType: plasmoid.configuration.windIconSetType

        Component {
            id: windIconDelegate

            Item {
                id: windspeedAnchor
                width: windSpeedRepeater.rectWidth
                height: labelHeight
                x: !item ? 0 : timeScale.translate(item.from.getTime()) - windSpeedRepeater.xOffset
                y: 0

                anchors.verticalCenter: parent.verticalCenter

                property QtObject item: meteogramModel.get(model.index)

                Image {
                    id: wind
                    source: !item || isNaN(item.windSpeed) ? "" :
                                windStrength(item.windSpeed, windSpeedRepeater.iconSetType)
                    fillMode: Image.PreserveAspectFit

                    width: height
                    height: (windSpeedRepeater.iconSetType ==
                                IconTools.WindIconSetType.QULLE) ?
                                windarea : labelHeight
                    anchors.centerIn: parent

                    visible: false

                    asynchronous: true
                }

                ColorOverlay {
                    anchors.fill: wind
                    source: wind
                    rotation: windFrom(!item ? 0 : item.windDirection,
                                        windSpeedRepeater.iconSetType)
                    color: main.colors.isShowBackground ?
                                main.colors.disabledTextColor :
                                main.colors.textColor
                    opacity: main.colors.isShowBackground ? 1.0 : 0.60
                    antialiasing: true
                    visible: true
                }

                function windFrom(rotation, iconSetType) {
                    rotation = IconTools.translateWindDirection(rotation, iconSetType)

                    rotation = (Math.round( rotation / 22.5 ) * 22.5)
                    rotation = (rotation >= 180) ? rotation - 180 : rotation + 180
                    return rotation
                }
                function windStrength(windspeed, iconSetType) {
                    windspeed = unitUtils.convertWindspeed(windspeed,
                                            UnitUtils.WindSpeedType.KNOTS)
                    return IconTools.getWindSpeedIconResource(windspeed, iconSetType)
                }
            }
        }
    }
}
