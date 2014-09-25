import QtQuick 2.0
import QtQuick.Layouts 1.0

GridLayout
{
  id: root
  property variant content
  property real fontScale: 1

  onContentChanged:
  {
    var items = []
    for(var i = 0; i < content.length; ++i)
    {
      var c = content[i]
      var item
      if(typeof c == 'string')
      {
        item = Qt.createQmlObject("import QtQuick 2.0; ScalableText {  }", root, "Table's text element")
        item.baseFont = Qt.binding(function() { return root.parent.style.text.font })
        item.text = c
      } else {
        itme = Qt.createQmlObject("import QtQuick 2.0; ScalableText { text: \"Unsupported type for " + c + "\"; color: \"red\" }", root, "Table's unsupported element")
      }
      item.fontScale = Qt.binding(function () { return root.fontScale; })
      items.push(item)
    }
    root.children      = items;
  }
}
