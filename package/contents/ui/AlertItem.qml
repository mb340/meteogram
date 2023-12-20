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
import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid

GridLayout {
    id: alertItem
    columns: 1

    RowLayout {
        Text {
            text: i18n("Source") + ":"
            color: theme.textColor
            font.pixelSize: theme.smallFont ? theme.smallFont.pixelSize : 11 * 1
            font.pointSize: -1
        }
        Text {
            wrapMode: Text.WordWrap
            text: alertSenderName
            color: theme.textColor
        }
    }
    RowLayout {
        Text {
            text: i18n("Event") + ":"
            color: theme.textColor
            font.pixelSize: theme.smallFont ? theme.smallFont.pixelSize : 11 * 1
            font.pointSize: -1
        }
        Text {
            wrapMode: Text.WordWrap
            text: alertEvent
            color: theme.textColor
        }
    }
    RowLayout {
        Text {
            text: i18n("Start") + ":"
            color: theme.textColor
            font.pixelSize: theme.smallFont ? theme.smallFont.pixelSize : 11 * 1
            font.pointSize: -1
        }
        Text {
            wrapMode: Text.WordWrap
            text: alertStart.toLocaleString()
            color: theme.textColor
        }
    }
    RowLayout {
        Text {
            text: i18n("End") + ":"
            color: theme.textColor
            font.pixelSize: theme.smallFont ? theme.smallFont.pixelSize : 11 * 1
            font.pointSize: -1
        }
        Text {
            wrapMode: Text.WordWrap
            text: alertEnd.toLocaleString()
            color: theme.textColor

        }
    }
    ColumnLayout {
        Layout.preferredWidth: parent.width

        Text {
            text: i18n("Description") + ":"
            color: theme.textColor
            font.pixelSize: theme.smallFont ? theme.smallFont.pixelSize : 11 * 1
        }

        Rectangle {
            property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5
            color: textColorLight ? 'black' : 'white'

            property double descMargin: 5 * 1

            Layout.preferredWidth: alertItem.width - (2 * descMargin)
            Layout.preferredHeight: childrenRect.height
            Layout.leftMargin: descMargin
            Layout.rightMargin: descMargin

            Text {
                id: alertDescriptionText
                width: parent.width

                text: alertDescription
                color: theme.textColor
                wrapMode: Text.Wrap
                font.family: "Monospace"
            }
        }
    }
}