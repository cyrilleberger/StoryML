import QtQuick 2.0

Item
{
  readonly property bool isStoryElement: true
  property Component defaultLayout: (parent && parent.defaultLayout) ? parent.defaultLayout : null
  property Component  defaultStyle: (parent && parent.defaultLayout) ? parent.defaultStyle : null

}
