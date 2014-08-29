import QtQuick 2.0
import SlidesML 1.0

SlideLayout
{
  id: root
  property int margin: 30
  Text {
    id: titleText
    x: root.margin
    y: 100
    width: root.width - 2 * root.margin
    height: parent.height - 2 * y

    color: slide.style_instance.title.color
    font: slide.style_instance.title.font
    text: slide.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
}
