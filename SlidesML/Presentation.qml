import QtQuick 2.0
import SlidesML 1.0
//import SlidesML.Styles 1.0

Item {
  id: root

  property Component defaultLayout: Qt.createComponent("Layouts/TitleContent.qml")
  property Component defaultStyle: Qt.createComponent("Styles/Simple.qml")

  property variant slides: []
  property int currentSlideIndex
  property Slide currentSlide: slides[currentSlideIndex]
  property int __inputSlideIndex

  width: 800
  height: 600
  focus: true
  property real slideScale: Math.min(width / 800, height / 600)

  Component.onCompleted:
  {
    var slides = [];

    for(var i = 0; i < root.children.length; ++i)
    {
      var r = root.children[i];
      if (r.isSlideItem)
      {
        slides.push(r);
        r.slideNumber = slides.length
        r.scale = Qt.binding(function() { return slideScale} )
        r.x = Qt.binding(function() { return 0.5 * (width - slideScale * 800) })
        r.y = Qt.binding(function() { return 0.5 * (height - slideScale * 600) })
        r.transformOrigin = Item.TopLeft
      }
    }

    root.slides = slides;

    if (root.slides.length > 0)
    {
        root.currentSlideIndex = 0;
        root.slides[root.currentSlideIndex].visible = true;
    }
  }
  onCurrentSlideIndexChanged:
  {
    if(root.currentSlideIndex < 0) root.currentSlideIndex = 0
    if(root.currentSlideIndex >= root.slides.length) root.currentSlideIndex = root.slides.length - 1
    root.slides[root.currentSlideIndex].visible = true
    root.currentSlide.animation.moveToFirst()
  }

  function moveToSlide(slide_number)
  {
    if(slide_number == root.currentSlideIndex) return;
    root.slides[root.currentSlideIndex].visible = false;
    root.currentSlideIndex = slide_number
  }

  function next()
  {
    if(!currentSlide.animation.next())
    {
      moveToSlide(root.currentSlideIndex + 1)
    }
  }
  function previous()
  {
    if(!currentSlide.animation.previous())
    {
      moveToSlide(root.currentSlideIndex - 1)
      root.currentSlide.animation.moveToLast()
    }
  }

  Keys.onSpacePressed: next()
  Keys.onRightPressed: next()
  Keys.onLeftPressed: previous()
  Keys.onReturnPressed: { moveToSlide(__inputSlideIndex - 1); __inputSlideIndex = 0 }
  Keys.onPressed: {
    if(event.key == Qt.Key_Q && event.modifiers == Qt.ControlModifier)
    {
      Qt.quit()
    } else if(event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
    {
      __inputSlideIndex = 10 * __inputSlideIndex + (event.key - Qt.Key_0)
    } else if(event.key == Qt.Key_Backspace)
    {
      __inputSlideIndex /= 10
    }
  }
  Rectangle {
    z: -10000
    color: "black"
    anchors.fill: parent
  }

  Rectangle {
    x: 2
    y: 2
    width: slideInput.contentWidth + 2
    height: slideInput.contentHeight + 2
    color: "white"
    visible: __inputSlideIndex > 0
    radius: 2
    z: 1000
    Text {
      id: slideInput
      x: 1
      y: 1
      text: __inputSlideIndex
    }
  }

  MouseArea {
      id: mouseArea
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: {
          if (mouse.button == Qt.RightButton)
              previous()
          else
              next()
      }
      onPressAndHold: previous();
  }
}
