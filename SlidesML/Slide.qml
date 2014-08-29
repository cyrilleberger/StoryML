import QtQuick 2.0
import SlidesML 1.0

Item
{
  id: root
  readonly property bool isSlideItem: true
  property Component layout: parent.defaultLayout
  property Component  style:  parent.defaultStyle

//  property SlideLayout __layout: layoutLoader.item
  property SlideStyle  style_instance:  styleLoader.item
  property string title
  property variant content

  anchors.fill: parent
  visible: false

  Loader {
    id: styleLoader
    sourceComponent: style
    property alias __slide: root
    anchors.fill: parent
  }
  Loader {
    id: layoutLoader
    sourceComponent: layout
    property alias __slide: root
    anchors.fill: parent
  }
}
