import QtQuick 2.0
import SlidesML.Components 1.0

Column
{
  id: figure
  property alias legend: legend_.text
  AutoscalableText
  {
    id: legend_
    color: parent.parent.style_instance.text.color
    baseFont: parent.parent.style_instance.text.font
    width: parent.width
    horizontalAlignment: Text.AlignHCenter
  }
  Component.onCompleted:
  {
    legend_.parent = null
    legend_.parent = figure
  }
}
