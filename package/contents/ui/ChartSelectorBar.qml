import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore


RowLayout {
    spacing: 0

    ChartSelectorButtons {
        selectedVarName: meteogram.y1VarName
        meteogram: fullRepresentation.meteogram
        meteogramModel: main.meteogramModel
        model: [
            { label: String.fromCodePoint(0xf078), varName: "dewPoint",
                tooltip: i18n("Dew Point")
            },
            { label: String.fromCodePoint(0xf055), varName: "feelsLike",
                tooltip: i18n("Feels Like")
            },
        ]
        callback: function callback(modelData) {
            if (meteogram.y1VarName === modelData.varName) {
                meteogram.y1VarName = ""
            } else {
                meteogram.y1VarName = modelData.varName
            }
        }

        Layout.alignment: Qt.AlignCenter
    }

    Label {
        text: "\uFF5C"
        color: main.theme.disabledTextColor
        Layout.leftMargin: 0
        Layout.rightMargin: 0
    }

    ChartSelectorButtons {
        radioButtonMode: false
        meteogram: fullRepresentation.meteogram
        meteogramModel: main.meteogramModel

        model: [
            { label: String.fromCodePoint(0x0023), varName: "precipitationAmount",
                tooltip: i18n("Precipitation Labels"),
                isSelected: plasmoid.configuration.renderPrecipitationLabels
            },
            { label: main.maxMeteogramHours === plasmoid.configuration.maxMeteogramHours ?
                        String.fromCodePoint(0xFF0B) :
                        String.fromCodePoint(0xFF0D) /*String.fromCodePoint(0x1F5D6)*/,
                varName: "maxMeteogramHours",
                tooltip: i18n("Chart all data"),
                hasVariable: true,
                isSelected: true,
            }
        ]
        callback: function callback(modelData, viewObj) {
            if (modelData.varName === "precipitationAmount") {
                let val = plasmoid.configuration.renderPrecipitationLabels
                plasmoid.configuration.renderPrecipitationLabels = !val
                viewObj.isSelected = plasmoid.configuration.renderPrecipitationLabels
                main.reloadMeteogram()
            } else if (modelData.varName === "maxMeteogramHours") {
                if (main.maxMeteogramHours == 1000) {
                    main.maxMeteogramHours = plasmoid.configuration.maxMeteogramHours
                } else {
                    main.maxMeteogramHours = 1000
                }
            }
        }

        Layout.alignment: Qt.AlignCenter
    }

    Label {
        text: "\uFF5C"
        color: main.theme.disabledTextColor
        Layout.leftMargin: 0
        Layout.rightMargin: 0
    }

    ChartSelectorButtons {
        selectedVarName: meteogram.y2VarName
        meteogram: fullRepresentation.meteogram
        meteogramModel: main.meteogramModel
        model: [
            { label: "\uf079", varName: "pressure", tooltip: i18n("Pressure") },
            { label: "\uf050", varName: "windSpeed", tooltip: i18n("Wind Speed") },
            { label: "\uf0cc", varName: "windGust", tooltip: i18n("Wind Gust") },
            { label: "\uf084", varName: "precipitationProb", tooltip: i18n("POP") },
            { label: "\uf00d", varName: "uvi", tooltip: i18n("UV Index") },
        ]
        callback: function callback(modelData) {
            if (meteogram.y2VarName === modelData.varName) {
                meteogram.y2VarName = ""
            } else {
                meteogram.y2VarName = modelData.varName
            }
        }

        Layout.alignment: Qt.AlignCenter
    }
}
