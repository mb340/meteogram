import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.1

Item {

    id: appearancePage
    property int cfg_layoutType
    property alias cfg_inTrayActiveTimeoutSec: inTrayActiveTimeoutSec.value
    property string cfg_widgetFontName: plasmoid.configuration.widgetFontName
    property string cfg_widgetFontSize: plasmoid.configuration.widgetFontSize
    property int cfg_iconSetType: plasmoid.configuration.iconSetType

    property alias cfg_compactItemOrder: compactItemOrder.order

    onCfg_compactItemOrderChanged: {
        print(JSON.stringify(cfg_compactItemOrder))
    }

    onCfg_layoutTypeChanged: {
        switch (cfg_layoutType) {
        case 0:
            layoutTypeRadioHorizontal.checked = true;
            break;
        case 1:
            layoutTypeRadioVertical.checked = true;
            break;
        case 2:
            layoutTypeRadioCompact.checked = true;
            break;
        default:
        }
    }

    onCfg_iconSetTypeChanged: {
        switch (cfg_iconSetType) {
            default:
            case 0:
                iconSetErikFlowers.checked = true
                break;
            case 1:
                iconSetMetNo.checked = true
                break;
            case 2:
                iconSetBasmilius.checked = true
                break;
            case 3:
                iconSetBreeze.checked = true
                break;
        }
    }

    ListModel {
        id: fontsModel
        Component.onCompleted: {
            var arr = []
            arr.push({text: i18nc("Use default font", "Default"), value: ""})

            var fonts = Qt.fontFamilies()
            var foundIndex = 0
            for (var i = 0, j = fonts.length; i < j; ++i) {
                if (fonts[i] === cfg_widgetFontName) {
                  foundIndex = i
                }
                arr.push({text: fonts[i], value: fonts[i]})
            }
            append(arr)
            if (foundIndex > 0) {
                fontFamilyComboBox.currentIndex = foundIndex + 1
            }
        }
    }

    Component.onCompleted: {
        cfg_layoutTypeChanged()
        cfg_iconSetTypeChanged()
    }

    ButtonGroup {
        id: layoutTypeGroup
    }

    ButtonGroup {
        id: iconSetTypeGroup
    }

    GridLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 3

        /* spacer */
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 3
        }

        /* Icon Set - Erik Flowers */
        Label {
            text: i18n("Icon Set")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.rowSpan: 1
        }
        RadioButton {
            id: iconSetErikFlowers
            ButtonGroup.group: iconSetTypeGroup
            text: i18n("Erik Flowers Weather Icons")
            onCheckedChanged: if (checked) cfg_iconSetType = 0
            Layout.rowSpan: 1
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }

        /* Icon Set - Yr.no */
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: iconSetMetNo
            ButtonGroup.group: iconSetTypeGroup
            text: i18n("Yr.no Weather Symbols")
            onCheckedChanged: if (checked) cfg_iconSetType = 1
            Layout.rowSpan: 1
        }

        /* Icon Set - Basmilius */
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: iconSetBasmilius
            ButtonGroup.group: iconSetTypeGroup
            text: i18n("Basmilius Meteocons")
            onCheckedChanged: if (checked) cfg_iconSetType = 2
            Layout.rowSpan: 1
        }

        /* Icon Set - Breeze */
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: iconSetBreeze
            ButtonGroup.group: iconSetTypeGroup
            text: i18n("System icon theme")
            onCheckedChanged: if (checked) cfg_iconSetType = 3
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
        RadioButton {
            id: layoutTypeRadioHorizontal
            ButtonGroup.group: layoutTypeGroup
            text: i18n("Horizontal")
            onCheckedChanged: if (checked) cfg_layoutType = 0;
        }
        Label {
            text: i18n("NOTE: Setting layout type for in-tray plasmoid has no effect.")
            Layout.rowSpan: 3
            Layout.preferredWidth: 250
            wrapMode: Text.WordWrap
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: layoutTypeRadioVertical
            ButtonGroup.group: layoutTypeGroup
            text: i18n("Vertical")
            onCheckedChanged: if (checked) cfg_layoutType = 1;
        }
        RadioButton {
            id: layoutTypeRadioCompact
            ButtonGroup.group: layoutTypeGroup
            text: i18n("Compact")
            onCheckedChanged: if (checked) cfg_layoutType = 2;
        }

        Item {
            width: 2
            height: 20
            Layout.columnSpan: 3
        }

        Item {
            width: 2
            height: 20
            Layout.columnSpan: 1
        }

        CompactItemOrder {
            id: compactItemOrder
            Layout.fillWidth: true
            Layout.minimumHeight: childrenRect.height
            Layout.columnSpan: 2
        }

        Item {
            width: 2
            height: 20
            Layout.columnSpan: 1
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
            Layout.rowSpan: 3
            Layout.preferredWidth: 250
            wrapMode: Text.WordWrap
        }
        Item {
            width: 2
            height: 20
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Widget font style") + ":"
        }
        ComboBox {
            id: fontFamilyComboBox
            Layout.fillWidth: true
            currentIndex: 0
            Layout.minimumWidth: units.gridUnit * 10
            model: fontsModel
            textRole: "text"

            onCurrentIndexChanged: {
                if (model.count === undefined || model.count === 0) {
                    return
                }
                var current = model.get(currentIndex)
                if (current) {
                    cfg_widgetFontName = currentIndex === 0 ? "" : current.value
                }
            }
        }
        Item {
            width: 2
            height: 20
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Widget font size") + ":"
        }
        SpinBox {
            id: widgetFontSize
            property int decimals: 0
            stepSize: 1
            from: 4
            to: 48
            value: cfg_widgetFontSize
            onValueChanged: {
                cfg_widgetFontSize = widgetFontSize.value
            }
            textFromValue: function(value, locale) {
                var num = Number(value).toLocaleString(locale, 'f', widgetFontSize.decimals)
                var suffix = i18nc("pixels", "px")
                return qsTr("%1 %2").arg(num).arg(suffix)
            }
            valueFromText: function(text) {
                let data = text.split(" ")
                if (data.length < 1) {
                    return 32
                }
                return Number.fromLocaleString(data[0])
            }
        }
    }
}
