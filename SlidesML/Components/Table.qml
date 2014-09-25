import QtQuick 2.0
import QtQuick.Layouts 1.0

GridLayout
{
  id: root
  property variant content

  onContentChanged:
  {
    var items = []
    for(var i = 0; i < content.length; ++i)
    {
      var c = content[i]
      var item
      if(typeof c == 'string')
      {
        item = Qt.createQmlObject("import QtQuick 2.0; Text {  }", root, "Table's text element")
        item.text = c
      } else {
        itme = Qt.createQmlObject("import QtQuick 2.0; Text { text: \"Unsupported type for " + c + "\"; color: \"red\" }", root, "Table's unsupported element")
      }

      items.push(item)
    }
    root.children      = items;
  }
}
