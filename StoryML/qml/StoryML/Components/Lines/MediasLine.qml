import QtQuick 2.0 as QQ
import StoryML.Components 1.0
import StoryML.Components.Lines 1.0

ItemsLine {
  id: root
  property alias imageHeight: root.itemHeight
  property alias imageHeights: root.itemHeights
  property alias imageSpacing: root.itemSpacing
  property alias sources: root.model
  property var u: Qt.resolvedUrl

  QQ.Component
  {
    id: image
    QQ.Image
    {
      fillMode: QQ.Image.PreserveAspectFit
      source: itemData
    }
  }
  QQ.Component
  {
    id: video
    Video
    {
      source: itemData
    }
  }
  component:QQ.Loader
  {
    function __get_component(url)
    {
       var mT = Extension.mimeTypeForUrl(url)
       if(mT === "video/mp4")
       {
         return video
       } else if(mT === "image/jpeg") {
         return image
       } else {
         console.log("Unsupported media type: ", mT)
       }
    }
    sourceComponent: __get_component(itemData)
    onLoaded:
    {
      item.source = itemData
    }
  }
}
