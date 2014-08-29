import SlidesML 1.0
import SlidesML.Components 1.0
import QtQuick 2.0

SlideStyle
{
  property alias backgroundColor: backgroundRectangle.color
  property alias showTotalCount: slideCounter.showTotal
  Rectangle
  {
    id: backgroundRectangle
    anchors.fill: parent
    color: "white"
  }
  SlideCounter
  {
    id: slideCounter
    slide: parent.slide
    anchors.bottom: parent.bottom
    anchors.right: parent.right
  }
}
