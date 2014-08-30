import QtQuick 2.0
import SlidesML 1.0
//import SlidesML.Styles 1.0

Item {
  id: root

  property Component defaultLayout: Qt.createComponent("Layouts/TitleContent.qml")
  property Component defaultStyle: Qt.createComponent("Styles/Simple.qml")

  property variant slides: []
  property int currentSlide
  property int __inputSlideIndex

  width: 1024
  height: 880
  focus: true

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
      }
    }

    root.slides = slides;

    if (root.slides.length > 0)
    {
        root.currentSlide = 0;
        root.slides[root.currentSlide].visible = true;
    }
  }
  onCurrentSlideChanged:
  {
    if(root.currentSlide < 0) root.currentSlide = 0
    if(root.currentSlide >= root.slides.length) root.currentSlide = root.slides.length - 1
    root.slides[root.currentSlide].visible = true
  }

  function moveToSlide(slide_number)
  {
    if(slide_number == root.currentSlide) return;
    root.slides[root.currentSlide].visible = false;
    root.currentSlide = slide_number
  }

  function next()
  {
    moveToSlide(root.currentSlide + 1)
  }
  function previous()
  {
    moveToSlide(root.currentSlide - 1)
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
