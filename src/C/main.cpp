#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSettings>

#include "AppSettings.h"
#include "AppFiles.h"

int main(int argc, char *argv[]) {
    // Application parameter setting
    QCoreApplication::setOrganizationName("QuantumCompiler");
    QCoreApplication::setApplicationName("BoilerPlateQt");
    QQuickStyle::setStyle("Material");
    AppSettings appSettings;
    AppFiles appFiles;

    // Qt Application instances
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Application context mappings
    engine.rootContext()->setContextProperty("appSettings", &appSettings);
    engine.rootContext()->setContextProperty("appFiles", &appFiles);

    // QML Singleton mappings
    qmlRegisterSingletonType(QUrl("qrc:/src/QML/Settings/Styles.qml"), "App.Styles", 1, 0, "Style");

    // Application execution
    engine.load(QUrl(QStringLiteral("qrc:src/QML/main.qml")));
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    // Additional application initiation
    appFiles.createSubAppDirectory("Data");

    return app.exec();
}
