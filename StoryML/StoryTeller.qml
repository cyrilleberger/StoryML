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

Item
{
  id: root

  property Item story // TODO: Item should be Slice, but this is recursive and crash...

  function onMouseClicked(mouse)
  {
  }
  function onKeyPressed(event)
  {
  }

  property int __slicesCount: 0
  property int __slicesReady: 0
  property bool readyToTell: root.__slicesCount == root.__slicesReady

  function __countSlides(group)
  {
    for(var i = 0; i < group.elements.length; ++i)
    {
      var element = group.elements[i]
      if(element.isGroup)
      {
        __groupSlides(element)
      } else if(element.isSlice)
      {
        root.__slicesCount = root.__slicesCount + 1
        element.onReadyToTellChanged.connect(function() { if(element.readyToTell) { root.__slicesReady += 1 } else { root.__slicesReady -= 1; } })
        if(element.readyToTell) root.__slicesReady += 1
      } else {
        console.log("StoryTeller.qml: unhandled ", element, " in __countSlides")
      }
    }
  }
  function __updateCountSlides()
  {
    root.__slicesCount = 0
    root.__slicesReady = 0
    __countSlides(root.story)
  }
  onStoryChanged:
  {
    if(root.story.elements)
    {
      __updateCountSlides()
    }
    root.story.onElementsChanged.connect(root.__updateCountSlides)
  }

}
