import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0
import StoryML.Components.Diagram 1.0

Item
{
  id: root
  property variant geometry: [0, 0, 30, 10]
  property variant style: [ "rectangle", root.parent.style_instance.backgroundColor, root.parent.style_instance.text.color, 1, root.parent.style_instance.text.color ]

  property string shape: style[0]
  property alias backgroundColor: rectangle.color
  property alias border: rectangle.border
  property alias text: scalableText.text
  property alias fontScale: scalableText.fontScale
  property alias font: scalableText.baseFont
  property alias radius: rectangle.radius
  property bool showConnectionPoints: false
  property SliceAnimation animation: SliceAnimation { parentItem: root; }
  property list<ConnectionPoint> connectionPoints

  x: geometry[0]
  y: geometry[1]
  width: geometry[2]
  height: geometry[3]

  opacity: root.animation.inFrame ? 1 : root.parent.style_instance.hiddenOpacity
  onConnectionPointsChanged: {
    for(var i = 0; i < connectionPoints.length; ++i)
    {
      connectionPoints[i].visible = Qt.binding(function() { return root.showConnectionPoints; })
    }
  }
  property list<ConnectionPoint> __connectionPointsRectangle: [
    ConnectionPoint { parent: root; posX: 0.0; posY: 0.0 },
    ConnectionPoint { parent: root; posX: 0.5; posY: 0.0 },
    ConnectionPoint { parent: root; posX: 1.0; posY: 0.0 },
    ConnectionPoint { parent: root; posX: 1.0; posY: 0.5 },
    ConnectionPoint { parent: root; posX: 1.0; posY: 1.0 },
    ConnectionPoint { parent: root; posX: 0.5; posY: 1.0 },
    ConnectionPoint { parent: root; posX: 0.0; posY: 1.0 },
    ConnectionPoint { parent: root; posX: 0.0; posY: 0.5 }
  ]
  property list<ConnectionPoint> __connectionPointsCircle: [
    ConnectionPoint { parent: root; posX: 0.5; posY: 0.0 },
    ConnectionPoint { parent: root; posX: 1.0; posY: 0.5 },
    ConnectionPoint { parent: root; posX: 0.5; posY: 1.0 },
    ConnectionPoint { parent: root; posX: 0.0; posY: 0.5 }
  ]
  function __getValue(array, index, defaultValue)
  {
    if(index >= array.length)
    {
      return defaultValue;
    } else {
      return array[index]
    }
  }

  state: shape
  Rectangle
  {
    id: rectangle
    anchors.fill: root
    visible:false
    border.width: __getValue(root.style, 3, 1)
    color: __getValue(root.style, 1, root.parent.style_instance.backgroundColor)
    border.color: __getValue(root.style, 4, root.parent.style_instance.text.color)
  }
  AutoscalableText {
    id: scalableText
    anchors.fill: root
    anchors.margins: 5
    color: __getValue(root.style, 2, root.parent.style_instance.text.color)
    baseFont: root.parent.style_instance.text.font
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment:   Text.AlignVCenter
  }
  states: [
    State {
      name: "rectangle"
      PropertyChanges {
        target: rectangle
        visible: true
      }
      PropertyChanges {
        target: root
        connectionPoints: __connectionPointsRectangle
      }
    },
    State {
      name: "circle"
      PropertyChanges {
        target: rectangle
        visible: true
        radius: 0.5 * Math.max(root.width, root.height)
      }
      PropertyChanges {
        target: root
        connectionPoints: __connectionPointsCircle
      }
    }
  ]
}
