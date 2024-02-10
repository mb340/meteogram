import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami


Item {
    id: root

    Rectangle {
        color: 'green'
        anchors.fill: parent
        z: -1
        visible: false
    }

    property int nextDayItemSpacing: defaultFontPixelSize * 0.5

    property double nextDayItemWidth: (width / dailyWeatherModels.count) - (2 * nextDayItemSpacing)

    ListView {
        id: listView

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: hourLegend.right
        anchors.right: parent.right

        model: fillModels ? dailyWeatherModels.model : []
        orientation: Qt.Horizontal
        spacing: nextDayItemSpacing
        interactive: false

        property var now: undefined

        delegate: NextDayItem {
            width: nextDayItemWidth
            height: root.height

            titleHeight: nextDayTitleMetrics.height
            rowHeight: (root.height - titleHeight) / 4

            now: listView.now
        }

        Component.onCompleted: {
            main.beginLoadFromCache.connect(beginLoadFromCache)
            main.endLoadFromCache.connect(endLoadFromCache)
        }

        function beginLoadFromCache() {
        }

        function endLoadFromCache() {
            now = timeUtils.dateNow(timezoneType, main.timezoneOffset)
        }
    }

    TextMetrics {
        id: nextDayTitleMetrics
        font.family: Kirigami.Theme.defaultFont.family
        font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
        text: "MMMMMM"
    }

    Column {
        id: hourLegend

        // width: contentWidth

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        property double itemHeight: (hourLegend.height - nextDayTitleMetrics.height) / 4
        property double fontPixelSize: defaultFontPixelSize * 1.25

        Label {
            id: hourLegendSpacer
            text: " "
            height: nextDayTitleMetrics.height
        }

        Item {
            id: hourLegendLineSpacer
            width: 1
            height: 1
        }

        component HourLegendLabel: Label {
            height: parent.itemHeight
            font.family: 'weathericons'
            font.pixelSize: hourLegend.fontPixelSize
            font.pointSize: -1
            horizontalAlignment: Text.AlignCenter
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.6

            ToolTip.visible: mouseArea.containsMouse

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        HourLegendLabel {
            text: "\uf0d2"  // wi-moon-alt-waxing-crescent-3
            ToolTip.text: i18n("Night")
        }
        HourLegendLabel {
            text: "\uf051"  // wi-horizon-alt
            ToolTip.text: i18n("Morning")
        }
        HourLegendLabel {
            text: "\uf00d"  // wi-day-sunny
            ToolTip.text: i18n("Day")
        }
        HourLegendLabel {
            text: "\uf052"  // wi-horizon
            ToolTip.text: i18n("Evening")
        }
    }
}
