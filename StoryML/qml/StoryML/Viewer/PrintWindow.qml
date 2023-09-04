import QtQuick 2.0
import QtQuick.Window 2.0
import Cyqlops.Print 1.0

Window {
  id: root
  width: 800
  height: 600
  property Component presentation
  property Printer printer: Printer
  {
    window: root
    orientation: Printer.Landscape
    debugVerbose: false
  }
  signal printFinished()

  Loader
  {
    id: presentationCurrent
    sourceComponent: root.presentation
    width: parent.width
    height: 600 * (width / 800)
    onItemChanged:
    {
      item.videosEnabled             = false
      item.animationsEnabled = false
    }
  }
  Timer
  {
    id: printTimer
    repeat: true
    interval: 1000
    onTriggered: {
      if(!presentationCurrent.item.readyToTell) return;
      printer.printWindow()
      if(presentationCurrent.item.storyTeller.currentSliceIndex === presentationCurrent.item.storyTeller.slices.length - 1)
      {
        root.visible = false
        printTimer.stop()
        printer.endPrinting()
        root.printFinished()
      } else {
        printer.newPage()
        ++presentationCurrent.item.storyTeller.currentSliceIndex;
      }
    }
  }

  function startPrinting()
  {
    visible = true
    printer.beginPrinting()
    printTimer.start()
  }
  function setEfficientMode(v)
  {
    if(v)
    {
      printer.mode = Printer.EFFICIENT
    }
  }
}
