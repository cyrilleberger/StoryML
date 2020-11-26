/* Copyright (c) 2014, Cyrille Berger <cberger@cberger.net>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 */

import QtQuick 2.0
import StoryML 1.0

Item
{
  id: root
  property variant content
  property SliceStyle style

  property SliceAnimation animation: SliceAnimation { parentItem: root }

  property variant __workaround_childrenRect: childrenRect // this is a bit ridiculous, but if we don't do that, we don't get update on childrenRect
  property real __fontScale: 1
  property real __largestGoodFontScale: 0
  property real __smallestBadFontScale: 1
  property bool __updatingFontScale: false
  property real __childrenHeight: 0
  property bool readyToTell: false

  property var fontScale: null
  onFontScaleChanged: root.__resetUpdateFontScale()

  function __resetUpdateFontScale()
  {
    if(root.fontScale != null)
    {
      __fontScale = fontScale
      __smallestBadFontScale  = fontScale
      __largestGoodFontScale  = fontScale
    } else {
      __fontScale             = 1
      __smallestBadFontScale  = 1
      __largestGoodFontScale  = 0
    }
  }

  Timer
  {
    id: relayout
    interval: 200
    onTriggered: {
      var y = 0

      for(var i = 0; i < root.children.length; ++i)
      {
        var c = root.children[i]
        c.y = y
        y += c.height
      }
      __childrenHeight = y
      root.__updateFontScale()
    }
  }
  Timer
  {
    id: check_fontScale
    interval: 400
    onTriggered: {
      if(__childrenHeight > height)
      {
        if(__smallestBadFontScale > 0.9999)
        {
          root.__resetUpdateFontScale()
        }
        __updateFontScale()
      } else {
        root.readyToTell = true
      }
    }
  }
  Timer
  {
      id: workaround
      interval: 2000
      onTriggered: {
          root.readyToTell = true
      }
  }

  function __updateFontScale()
  {
    if(root.fontScale != null)
    {
      __fontScale = fontScale
    } else {
      if(__childrenHeight < height)
      {
        root.__largestGoodFontScale = __fontScale
      } else {
        root.__smallestBadFontScale = __fontScale
      }
      if(root.__largestGoodFontScale > 0.99 * root.__smallestBadFontScale)
      {
        check_fontScale.restart()
        __fontScale = root.__largestGoodFontScale
      } else if(__childrenHeight > height || __childrenHeight < 0.9 * height)
      {
        __fontScale = 0.5 * (root.__largestGoodFontScale + root.__smallestBadFontScale)
        check_fontScale.restart()
      }
    }
  }

  onHeightChanged: {
    root.__resetUpdateFontScale()
    relayout.restart()
  }
  onWidthChanged: {
    root.__resetUpdateFontScale()
    relayout.restart()
  }

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
      var isFormula = false
      if(typeof c == 'string')
      {
        var start = 0;

        var highlighting_definition = ""
        if(c[start] === '[')
        {
          start += 1
          while(c[start] !== ']' && start < c.length)
          {
            highlighting_definition += c[start]
            start += 1;
          }
          start += 1
        }
        else if(c[start] === '\\' && c[start+1] === '[')
        {
          start += 1
        }

        if(highlighting_definition == "")
        {
          object = Qt.createQmlObject("import StoryML 1.0; import QtQuick 2.0; import StoryML.Components.Lines 1.0; TextLine {  }", root, "ContentBox's dynamic TextLine" )
        } else if(highlighting_definition.substr(0, 7) == "Formula") {
          var opts = highlighting_definition.split(",")
          object = Qt.createQmlObject("import StoryML 1.0; import QtQuick 2.0; import StoryML.Components.Lines 1.0; FormulaLine {  }", root, "ContentBox's dynamic TextLine" )
          isFormula = true
          for(var j = 1; j < opts.length; ++j)
          {
            var kv = opts[j].split("=")
              console.log(kv[0], kv[1])
            switch(kv[0])
            {
              case "h":
              case "height":
                object.formulaHeight = kv[1]
                break;
              default:
                console.log("Unkwown key " + kv[0])
                  break;
            }
          }
        } else {
          object = Qt.createQmlObject("import StoryML 1.0; import QtQuick 2.0; import StoryML.Components.Lines 1.0; HighlightedTextLine {  }", root, "ContentBox's dynamic TextLine" )
          object.highlightingDefinition = highlighting_definition
        }

        if(c[start] === '<')
        {
          start += 1;
          var beginNumber = ""
          var endNumber = ""
          while(c[start] !== '-' && c[start] !== '>' && start < c.length)
          {
            beginNumber += c[start]
            start += 1;
          }
          if(c[start] === '-') start += 1
          while(c[start] !== '-' && c[start] !== '>' && start < c.length)
          {
            endNumber += c[start]
            start += 1;
          }
          start += 1
          try
          {
            if(beginNumber.length > 0)
            {
              object.animation.first = beginNumber
            }
            if(endNumber.length > 0)
            {
              object.animation.last = endNumber
            }
          } catch(except)
          {
            console.log(except)
          }
        }

        var indentation = 0
        var start_after_animation = start

        while(c[start] === ' ' && start < c.length)
        {
          indentation += 1
          start += 1;
        }

        while(start < c.length)
        {
          if(c[start] === '\\' && (c[start + 1] ==='#' || c[start+1] === '*' ))
          {
            start += 1;
            break;
          }
          else if(c[start] === '#')
          {
            indentation += 1
            object.bulletType = 2
          } else if(c[start] === '*')
          {
            indentation += 1
            object.bulletType = 1
          } else {
            break;
          }
          start += 1;
        }
        if(c[start] === '\\' && c[start + 1] === '<')
        {
          start += 1;
        }

        object.indentation = (start == start_after_animation) ? 0 : (indentation - 1)
        if(isFormula)
        {
          if(start < c.length)
          {
            object.formulas = [c.substring(start, c.length)];
          } else {
            object.formulas = [""]
          }
        }
        else if(start < c.length)
        {
          object.text = c.substring(start, c.length);
        } else {
          object.text = " "
        }
      } else if(c instanceof Array) {
        object = Qt.createQmlObject("import StoryML 1.0; import QtQuick 2.0; Rectangle {color: 'red'; width: 104; height: 49; Text { text: 'Array is not yet implemented'}}", root, "ContentBox's dynamic item" )
      } else if(c instanceof Object) {
        if(c.isContentLine)
        {
          object = c
          object.parent = root
        } else {
          object = Qt.createQmlObject("import StoryML 1.0; import QtQuick 2.0; " + c.type + " { }", root, "ContentBox's dynamic item" )
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
        object = Qt.createQmlObject("import StoryML 1.0; import QtQuick 2.0; TextLine {  }", root, "ContentBox's dynamic TextLine" )
        object.text = "ContentBox.qml: unsupported " + c
      }

      object.width = Qt.binding(function() { return root.width; })
      object.fontScale = Qt.binding(function() { return root.__fontScale; })
      object.animation.frame = Qt.binding(function() { return root.animation.frame; })
      object.onHeightChanged.connect(function() { relayout.restart() })
      if(object.indentation === 0)
      {
        object.style = Qt.binding(function() { return root.style.level0; })
      } else if(object.indentation === 1)
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
    root.animation.last    = animationLast
    root.children          = items;
    root.__resetUpdateFontScale()
//     workaround.start()
  }
}
