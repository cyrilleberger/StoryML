import SlidesML 1.0
import QtQuick 2.0

SlideStyle
{
  property alias backgroundColor: backgroundRectangle.color
  Rectangle
  {
    id: backgroundRectangle
    anchors.fill: parent
    color: "white"
  }
}
