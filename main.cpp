#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "DataModel.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DataModel userDataModel("UserProgram");
    DataModel systemDataModel("SystemProgram");

    engine.rootContext()->setContextProperty("UserDataModel", &userDataModel);
    engine.rootContext()->setContextProperty("SystemDataModel", &systemDataModel);

    const QUrl url(u"qrc:/ProgramBar/Main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
