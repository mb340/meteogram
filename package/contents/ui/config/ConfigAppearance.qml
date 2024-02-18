import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import "../../code/print.js" as PrintUtil

Item {

    id: appearancePage

    objectName: "ConfigApearance"
    // property var dbgprint: PrintUtil.init(this)
    property var dbgprint: function(...args) {}

    property int cfg_layoutType
    property bool cfg_iconDropShadow

    property int cfg_cityAliasSizeMode
    property string cfg_cityAliasFontName
    property int cfg_cityAliasFontSize
    property alias cfg_cityAliasFixedSize: cityAliasFixedSize.value

    property int cfg_temperatureSizeMode
    property string cfg_temperatureFontName
    property int cfg_temperatureFontSize
    property alias cfg_temperatureFixedSize: temperatureFixedSize.value

    property int cfg_temperatureIconSizeMode
    property alias cfg_temperatureIconFixedSize: temperatureIconFixedSize.value
    property bool cfg_temperatureIconTypeSymbolic

    property alias cfg_layoutSpacing: layoutSpacing.value
    property alias cfg_inTrayActiveTimeoutSec: inTrayActiveTimeoutSec.value
    property int cfg_iconSetType: plasmoid.configuration.iconSetType
    property int cfg_windIconSetType: plasmoid.configuration.windIconSetType

    property alias cfg_compactItemOrder: compactItemOrder.order

    property bool compactItemsEnabled: cfg_layoutType === 0 || cfg_layoutType === 1

    property bool cityAliasEnabled: cfg_compactItemOrder.includes("0")
    property bool temperatureEnabled: cfg_compactItemOrder.includes("1")
    property bool temperatureIconEnabled: cfg_compactItemOrder.includes("2")

    property bool cfg_debugLayoutBoundaries

    onCfg_compactItemOrderChanged: {
        dbgprint(JSON.stringify(cfg_compactItemOrder))
    }

    Component.onCompleted: {
        cfg_layoutTypeChanged()
        cfg_iconSetTypeChanged()
        cfg_windIconSetTypeChanged()

        if (!cfg_cityAliasFontSize) {
            cfg_cityAliasFontSize = theme.defaultFont.pointSize
        }
        cfg_cityAliasFontSizeChanged()

        if (!cfg_cityAliasFontName) {
            cfg_cityAliasFontName = theme.defaultFont.family
        }
        cfg_cityAliasFontNameChanged()

        if (!cfg_temperatureFontSize) {
            cfg_temperatureFontSize = theme.defaultFont.pointSize
        }
        cfg_temperatureFontSizeChanged()

        if (!cfg_temperatureFontName) {
            cfg_temperatureFontName = theme.defaultFont.family
        }
        cfg_temperatureFontNameChanged()
    }

    GridLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 3

        Label {
            text: i18n("Icons")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font.bold: true
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Icon Set") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.rowSpan: 1
        }

        ComboBox {
            Layout.rowSpan: 1
            Layout.minimumWidth: units.gridUnit * 10
            currentIndex: cfg_iconSetType
            model: [
                i18n("Erik Flowers Weather Icons"),
                i18n("Yr.no Weather Symbols"),
                i18n("Basmilius Meteocons"),
                i18n("System icon theme")
            ]

            onCurrentIndexChanged: {
                if (currentIndex < 0 || currentIndex >= model.length) {
                    return
                }
                cfg_iconSetType = currentIndex
            }
        }

        Item {
            width: 2
            height: 2
            Layout.rowSpan: 3
        }

        Label {
            text: i18n("Drop Shadow")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }
        CheckBox {
            id: iconDropShadow
            checked: cfg_iconDropShadow
            Layout.alignment: Qt.AlignLeft
            Layout.rowSpan: 1
            onCheckedChanged: cfg_iconDropShadow = checked
        }

        Label {
            text: i18n("Wind Icon Set") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.rowSpan: 1
        }

        ComboBox {
            Layout.rowSpan: 1
            Layout.minimumWidth: units.gridUnit * 10
            currentIndex: cfg_windIconSetType
            model: [
                i18n("Blackadderkate"),
                i18n("Qulle"),
            ]

            onCurrentIndexChanged: {
                if (currentIndex < 0 || currentIndex >= model.length) {
                    return
                }
                cfg_windIconSetType = currentIndex
            }
        }

        Item {
            width: 2
            height: 2
            Layout.rowSpan: 3
        }

        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }

        Label {
            text: i18n("Layout")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font.bold: true
            Layout.columnSpan: 3
        }
        Label {
            text: i18n("Layout type") + ":"
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }

        ComboBox {
            Layout.rowSpan: 1
            Layout.minimumWidth: units.gridUnit * 10
            currentIndex: cfg_layoutType
            model: [
                i18n("Horizontal"),
                i18n("Vertical"),
                i18n("Compact")
            ]

            onCurrentIndexChanged: {
                if (currentIndex < 0 || currentIndex >= model.length) {
                    return
                }
                cfg_layoutType = currentIndex
            }
        }

        Label {
            text: i18n("NOTE: Setting layout type for in-tray plasmoid has no effect.")
            font.pixelSize: theme.defaultFont.pixelSize - 2
            Layout.rowSpan: 1
            Layout.preferredWidth: 250
            wrapMode: Text.WordWrap
        }

        component SizeModeComboBox: ComboBox {
            Layout.rowSpan: 1
            Layout.minimumWidth: units.gridUnit * 10
            // currentIndex: cfg_cityAliasSizeMode
            model: [
                i18n("Fill"),
                i18n("Fixed Size"),
                i18n("Font Size"),
            ]

            // onCurrentIndexChanged: {
            //     if (currentIndex < 0 || currentIndex >= model.length) {
            //         return
            //     }
            //     cfg_cityAliasSizeMode = currentIndex
            // }
        }

        Item {
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Layout spacing") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }

        SpinBox {
            id: layoutSpacing
            property int decimals: 0
            stepSize: 1
            from: 0
            to: 1024
            textFromValue: function(value, locale) {
                var suffix = i18nc("Abbreviation for pixels", "px")
                return qsTr("%1 %2").arg(value).arg(suffix)
            }
            valueFromText: function(text) {
                let data = text.split(" ")
                if (data.length < 1) {
                    return 0
                }
                return data[0]
            }
        }

        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }

        Item {
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        RowLayout {
            spacing: 0
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            Layout.columnSpan: 1
            Layout.minimumHeight: compactItemOrder.height

            Label {
                text: i18n("Layout order") + ":"
                Layout.alignment: Qt.AlignTop | Qt.AlignRight
            }
        }

        CompactItemOrder {
            id: compactItemOrder
            Layout.fillWidth: true
            Layout.minimumHeight: childrenRect.height
            Layout.columnSpan: 2
            enabled: compactItemsEnabled
        }


        Item {
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Show layout geometry") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }
        CheckBox {
            checked: cfg_debugLayoutBoundaries
            Layout.alignment: Qt.AlignLeft
            Layout.rowSpan: 1
            onCheckedChanged: cfg_debugLayoutBoundaries = checked
        }

        Label {
            text: i18n("Debug the layout of compact representation items.")
            font.pixelSize: theme.defaultFont.pixelSize - 2
            Layout.rowSpan: 1
            Layout.preferredWidth: 250
            wrapMode: Text.WordWrap
        }

        Item {
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("City alias")
            enabled: compactItemsEnabled && cityAliasEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.columnSpan: 1
        }

        Item {
            enabled: compactItemsEnabled && cityAliasEnabled
            width: 2
            height: 2
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Size mode") + ":"
            enabled: compactItemsEnabled && cityAliasEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        SizeModeComboBox {
            enabled: compactItemsEnabled && cityAliasEnabled
            Layout.columnSpan: 2

            currentIndex: cfg_cityAliasSizeMode
            onCurrentIndexChanged: {
                if (currentIndex < 0 || currentIndex >= model.length) {
                    return
                }
                cfg_cityAliasSizeMode = currentIndex
            }
        }

        Label {
            text: i18n("Font") + ":"
            enabled: compactItemsEnabled && cityAliasEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        Button {
            icon.name: 'configure'
            enabled: compactItemsEnabled && cityAliasEnabled

            Layout.columnSpan: 1

            onClicked: {
                fontDialog.font = Qt.font({
                    family: cfg_cityAliasFontName,
                    pointSize: cfg_cityAliasFontSize
                })
                fontDialog.onAccepted.connect(onAccepted)
                fontDialog.visible = true
            }

            function onAccepted() {
                cfg_cityAliasFontName = fontDialog.font.family
                cfg_cityAliasFontSize = fontDialog.font.pointSize
                dbgprint('cfg_cityAliasFontSize', cfg_cityAliasFontSize)
                fontDialog.visible = false
                fontDialog.onAccepted.disconnect(onAccepted)
            }
        }

        Item {
            width: 2
            height: 2
            enabled: compactItemsEnabled && cityAliasEnabled
            visible: cfg_cityAliasSizeMode === 1
            Layout.columnSpan: 1
        }

        Label {
            text: i18n("Fixed size") + ":"
            enabled: compactItemsEnabled && cityAliasEnabled
            visible: cfg_cityAliasSizeMode === 1
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        SpinBox {
            id: cityAliasFixedSize
            enabled: compactItemsEnabled && cityAliasEnabled
            visible: cfg_cityAliasSizeMode === 1

            Layout.columnSpan: 1

            stepSize: 1
            from: 0
            to: 1024
            textFromValue: function(value, locale) {
                var suffix = i18nc("Abbreviation for pixels", "px")
                return qsTr("%1 %2").arg(value).arg(suffix)
            }
            valueFromText: function(text) {
                let data = text.split(" ")
                if (data.length < 1) {
                    return 0
                }
                return data[0]
            }
        }

        Item {
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Temperature")
            enabled: compactItemsEnabled && temperatureEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.columnSpan: 1
        }

        Item {
            enabled: compactItemsEnabled && temperatureEnabled
            width: 2
            height: 2
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Size mode") + ":"
            enabled: compactItemsEnabled && temperatureEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        SizeModeComboBox {
            enabled: compactItemsEnabled && temperatureEnabled
            Layout.columnSpan: 2

            currentIndex: cfg_temperatureSizeMode
            onCurrentIndexChanged: {
                if (currentIndex < 0 || currentIndex >= model.length) {
                    return
                }
                cfg_temperatureSizeMode = currentIndex
            }
        }

        Label {
            text: i18n("Font") + ":"
            enabled: compactItemsEnabled && temperatureEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        Button {
            icon.name: 'configure'
            enabled: compactItemsEnabled && temperatureEnabled
            Layout.columnSpan: 1
            onClicked: {
                fontDialog.font = Qt.font({
                    family: cfg_temperatureFontName,
                    pointSize: cfg_temperatureFontSize
                })
                fontDialog.onAccepted.connect(onAccepted)
                fontDialog.visible = true
            }

            function onAccepted() {
                cfg_temperatureFontName = fontDialog.font.family
                cfg_temperatureFontSize = fontDialog.font.pointSize
                dbgprint('cfg_temperatureFontSize', cfg_temperatureFontSize)
                fontDialog.visible = false
                fontDialog.onAccepted.disconnect(onAccepted)
            }
        }

        Item {
            width: 2
            height: 2
            enabled: compactItemsEnabled && temperatureEnabled
            visible: cfg_temperatureSizeMode === 1
            Layout.columnSpan: 1
        }

        Label {
            text: i18n("Fixed size") + ":"
            enabled: compactItemsEnabled && temperatureEnabled
            visible: cfg_temperatureSizeMode === 1
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        SpinBox {
            id: temperatureFixedSize
            enabled: compactItemsEnabled && temperatureEnabled
            visible: cfg_temperatureSizeMode === 1

            Layout.columnSpan: 1

            stepSize: 1
            from: 0
            to: 1024
            textFromValue: function(value, locale) {
                var suffix = i18nc("Abbreviation for pixels", "px")
                return qsTr("%1 %2").arg(value).arg(suffix)
            }
            valueFromText: function(text) {
                let data = text.split(" ")
                if (data.length < 1) {
                    return 0
                }
                return data[0]
            }
        }

        Item {
            enabled: compactItemsEnabled && temperatureIconEnabled
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Temperature icon")
            enabled: compactItemsEnabled && temperatureIconEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.columnSpan: 1
        }

        Item {
            enabled: compactItemsEnabled && temperatureIconEnabled
            width: 2
            height: 2
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Size mode") + ":"
            enabled: compactItemsEnabled && temperatureIconEnabled
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        SizeModeComboBox {
            enabled: compactItemsEnabled && temperatureIconEnabled
            currentIndex: cfg_temperatureIconSizeMode
            model: [
                i18n("Fill"),
                i18n("Fixed Size"),
            ]

            onCurrentIndexChanged: {
                if (currentIndex < 0 || currentIndex >= model.length) {
                    return
                }
                cfg_temperatureIconSizeMode = currentIndex
            }
        }

        Item {
            enabled: compactItemsEnabled && temperatureIconEnabled
            width: 2
            height: 2
            Layout.columnSpan: 1
        }

        Label {
            text: i18n("Fixed size") + ":"
            enabled: compactItemsEnabled && temperatureIconEnabled
            visible: cfg_temperatureIconSizeMode === 1
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }

        SpinBox {
            id: temperatureIconFixedSize
            enabled: compactItemsEnabled && temperatureIconEnabled
            visible: cfg_temperatureIconSizeMode === 1

            Layout.columnSpan: 1

            stepSize: 1
            from: 0
            to: 1024
            textFromValue: function(value, locale) {
                var suffix = i18nc("Abbreviation for pixels", "px")
                return qsTr("%1 %2").arg(value).arg(suffix)
            }
            valueFromText: function(text) {
                let data = text.split(" ")
                if (data.length < 1) {
                    return 0
                }
                return data[0]
            }
        }

        Label {
            text: i18n("Symbolic icon")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.columnSpan: 1
        }
        CheckBox {
            id: temperatureIconTypeSymbolic
            checked: cfg_temperatureIconTypeSymbolic
            Layout.alignment: Qt.AlignLeft
            Layout.rowSpan: 1
            onCheckedChanged: cfg_temperatureIconTypeSymbolic = checked
        }

        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }

        FontDialog {
            id: fontDialog
            title: i18n("Choose a font")
            visible: false
        }

        Item {
            width: 2
            height: 2
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("In-Tray Settings")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font.bold: true
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Active timeout") + ":"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }

        SpinBox {
            id: inTrayActiveTimeoutSec
            property int decimals: 0
            stepSize: 10
            from: 10
            to: 8000
            textFromValue: function(value, locale) {
                var num = Number(value).toLocaleString(locale, 'f', inTrayActiveTimeoutSec.decimals)
                var suffix = i18nc("Abbreviation for seconds", "sec")
                return qsTr("%1 %2").arg(num).arg(suffix)
            }
            valueFromText: function(text) {
                let data = text.split(" ")
                if (data.length < 1) {
                    return 3600
                }
                return Number.fromLocaleString(data[0])
            }
        }

        Label {
            text: i18n("NOTE: After this timeout widget will be hidden in system tray until refreshed. You can always set the widget to be always \"Shown\" in system tray \"Entries\" settings.")
            font.pixelSize: theme.defaultFont.pixelSize - 2
            Layout.rowSpan: 3
            Layout.preferredWidth: 250
            wrapMode: Text.WordWrap
        }
        Item {
            width: 2
            height: 20
            Layout.columnSpan: 3
        }
    }
}
