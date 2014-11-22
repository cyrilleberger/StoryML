import QtQuick 2.0

Item
{
  property real absoluteX: parent.x + x
  property real absoluteY: parent.y + y
  property real posX: 0.0
  property real posY: 0.0
  visible: false
  x: parent.width * posX
  y: parent.height * posY
  Rectangle
  {
    x: -3
    y: -3
    width: 6
    height: 6
    radius: 3
    color: "red"
  }
}
