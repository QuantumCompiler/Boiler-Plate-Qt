#pragma once
#include <QObject>
#include <QSettings>
#include <QString>
#include <QVariant>

class AppSettings : public QObject {
    Q_OBJECT
public:
    explicit AppSettings(QObject *parent = nullptr);

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant getValue(const QString &key, const QVariant &defaultValue = QVariant());
    Q_INVOKABLE void removeKey(const QString &key);

private:
    QSettings settings;
};