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
import QtQuick.Window 2.0
import StoryML 1.0
import QtQuick.Controls 1.0

SplitView
{
  id: root
  property Component presentation
  property Presentation presentation_instance

  Rectangle
  {
    id: sideBar
    width: 0.3 * parent.width
    height: parent.height
    color: "black"
    Column
    {
      width: parent.width

      Text
      {
        color: "white"
        text: "Current slice:"
      }
      Loader
      {
        id: presentationCurrent
        sourceComponent: root.presentation
        width: parent.width
        height: 600 * (width / 800)
        onItemChanged:
        {
          item.videosEnabled                          = false
          item.storyTeller.currentSliceIndexBinding   = Qt.binding(function() { return presentation_instance ? presentation_instance.storyTeller.currentSliceIndex : 0 } )
          item.storyTeller.animationFrameBinding      = Qt.binding(function() { return presentation_instance ? presentation_instance.storyTeller.animationFrame : 0 } )
        }
      }
      Text
      {
        color: "white"
        text: "Next slice:"
      }
      Loader
      {
        id: presentationNext
        sourceComponent: root.presentation
        width: parent.width
        height: 600 * (width / 800)
        onItemChanged:
        {
          item.animationsEnabled = false
          item.videosEnabled     = false
          item.storyTeller.currentSliceIndexBinding = Qt.binding(function() { return presentation_instance ? presentation_instance.storyTeller.currentSliceIndex + 1 : 0 } )
        }
      }
    }
    Rectangle
    {
      anchors.bottom: parent.bottom
      width: clock.contentWidth
      height: clock.contentHeight
      color: "black"
      Text
      {
        anchors.fill: parent
        id: clock
        color: "white"
        Timer
        {
          interval: 100; running: true; repeat: true;
          onTriggered: clock.timeChanged()
        }
        function timeChanged()
        {
          var date = new Date;
          clock.text = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds()
        }
        font.pixelSize: 20
      }
    }
  }
  Rectangle
  {
    color: "white"
    Text
    {
      anchors.fill: parent
      text: presentation_instance ? presentation_instance.storyTeller.currentSlice.notes : ""
      wrapMode: Text.WordWrap
      font.pixelSize: 60
    }
  }
}
