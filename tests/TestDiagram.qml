import QtQuick 2.0
import StoryML 1.0
import StoryML.Layouts 1.0
import StoryML.Components.Diagram 1.0

Presentation {

  Slice {
    title: "Slice title"
    layout: TitleOnly {}
    Shape {
      id: hello
      x: 10
      y: 150
      width: 100
      height: 40
      text: "Hello"
    }
    Shape {
      id: world
      x: 400
      y: 250
      width: 100
      height: 40
      text: "World !"
      shape: "circle"
      color: "#aaaaaa"
    }
    Connector {
      connectionPoint1: hello.connectionPoints[4]
      connectionPoint2: world.connectionPoints[0]
    }
  }
}
