#include "plasmoidplugin.h"
#include "backend.h"

#include <QtQml>
#include <QDebug>

void PlasmoidPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.private.weatherWidget2"));
    
    qmlRegisterType<Backend>(uri, 2, 0, "Backend");
}
