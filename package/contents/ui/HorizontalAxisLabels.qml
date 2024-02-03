import QtQuick 2.5
import QtQuick.Controls 2.5
import "data_models"


Item {
    id: hourGrid

    property double hourItemWidth: nHours < 2 ? 0 : imageWidth / (nHours - 1)

    property var startTime: new Date(0)

    ManagedListModel {
        id: hourGridModel2
    }

    function setModel(startTime) {
        hourGrid.startTime = startTime
        let hour = startTime.getHours()
        let rem = hour % meteogramCanvas.hourStep
        if (rem != 0) {
            rem = meteogramCanvas.hourStep - rem
        }
        // print('startTime', startTime, 'hour', hour, 'hourStep', meteogramCanvas.hourStep, 'rem', rem)

        hourGridModel2.beginList()
        let i = rem
        for (; (i - rem) < root.nHours - rem; i += meteogramCanvas.hourStep) {
            hourGridModel2.addItem({ index: i })
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

            x: xAxisScale.translate(model.index)
            y: 0

            // function getDate(startTime, index, stepSize) {
            //     let date =  new Date(Number(startTime) + (index * stepSize))
            //     print(date)
            //     return date
            // }
            // property date date: getDate(hourGrid.startTime, model.index, hourGridRepeater.oneHourMs)

            property date date: new Date(Number(hourGrid.startTime) +
                                (model.index * hourGridRepeater.oneHourMs))


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
                font.pixelSize: theme.smallestFont.pixelSize
                font.pointSize: -1
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight

                anchors.top: parent.bottom
                anchors.right: parent.left
                anchors.topMargin: 2
            }

            Label {
                text: timeUtils.twelveHourClockEnabled ?
                                timeUtils.getAmOrPm(hourFrom) : '00'
                font.pixelSize: theme.smallestFont.pixelSize * 0.70
                font.pointSize: -1
                color: main.colors.isShowBackground ?
                            main.colors.disabledTextColor :
                            main.colors.textColor
                opacity: main.colors.isShowBackground ? 1.0 : 0.60

                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft

                anchors.top: hourText.top
                anchors.left: hourText.right
            }

            Loader {
                property bool isMidnight: hourFrom === 0
                property string dayStr: !isMidnight ? "" : Qt.locale().dayName(date.getDay(), Locale.LongFormat)
                property double itemEndX: !isMidnight ? 0 : timeScale.translate(date) + labelWidth
                property bool doLoad: isMidnight && (itemEndX < hourGrid.width)

                sourceComponent: !doLoad ? undefined : dayLabel
            }

            Component {
                id: dayLabel
                Label {
                    text: dayStr
                    font.pixelSize: theme.smallestFont.pixelSize
                    font.pointSize: -1

                    anchors.top: parent.top
                    anchors.topMargin: -labelHeight
                    anchors.left: parent.left
                }
            }
        }
    }
}