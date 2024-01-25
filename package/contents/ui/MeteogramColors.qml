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
import org.kde.kirigami as Kirigami


QtObject {

    property int colorPaletteType: plasmoid.configuration.colorPaletteType

    property var palette: defaultPalette
    property var paletteDark: defaultPaletteDark

    enum PaletteType {
        Default,
        Prot,
        Deut,
        Trit,
        Custom
    }

    /*
     * 4.5 contrast ratio for temperature colors
     * 7.0 contrast ratio for others
     * 1.5 contrast ratio for cloudarea
     * 4.0 contrast ratio for cloudarea2
     */
    property QtObject defaultPalette: Palette {
        // id: defaultPalette
        backgroundColor: "#FFFFFFFF"
        pressureColor: "#FF006800"
        temperatureWarmColor: "#FFEE0000"
        temperatureColdColor: "#FF0071f2"
        rainColor: "#FF0059A6"
        cloudAreaColor: "#50d3d3d3"
        cloudAreaColor2: "#506c6c6c"
        humidityColor: "#FF6105FF"
    }

    property QtObject defaultPaletteDark: Palette {
        // id: defaultPaletteDark
        backgroundColor: "#FF000000"
        pressureColor: "#FF00AE00"
        temperatureWarmColor: "#FFEA0000"
        temperatureColdColor: "#FF0071ea"
        rainColor: "#FF1B98FF"
        cloudAreaColor: "#50b3b3b3"
        cloudAreaColor2: "#506c6c6c"
        humidityColor: "#FFAB7BFF"
    }

    /*
     * red-green
     */
    property QtObject protPalette: Palette {
        // id: protPalette
        backgroundColor: "#FFFFFFFF"
        pressureColor: "#9F0162"
        temperatureWarmColor: "#E20134"
        temperatureColdColor: "#E20134"
        rainColor: "#8400CD"
        cloudAreaColor: defaultPalette.cloudAreaColor
        cloudAreaColor2: defaultPalette.cloudAreaColor2
        humidityColor: "#008DF9"
    }

    property QtObject protPaletteDark: Palette {
        // id: protPaletteDark
        backgroundColor: "#FF000000"
        pressureColor: "#00FCCF"
        temperatureWarmColor: "#FFC33B"
        temperatureColdColor: "#FFC33B"
        rainColor: "#008DF9"
        cloudAreaColor: defaultPaletteDark.cloudAreaColor
        cloudAreaColor2: defaultPaletteDark.cloudAreaColor2
        humidityColor: "#00C2F9"
    }

    /*
     * blue-yellow
     */
    property QtObject tritPalette: Palette {
        // id: tritPalette
        backgroundColor: "#FFFFFFFF"
        pressureColor: "#8400CD"
        temperatureWarmColor: "#E20134"
        temperatureColdColor: "#E20134"
        rainColor: "#00C2F9"
        cloudAreaColor: defaultPalette.cloudAreaColor
        cloudAreaColor2: defaultPalette.cloudAreaColor2
        humidityColor: "#008DF9"
    }

    property QtObject tritPaletteDark: Palette {
        // id: tritPaletteDark
        backgroundColor: "#FF000000"
        pressureColor: "#FFB2FD"
        temperatureWarmColor: "#FF6E3A"
        temperatureColdColor: "#FF6E3A"
        rainColor: "#00C2F9"
        cloudAreaColor: defaultPaletteDark.cloudAreaColor
        cloudAreaColor2: defaultPaletteDark.cloudAreaColor2
        humidityColor: "#008DF9"
    }

    onColorPaletteTypeChanged: {
        main.reloadMeteogram()
    }

    function backgroundColor() {
        if (colorPaletteType == MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.backgroundColor :
                                    plasmoid.configuration.backgroundColorDark
        }
        return getPalette().backgroundColor
    }

    function pressureColor(colorLight) {
        if (colorPaletteType == MeteogramColors.PaletteType.Custom) {
            let lightMode = colorLight !== undefined ? colorLight : main.theme.meteogram.isLightMode
            return !lightMode ? plasmoid.configuration.pressureColor :
                                    plasmoid.configuration.pressureColorDark
        }
        return getPalette().pressureColor
    }

    function temperatureWarmColor() {
        if (colorPaletteType == MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.temperatureWarmColor :
                                    plasmoid.configuration.temperatureWarmColorDark
        }
        return getPalette().temperatureWarmColor
    }

    function temperatureColdColor() {
        if (colorPaletteType === MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.temperatureColdColor :
                                    plasmoid.configuration.temperatureColdColorDark
        }
        return getPalette().temperatureColdColor
    }

    function rainColor() {
        if (colorPaletteType === MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.rainColor :
                                    plasmoid.configuration.rainColorDark
        }
        return getPalette().rainColor
    }

    function cloudAreaColor() {
        if (colorPaletteType === MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.cloudAreaColor :
                                    plasmoid.configuration.cloudAreaColorDark
        }
        return getPalette().cloudAreaColor
    }

    function cloudAreaColor2() {
        if (colorPaletteType === MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.cloudAreaColor2 :
                                    plasmoid.configuration.cloudAreaColor2Dark
        }
        return getPalette().cloudAreaColor2
    }

    function humidityColor() {
        if (colorPaletteType === MeteogramColors.PaletteType.Custom) {
            return !main.theme.meteogram.isLightMode ? plasmoid.configuration.humidityColor :
                                    plasmoid.configuration.humidityColorDark
        }
        return getPalette().humidityColor
    }

    function getPalette() {
        switch (colorPaletteType) {
            case MeteogramColors.PaletteType.Prot:     // prot
            case MeteogramColors.PaletteType.Deut:     // deut
                return main.theme.meteogram.isLightMode ? protPaletteDark : protPalette
            case MeteogramColors.PaletteType.Trit:     // trit
                return main.theme.meteogram.isLightMode ? tritPaletteDark : tritPalette
            case MeteogramColors.PaletteType.Custom:
                return null
            case MeteogramColors.PaletteType.Default:
            default:
                return main.theme.meteogram.isLightMode ? paletteDark : palette
        }
    }
}
