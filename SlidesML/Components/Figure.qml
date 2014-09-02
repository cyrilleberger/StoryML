import QtQuick 2.0

Column
{
  id: figure
  property alias legend: legend_.text
  Text
  {
    id: legend_
    color: parent.parent.style_instance.text.color
    font: parent.parent.style_instance.text.font
    function updateFontSize()
    {
      if(parent.width != 0 && parent)
      {
        font.pixelSize = font.pixelSize * parent.width / contentWidth
      }
    }
    onFontChanged: updateFontSize()
    onTextChanged: updateFontSize()
    onWidthChanged: updateFontSize()
    onContentWidthChanged: updateFontSize()
    width: parent.width
    horizontalAlignment: Text.AlignHCenter
  }
  Component.onCompleted:
  {
    legend_.parent = null
    legend_.parent = figure
  }
}
