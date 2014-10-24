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

  AutoscalableText {
    id: titleText
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin
    height: slice.style_instance.titleSize

    color: slice.style_instance.title.color
    baseFont: slice.style_instance.title.font
    text: slice.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }

  Item
  {
    id: itemHolder
    property SliceAnimation animation: SliceAnimation { parentItem: itemHolder }
    x: root.margin
    y: slice.style_instance.headerSize + root.margin
    width: root.width - 2 * root.margin - marginRight
    height: root.height - 3 * root.margin - slice.style_instance.footerSize - root.marginBottom - slice.style_instance.headerSize
  }

  onContentChanged: {
    content.parent = itemHolder
    content.anchors.fill = itemHolder
    itemHolder.animation.updateLast()
  }
}
