import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.0
import SlidesML.Viewer 1.0

ApplicationWindow
{
  id: root
  title: "Slides"
  width: 200
  height: 150
  property Component presentation

  function __createPrintWindow()
  {
    var pw = null;
    try {
      pw = Qt.createQmlObject("import SlidesML.Viewer 1.0; PrintWindow {}", root)
    } catch(except)
    {

    }
    return pw;
  }

  property Window __printWindow: __createPrintWindow()

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
        ToolButton
        {
          iconName: "application-pdf"
          enabled: presentation
          visible: root.__printWindow
          onClicked:
          {
            printOptions.visible = true
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

  Item
  {
    id: printOptions
    visible: false
    anchors.fill: parent

    onVisibleChanged: {
      printButton.enabled = true
    }

    GridLayout
    {
      columns: 2
      Label {
        text: "Filename:"
      }
      TextField
      {
        id: filename
        text: "output.pdf"
      }
      Label {
        text: "Rows:"
      }
      SpinBox
      {
        id: rows
        value: 2
        minimumValue: 1
        maximumValue: 10
      }
      Label {
        text: "Columns:"
      }
      SpinBox
      {
        id: columns
        value: 2
        minimumValue: 1
        maximumValue: 10
      }
      Label {
        text: "Margin:"
      }
      SpinBox
      {
        id: margin
        value: 20
        minimumValue: 0
        maximumValue: 100
      }
      Button
      {
        id: printButton
        text: "Print"
        onClicked:
        {
          root.__printWindow.presentation             = root.presentation
          root.__printWindow.printer.filename         = filename.text
          root.__printWindow.printer.miniPage.columns = columns.value
          root.__printWindow.printer.miniPage.rows    = rows.value
          root.__printWindow.printer.miniPage.margin  = margin.value
          root.__printWindow.startPrinting()
          printButton.enabled = false
        }
      }
    }


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
    presentation_instance: presentationWindow.presentation_instance
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
