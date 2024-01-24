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
            Layout.fillHeight: true

            Layout.leftMargin: 1
            Layout.rightMargin: 1

            ToolTip.text: modelData.tooltip
            ToolTip.visible: mouseArea.containsMouse

            Label {
                id: varNameLabel
                height: parent.height
                text: modelData.label
                color: main.colors.isShowBackground ?
                            (enabled ?
                                main.colors.textColor :
                                main.colors.disabledTextColor) :
                            main.colors.textColor

                opacity: main.colors.isShowBackground ? 1.0 :
                            (varNameLabel.isVarSelected ? 1.0 : 0.60)

                font.family: 'weathericons'
                enabled: (isVarSelected && hasVariable)

                property bool isHighlighted: false
                property bool isSelected: modelData.isSelected !== undefined ?
                                            modelData.isSelected : false

                property bool isVarSelected: radioButtonMode ?
                                                (selectedVarName === modelData.varName) :
                                                isSelected

                property bool hasVariable: modelData.hasVariable !== undefined ? modelData.hasVariable :
                                            meteogramModel.hasVariable(modelData.varName)

                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: main.colors.highlightColor
                    antialiasing: true
                    visible: varNameLabel.isHighlighted
                }

                Image {
                    id: notAvailable
                    source: "images/not-allowed.svg"
                    smooth: true
                    visible: false

                    width: parent.height * 0.8
                    height: width
                    sourceSize.width: width
                    sourceSize.height: width

                    anchors.centerIn: varNameLabel
                }

                ColorOverlay {
                    anchors.fill: notAvailable
                    source: notAvailable
                    color: main.colors.isShowBackground ?
                                ((visible && varNameLabel.isVarSelected) ?
                                    main.colors.textColor :
                                    main.colors.disabledTextColor)
                                :
                                main.colors.textColor
                    opacity: main.colors.isShowBackground ? 1.0 :
                                (varNameLabel.isVarSelected ? 1.0 : 0.60)
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
