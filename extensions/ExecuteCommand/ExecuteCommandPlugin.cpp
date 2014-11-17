#include "ExecuteCommandPlugin.h"

#include "ExecuteCommand.h"
#include <qqml.h>

void ExecuteCommandPlugin::registerTypes(const char *uri)
{
  // @uri org.storyml.executecommand
  qmlRegisterType<ExecuteCommand>(uri, 1, 0, "ExecuteCommand");
}


