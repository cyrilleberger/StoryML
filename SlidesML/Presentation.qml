/* Copyright (c) 2014, Cyrille Berger <cberger@cberger.net>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 */

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
  property bool animationsEnabled: true
  property bool videosEnabled: true
  property int animationFrame
  property int animationFrameBinding
  property var sections: []

  width: 800
  height: 600
  focus: true
  property real slideScale: Math.min(width / 800, height / 600)

  Component.onCompleted:
  {
    var slides = [];
    var sections = [];

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

        if(r.isSection)
        {
          sections.push(r.title)
        }
      }
    }

    root.slides   = slides;
    root.sections = sections;

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
      if(animationsEnabled)
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
    if(!animationsEnabled || !currentSlide.animation.next())
    {
      currentSlideIndex = root.currentSlideIndex + 1
    } else {
      animationFrame = currentSlide.animation.frame
    }
  }
  function previous()
  {
    if(!animationsEnabled || !currentSlide.animation.previous())
    {
      currentSlideIndex = root.currentSlideIndex - 1
      if(animationsEnabled) root.currentSlide.animation.moveToLast()
    } else {
      animationFrame = currentSlide.animation.frame
    }
  }

  Keys.onSpacePressed: next()
  Keys.onRightPressed: next()
  Keys.onLeftPressed: previous()
  Keys.onReturnPressed: { root.currentSlideIndex = __inputSlideIndex - 1; __inputSlideIndex = 0 }
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
