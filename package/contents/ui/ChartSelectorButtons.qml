import QtQuick 2.2
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

RowLayout {
    id: root

    property var meteogram
    property var meteogramModel

    property var model: []
    property var callback: function(varName) { }

    property string selectedVarName: ""
    property bool radioButtonMode: true

    Component {
        id: rightAxisButtonComponent

        Item {
            width: childrenRect.width
            height: childrenRect.height

            Layout.leftMargin: 1
            Layout.rightMargin: 1

            ToolTip.text: modelData.tooltip
            ToolTip.visible: mouseArea.containsMouse

            Label {
                id: varNameLabel
                text: modelData.label
                font.family: 'weathericons'
                color: textColor

                property bool isHighlighted: false
                property bool isSelected: modelData.isSelected !== undefined ?
                                            modelData.isSelected : false

                property bool isVarSelected: radioButtonMode ?
                                                (selectedVarName === modelData.varName) :
                                                isSelected

                property bool hasVariable: modelData.hasVariable !== undefined ? modelData.hasVariable :
                                            meteogramModel.hasVariable(modelData.varName)

                property var textColor: isHighlighted ? theme.highlightColor :
                                        ((isVarSelected && hasVariable) ? theme.textColor :
                                                         PlasmaCore.Theme.disabledTextColor)

                Image {
                    id: notAvailable
                    source: "images/not-allowed.svg"
                    smooth: true
                    visible: false

                    width: parent.height
                    height: width
                    sourceSize.width: width
                    sourceSize.height: width

                    anchors.centerIn: varNameLabel
                }

                ColorOverlay{
                    anchors.fill: notAvailable
                    source: notAvailable
                    color: (visible && varNameLabel.isVarSelected) ?
                                theme.textColor : PlasmaCore.Theme.disabledTextColor
                    antialiasing: true
                    visible: !varNameLabel.hasVariable
                }
            }


            MouseArea {
                id: mouseArea
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                anchors.fill: parent
                onClicked: callback(modelData, varNameLabel)
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
