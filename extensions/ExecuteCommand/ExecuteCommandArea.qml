import QtQuick 2.0
import QtQuick.Controls 1.0
import org.storyml.executecommand 1.0

Item {
  property alias program: executeCommand.program
  function start()
  {
    executeCommand.start()
  }
  ExecuteCommand
  {
    id: executeCommand
  }

  TextArea
  {
    anchors.fill: parent
    readOnly: true
    text: executeCommand.output
  }
}
