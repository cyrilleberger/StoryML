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

StoryTeller {
  id: root


  property int currentSliceIndex: -1
  property int currentSliceIndexBinding: -1
  property int __previousSliceIndex: 0
  property Slice currentSlice: (root.slices.length > 0) ? slices[currentSliceIndex] : null
  property Slice __previousSlice: (root.slices.length > 0) ? slices[__previousSliceIndex] : null
  property int __inputSliceIndex
  property int animationFrame
  property int animationFrameBinding

  property variant slices: []
  property var sections: []

  function __sectionSlides(slices, section, sections)
  {
    var subs = [];

    __groupSlides(slices, section, subs)
    sections.push(section.title)
    if(subs.length > 0)
    {
      sections.push(subs)
    }
  }

  function __groupSlides(slices, group, subs)
  {
    if(!group) return;
    for(var i = 0; i < group.elements.length; ++i)
    {
      var element = group.elements[i]
      if(element.isSection)
      {
        __sectionSlides(slices, element, subs)
      } else if(element.isGroup)
      {
        __groupSlides(slices, element, subs)
      } else if(element.isSlice)
      {
        element.sliceNumber = slices.length + 1
        slices.push(element)
      } else {
        console.log("Linear.qml: unhandled ", element, " in __groupSlides")
      }
    }

  }

  function __updateSlices()
  {
    var slices = [];
    var sections = [];

    __groupSlides(slices, root.story, sections)
    root.slices   = slices;
    root.sections = sections;

    if (root.slices.length > 0)
    {
      root.currentSliceIndex = 0;
      root.slices[root.currentSliceIndex].animation.frame = 0
        root.slices[root.currentSliceIndex].opacity = 1;
        root.slices[root.currentSliceIndex].z = 1;
    }
  }

  onStoryChanged:
  {
    if(root.story.elements)
    {
      __updateSlices()
    }
    root.story.onElementsChanged.connect(root.__updateSlices)
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
      root.__previousSlice.z = 0
      root.__previousSlice.opacity = 0;
      root.__previousSlice.animation.frame = -1
      root.currentSlice = root.slices[root.currentSliceIndex]
      root.currentSlice.z = 1
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

  function onKeyPressed(event)
  {
    if(event.key === Qt.Key_Q && event.modifiers === Qt.ControlModifier)
    {
      Qt.quit()
    } else if(event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
    {
      __inputSliceIndex = 10 * __inputSliceIndex + (event.key - Qt.Key_0)
    } else if(event.key === Qt.Key_Backspace)
    {
      __inputSliceIndex /= 10
    } else if(event.key === Qt.Key_Return)
    {
      root.currentSliceIndex = __inputSliceIndex - 1
      __inputSliceIndex = 0
    } else if(event.key === Qt.Key_Space || event.key === Qt.Key_Right || event.key == Qt.Key_PageDown)
    {
      next();
    } else if(event.key === Qt.Key_Left || event.key == Qt.Key_PageUp)
    {
      previous();
    }
  }
  Rectangle {
    parent: story
    z: -10000
    color: "black"
    anchors.fill: parent
  }

  Rectangle {
    parent: story
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
  function onMouseClicked(mouse)
  {
    if (mouse.button === Qt.RightButton)
    {
      previous()
    } else {
      next()
    }
  }
}
