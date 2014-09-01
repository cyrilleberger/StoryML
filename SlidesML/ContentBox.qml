import QtQuick 2.0

Column
{
  id: root
  property variant content
  property SlideStyle style

  function content2model(_content)
  {
    if( !(_content instanceof Array))
    {
      _content = [_content]
    }

    var items = [];

    for(var i = 0; i < _content.length; ++i)
    {
      var c = _content[i]
      var object
      if(typeof c == 'string')
      {
        object = Qt.createQmlObject("import SlidesML 1.0; import QtQuick 2.0; TextLine {  }", root, "ContentBox's dynamic TextLine" )
        object.text = c;
      } else if(c instanceof Array) {
        object = Qt.createQmlObject("import SlidesML 1.0; import QtQuick 2.0; Rectangle {color: 'red'; width: 104; height: 49 Text { text: 'Array is not yet implemented'}}", root, "ContentBox's dynamic item" )
      } else if(c instanceof Object) {
        if(c.isContentLine)
        {
          object = c
          object.parent = root
        } else {
          object = Qt.createQmlObject("import SlidesML 1.0; import QtQuick 2.0; " + c.type + " { }", root, "ContentBox's dynamic item" )
          for(var k in c)
          {
            if(k != 'type')
            {
              object[k] = c[k]
            }
          }

        }
      } else {
        object = Qt.createQmlObject("import SlidesML 1.0; import QtQuick 2.0; TextLine {  }", root, "ContentBox's dynamic TextLine" )
        object.text = "ContentBox.qml: unsupported " + c
      }

      object.width = Qt.binding(function() { return root.width; })
      object.style = Qt.binding(function() { return root.style; })
      object.fontScale = Qt.binding(function() { return root.__fontScale; })
      items.push(object)
    }

    return items;
  }

  property variant __workaround_childrenRect: childrenRect // this is a bit ridiculous, but if we don't do that, we don't get update on childrenRect
  property real __fontScale: 1
  property bool __updatingFontScale: false
  onChildrenRectChanged: {
    if(__updatingFontScale) return;
    __updatingFontScale = true;
    var newFontScale = Math.min(1, __fontScale * height / root.childrenRect.height);
    if(Math.abs(newFontScale - __fontScale) > 0.01) // Limit the number of adjustment
    {
      __fontScale = newFontScale
    }
    __updatingFontScale = false;
  }


  Component.onCompleted:
  {
    children = Qt.binding(function () { return content2model(root.content) })
  }
}
