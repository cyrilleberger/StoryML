import QtQuick 2.0
import QtQuick.Window 2.0
import SlidesML 1.0

Window
{
  id: root
  property Component presentation
  property Presentation presentation_instance

  Rectangle
  {
    id: sideBar
    width: 0.2 * parent.width
    height: parent.height
    color: "black"
    Column
    {
      width: parent.width

      Text
      {
        color: "white"
        text: "Current slide:"
      }
      Loader
      {
        id: presentationCurrent
        sourceComponent: root.presentation
        width: parent.width
        height: 600 * (width / 800)
        onItemChanged:
        {
          item.videosEnabled             = false
          item.currentSlideIndexBinding  = Qt.binding(function() { return presentation_instance ? presentation_instance.currentSlideIndex : 0 } )
          item.animationFrameBinding     = Qt.binding(function() { return presentation_instance ? presentation_instance.animationFrame : 0 } )
        }
      }
      Text
      {
        color: "white"
        text: "Next slide:"
      }
      Loader
      {
        id: presentationNext
        sourceComponent: root.presentation
        width: parent.width
        height: 600 * (width / 800)
        onItemChanged:
        {
          item.animationsEnabled = false
          item.videosEnabled     = false
          item.currentSlideIndexBinding = Qt.binding(function() { return presentation_instance ? presentation_instance.currentSlideIndex + 1 : 0 } )
        }
      }
    }
    Text
    {
      id: clock
      anchors.bottom: parent.bottom
      color: "white"
      Timer
      {
        interval: 100; running: true; repeat: true;
        onTriggered: clock.timeChanged()
      }
      function timeChanged()
      {
        var date = new Date;
        clock.text = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds()
      }
      font.pixelSize: 20
    }
  }
  Text
  {
    anchors.top: parent.top
    anchors.left:sideBar.right
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    text: presentation_instance ? presentation_instance.currentSlide.notes : ""
    font.pixelSize: 30
  }
}
