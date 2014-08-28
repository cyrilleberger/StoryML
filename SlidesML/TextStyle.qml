import QtQuick 2.0

Item {
  property alias font: forfont.font
  property color color: "black"
  Text {
    id: forfont
    visible: false
  }
}
