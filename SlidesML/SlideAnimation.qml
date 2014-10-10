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

QtObject {
  id: root
  readonly property bool inFrame: (frame >= first && frame <= last)
  property int frame: 0
  property int first: 0
  property int last: 90071992
  property int __lastPrevious: 90071992
  property int __autoSetLast: 90071992
  property int __userSetLast: 90071992
  property bool __completed: false // Seems like Component.status is undefined
  property Item parentItem

  Component.onCompleted:
  {
    __completed = true
    updateLast();
    parentItem.childrenChanged.connect(function() { if(root) { root.updateLast() } })
  }

  onLastChanged:
  {
    if(last != __autoSetLast) __userSetLast = last
    if(!__completed && !parentItem) return;
    if(parentItem.parent && parentItem.parent.animation)
    {
      parentItem.parent.animation.updateLast();
    }
    __lastPrevious = last;
  }

  onFrameChanged:
  {
    for(var child_index in parentItem.children)
    {
      var child = parentItem.children[child_index]
      if(child.animation)
      {
        child.animation.frame = root.frame
      }
    }
  }

  function updateLast()
  {
    var new_last = __userSetLast

    for(var child_index in parentItem.children)
    {
      var child = parentItem.children[child_index]
      if(child.animation)
      {
        if(child.animation.last != 90071992)
        {
          if(new_last == 90071992)
          {
            new_last = child.animation.last
          } else {
            new_last = Math.max(new_last, child.animation.last)
          }
        }
        new_last = Math.max(new_last, child.animation.first)
      }
    }
    __autoSetLast = new_last
    root.last     = new_last
  }
  function next()
  {
    if(last == 90071992 || frame == last) return false;
    frame += 1;
    return true;
  }
  function previous()
  {
    if(frame == 0) return false;
    frame -= 1;
    return true;
  }
  function moveToFirst()
  {
    frame = 0;
  }
  function moveToLast()
  {
    if(last == 90071992) frame = 0;
    else frame = last;
  }
}
