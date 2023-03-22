import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

Column {
    id: root

    width: 240 * units.devicePixelRatio
    height: 128 * units.devicePixelRatio

    readonly property var defaultOrder: ["0", "1", "2"]
    readonly property var itemNames: [
                    i18n("Place Identifier"),
                    i18n("Temperature"),
                    i18n("Icon")
                ]

    // property var order: ["0", "1", "2"]
    property var order: []

    ListModel {
        id: disabledItemsModel
    }

    ListModel {
        id: enabledItemsModel
    }

    RowLayout {

        width: parent.width
        height: parent.height - itemOrderButtons.height

        Rectangle {
            color: 'transparent'

            Layout.fillWidth: true

            Layout.preferredHeight: parent.height

            ColumnLayout {
                anchors.fill: parent
                width: parent.width

                HorizontalHeaderView {
                    id: disabledTableHeader

                    Layout.preferredWidth: parent.width
                    clip: true

                    syncView: disabledTableView
                    model: [i18n("Disabled Items"), ]
                }

                TableView {
                    id: disabledTableView

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    property int currentRow: -1

                    onWidthChanged: forceLayout()
                    onHeightChanged: forceLayout()

                    model: disabledItemsModel
                    delegate: listItemComponent
                }
            }
        }

        ColumnLayout {
            id: addRemoveButtons

            Layout.fillWidth: false
            Layout.minimumWidth: childrenRect.width
            Layout.preferredHeight: parent.height

            Item {
                Layout.preferredWidth: parent.width
                Layout.minimumHeight: Math.max(disabledTableHeader.height, enabledTableHeader.height)

                Rectangle {
                    anchors.fill: parent
                    color: 'transparent'
                }
            }

            Item {
                Layout.preferredWidth: parent.width
                Layout.fillHeight: true
            }

            Button {
                icon.name: 'go-next'
                enabled: disabledTableView.currentRow !== -1 && disabledItemsModel.count > 0

                // Layout.alignment: Qt.AlignVCenter

                onClicked: moveItemToTable(disabledTableView, enabledTableView)
            }


            Button {
                icon.name: 'go-previous'
                enabled: enabledTableView.currentRow !== -1 && enabledItemsModel.count > 1

                // Layout.alignment: Qt.AlignVCenter

                onClicked: {
                    if (enabledItemsModel.count <= 1) {
                        return
                    }
                    moveItemToTable(enabledTableView, disabledTableView)
                }
            }

            Item {
                Layout.preferredWidth: parent.width
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: parent.width
                Layout.minimumHeight: itemOrderButtons.height

                Rectangle {
                    anchors.fill: parent
                    color: 'transparent'
                }
            }
        }

        Rectangle {
            color: 'transparent'

            Layout.fillWidth: true
            Layout.preferredHeight: parent.height

            ColumnLayout {

                anchors.fill: parent

                HorizontalHeaderView {
                    id:enabledTableHeader

                    Layout.preferredWidth: enabledTableView.width
                    Layout.fillWidth: true
                    clip: true

                    syncView: enabledTableView
                    model: [i18n("Enabled Items"), ]
                }

                TableView {
                    id: enabledTableView

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    property int currentRow: -1

                    onWidthChanged: forceLayout()
                    onHeightChanged: forceLayout()

                    model: enabledItemsModel
                    delegate: listItemComponent
                }
            }
        }
    }

    Component {
        id: listItemComponent

        Rectangle {
            id: tableViewItem

            implicitWidth: parentTable ? parentTable.width : childrenRect.width
            implicitHeight: childrenRect.height

            color: parentTable && parentTable.currentRow === row ?
                        highlightColor : viewBackgroundColor

            clip: true

            property var viewBackgroundColor: PlasmaCore.Theme.viewBackgroundColor ?
                                                PlasmaCore.Theme.viewBackgroundColor : 'white'
            property var highlightColor: PlasmaCore.Theme.highlightColor ?
                                                PlasmaCore.Theme.highlightColor : 'green'

            Label {
                id: itemText
                text: model.text
            }

            MouseArea {
                anchors.fill: tableViewItem

                onClicked: {
                    if (parentTable != enabledTableView) {
                        enabledTableView.currentRow = -1
                    } else if (parentTable != disabledTableView) {
                        disabledTableView.currentRow = -1
                    }
                    if (row !== parentTable.currentRow) {
                        parentTable.currentRow = row
                    } else {
                        parentTable.currentRow = -1
                    }
                }

                onDoubleClicked: {
                    let src = parentTable
                    let dst = parentTable === enabledTableView ?
                                disabledTableView : enabledTableView
                    moveItemToTable(src, dst)
                }
            }
        }
    }

    RowLayout {
        id: itemOrderButtons

        width: parent.width
        height: childrenRect.height

        Item {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
        }

        Button {
            icon.name: 'go-up'
            enabled: enabledTableView.currentRow !== -1 && enabledTableView.currentRow > 0
            onClicked: moveItemUp()
        }
        Button {
            icon.name: 'go-down'
            enabled: enabledTableView.currentRow !== -1 &&
                        enabledTableView.currentRow < enabledItemsModel.count - 1
            onClicked: moveItemDown()
        }
    }

    property bool disableModelUpdates: false

    onOrderChanged: {
        if (disableModelUpdates === true) {
            disableModelUpdates = false
            return
        }
        populateEnabledTable()
        populateDisabledTable()
    }

    function populateEnabledTable() {
        for (var i = 0; i < order.length; i++) {
            var value = String(order[i])
            if (typeof(value) !== 'string' || !defaultOrder.includes(value)) {
                continue
            }
            enabledItemsModel.append({
                text: itemNames[value],
                value: order[i],
                parentTable: enabledTableView
            })
        }
    }

    function populateDisabledTable() {
        disabledItemsModel.clear()
        for (var i = 0; i < defaultOrder.length; i++) {
            var value = defaultOrder[i]
            if (typeof(value) === 'string' && order.includes(value)) {
                continue
            }

            disabledItemsModel.append({
                text: itemNames[value],
                value: defaultOrder[i],
                parentTable: disabledTableView
            })
        }
    }

    function moveItemUp() {
        let row = enabledTableView.currentRow
        if (row <= 0 || row > enabledItemsModel.count) {
            return
        }
        enabledItemsModel.move(row, row - 1, 1)
        enabledTableView.currentRow--

        updateOrder(true)
    }

    function moveItemDown() {
        let row = enabledTableView.currentRow
        if (row < 0 || row >= enabledItemsModel.count - 1) {
            return
        }
        enabledItemsModel.move(row, row + 1, 1)
        enabledTableView.currentRow++

        updateOrder(true)
    }

    function updateOrder(disableModelUpdates) {
        if (disableModelUpdates !== undefined) {
            root.disableModelUpdates = disableModelUpdates 
        }
        let _order = []
        for (var i = 0; i < enabledItemsModel.count; i++) {
            let item = enabledItemsModel.get(i)
            _order.push(String(item.value))
        }

        order = _order
    }

    function moveItemToTable(src, dst) {
        if (src.currentRow === -1) {
            return
        }

        if (src === enabledTableView && src.model.count <= 1) {
            return
        }

        var idx = src.currentRow
        var item = src.model.get(idx)

        item.parentTable = dst
        dst.model.append(item)
        src.model.remove(idx, 1)

        src.currentRow = Math.max(0, src.currentRow - 1)

        updateOrder(true)
    }

    // property var theme: ({
    //     viewBackgroundColor: 'grey',
    //     highlightColor: 'blue'
    // })

    // function i18n(text) {
    //     return text
    // }
}
