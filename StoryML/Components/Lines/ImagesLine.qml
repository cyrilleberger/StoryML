import QtQuick 2.0 as QQ
import StoryML.Components 1.0
import StoryML.Components.Lines 1.0

ItemsLine {
  id: root
  property alias imageHeight: root.itemHeight
  property alias imageHeights: root.itemHeights
  property alias imageSpacing: root.itemSpacing
  property alias sources: root.model

  component: QQ.Image
  {
    fillMode: QQ.Image.PreserveAspectFit
    source: itemData
  }
}


