TEMPLATE = app

QT += qml quick widgets KSyntaxHighlighting
CONFIG += C++11

SOURCES += main.cpp Extension.cpp
HEADERS += Extension.h

RESOURCES += StoryEditor.qrc ../StoryML/StoryML.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = ..

# Default rules for deployment.
include(../deployment.pri)
