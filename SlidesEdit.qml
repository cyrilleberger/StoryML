import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.0
import SlidesML 1.0
import SlidesML.Viewer 1.0
import org.slidesml.textedit 1.0

ApplicationWindow
{
  id: root
  title: "SlidesML Edit"
  width: 800
  height: 600
  property url presentationUrl: temporaryPresentationFileIO.url

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

  Action {
      id: saveAction
      text: "&Save"
      shortcut: "Ctrl+S"
      iconName: "document-save"
      onTriggered:
      {
        if(presentationFileIO.url.toString().length > 0)
        {
          presentationFileIO.content = editor.text
          presentationFileIO.writeFile()
        } else {
          saveFileDialog.open()
        }
      }

      tooltip: "Save the presentation"
  }

  toolBar:
    ToolBar
    {
      RowLayout
      {
        ToolButton
        {
          text: "Open"
          iconName: "document-open"
          onClicked:
          {
            openFileDialog.open()
          }
        }
        ToolButton
        {
          action: saveAction
        }
        ToolButton
        {
          text: "Save as"
          iconName: "document-save-as"
          onClicked:
          {
            saveFileDialog.open()
          }
        }
        ToolButton
        {
          text: "Start presentation"
          iconName: "media-playback-start"
          enabled: editorItem.validPresentation
          onClicked:
          {
            var presentation                = Qt.createComponent(temporaryPresentationFileIO.url)
            notesView.presentation          = presentation
            presentationWindow.presentation = presentation
            notesWindow.visible             = true
            presentationWindow.visible      = true
          }
        }
        ToolButton
        {
          text: "Export to PDF"
          iconName: "application-pdf"
          enabled: editorItem.validPresentation
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
        presentationFileIO.readFile(fileUrl)
        editor.text = presentationFileIO.content
      }
  }
  FileDialog
  {
    id: saveFileDialog
    selectExisting: false
    nameFilters: [ "SlidesML Presentation (*.slidesml *.qml)" ]
    onAccepted:
      {
        presentationFileIO.content = editor.text
        presentationFileIO.writeFile(fileUrl)
      }
  }
  FileIO
  {
    id: presentationFileIO
  }
  FileIO
  {
    id: temporaryPresentationFileIO
    url: temporaryFile.fileName
  }
  TemporaryFile
  {
    id: temporaryFile
    fileTemplate: presentationFileIO.url + "_XXXXXX.qml";
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
      CheckBox
      {
        id: efficient
        text: "Efficient Mode"
        checked: false
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
          root.__printWindow.setEfficientMode(efficient.checked)

          root.__printWindow.startPrinting()
          printButton.enabled = false
        }
      }
    }
  }

  Item
  {
    id: editorItem
    anchors.fill: parent
    property int __currentIndexMaxValue
    property var __preview_items: [preview_1, preview_2]
    property bool validPresentation: __preview_items[1].item
    property int __errorLineNumber: -1
    Loader
    {
      id: preview_1
      width: 300
      height: 200
      clip: true
      asynchronous: true
      onStatusChanged:
      {
        if(status == Loader.Ready)
        {
          errorText.visible = false
          preview_1.item.currentSlideIndex = Qt.binding(function () { return currentIndexSpinBox.value })
          editorItem.__currentIndexMaxValue = preview_1.item.slides.length
          preview_1.z = 1
          preview_2.z = 0
          editorItem.__preview_items = [ preview_2, preview_1 ]
        } else if(status == Loader.Error)
        {
          errorText.showComponentError(preview_1.sourceComponent)
        }
      }
    }
    Loader
    {
      id: preview_2
      width: 300
      height: 200
      clip: true
      asynchronous: true
      onStatusChanged:
      {
        if(status == Loader.Ready)
        {
          errorText.visible = false
          preview_2.item.currentSlideIndex = Qt.binding(function () { return currentIndexSpinBox.value })
          editorItem.__currentIndexMaxValue = preview_2.item.slides.length
          preview_2.z = 1
          preview_1.z = 0
          editorItem.__preview_items = [ preview_1, preview_2 ]
        } else if(status == Loader.Error)
        {
          errorText.showComponentError(preview_2.sourceComponent)
        }
      }
    }
    Row
    {
      anchors.top: preview_1.bottom
      SpinBox
      {
        id: currentIndexSpinBox
        maximumValue: editorItem.__currentIndexMaxValue

        property bool __disableValueChanged: false
        onValueChanged: {
          if(__disableValueChanged) return;
          currentIndexSlider.__disableValueChanged = true;
          currentIndexSlider.value = value;
          currentIndexSlider.__disableValueChanged = false;
        }
      }
      Slider
      {
        id: currentIndexSlider

        maximumValue: editorItem.__currentIndexMaxValue
        property bool __disableValueChanged: false
        onValueChanged: {
          if(__disableValueChanged) return;
          currentIndexSpinBox.__disableValueChanged = true;
          currentIndexSpinBox.value = value;
          currentIndexSpinBox.__disableValueChanged = false;
        }
      }
    }

    Rectangle {
      id: errorRectangle
      width: preview_1.width
      height: 50
      color: "white"
      anchors.bottom: parent.bottom
      Text
      {
        id: errorText
        visible: false
        anchors.fill: parent
        color: "red"

        function setError(ex)
        {
          var text = ""
          for(var k in ex['qmlErrors'])
          {
            var err         = ex['qmlErrors'][k]
            text           += err['lineNumber'] + "," + err['columnNumber'] + ":" + err['message']
          }
          errorText.text    = text
          errorText.visible = true
        }
        function showComponentError(component)
        {
          var eS            = component.errorString().replace(new RegExp(temporaryPresentationFileIO.url, "gm"), "Line")
          editorItem.__errorLineNumber = eS.match(/^Line:(.*?) /)[1]; // TODO array
          errorText.text    = eS.replace(/Line:/g, "")
          errorText.visible = true
        }
      }
    }
    TextEditorArea
    {
      id: editor
      height: parent.height
      anchors.left: preview_1.right
      anchors.right: parent.right
      text: ""
      onTextChanged:
      {
        if(editorItem.__preview_items[0].status != Loader.Loading)
        {
          temporaryFile.regenerate()
          temporaryPresentationFileIO.content = editor.text
          temporaryPresentationFileIO.writeFile()
          editorItem.__preview_items[0].source = temporaryPresentationFileIO.url
          editorItem.__preview_items[0].z = -1
        }
      }
    }
  }


  PresentationWindow
  {
    id: presentationWindow
    visible: false
    width: 800
    height: 600
    onPresentationClosed:
    {
      notesWindow.visible = false
      presentationWindow.visible = false
    }
  }
  Window
  {
    id: notesWindow
    visible: false
    width: 800
    height: 600
    NotesView
    {
      id: notesView
      anchors.fill: parent
      presentation_instance: presentationWindow.presentation_instance
    }
  }
  Component.onCompleted:
  {
    var arg = Qt.application.arguments[Qt.application.arguments.length - 2]
    if(Utils.endsWith(arg, ".qml") || Utils.endsWith(arg, ".slidesml"))
    {
      presentation = Qt.createComponent(arg)
    }
  }
}
