import QtQuick 2.0
import SlidesML 1.0
import SlidesML.Components 1.0

SlideLayout
{
  id: root
  property int margin: 30
  property int marginBottom: 0

  AutoscalableText {
    id: titleText
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin
    height: slide.style_instance.titleSize

    color: slide.style_instance.title.color
    baseFont: slide.style_instance.title.font
    text: slide.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  ContentBox
  {
    x: root.margin
    y: slide.style_instance.headerSize + root.margin
    width: root.width - 2 * root.margin
    height: root.height - 3 * root.margin - slide.style_instance.footerSize - root.marginBottom - slide.style_instance.headerSize

    content: slide.content
    style: slide.style_instance
  }
}
