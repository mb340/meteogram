import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "data_models"


Item {

    ManagedListModel {
        id: horizontalLinesModel
    }

    function setModel(count, gridStep, maxTemperature) {
        horizontalLinesModel.beginList()
        for (var i = 0; i <= count; i++) {
            if (i % gridStep !== 0) {
                continue
            }
            horizontalLinesModel.addItem({
                index: i,
                temperature: maxTemperature - i
            })
        }
        horizontalLinesModel.endList()
    }

    Repeater {
        id: horizontalLinesRepeater
        model: fillModels ? horizontalLinesModel.model : []

        delegate: Item {
            height: 0
            width: meteogramCanvas.width

            x: 0
            y: temperatureScale.translate(temperature)

            Rectangle {
                id: gridLine
                color: gridColor

                width: parent.width
                height: 1 * 1

                visible: true
            }
            Label {
                text: temperature.toFixed(0)
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                font.pointSize: -1
                horizontalAlignment: Text.AlignRight

                height: labelHeight
                width: labelWidth
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: -labelWidth - 2
                anchors.topMargin: -labelHeight / 2
            }
            Label {
                text: rightGridScale.invert(index).toFixed(rightAxisDecimals)
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                font.pointSize: -1
                horizontalAlignment: Text.AlignLeft

                color: colorPalette.pressureColor(main.theme.isDarkMode)

                height: labelHeight
                width: labelWidth
                anchors.top: parent.top
                anchors.topMargin: -labelHeight / 2
                anchors.left: parent.right
                anchors.leftMargin: 2

                visible: y2AxisVisble
            }
        }

    }
}
