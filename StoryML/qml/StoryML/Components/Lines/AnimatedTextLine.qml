import QtQuick 2.0

TextLine
{
  id: root
  property int animationOffset: 0
  property string seperator: "||"
  property var texts
  property var __texts: []
  text: __select_text(__texts, animation.frame - animation.first)
  function __select_text(_texts, _index)
  {
    if(_texts.length == 0) return ""
    if(_index < 0) _index = 0
    if(_index >= __texts.length) _index = __texts.length - 1
    return _texts[_index]
  }
  onTextsChanged:
  {
    if(typeof texts == 'string')
    {
      __texts = texts.split(root.seperator)
    } else {
      __texts = texts
    }
    animation.last = __texts.length
  }
}
