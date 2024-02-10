import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami
import "../code/icons.js" as IconTools
import "data_models"
import "utils"


Item {
    id: root

    required property int hourStep
    required property double rectWidth

    required property var timeScale

    signal modelsChanged()

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
            if (meteogramModel.hourInterval === 1 && (t.getHours()) % hourStep !== 0) {
                continue
            }

            windSpeedModel.addItem({
                index: i
            })
        }
        windSpeedModel.endList()
        modelsChanged()
    }

    Repeater {
        id: windSpeedRepeater
        model: fillModels ? windSpeedModel.model : []
        delegate: windIconDelegate

        property double rectWidth: hourStep * rectWidth
        property double xOffset: (windSpeedRepeater.rectWidth / 2)
        property int iconSetType: plasmoid.configuration.windIconSetType

        Component {
            id: windIconDelegate

            Item {
                id: windspeedAnchor
                width: windSpeedRepeater.rectWidth
                x: !item ? 0 : timeScale.translate(item.from.getTime()) - windSpeedRepeater.xOffset
                y: 0

                anchors.verticalCenter: parent.verticalCenter

                property var item: meteogramModel.get(model.index)

                Component.onCompleted: {
                    root.modelsChanged.connect(itemChanged)
                }

                Image {
                    id: wind
                    source: !item || isNaN(item.windSpeed) ? "" :
                                windStrength(item.windSpeed, windSpeedRepeater.iconSetType)
                    fillMode: Image.PreserveAspectFit

                    width: height
                    height: (windSpeedRepeater.iconSetType ==
                                IconTools.WindIconSetType.QULLE) ?
                                root.height - Kirigami.Units.smallSpacing : labelHeight
                    anchors.centerIn: parent

                    visible: false

                    asynchronous: true
                }

                ColorOverlay {
                    anchors.fill: wind
                    source: wind
                    rotation: windFrom(item?.windDirection ?? 0,
                                       windSpeedRepeater.iconSetType)
                    color: main.theme.disabledTextColor
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
