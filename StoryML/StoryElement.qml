import QtQuick 2.0

Item
{
  readonly property bool isStoryElement: true
  property Component defaultLayout: (parent && parent.defaultLayout) ? parent.defaultLayout : null
  property Component  defaultStyle: (parent && parent.defaultStyle) ? parent.defaultStyle : null
  property Component  defaultSectionStyle: (parent && parent.defaultSectionStyle) ? parent.defaultSectionStyle : null

}
