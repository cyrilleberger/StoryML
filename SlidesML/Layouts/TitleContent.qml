import QtQuick 2.0
import SlidesML 1.0

SlideLayout
{
  id: root
  property int margin: 30
  Text {
    id: titleText
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin
    height: 100

    color: slide.style_instance.title.color
    font: slide.style_instance.title.font
    text: slide.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  Text {
    id: contentText
    color: slide.style_instance.text.color
    font: slide.style_instance.text.font
    text: slide.content

    x: root.margin
    anchors.top: titleText.bottom
    anchors.topMargin: root.margin
    width: root.width - 2 * root.margin
    anchors.bottom: root.bottom
    anchors.bottomMargin: root.margin
  }
}
