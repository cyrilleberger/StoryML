import QtQuick 2.0
import QtMultimedia 5.0

Item
{
  property alias source: player.source
  property alias sourceRect: videoOutput.sourceRect
  property alias muted: player.muted
  MediaPlayer
  {
    id: player
    autoPlay: false
    loops: MediaPlayer.Infinite
  }
  VideoOutput
  {
    id: videoOutput
    source: player
    anchors.fill: parent
    onVisibleChanged:
    {
      if(visible)
      {
        var p = parent
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
    }
  }
}
