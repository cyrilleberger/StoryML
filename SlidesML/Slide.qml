import QtQuick 2.0
import SlidesML 1.0

Item
{
  id: root
  readonly property bool isSlideItem: true
  property Component layout: parent.defaultLayout
  property Component  style:  parent.defaultStyle
  property int slideNumber

//  property SlideLayout __layout: layoutLoader.item
  property SlideStyle  style_instance:  styleLoader.item
  property string title
  property variant content

  width:  800
  height: 600
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
