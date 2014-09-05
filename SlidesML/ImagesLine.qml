import SlidesML 1.0
import QtQuick 2.0
import SlidesML.Components 1.0

ContentLine
{
  id: root
  property int imageHeight: height
  property alias imageSpacing: row.spacing
  property variant sources
  Item
  {
    height: imageHeight
    width: childrenAvailableWidth
    Row
    {
      anchors.centerIn: parent
      id: row
      Repeater
      {
        model: root.sources
        delegate: Image
        {
          height: root.imageHeight
          fillMode: Image.PreserveAspectFit
          source: modelData
        }
      }
    }
  }

}
