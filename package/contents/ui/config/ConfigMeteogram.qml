import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami


import "../../code/color.js" as ColorTools

KCM.SimpleKCM {
    id: root

    property alias cfg_maxMeteogramHours: maxMeteogramHours.value

    property bool cfg_renderTemperature: plasmoid.configuration.renderTemperature
    property bool cfg_renderPressure: plasmoid.configuration.renderPressure
    property bool cfg_renderHumidity: plasmoid.configuration.renderHumidity
    property bool cfg_renderPrecipitation: plasmoid.configuration.renderPrecipitation
    property bool cfg_renderCloudCover: plasmoid.configuration.renderCloudCover
    property bool cfg_renderIcons: plasmoid.configuration.renderIcons
    property bool cfg_renderAlerts: plasmoid.configuration.renderAlerts
    property bool cfg_renderSunsetShade: plasmoid.configuration.renderSunsetShade

    property int cfg_colorPaletteType: plasmoid.configuration.colorPaletteType

    property string cfg_backgroundColor: plasmoid.configuration.backgroundColor
    property string cfg_pressureColor: plasmoid.configuration.pressureColor
    property string cfg_temperatureWarmColor: plasmoid.configuration.temperatureWarmColor
    property string cfg_temperatureColdColor: plasmoid.configuration.temperatureColdColor
    property string cfg_rainColor: plasmoid.configuration.rainColor
    property string cfg_cloudAreaColor: plasmoid.configuration.cloudAreaColor
    property string cfg_cloudAreaColor2: plasmoid.configuration.cloudAreaColor2
    property string cfg_humidityColor: plasmoid.configuration.humidityColor

    property string cfg_backgroundColorDark: plasmoid.configuration.backgroundColorDark
    property string cfg_pressureColorDark: plasmoid.configuration.pressureColorDark
    property string cfg_temperatureWarmColorDark: plasmoid.configuration.temperatureWarmColorDark
    property string cfg_temperatureColdColorDark: plasmoid.configuration.temperatureColdColorDark
    property string cfg_rainColorDark: plasmoid.configuration.rainColorDark
    property string cfg_cloudAreaColorDark: plasmoid.configuration.cloudAreaColorDark
    property string cfg_cloudAreaColor2Dark: plasmoid.configuration.cloudAreaColor2Dark
    property string cfg_humidityColorDark: plasmoid.configuration.humidityColorDark

    property bool isCustomColor: cfg_colorPaletteType === 4
    property int lightDarkMode: 0

    property var lightModeColors: [
        { colorVal: cfg_backgroundColor, colorVar: "backgroundColor", colorLabel: i18n("Background") },
        { colorVal: cfg_pressureColor, colorVar: "pressureColor", colorLabel: i18n("Pressure") },
        { colorVal: cfg_temperatureWarmColor, colorVar: "temperatureWarmColor", colorLabel: i18n("Warm Temperature") },
        { colorVal: cfg_temperatureColdColor, colorVar: "temperatureColdColor", colorLabel: i18n("Cold Temperature") },
        { colorVal: cfg_rainColor, colorVar: "rainColor", colorLabel: i18n("Rain") },
        { colorVal: cfg_cloudAreaColor, colorVar: "cloudAreaColor", colorLabel: i18n("Cloud Cover Top") },
        { colorVal: cfg_cloudAreaColor2, colorVar: "cloudAreaColor2", colorLabel: i18n("Cloud Cover Bottom") },
        { colorVal: cfg_humidityColor, colorVar: "humidityColor", colorLabel: i18n("Relative Humidity") }
    ]

    property var darkModeColors: [
        { colorVal: cfg_backgroundColorDark, colorVar: "backgroundColorDark", colorLabel: i18n("Background") },
        { colorVal: cfg_pressureColorDark, colorVar: "pressureColorDark", colorLabel: i18n("Pressure") },
        { colorVal: cfg_temperatureWarmColorDark, colorVar: "temperatureWarmColorDark", colorLabel: i18n("Warm Temperature") },
        { colorVal: cfg_temperatureColdColorDark, colorVar: "temperatureColdColorDark", colorLabel: i18n("Cold Temperature") },
        { colorVal: cfg_rainColorDark, colorVar: "rainColorDark", colorLabel: i18n("Rain") },
        { colorVal: cfg_cloudAreaColorDark, colorVar: "cloudAreaColorDark", colorLabel: i18n("Cloud Cover Top") },
        { colorVal: cfg_cloudAreaColor2Dark, colorVar: "cloudAreaColor2Dark", colorLabel: i18n("Cloud Cover Bottom") },
        { colorVal: cfg_humidityColorDark, colorVar: "humidityColorDark", colorLabel: i18n("Relative Humidity") }
    ]

    property var maxColWidth: 0

    ButtonGroup {
        id: lightDarkModeGroup
    }

    ListModel {
        id: colorsModel
    }

    // Work around broken ColorDialog with Qt 6
    // https://invent.kde.org/plasma/kdeplasma-addons/-/commit/797cef06882acdf4257d8c90b8768a74fdef0955
    // https://bugs.kde.org/show_bug.cgi?id=476509
    // https://bugreports.qt.io/browse/QTBUG-119055
    Component {
        id: colorDialogWindowComponent

        Window {
            id: colorDialogWindow
            width: Kirigami.Units.gridUnit * 19
            height: Kirigami.Units.gridUnit * 23
            visible: true
            title: qsTr("Choose a %1 color").arg(colorLabel)

            required property string colorVar
            required property string colorLabel

            ColorDialog {
                id: colorDialog
                title: colorDialogWindow.title
                visible: false
                options: ColorDialog.ShowAlphaChannel
                selectedColor: plasmoid.configuration[colorDialogWindow.colorVar]

                onAccepted: {
                    var isLight = !colorVar.endsWith("Dark")
                    var color = colorDialog.selectedColor


                    var targetContrast =  4.5
                    if (colorVar.startsWith("temperature")) {
                        targetContrast =  isLight ? 4.5 : 3.0
                    } else if (colorVar.startsWith("cloudAreaColor2")) {
                        targetContrast = isLight ? 4.0 : 1.5
                    } else if (colorVar.startsWith("cloudAreaColor")) {
                        targetContrast = isLight ? 1.5 : 4.0
                    } else {
                        targetContrast =  isLight ? 3.0 : 4.5
                    }

                    var bgColor = isLight ? cfg_backgroundColor : cfg_backgroundColorDark
                    bgColor = ColorTools.strToColor(bgColor)
                    var targetColor = ColorTools.getContrastingColor(color, bgColor, targetContrast)

                    eval("cfg_" + colorVar + " = \"" + color + "\"")
                    if (!colorVar.startsWith("background") && !ColorTools.equals(color, targetColor)) {
                        setModelColor(colorVar, String(color), String(targetColor))
                    }

                    colorDialogWindow.destroy()
                }
                onRejected: {
                    colorDialogWindow.destroy()
                }
            }
            onClosing: destroy()
            Component.onCompleted: colorDialog.open()
        }
    }

    onLightDarkModeChanged: {
        switch (lightDarkMode) {
            default:
            case 0:
                lightModeRadioButton.checked = true
                break
            case 1:
                darkModeRadioButton.checked = true
                break
        }
        setModel()
    }


    Kirigami.FormLayout {
        ColumnLayout {
            Layout.fillWidth: true


            Component.onCompleted: {
                cfg_renderTemperatureChanged()
                cfg_renderPressureChanged()
                cfg_renderHumidityChanged()
                cfg_renderPrecipitationChanged()
                cfg_renderCloudCoverChanged()
                cfg_renderIconsChanged()
                cfg_renderAlertsChanged()
                cfg_renderSunsetShadeChanged()

                cfg_colorPaletteTypeChanged()
                lightDarkModeChanged()
                setModel()
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3

                Label {
                    text: i18n("Maximum Hours")
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignRight

                    Layout.preferredWidth: maxColWidth
                    onWidthChanged: updateMaxColWidth(width)
                }

                SpinBox {
                    id: maxMeteogramHours
                    property int decimals: 0
                    stepSize: 1
                    from: 24
                    to: 72
                    textFromValue: function(value, locale) {
                        return qsTr("%1").arg(value)
                    }
                }
            }

            Label {
                text: i18n("Visible Parameters")
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2

                property var labels: [
                    i18n("Temperature"),
                    i18n("Pressure"),
                    i18n("Relative Humidity"),
                    i18n("Precipitation"),
                    i18n("Cloud Cover"),
                    i18n("Icons"),
                    i18n("Alerts"),
                    i18n("Sunset Shade")
                ]

                property var values: [
                    "renderTemperature",
                    "renderPressure",
                    "renderHumidity",
                    "renderPrecipitation",
                    "renderCloudCover",
                    "renderIcons",
                    "renderAlerts",
                    "renderSunsetShade"
                ]

                Repeater {
                    model: parent.labels
                    Item {
                        width: 2
                        height: 2
                        Layout.row: index
                        Layout.column: 0

                        Layout.preferredWidth: maxColWidth
                        onWidthChanged: updateMaxColWidth(width)
                    }
                }

                Repeater {
                    model: parent.values

                    delegate: CheckBox {
                        id: renderParameterCheckbox
                        text: parent.labels[index]
                        checked: plasmoid.configuration[modelData]
                        Layout.row: index
                        Layout.column: 1

                        Binding {
                            target: root
                            property: "cfg_" + modelData
                            value: renderParameterCheckbox.checked
                        }
                    }

                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2

                Label {
                    text: i18n("Color Palette") + ":"
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                    Layout.preferredWidth: maxColWidth
                    onWidthChanged: updateMaxColWidth(width)
                }

                ComboBox {
                    Layout.rowSpan: 1
                    Layout.minimumWidth: Kirigami.Units.gridUnit * 10
                    currentIndex: cfg_colorPaletteType
                    model: [
                        i18n("Default"),
                        i18n("Protanopia"),
                        i18n("Deuteranopia"),
                        i18n("Tritanopia"),
                        i18n("Custom")
                    ]

                    onCurrentIndexChanged: {
                        if (currentIndex < 0 || currentIndex >= model.length) {
                            return
                        }
                        cfg_colorPaletteType = currentIndex
                    }
                }
            }

            Label {
                text: i18n("Custom Palette")
                font.bold: true
                visible: isCustomColor
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }

            RowLayout {
                visible: isCustomColor

                Label {
                    text: i18n("Mode:")
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
                RadioButton {
                    id: lightModeRadioButton
                    ButtonGroup.group: lightDarkModeGroup
                    text: i18n("Light")
                    onCheckedChanged: if (checked) lightDarkMode = 0
                }
                RadioButton {
                    id: darkModeRadioButton
                    ButtonGroup.group: lightDarkModeGroup
                    text: i18n("Dark")
                    onCheckedChanged: if (checked) lightDarkMode = 1
                }
            }

            HorizontalHeaderView {
                id: horizontalHeader
                syncView: tableView
                visible: isCustomColor
                Layout.preferredHeight: contentHeight
                Layout.preferredWidth: parent.width
                Layout.fillWidth: true

                model: [
                    i18n("Color"),
                    i18n("Suggested Color"),
                    // i18n("Place Identifier"),
                ]
            }

            TableView {
                id: tableView
                Layout.minimumHeight: 150
                Layout.fillWidth: true
                clip: true
                visible: isCustomColor

                selectionBehavior: TableView.SelectRows
                selectionModel: ItemSelectionModel {
                    id: itemSelectionModel
                    model: tableView.model
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded 
                }

                model: colorsModel

                property var columnWidths: [0.5, 0.5]
                columnWidthProvider: function (column) {
                    return tableView.width * columnWidths[column]
                }

                onWidthChanged: tableView.forceLayout()

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: colLabel.height

                    color: selected ? highlightColor : viewBackgroundColor


                    property var viewBackgroundColor: Kirigami.Theme.viewBackgroundColor ?
                                                        Kirigami.Theme.viewBackgroundColor : 'white'
                    property var highlightColor: Kirigami.Theme.highlightColor ?
                                                        Kirigami.Theme.highlightColor : 'green'

                    required property bool selected

                    MouseArea {
                        width:  parent.width
                        height: colLabel.height

                        RowLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: colLabel.height

                            Row {
                                Layout.preferredWidth: tableView.width * tableView.columnWidths[0]
                                Layout.preferredHeight: colLabel.height

                                Rectangle {
                                    color: colorVal
                                    height: colLabel.height
                                    width: height
                                }

                                Label {
                                    id: colLabel
                                    text: colorLabel
                                }
                            }

                            Row {
                                Layout.preferredWidth: tableView.width * tableView.columnWidths[1]
                                Layout.preferredHeight: sugColLabel.height

                                Rectangle {
                                    color: suggestedColor == "" ? 'transparent' : suggestedColor
                                    height: sugColLabel.height
                                    width: height
                                }

                                Label {
                                    id: sugColLabel
                                    text: String(suggestedColor)
                                    font.family: "Monospace"
                                }

                                // visible: suggestedColor.length === 0
                            }                    
                        }
                    
                        onClicked: {
                            let index = tableView.model.index(row, 0)
                            if (!itemSelectionModel.isSelected(index)) {
                                itemSelectionModel.clear()
                                itemSelectionModel.select(index, ItemSelectionModel.SelectCurrent | ItemSelectionModel.Row)
                            } else {
                                itemSelectionModel.select(index, ItemSelectionModel.Deselect)
                            }


                        }
                        onDoubleClicked: {
                            showColorDialog(colorVar, colorLabel)
                        }
                    }
                }
            }

            RowLayout {
                visible: isCustomColor

                Button {
                    icon.name: "edit-entry"
                    enabled: itemSelectionModel.hasSelection
                    hoverEnabled: true

                    ToolTip.delay: 100
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Edit color.")

                    onClicked: {
                        if (!itemSelectionModel.hasSelection) {
                            return
                        }

                        let idx = itemSelectionModel.selectedIndexes[0].row
                        let item = colorsModel.get(idx)
                        showColorDialog(item.colorVar, item.colorLabel)
                    }
                }

                Button {
                    icon.name: "go-previous"
                    enabled: itemSelectionModel.hasSelection
                    hoverEnabled: true

                    ToolTip.delay: 100
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Use suggested color.")

                    onClicked: {
                        if (!itemSelectionModel.hasSelection) {
                            return
                        }

                        let idx = itemSelectionModel.selectedIndexes[0].row
                        let item = colorsModel.get(idx)

                        if (item.suggestedColor == "") {
                            return
                        }

                        eval("cfg_" + item.colorVar + " = \"" + item.suggestedColor + "\"")
                        setModelColor(item.colorVar, item.suggestedColor, "")
                    }
                }

                Button {
                    icon.name: "go-previous-skip"
                    enabled: itemSelectionModel.hasSelection
                    hoverEnabled: true

                    ToolTip.delay: 100
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Use all suggested colors.")

                    onClicked: {
                        for (var i = 0; i < colorsModel.count; i++) {
                            let item = colorsModel.get(i)
                            if (item.suggestedColor == "") {
                                continue
                            }

                            eval("cfg_" + item.colorVar + " = \"" + item.suggestedColor + "\"")
                            setModelColor(item.colorVar, item.suggestedColor, "")
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    function getModelItem(colorVar) {
        var idx = -1;
        for (var i = 0; i < colorsModel.count; i++) {
            let item = colorsModel.get(i)
            if (item.colorVar === colorVar) {
                idx = i
                break
            }
        }
        return idx
    }

    function setModelColor(colorVar, colorVal, suggestedColorVal) {
        let idx = getModelItem(colorVar)
        if (idx !== -1) {
            colorsModel.setProperty(idx, "colorVal", colorVal)
            colorsModel.setProperty(idx, "suggestedColor", suggestedColorVal)
        }
    }

    function setModel() {
        var modelSrc = []
        if (lightDarkMode === 0) {
            modelSrc = lightModeColors
        } else if (lightDarkMode === 1) {
            modelSrc = darkModeColors
        }

        colorsModel.clear()
        modelSrc.forEach(function (colorObj) {
            colorObj['suggestedColor'] = ""
            colorsModel.append(colorObj)
        })
    }

    function showColorDialog(colorVar, colorLabel) {
        let props = {
            colorVar: colorVar,
            colorLabel: colorLabel,
        }
        colorDialogWindowComponent.createObject(root, props)
    }

    function updateMaxColWidth(width) {
        maxColWidth = Math.max(maxColWidth, width)
    }
}
