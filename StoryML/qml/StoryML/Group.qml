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

StoryElement
{
  id: root
  readonly property bool isGroup: true

  width: 800
  height: 600
  property real sliceScale: Math.min(width / 800, height / 600)

  property variant elements: []

  Component.onCompleted:
  {
    var slices = [];
    for(var i = 0; i < root.children.length; ++i)
    {
      var r = root.children[i];
      if (r.isStoryElement)
      {
        slices.push(r);
        r.scale = Qt.binding(function() { return sliceScale} )
        r.x = Qt.binding(function() { return 0.5 * (width - sliceScale * 800) })
        r.y = Qt.binding(function() { return 0.5 * (height - sliceScale * 600) })
        r.transformOrigin = Item.TopLeft
      }
    }
    root.elements = slices;
  }

}
