/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
// import QtGraphicalEffects 1.0
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami


Item {
    id: textContainer

    width: sizerLabel.width
    height: sizerLabel.height

    property string debugName: "CompactItemText"

    property int sizeMode: CompactItem.SizeMode.Fill

    property string sizerText: ""
    property string actualText: ""

    property double parentWidth
    property double parentHeight

    property double sizerWidth
    property double sizerHeight

    property bool isHeightSizer: false
    property bool isWidthSizer: false

    property bool showDropShadow

    property font font: Qt.font({
        family: theme.defaultFont.family,
        pointSize: 1024,
    })

    property alias innerLabel: innerLabel

    // property alias font: sizerLabel.font
    property alias fontSizeMode: sizerLabel.fontSizeMode
    property alias horizontalAlignment: sizerLabel.horizontalAlignment
    property alias verticalAlignment: sizerLabel.verticalAlignment


    property alias contentWidth: sizerLabel.contentWidth
    property alias contentHeight: sizerLabel.contentHeight

    onStateChanged: {
        dbgprint(debugName, " onStateChanged", state)
    }

    Label {
        id: sizerLabel
        text: sizerText

        color: Qt.rgba(0, 1, 0, 1)
        opacity: 0

        // font.family: theme.defaultFont
        // font.pointSize: fontPointSize
        font.family: textContainer.font.family
        font.pointSize: textContainer.font.pointSize
        minimumPixelSize: 1
        minimumPointSize: 1

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Label {
        id: innerLabel

        width: parent.width
        height: parent.height

        text: actualText

        font.family: sizerLabel.font.family
        font.pointSize: sizerLabel.font.pointSize
        minimumPixelSize: 1
        minimumPointSize: 1

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        anchors.centerIn: parent

        // Rectangle {
        //     anchors.fill: parent
        //     color: "red"
        //     visible: false
        //     z: -1
        // }
    }

    DropShadow {
        anchors.fill: innerLabel
        radius: 3
        samples: 16
        spread: 0.9
        fast: true
        color: Kirigami.Theme.backgroundColor
        source: innerLabel
        visible: showDropShadow
    }

    // Rectangle {
    //     anchors.fill: parent
    //     // color: "blue"
    //     border.color: Qt.rgba(0, 0, 0, 0.5)
    //     border.width: 2
    //     z: -1
    //     visible: false
    // }

    states: [
        State {
            name: "base"
            AnchorChanges {
                target: sizerLabel
                anchors.bottom: undefined
                anchors.right: undefined
            }
        },
        State {
            name: "horizontalOnHorizontalPanel"
            extend: "base"
            PropertyChanges {
                target: sizerLabel

                width: (sizeMode === CompactItem.SizeMode.Fill) ? innerLabel.contentWidth :
                        (sizeMode === CompactItem.SizeMode.FixedSize) ? sizerWidth :
                        /*(sizeMode === CompactItem.SizeMode.FontSize)*/ innerLabel.contentWidth
                height: parentHeight

                fontSizeMode: (sizeMode === CompactItem.SizeMode.Fill) ? Text.VerticalFit :
                                (sizeMode === CompactItem.SizeMode.FixedSize) ? Text.Fit :
                                /*(sizeMode === CompactItem.SizeMode.FontSize)*/ Text.FixedSize

                font.pointSize: (sizeMode === CompactItem.SizeMode.Fill) ? 1024 :
                                 (sizeMode === CompactItem.SizeMode.FixedSize) ? 1024 :
                                /*(sizeMode === CompactItem.SizeMode.FontSize) ? */ textContainer.font.pointSize
            }
            PropertyChanges {
                target: innerLabel

                fontSizeMode: (sizeMode === CompactItem.SizeMode.Fill) ? Text.VerticalFit :
                                (sizeMode === CompactItem.SizeMode.FixedSize) ? Text.Fit :
                                /*(sizeMode === CompactItem.SizeMode.FontSize)*/ Text.FixedSize

            }
        },
        State {
            name: "horizontalOnVerticalPanel"
            extend: "base"
            PropertyChanges {
                target: sizerLabel

                width: sizerWidth
                height: isHeightSizer ? contentHeight : sizerHeight

                fontSizeMode: Text.HorizontalFit
                font.pointSize: 1024
            }
            PropertyChanges {
                target: innerLabel

                fontSizeMode: Text.HorizontalFit
            }
        },
        State {
            name: "verticalOnVerticalPanel"
            extend: "base"
            PropertyChanges {
                target: sizerLabel

                // width: parentWidth
                // height: contentHeight

                // fontSizeMode: Text.HorizontalFit
                // font.pointSize: 1024

                width: parentWidth
                height: (sizeMode === CompactItem.SizeMode.Fill) ? sizerLabel.contentHeight :
                          (sizeMode === CompactItem.SizeMode.FixedSize) ? sizerHeight :
                            /*(sizeMode === CompactItem.SizeMode.FontSize)*/ innerLabel.contentHeight

                fontSizeMode: (sizeMode === CompactItem.SizeMode.Fill) ? Text.HorizontalFit :
                                (sizeMode === CompactItem.SizeMode.FixedSize) ? Text.Fit :
                                /*(sizeMode === CompactItem.SizeMode.FontSize)*/ Text.FixedSize

                font.pointSize: (sizeMode === CompactItem.SizeMode.Fill) ? 1024 :
                                 (sizeMode === CompactItem.SizeMode.FixedSize) ? 1024 :
                                /*(sizeMode === CompactItem.SizeMode.FontSize) ? */ textContainer.font.pointSize
            }
            PropertyChanges {
                target: innerLabel

                anchors.centerIn: parent

                // fontSizeMode: Text.Fit
                // font.pointSize:  textContainer.contentHeight

                fontSizeMode: (sizeMode === CompactItem.SizeMode.Fill) ? Text.HorizontalFit :
                                (sizeMode === CompactItem.SizeMode.FixedSize) ? Text.Fit :
                                /*(sizeMode === CompactItem.SizeMode.FontSize)*/ Text.FixedSize
            }
        },
        State {
            name: "verticalOnHorizontalPanel"
            extend: "base"
            PropertyChanges {
                target: sizerLabel

                width: (sizeMode === CompactItem.SizeMode.Fill) ? innerLabel.contentWidth :
                        (sizeMode === CompactItem.SizeMode.FixedSize) ? contentWidth :
                        /*(sizeMode === CompactItem.SizeMode.FontSize)*/ innerLabel.contentWidth
                height: sizerHeight

                fontSizeMode: (sizeMode === CompactItem.SizeMode.Fill) ? Text.VerticalFit :
                                (sizeMode === CompactItem.SizeMode.FixedSize) ? Text.VerticalFit :
                                /*(sizeMode === CompactItem.SizeMode.FontSize)*/ Text.FixedSize

                font.pointSize: (sizeMode === CompactItem.SizeMode.Fill) ? 1024 :
                                 (sizeMode === CompactItem.SizeMode.FixedSize) ? 1024 :
                                /*(sizeMode === CompactItem.SizeMode.FontSize) ? */ textContainer.font.pointSize
            }
            PropertyChanges {
                target: innerLabel

                anchors.centerIn: parent

                fontSizeMode: (sizeMode === CompactItem.SizeMode.Fill) ? Text.VerticalFit :
                                (sizeMode === CompactItem.SizeMode.FixedSize) ? Text.Fit :
                                /*(sizeMode === CompactItem.SizeMode.FontSize)*/ Text.FixedSize
            }
        },
        State {
            name: "compact"
            PropertyChanges {
                target: sizerLabel

                width: Math.min(textContainer.parent.width, textContainer.parent.height)
                height: Math.min(textContainer.parent.width, textContainer.parent.height)

                fontSizeMode: Text.Fit

                font.pointSize: 1024
            }
            PropertyChanges {
                target: innerLabel

                fontSizeMode: Text.Fit
            }
        }
    ]
}
