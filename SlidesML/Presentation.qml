import QtQuick 2.0
import SlidesML 1.0
//import SlidesML.Styles 1.0

Item {
  id: root

  property Component defaultLayout: Qt.createComponent("Layouts/TitleContent.qml")
  property Component defaultStyle: Qt.createComponent("Styles/Simple.qml")

  property variant slides: []
  property int currentSlideIndex: -1
  property int currentSlideIndexBinding: -1
  property int __previousSlideIndex: 0
  property Slide currentSlide: slides[currentSlideIndex]
  property Slide __previousSlide: slides[__previousSlideIndex]
  property int __inputSlideIndex
  property bool animationEnabled: true
  property bool videosEnabled: true
  property int animationFrame
  property int animationFrameBinding

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
  onAnimationFrameBindingChanged:
  {
    animationFrame = animationFrameBinding
    if(animationFrame != currentSlide.animation.frame)
    {
      currentSlide.animation.frame = animationFrame
    }
  }
  onCurrentSlideIndexBindingChanged:
  {
    currentSlideIndex = currentSlideIndexBinding
  }
  onCurrentSlideIndexChanged:
  {
    if(root.currentSlideIndex < 0) root.currentSlideIndex = 0
    if(root.currentSlideIndex >= root.slides.length) root.currentSlideIndex = root.slides.length - 1

    if(root.currentSlideIndex != root.__previousSlideIndex)
    {
      root.__previousSlide.visible = false;
      root.currentSlide = root.slides[root.currentSlideIndex]
      root.currentSlide.visible    = true
      if(animationEnabled)
      {
        root.currentSlide.animation.moveToFirst()
      } else {
        root.currentSlide.animation.moveToLast()
      }
      root.__previousSlideIndex = root.currentSlideIndex
    }
    animationFrame = currentSlide ? currentSlide.animation.frame : 0
  }

  function next()
  {
    if(!animationEnabled || !currentSlide.animation.next())
    {
      currentSlideIndex = root.currentSlideIndex + 1
    } else {
      animationFrame = currentSlide.animation.frame
    }
  }
  function previous()
  {
    if(!animationEnabled || !currentSlide.animation.previous())
    {
      currentSlideIndex = root.currentSlideIndex - 1
      if(animationEnabled) root.currentSlide.animation.moveToLast()
    } else {
      animationFrame = currentSlide.animation.frame
    }
  }

  Keys.onSpacePressed: next()
  Keys.onRightPressed: next()
  Keys.onLeftPressed: previous()
  Keys.onReturnPressed: { root.currentSlide = __inputSlideIndex - 1; __inputSlideIndex = 0 }
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
