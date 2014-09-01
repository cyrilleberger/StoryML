import QtQuick 2.0
import SlidesML 1.0

Item
{
  id: root
  readonly property bool isSlideItem: true
  property Component layout: parent.defaultLayout
  property Component  style:  parent.defaultStyle
  property int slideNumber

  property int animationFrame: 0
  property int animationLast: 1

//  property SlideLayout __layout: layoutLoader.item
  property SlideStyle  style_instance:  styleLoader.item
  property string title

  function object_to_list(_obj)
  {
    var list = []
    for(var k in _obj)
    {
      list.push(_obj[k])
    }
    return list
  }

  property variant content: object_to_list(contentLines)
  property list<ContentLine> contentLines

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
