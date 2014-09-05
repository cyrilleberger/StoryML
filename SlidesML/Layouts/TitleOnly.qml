import SlidesML 1.0
import SlidesML.Components 1.0
import QtQuick 2.0

SlideLayout
{
  id: root
  property int margin: 30
  AutoscalableText {
    id: titleText
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin
    height: 100

    color: slide.style_instance.title.color
    baseFont: slide.style_instance.title.font
    text: slide.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
}
