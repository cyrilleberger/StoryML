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

import StoryML 1.0
import QtQuick 2.0
import StoryML.Components 1.0

ContentLine
{
  id: root
  property int imageHeight: height
  property variant imageHeights: []
  property alias imageSpacing: row.spacing
  property variant sources
  function height_at(index)
  {
    if(index < imageHeights.length)
    {
      return imageHeights[index]
    } else {
      return imageHeight
    }
  }
  function __max(h, hs)
  {
    var mh = h
    for(var i = 0; i < hs.length; ++i)
    {
      mh = Math.max(mh, hs[i])
    }
    return mh
  }

  Item
  {
    id: container
    height: __max(imageHeight, imageHeights)
    width: childrenAvailableWidth
    Row
    {
      anchors.centerIn: parent
      id: row
      Repeater
      {
        model: root.sources
        delegate: Image
        {
          y: 0.5 * (container.height - height)
          height: height_at(index)
          fillMode: Image.PreserveAspectFit
          source: modelData
        }
      }
    }
  }

}
