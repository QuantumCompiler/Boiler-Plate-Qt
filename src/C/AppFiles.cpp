#include "AppFiles.h"

AppFiles::AppFiles(QObject *parent) : QObject(parent) {}

QString AppFiles::getApplicationDocumentsDirectory() {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(path);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return path;
};

void AppFiles::openApplicationDocumentsDirectory() {
    QString path = AppFiles::getApplicationDocumentsDirectory();
    QDesktopServices::openUrl(QUrl::fromLocalFile(path));
}

void AppFiles::createSubAppDirectory(const QString &folderName) {
    QString basePath = AppFiles::getApplicationDocumentsDirectory();
    QDir dir(basePath);
    if (!dir.exists(folderName)) {
        dir.mkpath(folderName);
    }
}