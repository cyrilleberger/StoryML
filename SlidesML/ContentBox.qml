import QtQuick 2.0
import SlidesML 1.0

Column
{
  id: root
  property variant content
  property SlideStyle style

  property SlideAnimation animation: SlideAnimation { parentItem: root }

  property variant __workaround_childrenRect: childrenRect // this is a bit ridiculous, but if we don't do that, we don't get update on childrenRect
  property real __fontScale: 1
  property bool __updatingFontScale: false

  function __updateFontScale()
  {
    if(__updatingFontScale) return;
    if(style && root.childrenRect.height < height && (height - root.childrenRect.height) < style.text.font.pixelSize) return;
    __updatingFontScale = true;
    var newFontScale = Math.min(1, __fontScale * height / root.childrenRect.height);

    var absdiff = Math.abs(newFontScale - __fontScale)

    if(absdiff > 0.01) // Limit the number of adjustment
    {
      if(__fontScale < newFontScale)
      {
        __fontScale += 0.1 * absdiff
      } else {
        __fontScale -= 0.1 * absdiff
      }
    } else if(absdiff > 0.0001) {
      __fontScale = newFontScale
    }
    __updatingFontScale = false;

  }

  onChildrenRectChanged: __updateFontScale()

  property bool __updatingContent: false

  onContentChanged:
  {
    var _content = content
    if( !(_content instanceof Array))
    {
      _content = [_content]
    }

    var items          = [];
    var previousObject = null
    var animationLast  = 0
    for(var i = 0; i < _content.length; ++i)
    {
      var c = _content[i]
      var object
      if(typeof c == 'string')
      {
        object = Qt.createQmlObject("import SlidesML 1.0; import QtQuick 2.0; TextLine {  }", root, "ContentBox's dynamic TextLine" )
        var start = 0;

        if(c[start] == '<')
        {
          start += 1;
          var beginNumber = ""
          var endNumber = ""
          while(c[start] != '-' && c[start] != '>' && start < c.length)
          {
            beginNumber += c[start]
            start += 1;
          }
          if(c[start] == '-') start += 1
          while(c[start] != '-' && c[start] != '>' && start < c.length)
          {
            endNumber += c[start]
            start += 1;
          }
          start += 1
          if(beginNumber.length > 0)
          {
            object.animation.first = beginNumber
          }
          if(endNumber.length > 0)
          {
            object.animation.last = endNumber
          }
        }

        var indentation = 0
        var start_after_animation = start

        while(true)
        {
          if(c[start] == ' ')
          {
            indentation += 1
          } else if(c[start] == '#')
          {
            indentation += 1
            object.bulletType = 2
          } else if(c[start] == '*')
          {
            indentation += 1
            object.bulletType = 1
          } else {
            break;
          }
          start += 1;
        }
        if(c[start] == '\\' && c[start + 1] == '<')
        {
          start += 1;
        }

        object.indentation = (start == start_after_animation) ? 0 : (indentation - 1)
        object.text = c.substring(start, c.length);
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
              var splited = k.split('.')
              var subobj = object
              for(var j = 0; j < splited.length - 1; j += 1)
              {
                subobj = subobj[splited[j]]
              }

              subobj[splited[splited.length - 1]] = c[k]
            }
          }

        }
      } else {
        object = Qt.createQmlObject("import SlidesML 1.0; import QtQuick 2.0; TextLine {  }", root, "ContentBox's dynamic TextLine" )
        object.text = "ContentBox.qml: unsupported " + c
      }

      object.width = Qt.binding(function() { return root.width; })
      object.fontScale = Qt.binding(function() { return root.__fontScale; })
      object.animation.frame = Qt.binding(function() { return root.animation.frame; })
      if(object.indentation == 0)
      {
        object.style = Qt.binding(function() { return root.style.level0; })
      } else if(object.indentation == 1)
      {
        object.style = Qt.binding(function() { return root.style.level1; })
      } else
      {
        object.style = Qt.binding(function() { return root.style.level2; })
      }
      object.previousLine = previousObject
      items.push(object)
      previousObject = object
      if(object.animation.last > root.animation.last && object.animation.last < 90071992)
      {
        animationLast = object.animation.last
      }
    }
    root.animation.last = animationLast
    root.children      = items;
  }
}
