TEMPLATE = lib
TARGET = ExecuteCommand
QT += qml quick
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = org.storyml.executecommand

# Input
SOURCES += \
    ExecuteCommand.cpp \
    ExecuteCommandPlugin.cpp

HEADERS += \
    ExecuteCommand.h \
    ExecuteCommandPlugin.h

OTHER_FILES = qmldir \
    ExecuteCommandArea.qml \
    examples/ExecuteCommand.qml

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir ExecuteCommandArea.qml
unix {
    equals(PREFIX, "") {
      installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    } else {
      installPath = $${PREFIX}/lib/qt5/qml/$$replace(uri, \\., /)
    }
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}

