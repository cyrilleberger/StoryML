import SlidesML 1.0
import QtQuick 2.0

ContentLine
{
  height: text_.height
  property alias text: text_.text
  Text
  {
    id: text_
    color: parent.style.text.color
    font: parent.style.text.font
  }
  onFontScaleChanged: text_.font.pixelSize = style.text.font.pixelSize * fontScale
}
