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
import StoryML.Components 1.0

SliceLayout
{
  id: root
  property int margin: 30
  property int marginBottom: 0
  property int marginTop: 0
  property real leftColumnWidth: 0.5
  property var content : slice.content

  AutoscalableText {
    id: titleText
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin
    height: slice.style_instance.titleSize
    clip: true

    color: slice.style_instance.title.color
    baseFont: slice.style_instance.title.font
    text: slice.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  property int __total_column_width: (root.width - 3 * root.margin)
  Item
  {
    id: leftItemHolder
    property SliceAnimation animation: SliceAnimation { parentItem: leftItemHolder }
    x: root.margin
    y: slice.style_instance.headerSize + root.margin + root.marginTop
    width: __total_column_width * leftColumnWidth
    height: root.height - 3 * root.margin - slice.style_instance.footerSize - root.marginBottom - root.marginTop - slice.style_instance.headerSize

  }
  Item
  {
    id: rightItemHolder
    property SliceAnimation animation: SliceAnimation { parentItem: rightItemHolder }
    x: 2 * root.margin + __total_column_width * leftColumnWidth
    y: slice.style_instance.headerSize + root.margin + root.marginTop
    width: __total_column_width * (1.0 - leftColumnWidth)
    height: root.height - 3 * root.margin - slice.style_instance.footerSize - root.marginBottom - root.marginTop - slice.style_instance.headerSize

  }

  onContentChanged: {
    content[0].parent = leftItemHolder
    content[0].anchors.fill = leftItemHolder
    leftItemHolder.animation.updateLast()
    content[1].parent = rightItemHolder
    content[1].anchors.fill = rightItemHolder
    rightItemHolder.animation.updateLast()
  }

}
