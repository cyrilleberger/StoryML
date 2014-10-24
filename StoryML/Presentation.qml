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
import StoryML 1.0

Item {
  id: root

  property Component defaultLayout: Qt.createComponent("Layouts/TitleContent.qml")
  property Component defaultStyle: Qt.createComponent("Styles/Simple.qml")
  property Component defaultSectionStyle: defaultStyle
  property Component defaultSubsectionStyle: defaultSectionStyle

  property variant slices: []
  property int currentSliceIndex: -1
  property int currentSliceIndexBinding: -1
  property int __previousSliceIndex: 0
  property Slice currentSlice: slices[currentSliceIndex]
  property Slice __previousSlice: slices[__previousSliceIndex]
  property int __inputSliceIndex
  property bool animationsEnabled: true
  property bool videosEnabled: true
  property int animationFrame
  property int animationFrameBinding
  property var sections: []

  width: 800
  height: 600
  focus: true
  property real sliceScale: Math.min(width / 800, height / 600)

  Component.onCompleted:
  {
    var slices = [];
    var sections = [];
    var currentSub = [];

    for(var i = 0; i < root.children.length; ++i)
    {
      var r = root.children[i];
      if (r.isSliceItem)
      {
        slices.push(r);
        r.sliceNumber = slices.length
        r.scale = Qt.binding(function() { return sliceScale} )
        r.x = Qt.binding(function() { return 0.5 * (width - sliceScale * 800) })
        r.y = Qt.binding(function() { return 0.5 * (height - sliceScale * 600) })
        r.transformOrigin = Item.TopLeft

        if(r.isSection)
        {
          if(currentSub.length > 0)
          {
            sections.push(currentSub)
            currentSub = []
          }
          sections.push(r.title)
        }
        if(r.isSubsection)
        {
          currentSub.push(r.title)
        }
      }
    }
    if(currentSub.length > 0)
    {
      sections.push(currentSub)
      currentSub = []
    }
    root.slices   = slices;
    root.sections = sections;

    if (root.slices.length > 0)
    {
      root.currentSliceIndex = 0;
      root.slices[root.currentSliceIndex].animation.frame = 0
      root.slices[root.currentSliceIndex].opacity = 1;
    }
  }
  onAnimationFrameBindingChanged:
  {
    animationFrame = animationFrameBinding
    if(animationFrame != currentSlice.animation.frame)
    {
      currentSlice.animation.frame = animationFrame
    }
  }
  onCurrentSliceIndexBindingChanged:
  {
    currentSliceIndex = currentSliceIndexBinding
  }
  onCurrentSliceIndexChanged:
  {
    if(root.currentSliceIndex < 0) root.currentSliceIndex = 0
    if(root.currentSliceIndex >= root.slices.length) root.currentSliceIndex = root.slices.length - 1

    if(root.currentSliceIndex != root.__previousSliceIndex)
    {
      root.__previousSlice.opacity = 0;
      root.__previousSlice.animation.frame = -1
      root.currentSlice = root.slices[root.currentSliceIndex]
      root.currentSlice.opacity = 1
      if(animationsEnabled)
      {
        root.currentSlice.animation.moveToFirst()
      } else {
        root.currentSlice.animation.moveToLast()
      }
      root.__previousSliceIndex = root.currentSliceIndex
    }
    animationFrame = currentSlice ? currentSlice.animation.frame : 0
  }

  function next()
  {
    if(!animationsEnabled || !currentSlice.animation.next())
    {
      currentSliceIndex = root.currentSliceIndex + 1
    } else {
      animationFrame = currentSlice.animation.frame
    }
  }
  function previous()
  {
    if(!animationsEnabled || !currentSlice.animation.previous())
    {
      currentSliceIndex = root.currentSliceIndex - 1
      if(animationsEnabled) root.currentSlice.animation.moveToLast()
    } else {
      animationFrame = currentSlice.animation.frame
    }
  }

  Keys.onSpacePressed: next()
  Keys.onRightPressed: next()
  Keys.onLeftPressed: previous()
  Keys.onReturnPressed: { root.currentSliceIndex = __inputSliceIndex - 1; __inputSliceIndex = 0 }
  Keys.onPressed: {
    if(event.key == Qt.Key_Q && event.modifiers == Qt.ControlModifier)
    {
      Qt.quit()
    } else if(event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
    {
      __inputSliceIndex = 10 * __inputSliceIndex + (event.key - Qt.Key_0)
    } else if(event.key == Qt.Key_Backspace)
    {
      __inputSliceIndex /= 10
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
    width: sliceInput.contentWidth + 2
    height: sliceInput.contentHeight + 2
    color: "white"
    visible: __inputSliceIndex > 0
    radius: 2
    z: 1000
    Text {
      id: sliceInput
      x: 1
      y: 1
      text: __inputSliceIndex
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
