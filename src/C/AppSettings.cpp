#include "AppSettings.h"

AppSettings::AppSettings(QObject *parent) : QObject(parent), settings("QuantumCompiler", "DynamicsOfCelestialBodies") {}

void AppSettings::setValue(const QString &key, const QVariant &value) {
    settings.setValue(key, value);
}

QVariant AppSettings::getValue(const QString &key, const QVariant &defaultValue) {
    return settings.value(key, defaultValue);
}

void AppSettings::removeKey(const QString &key) {
    settings.remove(key);
}