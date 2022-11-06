import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1

Item {

    id: appearancePage
    property int cfg_layoutType
    property alias cfg_inTrayActiveTimeoutSec: inTrayActiveTimeoutSec.value
    property string cfg_widgetFontName: plasmoid.configuration.widgetFontName
    property string cfg_widgetFontSize: plasmoid.configuration.widgetFontSize
    property bool cfg_graphCurvedLine: plasmoid.configuration.graphCurvedLine
    property int cfg_colorPaletteType: plasmoid.configuration.colorPaletteType

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

    onCfg_colorPaletteTypeChanged: {
        switch (cfg_colorPaletteType) {
            default:
            case 0:
                colorPaletteTypeDefault.checked = true
                break;
            case 1:
                colorPaletteTypeProt.checked = true
                break;
            case 2:
                colorPaletteTypeDeut.checked = true
                break;
            case 3:
                colorPaletteTypeTrit.checked = true
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
        cfg_colorPaletteTypeChanged()
    }

    ButtonGroup {
        id: layoutTypeGroup
    }

    ButtonGroup {
        id: colorPaletteTypeGroup
    }

    GridLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        columns: 3

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Meteogram")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font.bold: true
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Smooth Graph Line:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }

        CheckBox {
            checked: cfg_graphCurvedLine
            onCheckedChanged: {
                cfg_graphCurvedLine = checked
            }
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Color palette")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
        RadioButton {
            id: colorPaletteTypeDefault
            ButtonGroup.group: colorPaletteTypeGroup
            text: i18n("Default")
            onCheckedChanged: if (checked) cfg_colorPaletteType = 0
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 1
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: colorPaletteTypeProt
            ButtonGroup.group: colorPaletteTypeGroup
            text: i18n("Protanopia")
            onCheckedChanged: if (checked) cfg_colorPaletteType = 1
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: colorPaletteTypeDeut
            ButtonGroup.group: colorPaletteTypeGroup
            text: i18n("Deuteranopia")
            onCheckedChanged: if (checked) cfg_colorPaletteType = 2
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 2
        }
        RadioButton {
            id: colorPaletteTypeTrit
            ButtonGroup.group: colorPaletteTypeGroup
            text: i18n("Tritanopia")
            onCheckedChanged: if (checked) cfg_colorPaletteType = 3
        }

        Label {
            text: i18n("Layout")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font.bold: true
            Layout.columnSpan: 3
        }
        Label {
            text: i18n("Layout type:")
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

        Label {
            text: i18n("In-Tray Settings")
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font.bold: true
            Layout.columnSpan: 3
        }

        Label {
            text: i18n("Active timeout:")
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
            text: i18n("Widget font style:")
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
            text: i18n("Widget font size:")
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
                var num = Number(value).toLocaleString(locale, 'f', inTrayActiveTimeoutSec.decimals)
                var suffix = i18nc("pixels", "px")
                return qsTr("%1 %2").arg(num).arg(suffix)
            }
        }
    }
}
