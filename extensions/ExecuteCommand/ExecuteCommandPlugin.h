#ifndef EXECUTECOMMANDPLUGIN_H
#define EXECUTECOMMANDPLUGIN_H

#include <QQmlExtensionPlugin>

class ExecuteCommandPlugin : public QQmlExtensionPlugin
{
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
  void registerTypes(const char *uri);
};

#endif // EXECUTECOMMANDPLUGIN_H
