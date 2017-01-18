import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0

SliceLayout
{
  id: root
  property int margin: 30
  property int marginBottom: 0
  property int marginRight: 0
  property Item content: slice.content

  Item
  {
    id: itemHolder
    property SliceAnimation animation: SliceAnimation { parentItem: itemHolder }
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin - marginRight
    height: root.height - 2 * root.margin - root.marginBottom
  }

  onContentChanged: {
    content.parent = itemHolder
    content.anchors.fill = itemHolder
    itemHolder.animation.updateLast()
  }
}

