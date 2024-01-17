import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: Qt.resolvedUrl('../images/weather-widget.svg')
         source: 'config/ConfigGeneral.qml'
    }
    ConfigCategory {
         name: i18n("Appearance")
         icon: 'preferences-desktop-color'
         source: 'config/ConfigAppearance.qml'
    }
    ConfigCategory {
         name: i18n("Meteogram")
         icon: 'office-chart-line'
         source: 'config/ConfigMeteogram.qml'
    }
    ConfigCategory {
         name: i18n("Units")
         icon: 'plugins'
         source: 'config/ConfigUnits.qml'
    }
}
