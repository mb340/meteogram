import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

RowLayout {
    id: root

    property var meteogram
    property var meteogramModel

    property var model: []
    property var callback: function(varName) { }

    property string selectedVarName: ""

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
                property bool isVarSelected: (selectedVarName === modelData.varName)

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
                onClicked: callback(modelData.varName)
                onEntered: varNameLabel.isHighlighted = true
                onExited: varNameLabel.isHighlighted = false
            }
        }
    }

    Repeater {
        model: root.model
        delegate: rightAxisButtonComponent
    }
}
