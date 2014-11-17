import QtQuick 2.0
import org.storyml.executecommand 1.0

ExecuteCommandArea
{
  program: "ls"
  Component.onCompleted: start()
}
