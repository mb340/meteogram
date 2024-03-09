import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "data_models"


Item {
    id: hourGrid

    property double hourItemWidth: nHours < 2 ? 0 : imageWidth / (nHours - 1)

    property var startTime: new Date(0)

    ManagedListModel {
        id: hourGridModel2
    }

    function setModel(startTime, endTime) {
        const MS_PER_HOUR = 60 * 60 * 1000
        let startHour = startTime.getHours()

        let date = new Date(startTime)

        let rem = startHour % meteogramCanvas.hourStep
        if (rem !== 0) {
            let step = meteogramCanvas.hourStep - rem
            date = new Date(Number(date) + (step * MS_PER_HOUR))
        }

        hourGridModel2.beginList()
        hourGridModel2.addItem({ date: date })

        while (true) {
            let step = meteogramCanvas.hourStep
            let rem = date.getHours() % step
            if (rem !== 0) {
                step = step - rem
            }
            date = new Date(Number(date) + (step * MS_PER_HOUR))
            if (date > endTime) {
                break
            }
            hourGridModel2.addItem({ date: date })
        }
        hourGridModel2.endList()
    }


    Repeater {
        id: hourGridRepeater

        model: fillModels ? hourGridModel2.model : []

        readonly property int oneHourMs: 60 * 60 * 1000

        delegate: Item {
            height: hourGrid.height
            width: 0

            x: timeScale.translate(date)
            y: 0

            property int hourFrom: date.getHours()
            property bool dayBegins: hourFrom === 0

            Rectangle {
                id: verticalLine

                width: dayBegins ? 2 : 1
                height: imageHeight


                color: dayBegins ? gridColorHighlight : gridColor
            }

            Label {
                id: hourText

                text: timeUtils.getHourText(hourFrom)
                font: Kirigami.Theme.smallFont
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight

                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 2
            }

            Loader {
                property bool doLoad: timeUtils.twelveHourClockEnabled &&
                                        (hourFrom === 0 || hourFrom === 12)

                sourceComponent: !doLoad ? undefined : hourSubLabel

                anchors.top: hourText.top
                anchors.left: hourText.right
                anchors.topMargin: 1
            }


            Component {
                id: hourSubLabel
                Label {
                    text: timeUtils.twelveHourClockEnabled ?
                                    timeUtils.getAmOrPm(hourFrom) : '00'
                    font.family: Kirigami.Theme.smallFont.family
                    font.pixelSize: 1024
                    minimumPixelSize: 1
                    fontSizeMode: Text.Fit
                    color: main.theme.isShowBackground ?
                                main.theme.disabledTextColor :
                                main.theme.textColor
                    opacity: main.theme.isShowBackground ? 1.0 : 0.60

                    width: hourText.width - 1
                    height: hourText.height

                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft
                }
            }

            Loader {
                property bool isMidnight: hourFrom === 0
                property double itemEndX: !isMidnight ? 0 : timeScale.translate(date) + labelWidth
                property bool doLoad: isMidnight && (itemEndX < hourGrid.width)

                sourceComponent: !doLoad ? undefined : dayLabel
            }

            Component {
                id: dayLabel
                Label {
                    text: !isMidnight ? "" : Qt.locale().dayName(date.getDay(), Locale.LongFormat)
                    font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                    font.pointSize: -1

                    anchors.top: parent.top
                    anchors.topMargin: -labelHeight
                    anchors.left: parent.left
                }
            }
        }
    }
}
