import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0
import StoryML 1.0
import StoryML.Viewer 1.0
import org.storyml.textedit 1.0

ApplicationWindow
{
  id: root
  title: "StoryML - " + __display_filename(presentationFileIO.url) + (modified ? "*" : "")
  width: 800
  height: 600
  visible: true

  function __presentationUrl()
  {
    return "file:///" + temporaryFile.fileName
  }

  function __createPrintWindow()
  {
    var pw = null;
    try {
      pw = Qt.createQmlObject("import StoryML.Viewer 1.0; PrintWindow {}", root)
    } catch(except)
    {

    }
    return pw;
  }

  property Window __printWindow: __createPrintWindow()

  property bool modified: false

  function save()
  {
    if(presentationFileIO.url.toString().length > 0)
    {
      presentationFileIO.content = editor.text
      presentationFileIO.writeFile()
      modified = false
    } else {
      saveFileDialog.open()
    }
  }
  function __display_filename(_url)
  {
    var str = _url.toString()
    if(str.length === 0)
    {
      return "New Presentation"
    }
    var pathArray = str.split('/')
    return pathArray[pathArray.length - 1]
  }

  Action {
      id: saveAction
      text: "&Save"
      shortcut: "Ctrl+S"
      iconName: "document-save"
      onTriggered: root.save()

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
            var presentation                = Qt.createComponent(root.__presentationUrl())
            notesView.presentation          = presentation
            presentationWindow.presentation = presentation
            notesWindow.showMaximized()
            presentationWindow.showFullScreen()
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
            editorItem.visible   = false
          }
        }
      }
    }
  FileDialog
  {
    id: openFileDialog
    nameFilters: [ "StoryML Presentation (*.storyml *.qml)" ]
    onAccepted:
      {
        presentationFileIO.readFile(fileUrl)
        editor.text   = presentationFileIO.content
        root.modified = false
      }
  }
  FileDialog
  {
    id: saveFileDialog
    selectExisting: false
    nameFilters: [ "StoryML Presentation (*.storyml *.qml)" ]
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
  TemporaryFile
  {
    id: temporaryFile
    property int counter: 0
    fileTemplate: presentationFileIO.url + "_" + counter + "_" + "_XXXXXX.qml";
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
          root.__printWindow.presentation             = Qt.createComponent(root.__presentationUrl())
          root.__printWindow.printer.filename         = filename.text
          root.__printWindow.printer.miniPage.columns = columns.value
          root.__printWindow.printer.miniPage.rows    = rows.value
          root.__printWindow.printer.miniPage.margin  = margin.value
          root.__printWindow.setEfficientMode(efficient.checked)

          root.__printWindow.startPrinting()
          printButton.enabled  = false
          printOptions.visible = false
          editorItem.visible   = true
        }
      }
    }
  }

  SplitView
  {
    id: editorItem
    anchors.fill: parent
    property int __currentIndexMaxValue
    property var __preview_items: [preview_1, preview_2]
    property bool validPresentation: __preview_items[1].item
    property int __errorLineNumber: -1
    property bool __uptodate: true

    property bool preview1Ready: preview_1.status == Loader.Ready && preview_1.item && preview_1.item.readyToTell
    property bool preview2Ready: preview_2.status == Loader.Ready && preview_2.item && preview_2.item.readyToTell

    property int currentSliceIndex: 0
    property StoryTeller currentStoryTeller

    onCurrentSliceIndexChanged: {
      if(preview1Ready && preview_1.z == 1)
      {
        preview_1.item.storyTeller.currentSliceIndex = currentSliceIndex
      }
      if(preview2Ready && preview_2.z == 1)
      {
        preview_2.item.storyTeller.currentSliceIndex = currentSliceIndex
      }
      currentIndexSpinBox.value = currentSliceIndex
    }

    onPreview1ReadyChanged: {
      if(preview1Ready)
      {
        errorText.visible = false
        preview_1.item.storyTeller.onCurrentSliceIndexChanged.connect(function () { editorItem.currentSliceIndex = preview_1.item.storyTeller.currentSliceIndex })
        preview_1.item.storyTeller.currentSliceIndex = editorItem.currentSliceIndex
        editorItem.__currentIndexMaxValue = preview_1.item.storyTeller.slices.length
        preview_1.z = 1
        preview_2.z = 0
        editorItem.__preview_items = [ preview_2, preview_1 ]
        editorItem.currentStoryTeller = preview_1.item.storyTeller
        editorItem.__updateIfNeeded()
      }
    }

    onPreview2ReadyChanged:
    {
      if(preview2Ready)
      {
        errorText.visible = false
        preview_2.item.storyTeller.onCurrentSliceIndexChanged.connect(function () { editorItem.currentSliceIndex = preview_2.item.storyTeller.currentSliceIndex })
        preview_2.item.storyTeller.currentSliceIndex = editorItem.currentSliceIndex
        editorItem.__currentIndexMaxValue = preview_2.item.storyTeller.slices.length
        preview_2.z = 1
        preview_1.z = 0
        editorItem.__preview_items = [ preview_1, preview_2 ]
        editorItem.currentStoryTeller = preview_2.item.storyTeller
        editorItem.__updateIfNeeded()
      }
    }

    function __updateIfNeeded()
    {
      if(!__uptodate
          && preview_1.status != Loader.Loading && (!preview_1.item || preview_1.item.readyToTell)
          && preview_2.status != Loader.Loading && (!preview_2.item || preview_2.item.readyToTell))
      {
        __uptodate = true
        temporaryFile.counter += 1
        temporaryFile.writeContent(editor.text)
        editorItem.__preview_items[0].source = root.__presentationUrl()
        editorItem.__preview_items[0].z = -1
      }
    }

    Item
    {
      id: sideBar
      width: 300
      height: editorItem.height
      Item
      {
        id: preview
        width: sideBar.width
        height: (600 * width) / 800
        Loader
        {
          id: preview_1
          clip: true
          asynchronous: true
          anchors.fill: parent
          onStatusChanged:
          {
            if(status == Loader.Error)
            {
              errorText.showComponentError(preview_1.sourceComponent, preview_1.source)
            }
          }
        }
        Loader
        {
          id: preview_2
          anchors.fill: parent
          clip: true
          asynchronous: true
          onStatusChanged:
          {
            if(status == Loader.Error)
            {
              errorText.showComponentError(preview_2.sourceComponent, preview_2.source)
            }
          }
        }
        Text
        {
          id: updatingLabel
          visible: preview_1.status == Loader.Loading || preview_2.status == Loader.Loading
          text: "Updating..."
          anchors.centerIn: parent
          z: 100
        }
      }
      Row
      {
        id: slideSelector
        anchors.top: preview.bottom
        width: sideBar.width
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
            editorItem.currentSliceIndex = value
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
            editorItem.currentSliceIndex = value
          }
        }
      }
      Rectangle
      {
        width: sideBar.width
        anchors.top: slideSelector.bottom
        anchors.bottom: errorRectangle.top
        anchors.bottomMargin: 3
        color: "white"
        Text
        {
          function __get_notes(notes, frame)
          {
            if(Array.isArray(notes))
            {
              return notes[Math.min(frame, notes.length - 1)]
            } else {
              return notes
            }
          }

          anchors.fill: parent
          text: editorItem.currentStoryTeller ? __get_notes(editorItem.currentStoryTeller.currentSlice.notes, editorItem.currentStoryTeller.animationFrame)  : ""
          wrapMode: Text.WordWrap
          font.pixelSize: 10
        }
      }

      Rectangle {
        id: errorRectangle
        width: sideBar.width
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
          function showComponentError(component, url)
          {
            var eS            = component.errorString().replace(new RegExp(url, "gm"), "Line")
            editorItem.__errorLineNumber = eS.match(/^Line:(.*?) /)[1]; // TODO array
            errorText.text    = eS.replace(/Line:/g, "")
            errorText.visible = true
          }
        }
      }
    }
    TextEditorArea
    {
      id: editor
      height: parent.height
      anchors.left: sideBar.right
      anchors.right: parent.right
      options.font.pointSize: 20
      options.font.family: "monospace"
      document.highlightingDefinition: "QML"
      text: "import QtQuick 2.0
import StoryML 1.0

Presentation {
  Slice
  {
  }
}
"
      onTextChanged:
      {
        root.modified         = true
        editorItem.__uptodate = false
        editorItem.__updateIfNeeded()
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
    if(Utils.endsWith(cmd_filename.toString(), ".qml") || Utils.endsWith(cmd_filename.toString(), ".storyml"))
    {
      presentationFileIO.readFile(cmd_filename)
      editor.text   = presentationFileIO.content
      root.modified = false
    }
  }
  MessageDialog
  {
    id: shouldSaveFile
    icon: StandardIcon.Question
    text: "File '" + __display_filename(presentationFileIO.url) + "' modified. Do you want to save it?"
    standardButtons: StandardButton.Yes | StandardButton.No
    onYes: root.save()
  }
  onClosing:
  {
    if(root.modified) shouldSaveFile.open()
  }
}
