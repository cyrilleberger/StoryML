import QtQuick 2.0
import SlidesML 1.0

Item
{
  readonly property Item slide: __slide // TODO: Item should be Style, but this is recursive and crash...
  property TextStyle title: TextStyle { font.pointSize: 50 }
  property TextStyle text: TextStyle { font.pointSize: 30 }
  property TextStyle footer: TextStyle { font.pointSize: 20 }

}
