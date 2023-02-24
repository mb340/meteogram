import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

RowLayout {

    property var meteogram
    property var meteogramModel

    Component {
        id: rightAxisButtonComponent

        Item {
            width: childrenRect.width
            height: childrenRect.height

            ToolTip.text: modelData.tooltip
            ToolTip.visible: mouseArea.containsMouse

            Label {
                id: varNameLabel
                text: modelData.label
                font.family: 'weathericons'
                color: textColor

                property bool isHighlighted: false
                property bool isVarSelected: (meteogram.y2VarName === modelData.varName)

                property bool hasVariable: !meteogramModel.hasVariable(modelData.varName)
                property var textColor: isHighlighted ? theme.highlightColor :
                                        (isVarSelected ? theme.textColor :
                                                         PlasmaCore.Theme.disabledTextColor)
            }

            Label {
                text: "\u2715"
                color: varNameLabel.textColor
                visible: varNameLabel.hasVariable
                anchors.fill: parent
            }

            MouseArea {
                id: mouseArea
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    if (meteogram.y2VarName === modelData.varName) {
                        meteogram.y2VarName = ""
                    } else {
                        meteogram.y2VarName = modelData.varName
                    }
                }
                onEntered: varNameLabel.isHighlighted = true
                onExited: varNameLabel.isHighlighted = false
            }
        }
    }

    Repeater {
        model: [
            { label: "\uf079", varName: "pressure", tooltip: i18n("Pressure") },
            { label: "\uf050", varName: "windSpeed", tooltip: i18n("Wind Speed") },
            { label: "\uf0cc", varName: "windGust", tooltip: i18n("Wind Gust") },
            { label: "\uf084", varName: "precipitationProb", tooltip: i18n("POP") },
            { label: "\uf00d", varName: "uvi", tooltip: i18n("UV Index") },
        ]

        delegate: rightAxisButtonComponent
    }
}
