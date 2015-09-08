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

Row
{
  id: root
  readonly property int noBullet: 0
  readonly property int shapeBullet: 1
  readonly property int numberBullet: 2

  readonly property bool isContentLine: true
  property SliceAnimation animation: SliceAnimation { parentItem: root }
  property real fontScale: 1
  property TextLineStyle style: TextLineStyle {}
  property Item previousLine

  property int indentation: 0
  property int bulletType: noBullet
  property int __bulletNumberCache: 1

  property int indentationSize: style.text.font.pixelSize * fontScale
  property int childrenAvailableWidth: width - (bullet.width + indentation.width)

  onChildrenChanged:
  {
    for(var i = 1; i < root.children.length; ++i)
    {
      root.children[i].opacity = Qt.binding(function() { return root.animation.inFrame ? 1 : style.hiddenOpacity; } )
    }
  }

  onPreviousLineChanged: computeBulletNumber()

  function getBulletNumberRec(_indentation)
  {
    if(_indentation === root.indentation)
    {
      return __bulletNumberCache + 1;
    } else if(_indentation > root.indentation)
    {
      return 1;
    } else if(previousLine) {
      return previousLine.getBulletNumberRec(_indentation);
    } else {
      return 1;
    }
  }
  function computeBulletNumber()
  {
    if(previousLine)
    {
      __bulletNumberCache = previousLine.getBulletNumberRec(root.indentation)
    } else {
      __bulletNumberCache = 1
    }
  }

  Item {
    id: indentation
    height: root.indentationSize
    width: root.indentationSize * (root.indentation + 1 - (root.bulletType != noBullet))
  }
  Item {
    id: bullet
    visible: root.bulletType != root.noBullet
    height: root.indentationSize * visible
    width: root.indentationSize * visible
    Rectangle
    {
      visible: root.bulletType === root.shapeBullet
      anchors.centerIn: parent
      color: root.style.bulletColor
      height: root.style.bulletSize * indentationSize
      width: root.style.bulletSize * indentationSize
      radius: 0.5 * width * root.style.bulletRadius
      border.width: root.style.bulletBorderWidth
      border.color: root.style.bulletBorderColor
    }
    ScalableText
    {
      visible: root.bulletType === root.numberBullet
      anchors.right: parent.right
      y: 0
      color: root.style.bulletTextColor
      baseFont: root.style.text.font
      text: root.__bulletNumberCache
      fontScale: root.fontScale
    }
  }
}
