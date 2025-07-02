QT       += core gui qml quick quickcontrols2
CONFIG   += c++17                       
TEMPLATE  = app
TARGET    = main                       

SOURCES += src/C/main.cpp \
        src/C/AppSettings.cpp \
        src/C/AppFiles.cpp
HEADERS += src/C/AppSettings.h \
        src/C/AppFiles.h \
        src/C/SettingsKeys.h
RESOURCES += QML.qrc
