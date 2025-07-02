#pragma once
#include <QDesktopServices>
#include <QStandardPaths>
#include <QDebug>
#include <QDir>
#include <QUrl>

class AppFiles : public QObject {
    Q_OBJECT
public:
    explicit AppFiles(QObject *parent = nullptr);

    void createSubAppDirectory(const QString &folderName);

    Q_INVOKABLE QString getApplicationDocumentsDirectory();
    Q_INVOKABLE void openApplicationDocumentsDirectory();
};