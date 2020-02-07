TEMPLATE = app

QT += qml quick widgets KSyntaxHighlighting
CONFIG += C++11

SOURCES += main.cpp Extension.cpp
HEADERS += Extension.h

RESOURCES += StoryML.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH = qml

#OTHER_FILES += qml/main.qml
#OTHER_FILES += qml/StoryML/* qml/StoryML/Components/* qml/StoryML/Components/Diagram/* qml/StoryML/Components/Lines/* qml/StoryML/Layouts/* qml/StoryML/StoryTellers/* qml/StoryML/Styles/* qml/StoryML/Viewer/*

target.path = "$${target.path}/bin"
INSTALLS += target
