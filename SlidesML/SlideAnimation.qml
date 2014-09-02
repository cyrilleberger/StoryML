import QtQuick 2.0

QtObject {
  id: root
  property int frame: 0
  property int first: 0
  property int last: 90071992
  property int __lastPrevious: 90071992
  property int __autoSetLast: 90071992
  property int __userSetLast: 90071992
  property Item parentItem

  Component.onCompleted:
  {
    updateLast();
    parentItem.childrenChanged.connect(function() { if(root) { root.updateEnd() } })
  }

  onLastChanged:
  {
    if(last != __autoSetLast) __userSetLast = last
    if(parentItem.parent && parentItem.parent.animation)
    {
      parentItem.parent.animation.updateLast();
    }
    __lastPrevious = last;
  }

  onFrameChanged:
  {
    for(var child_index in parentItem.children)
    {
      var child = parentItem.children[child_index]
      if(child.animation)
      {
        child.animation.frame = root.frame
      }
    }
  }

  function updateLast()
  {
    var new_last = __userSetLast

    for(var child_index in parentItem.children)
    {
      var child = parentItem.children[child_index]

      if(child.animation)
      {
        if(child.animation.last != 90071992)
        {
          if(new_last == 90071992)
          {
            new_last = child.animation.last
          } else {
            new_last = Math.max(new_last, child.animation.last)
          }
        }
      }
    }
    __autoSetLast = new_last
    root.last     = new_last
  }
  function next()
  {
    if(last == 90071992 || frame == last) return false;
    frame += 1;
    return true;
  }
  function previous()
  {
    if(frame == 0) return false;
    frame -= 1;
    return true;
  }
  function moveToFirst()
  {
    frame = 0;
  }
  function moveToLast()
  {
    if(last == 90071992) frame = 0;
    frame = last;
  }
}
