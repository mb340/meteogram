/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "utils"

Item {
    id: compactRepresentation

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
                                | PlasmaCore.Types.ConfigurableBackground

    CompactItem {
        id: compactItem
    }

    // Rectangle {
    //     anchors.fill: parent
    //     color: "red"
    //     z: -1
    //     visible: false
    // }

    // Rectangle {
    //     anchors.fill: compactItem
    //     color: "green"
    //     z: -1
    //     visible: false
    // }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: plasmoid.expanded = !plasmoid.expanded
    }

    BusyIndicator {
        anchors.fill: parent
        running: reloadTimer.state === ReloadTimer.State.LOADING
    }

}
