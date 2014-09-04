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
    height: slide.style_instance.titleSize

    color: slide.style_instance.title.color
    font: slide.style_instance.title.font
    text: slide.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  property int __column_width: (root.width - 3 * root.margin) / 2
  ContentBox
  {
    x: root.margin
    width: __column_width

    anchors.top: titleText.bottom
    anchors.topMargin: root.margin
    anchors.bottom: root.bottom
    anchors.bottomMargin: root.margin + slide.style_instance.footerSize

    content: slide.content[0]
    style: slide.style_instance
  }
  ContentBox
  {
    x: 2 * root.margin + __column_width
    width: __column_width

    anchors.top: titleText.bottom
    anchors.topMargin: root.margin
    anchors.bottom: root.bottom
    anchors.bottomMargin: root.margin + slide.style_instance.footerSize

    content: slide.content[1]
    style: slide.style_instance
    Rectangle {
      color: "red"
      anchors.fill: parent
    }
  }
}
