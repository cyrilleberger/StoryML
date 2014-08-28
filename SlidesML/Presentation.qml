import QtQuick 2.0
import SlidesML 1.0
//import SlidesML.Styles 1.0

Item {
  id: root

  property Component defaultLayout: Qt.createComponent("Layouts/TitleContent.qml")
  property Component defaultStyle: Qt.createComponent("Styles/Simple.qml")

  property variant slides: []
  property int currentSlide

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
