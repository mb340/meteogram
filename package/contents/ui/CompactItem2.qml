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
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../code/icons.js" as IconTools
import "../code/print.js" as PrintUtil
import "utils"

Grid {
    id: compactItem

    objectName: "CompactItem2"
    property var dbgprint: PrintUtil.init(this, plasmoidCacheId)
    // property var dbgprint: function(...args) {}

    property int temperatureType: plasmoid.configuration.temperatureType

    property int iconSetType: (plasmoid && plasmoid.configuration &&
                               plasmoid.configuration.iconSetType) ?
                                plasmoid.configuration.iconSetType : 0

    property var itemOrder: plasmoid.configuration.compactItemOrder

    property string places: plasmoid.configuration.places

    property bool constrainCityAliasLabel: plasmoid.configuration.constrainCityAliasLabel
    property bool constrainTemperatureLabel: plasmoid.configuration.constrainTemperatureLabel

    property int cityAliasSizeMode: plasmoid.configuration.cityAliasSizeMode
    property string cityAliasFontName: plasmoid.configuration.cityAliasFontName
    property int cityAliasFontSize: plasmoid.configuration.cityAliasFontSize
    property double cityAliasFixedSize: plasmoid.configuration.cityAliasFixedSize

    property int temperatureSizeMode: plasmoid.configuration.temperatureSizeMode
    property string temperatureFontName: plasmoid.configuration.temperatureFontName
    property int temperatureFontSize: plasmoid.configuration.temperatureFontSize
    property double temperatureFixedSize: plasmoid.configuration.temperatureFixedSize

    property int temperatureIconSizeMode: plasmoid.configuration.temperatureIconSizeMode
    property double temperatureIconFixedSize: plasmoid.configuration.temperatureIconFixedSize

    property string iconNameStr: !currentWeatherModel.valid ? '\uf07b' :
                                    IconTools.getIconCode(currentWeatherModel.iconName,
                                                          currentProvider, getPartOfDayIndex())

    property double temperature: !currentWeatherModel.valid ? NaN : currentWeatherModel.temperature
    property int nDigits: unitUtils.convertTemperature(temperature, temperatureType) >= 200 ? 0 : 1
    property string temperatureStr: isNaN(temperature) ? "--" :
                                    unitUtils.getTemperatureText(temperature, temperatureType,
                                                                 nDigits)

    property bool isPanelVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
                                    // Other form factors will default to user config
                                    || (plasmoid.formFactor !== PlasmaCore.Types.Horizontal && isVertical)

    property bool isPanelHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal
                                        || (plasmoid.formFactor !== PlasmaCore.Types.Vertical && isHorizontal)

    property double parentWidth: isPanelVertical ? width : height
    property double parentHeight: isPanelHorizontal ? height : width

    property bool isCompact: layoutType === 2
    property bool isVertical: layoutType === 1
    property bool isHorizontal: layoutType === 0

    property bool isHorizontalState: !inTray && !isCompact && isHorizontal
    property bool isVerticalState: !inTray && !isCompact && isVertical
    property bool isCompactState: (inTray || isCompact)

    property double sizerWidth
    property double sizerHeight


    rowSpacing: plasmoid.configuration.layoutSpacing
    columnSpacing: plasmoid.configuration.layoutSpacing

    horizontalItemAlignment: Grid.AlignHCenter
    verticalItemAlignment: Grid.AlignVCenter

    anchors.centerIn: parent

    Item {
        id: placeholder
        visible: false
        width: 0
        height: 0
    }

    CompactItemText {
        id: placeAliasContainer

        debugName: "placeAliasContainer"

        sizeMode: cityAliasSizeMode

        font.family: cityAliasFontName
        font.pointSize: cityAliasFontSize

        parentWidth: compactItem.parentWidth
        parentHeight: compactItem.parentHeight

        sizerText: "London, UK"
        actualText: main.placeAlias 

        sizerWidth: (sizeMode === CompactItem2.SizeMode.FixedSize && isHorizontalState) ?
                        cityAliasFixedSize : compactItem.sizerWidth
        sizerHeight:  (sizeMode === CompactItem2.SizeMode.FixedSize && isVerticalState) ?
                        cityAliasFixedSize : compactItem.sizerHeight

        isConstrainedToSizerText: constrainCityAliasLabel

        state: compactItem.state
        onStateChanged: visible = order.includes(CompactItem2.ItemType.PlaceAlias)
    }

    CompactItemText {
        id: temperatureTextContainer

        debugName: "temperatureTextContainer"

        sizeMode: temperatureSizeMode

        font.family: temperatureFontName
        font.pointSize: temperatureFontSize

        parentWidth: compactItem.parentWidth
        parentHeight: compactItem.parentHeight

        sizerText: isHorizontalState ?
            unitUtils.getTemperatureText(-0.8, UnitUtils.TemperatureType.CELSIUS, 1) :
            unitUtils.getTemperatureText(-100.8, UnitUtils.TemperatureType.CELSIUS, 1)
        actualText: temperatureStr

        sizerWidth: (sizeMode === CompactItem2.SizeMode.FixedSize && isHorizontalState) ?
                        temperatureFixedSize : compactItem.sizerWidth
        sizerHeight:  (sizeMode === CompactItem2.SizeMode.FixedSize && isVerticalState) ?
                        temperatureFixedSize : compactItem.sizerHeight

        isHeightSizer: true
        isWidthSizer: true

        isConstrainedToSizerText: constrainTemperatureLabel

        state: compactItem.state
        onStateChanged: visible = order.includes(CompactItem2.ItemType.TemperatureText)
    }

    CompactTemperatureIcon {
        id: temperatureIcon

        sizeMode: temperatureIconSizeMode

        parentWidth: compactItem.parentWidth
        parentHeight: compactItem.parentHeight

        sizerWidth: (sizeMode === CompactItem2.SizeMode.FixedSize) ?
                        temperatureIconFixedSize : compactItem.sizerWidth
        sizerHeight: (sizeMode === CompactItem2.SizeMode.FixedSize && isVerticalState) ?
                        temperatureIconFixedSize : compactItem.sizerHeight

        isVerticalState: compactItem.isVerticalState

        state: compactItem.state
        onStateChanged: visible = order.includes(CompactItem2.ItemType.TemperatureIcon)
    }

    Component.onCompleted: {
        dbgprint("CompactItem: onCompleted: formFactor " + plasmoid.formFactor)
    }

    onStateChanged: {
        dbgprint("onStateChanged", state)
    }

    onItemOrderChanged: {
        updateOrder()
    }

    onTemperatureTypeChanged: {
        updateOrder()
    }

    onPlacesChanged: {
        updateOrder()
    }

    enum ItemType {
        PlaceAlias,
        TemperatureText,
        TemperatureIcon,
        NumTypes
    }

    enum SizeMode {
        Fill,
        FixedSize,
        FontSize
    }

    property var order: []

    function forceStateUpdate() {
        let prevState = state
        state = "void"
        state = prevState
    }

    function updateOrder() {
        dbgprint('itemOrder', JSON.stringify(itemOrder))

        order = []
        for (var i = 0; i < itemOrder.length; i++) {
            let itemNum = Number(itemOrder[i])
            order.push(itemNum)
        }

        forceStateUpdate()
    }

    function deparentChildren() {
        for (var i = 0; i < CompactItem2.ItemType.NumTypes; i++) {
            if (order[i] === CompactItem2.ItemType.PlaceAlias) {
                placeAliasContainer.parent = placeholder
            } else if (order[i] === CompactItem2.ItemType.TemperatureText) {
                temperatureTextContainer.parent = placeholder
            } else if (order[i] === CompactItem2.ItemType.TemperatureIcon) {
                temperatureIcon.parent = placeholder
            }
        }
    }

    function reparentChildren(order) {
        dbgprint("reparentChildren", JSON.stringify(order))
        for (var i = 0; i < order.length; i++) {
            if (order[i] === CompactItem2.ItemType.PlaceAlias) {
                placeAliasContainer.parent = compactItem
            } else if (order[i] === CompactItem2.ItemType.TemperatureText) {
                temperatureTextContainer.parent = compactItem
            } else if (order[i] === CompactItem2.ItemType.TemperatureIcon) {
                temperatureIcon.parent = compactItem
            }
        }
    }

    function getNumVisible() {
        return (placeAliasContainer.visible ? 1 : 0) +
                (temperatureTextContainer.visible ? 1 : 0) +
                (temperatureIcon.visible ? 1 : 0)
    }

    states: [
        State {
            id: "void"
        },
        State {
            name: "removeAllChildren"
            StateChangeScript {
                script: {
                    dbgprint("removeAllChildren StateChangeScript")
                    deparentChildren()
                }
            }
        },
        State {
            name: "changeOrientation"
            extend: "removeAllChildren"
            PropertyChanges {
                target: compactItem
                rows: isVerticalState ? order.length : 1
                columns: isVerticalState ? 1 : order.length
            }
        },
        State {
            name: "addChildren"
            extend: "changeOrientation"
            StateChangeScript {
                script: {
                    dbgprint("addChildren StateChangeScript")
                    reparentChildren(compactItem.order)
                }
            }
        },
        State {
            name: "horizontal"
            extend: "addChildren"

            PropertyChanges {
                target: compactItem

                sizerWidth: (compactItem.width / order.length)
                sizerHeight: isPanelHorizontal ? compactItem.height / order.length :
                                                 temperatureTextContainer.innerLabel.height
            }
        },
        State {
            name: "horizontalOnHorizontalPanel"
            extend: "horizontal"
            when: isHorizontalState && isPanelHorizontal

            PropertyChanges {
                target: parent
                Layout.minimumWidth: compactItem.width
                Layout.maximumWidth: compactItem.width
                Layout.fillWidth: false
            }
            PropertyChanges {
                target: compactItem

                width:  (placeAliasContainer.visible ? placeAliasContainer.width : 0) +
                        (temperatureTextContainer.visible ? temperatureTextContainer.width : 0) +
                        (temperatureIcon.visible ? temperatureIcon.width : 0) +
                        (rowSpacing * (getNumVisible() - 1))

                height: parent.height
            }
        },
        State {
            name: "horizontalOnVerticalPanel"
            extend: "horizontal"
            when: isHorizontalState && isPanelVertical

            PropertyChanges {
                target: parent
                Layout.fillWidth: true
                Layout.maximumHeight: compactItem.height
            }
            PropertyChanges {
                target: compactItem

                width: parent.width
                height: childrenRect.height
            }
        },
        State {
            name: "vertical"
            extend: "addChildren"

            PropertyChanges {
                target: compactItem

                sizerWidth: temperatureTextContainer.innerLabel.width
                sizerHeight: isPanelHorizontal ?
                                (parent.height / order.length) :
                                temperatureTextContainer.innerLabel.height
            }
        },

        State {
            name: "verticalOnVerticalPanel"
            extend: "vertical"
            when: isVerticalState && isPanelVertical

            PropertyChanges {
                target: parent
                Layout.minimumHeight: compactItem.height
                Layout.maximumHeight: compactItem.height
            }
            PropertyChanges {
                target: compactItem

                width: parent.width
                height: (placeAliasContainer.visible ? placeAliasContainer.height : 0) +
                        (temperatureTextContainer.visible ?
                            temperatureTextContainer.height : 0) +
                        (temperatureIcon.visible ? temperatureIcon.contentHeight : 0) +
                        (columnSpacing * (getNumVisible() - 1))
            }
        },
        State {
            name: "verticalOnHorizontalPanel"
            extend: "vertical"
            when: isVerticalState && isPanelHorizontal

            PropertyChanges {
                target: parent

                Layout.minimumWidth: compactItem.width
                Layout.maximumWidth: compactItem.width
            }
            PropertyChanges {
                target: compactItem

                width:  Math.max(
                            Math.max((placeAliasContainer.visible ?
                                        placeAliasContainer.width : 0),
                                     (temperatureTextContainer.visible ?
                                        temperatureTextContainer.width : 0)),
                            (temperatureIcon.visible ? temperatureIcon.width : 0)
                        )
                height: parent.height
            }
        },
        State {
            name: "compact"
            when: isCompactState

            PropertyChanges {
                target: parent
                Layout.fillWidth: isPanelVertical
                Layout.fillHeight: !isPanelVertical
            }
            PropertyChanges {
                target: compactItem

                width: parent.width
                height: parent.height

                rows: 1
                columns: 1

                temperatureStr: isNaN(temperature) ? "--" :
                                    unitUtils.getTemperatureText(temperature, temperatureType, 0)
            }
            ParentChange {
                target: placeAliasContainer
                parent: placeholder
            }
            PropertyChanges {
                target: placeAliasContainer
                visible: false
            }

            ParentChange {
                target: temperatureIcon
                parent: compactItem
            }

            ParentChange {
                target: temperatureTextContainer
                parent: temperatureIcon
            }
            // PropertyChanges {
            //     target: temperatureTextContainer
            //     visible: false
            // }
            PropertyChanges {
                target: temperatureTextContainer

                width: Math.min(parent.width, parent.height) * (main.inTray ? 0.75 : 0.50)
                height: Math.min(parent.width, parent.height)

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom

                fontSizeMode: Text.Fit

                showDropShadow: true
                visible: true

                innerLabel.horizontalAlignment: Text.AlignRight
                innerLabel.verticalAlignment: Text.AlignBottom

                innerLabel.fontSizeMode: Text.Fit
            }
            AnchorChanges {
                target: temperatureTextContainer
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }
        }
    ]
}
