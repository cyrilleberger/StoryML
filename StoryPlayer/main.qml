import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.0
import StoryML 1.0
import StoryML.Viewer 1.0

ApplicationWindow
{
  id: root
  title: "StoryML Player"
  width: 800
  height: 600
  property Component presentation

  FileDialog
  {
    id: openFileDialog
    title: "Open Presentation"
    nameFilters: [ "StoryML Presentation (*.storyml *.qml)" ]
    onAccepted:
      {
        presentation = Qt.createComponent(fileUrl)
      }
  }

  PresentationWindow
  {
    id: presentationWindow
    visible: root.presentation
    presentation: root.presentation
    onPresentationClosed:
    {
      notesWindow.visible = false
      presentationWindow.visible = false
    }
  }
  NotesView
  {
    id: notesWindow
    visible: root.presentation
    anchors.fill: parent
    presentation: root.presentation
    presentation_instance: presentationWindow.presentation_instance
  }

  Component.onCompleted:
  {
    if(Utils.endsWith(cmd_filename.toString(), ".qml") || Utils.endsWith(cmd_filename.toString(), ".storyml"))
    {
      presentation = Qt.createComponent(cmd_filename)
    } else {
      openFileDialog.open()
    }

  }
}
