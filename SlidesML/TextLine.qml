import SlidesML 1.0
import QtQuick 2.0
import SlidesML.Components 1.0

ContentLine
{
  id: root
  property alias text: text_.text
  ScalableText
  {
    id: text_
    color: parent.style.text.color
    baseFont: parent.style.text.font
    fontScale: root.fontScale
    wrapMode: Text.WordWrap
    width: childrenAvailableWidth
  }
}
