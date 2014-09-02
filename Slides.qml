import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import SlidesML.Viewer 1.0

ApplicationWindow
{
  id: root
  title: "Slides"
  width: 200
  height: 150
  property Component presentation
  toolBar:
    ToolBar
    {
      RowLayout
      {
        ToolButton
        {
          iconName: "document-open"
          onClicked:
          {
            openFileDialog.open()
          }
        }
        ToolButton
        {
          iconName: "media-playback-start"
          enabled: presentation
          onClicked:
          {
            notesWindow.visible = true
            presentationWindow.visible = true
          }
        }
      }
    }
  FileDialog
  {
    id: openFileDialog
    nameFilters: [ "SlidesML Presentation (*.slidesml *.qml)" ]
    onAccepted:
      {
        presentation = Qt.createComponent(fileUrl)
      }
  }
  onPresentationChanged:
    {
    }

  PresentationWindow
  {
    id: presentationWindow
    visible: false
    presentation: root.presentation
    onPresentationClosed:
    {
      notesWindow.visible = false
      presentationWindow.visible = false
    }
  }
  NotesWindow
  {
    id: notesWindow
    visible: false
    presentation: root.presentation
  }
  function endsWith(str, pat)
  {
    var pos = str.length - pat.length
    return str.indexOf(pat, pos) == pos
  }

  Component.onCompleted:
  {
    var arg = Qt.application.arguments[Qt.application.arguments.length - 2]
    if(endsWith(arg, ".qml") || endsWith(arg, ".slidesml"))
    {
      presentation = Qt.createComponent(arg)
    }
  }
}
