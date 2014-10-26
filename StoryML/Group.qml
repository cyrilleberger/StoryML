import QtQuick 2.0
import StoryML 1.0

StoryElement
{
  readonly property bool isGroup: true

  width: 800
  height: 600
  property real sliceScale: Math.min(width / 800, height / 600)

  property variant elements: []

  Component.onCompleted:
  {
    var slices = [];
    var sections = [];

    for(var i = 0; i < root.children.length; ++i)
    {
      var r = root.children[i];
      if (r.isStoryElement)
      {
        slices.push(r);
        r.sliceNumber = slices.length
        r.scale = Qt.binding(function() { return sliceScale} )
        r.x = Qt.binding(function() { return 0.5 * (width - sliceScale * 800) })
        r.y = Qt.binding(function() { return 0.5 * (height - sliceScale * 600) })
        r.transformOrigin = Item.TopLeft
      }
    }
    root.elements = slices;
  }

}
