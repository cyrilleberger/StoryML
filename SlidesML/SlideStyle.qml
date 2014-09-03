import QtQuick 2.0
import SlidesML 1.0

Item
{
  id: root

  readonly property Item slide: __slide // TODO: Item should be Slide, but this is recursive and crash...
  property TextStyle title: TextStyle { font.pointSize: 50 }
  property TextStyle text: TextStyle { font.pointSize: 30 }
  property TextStyle footer: TextStyle { font.pointSize: 20 }
  property real headerSize: 100
  property real footerSize: 0

  property TextLineStyle level0: TextLineStyle { text: root.text; }
  property TextLineStyle level1: TextLineStyle { text: root.text; bulletSize: 0.15; bulletColor: "white"; bulletBorderColor: "black"}
  property TextLineStyle level2: TextLineStyle { text: root.text; bulletSize: 0.1;  bulletRadius: 0.5; bulletColor: "white"; bulletBorderColor: "black"; bulletBorderWidth: 0}
}
