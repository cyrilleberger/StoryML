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
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0
import StoryML 1.0

Item
{
  id: root
  property SliceAnimation animation: SliceAnimation {  parentItem: root }
  property url source
  property alias sourceRect:  videoOutput.sourceRect
  property alias muted:       player.muted
  Component.onCompleted: {
    root.animation.onInFrameChanged.connect(function() {
      if(animation.inFrame)
      {
        var p = root.parent
        while(p)
        {
          if(p.videosEnabled)
          {
            player.play()
            break;
          }
          p = p.parent
        }
      }
      else {
        player.stop()
      }
    })
  }

  MediaPlayer
  {
    id: player
    autoPlay: false
    loops: MediaPlayer.Infinite
    source: fix_url(root.source)
    function fix_url(ur)
    {
      var urs = ur.toString()
      if(!urs.startsWith("file:///") && urs.startsWith("file://"))
      {
        urs = "file:///" + urs.substr(7)
      }
      return urs;
    }

    onPositionChanged:
    {
      controlPositionSlider.enable_seeking = false
      controlPositionSlider.value = position
      controlPositionSlider.enable_seeking = true
    }
  }
  VideoOutput
  {
    id: videoOutput
    source: player
    anchors.fill: parent
  }
  MouseArea
  {
    anchors.fill: parent
    hoverEnabled: true
    onPositionChanged:
    {
      control.height = 20
      hideControl.restart()
    }
    enabled: animation.inFrame
  }

  Rectangle
  {
    id: control
    color: "black"
    height: 0
    clip: true
    width: root.width
    anchors.bottom: root.bottom

    Row
    {
      id: controlButtonsRow
      Button {
        iconName: (player.playbackState === MediaPlayer.PlayingState ) ? "media-playback-pause.png" : "media-playback-start.png"
        width: height
        height: control.height
        onClicked: {
          if(player.playbackState === MediaPlayer.PlayingState)
          {
            player.pause()
          } else {
            player.play()
          }
        }
      }
      Button {
        iconName: "media-playback-stop.png"
        enabled: player.playbackState != MediaPlayer.StoppedState
        width: height
        height: control.height
        onClicked: {
          player.stop()
        }
      }
      Button {
        iconName: "player-volume-muted.png"
        width: height
        height: control.height
        checkable: true
        checked: player.muted
        onClicked:
        {
          player.muted = !player.muted
        }
      }
    }
    Slider
    {
      id: controlPositionSlider
      anchors.left: controlButtonsRow.right
      anchors.right: control.right
      maximumValue: player.duration
      enabled: player.seekable
      property bool enable_seeking: true

      onValueChanged:
      {
        if(enable_seeking)
        {
          hideControl.restart()
          player.seek(value)
        }
      }
    }

    Behavior on height
    {
      NumberAnimation
      {
       duration: 100
      }
    }
  }
  Timer
  {
    id: hideControl
    interval: 1000
    onTriggered:
    {
      control.height = 0
    }
  }
  function __updateSize(width_fix, height_fix)
  {
    __updating_size = true
    if(!width_fix && !height_fix)
    {
      width = sourceRect.width
      height = sourceRect.height
    } else if(height_fix && !width_fix)
    {
      width = sourceRect.width * height / sourceRect.height
    } else if(width_fix && !height_fix)
    {
      height = sourceRect.height * width / sourceRect.width
    }
    __updating_size = false
  }

  onWidthChanged:
  {
    if(__updating_size) return;
    __set_width = width
    __updateSize(true, false)
  }
  onHeightChanged:
  {
    if(__updating_size) return;
    __set_height = height
    __updateSize(false, true)
  }
  onSourceRectChanged: __updateSize(__set_width > 0, __set_height > 0)
  property real __set_width: 0
  property real __set_height: 0
  property bool __updating_size: false

}
