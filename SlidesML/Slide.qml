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

Item
{
  id: root
  readonly property bool isSlideItem: true
  property Component layout: parent.defaultLayout
  property Component  style:  parent.defaultStyle
  property int slideNumber
  property string notes

  property SlideAnimation animation: SlideAnimation { parentItem: root }

//  property SlideLayout __layout: layoutLoader.item
  property SlideStyle  style_instance:  styleLoader.item
  property string title

  function object_to_list(_obj)
  {
    var list = []
    for(var k in _obj)
    {
      list.push(_obj[k])
    }
    return list
  }

  property variant content: object_to_list(contentLines)
  property list<ContentLine> contentLines

  width:  800
  height: 600
  visible: false

  Loader {
    id: styleLoader
    sourceComponent: style
    property alias __slide: root
    anchors.fill: parent
  }
  Loader {
    id: layoutLoader
    sourceComponent: layout
    property alias __slide: root
    anchors.fill: parent
    property SlideAnimation animation: SlideAnimation { parentItem: layoutLoader }
  }
}
