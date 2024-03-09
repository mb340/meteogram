import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami


Column {
    id: root

    width: 240 * 1
    height: 128 * 1

    readonly property var defaultOrder: ["0", "1", "2"]
    readonly property var itemNames: [
                    i18n("City Alias"),
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
                    clip: true

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    selectionModel: ItemSelectionModel {
                        model: disabledTableView.model
                    }

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
                enabled: disabledTableView.selectionModel.hasSelection && disabledItemsModel.count > 0

                // Layout.alignment: Qt.AlignVCenter

                onClicked: moveItemToTable(disabledTableView, enabledTableView)
            }


            Button {
                icon.name: 'go-previous'
                enabled: enabledTableView.selectionModel.hasSelection && enabledItemsModel.count > 1

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
                    clip: true

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    selectionModel: ItemSelectionModel {
                        model: enabledTableView.model
                    }

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

            required property bool selected
            // required property bool current

            implicitWidth: parentTable?.width ?? childrenRect.width
            implicitHeight: childrenRect.height

            color: selected ? highlightColor : 'transparent'

            property var highlightColor: Kirigami.Theme.highlightColor ?
                                                Kirigami.Theme.highlightColor : 'green'

            Label {
                id: itemText
                text: model.text

                color: enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            }

            MouseArea {
                anchors.fill: tableViewItem

                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (parentTable != enabledTableView) {
                        enabledTableView.selectionModel.clear()
                    } else if (parentTable != disabledTableView) {
                        disabledTableView.selectionModel.clear()
                    }

                    let index = parentTable.model.index(row, 0)
                    if (!parentTable.selectionModel.isSelected(index)) {
                        parentTable.selectionModel.select(index, ItemSelectionModel.SelectCurrent)

                    } else {
                        parentTable.selectionModel.select(index, ItemSelectionModel.Deselect)
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
            enabled: (enabledTableView.selectionModel.hasSelection &&
                        enabledTableView.selectionModel.selectedIndexes.length > 0 &&
                        enabledTableView.selectionModel.selectedIndexes[0].row > 0)
            onClicked: moveItemUp()
        }
        Button {
            icon.name: 'go-down'
            enabled: (enabledTableView.selectionModel.hasSelection &&
                        enabledTableView.selectionModel.selectedIndexes.length > 0 &&
                        (enabledTableView.selectionModel.selectedIndexes[0].row <
                            (enabledItemsModel.count - 1))
                        )
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
        let row = enabledTableView.selectionModel.selectedIndexes.length === 0 ? -1 :
                    enabledTableView.selectionModel.selectedIndexes[0].row
        if (row <= 0 || row > enabledItemsModel.count) {
            return
        }
        enabledItemsModel.move(row, row - 1, 1)

        updateOrder(true)
    }

    function moveItemDown() {
        let row = enabledTableView.selectionModel.selectedIndexes.length === 0 ? -1 :
                    enabledTableView.selectionModel.selectedIndexes[0].row
        if (row < 0 || row >= enabledItemsModel.count - 1) {
            return
        }
        enabledItemsModel.move(row, row + 1, 1)

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
        if (!src.selectionModel.hasSelection) {
            return
        }

        if (src === enabledTableView && src.model.count <= 1) {
            return
        }

        let idx = src.selectionModel.selectedIndexes[0].row
        var item = src.model.get(idx)

        item.parentTable = dst
        dst.model.append(item)
        src.model.remove(idx, 1)

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
