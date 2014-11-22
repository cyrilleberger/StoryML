import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0
import StoryML.Components.Diagram 1.0

Item
{
  id: root
  property string shape: "rectangle"
  property alias color: rectangle.color
  property alias border: rectangle.border
  property alias text: scalableText.text
  property alias fontScale: scalableText.fontScale
  property bool showConnectionPoints: false
  property SliceAnimation animation: SliceAnimation { parentItem: root }
  property list<ConnectionPoint> connectionPoints
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
    ConnectionPoint { parent: root; posX: 0.5; posY: 1.0 },
    ConnectionPoint { parent: root; posX: 0.0; posY: 0.5 },
    ConnectionPoint { parent: root; posX: 1.0; posY: 0.5 }
  ]
  state: shape
  Rectangle
  {
    id: rectangle
    anchors.fill: root
    visible:false
    border.width: 1
  }
  ScalableText {
    id: scalableText
    anchors.centerIn: root
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
