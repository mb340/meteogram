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
 import QtQuick 2.0


Item {

    property int colorPaletteType: plasmoid.configuration.colorPaletteType

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5
    property var palette: defaultPalette
    property var paletteDark: defaultPaletteDark

    /*
     * 4.5 contrast ratio for temperature colors
     * 7.0 contrast ratio for others
     * 1.5 contrast ratio for cloudarea
     * 4.0 contrast ratio for cloudarea2
     */
    Item {
        id: defaultPalette
        property color pressureColor: "#FF006800"
        property color temperatureWarmColor: "#FFEE0000"
        property color temperatureColdColor: "#FF0071f2"
        property color rainColor: "#FF0059A6"
        property color cloudAreaColor: "#50d3d3d3"
        property color cloudAreaColor2: "#506c6c6c"
        property color humidityColor: "#FF6105FF"
    }

    Item {
        id: defaultPaletteDark
        property color pressureColor: "#FF00AE00"
        property color temperatureWarmColor: "#FFEA0000"
        property color temperatureColdColor: "#FF0071ea"
        property color rainColor: "#FF1B98FF"
        property color cloudAreaColor: "#50b3b3b3"
        property color cloudAreaColor2: "#506c6c6c"
        property color humidityColor: "#FFAB7BFF"
    }

    /*
     * red-green
     */
    Item {
        id: protPalette
        property color pressureColor: "#9F0162"
        property color temperatureWarmColor: "#E20134"
        property color temperatureColdColor: "#E20134"
        property color rainColor: "#8400CD"
        property color cloudAreaColor: defaultPalette.cloudAreaColor
        property color cloudAreaColor2: defaultPalette.cloudAreaColor2
        property color humidityColor: "#008DF9"
    }

    Item {
        id: protPaletteDark
        property color pressureColor: "#00FCCF"
        property color temperatureWarmColor: "#FFC33B"
        property color temperatureColdColor: "#FFC33B"
        property color rainColor: "#008DF9"
        property color cloudAreaColor: defaultPaletteDark.cloudAreaColor
        property color cloudAreaColor2: defaultPaletteDark.cloudAreaColor2
        property color humidityColor: "#00C2F9"
    }

    /*
     * blue-yellow
     */
    Item {
        id: tritPalette
        property color pressureColor: "#8400CD"
        property color temperatureWarmColor: "#E20134"
        property color temperatureColdColor: "#E20134"
        property color rainColor: "#00C2F9"
        property color cloudAreaColor: defaultPalette.cloudAreaColor
        property color cloudAreaColor2: defaultPalette.cloudAreaColor2
        property color humidityColor: "#008DF9"
    }

    Item {
        id: tritPaletteDark
        property color pressureColor: "#FFB2FD"
        property color temperatureWarmColor: "#FF6E3A"
        property color temperatureColdColor: "#FF6E3A"
        property color rainColor: "#00C2F9"
        property color cloudAreaColor: defaultPaletteDark.cloudAreaColor
        property color cloudAreaColor2: defaultPaletteDark.cloudAreaColor2
        property color humidityColor: "#008DF9"
    }

    onColorPaletteTypeChanged: {
        print("onColorPaletteTypeChanged")
        main.alreadyLoadedFromCache = false
        main.loadFromCache()
    }

    function pressureColor() {
        return getPalette().pressureColor
    }

    function temperatureWarmColor() {
        return getPalette().temperatureWarmColor
    }

    function temperatureColdColor() {
        return getPalette().temperatureColdColor
    }

    function rainColor() {
        return getPalette().rainColor
    }

    function cloudAreaColor() {
        return getPalette().cloudAreaColor
    }

    function cloudAreaColor2() {
        return getPalette().cloudAreaColor2
    }

    function humidityColor() {
        return getPalette().humidityColor
    }

    function getPalette() {
        switch (colorPaletteType) {
            case 1:     // prot
            case 2:     // deut
                return textColorLight ? protPaletteDark : protPalette
            case 3:     // trit
                return textColorLight ? tritPaletteDark : tritPalette
            case 0:
            default:
                return textColorLight ? paletteDark : palette
        }
    }
}
