import QtQuick 2.0
import SlidesML 1.0
import SlidesML.Components 1.0

Row
{
  id: root
  readonly property int noBullet: 0
  readonly property int shapeBullet: 1
  readonly property int numberBullet: 2

  readonly property bool isContentLine: true
  property SlideAnimation animation: SlideAnimation { parentItem: root }
  property real fontScale: 1
  property TextLineStyle style: TextLineStyle {}
  property Item previousLine

  property int indentation: 0
  property int bulletType: noBullet
  property int __bulletNumberCache: 1

  property bool children_visible: (animation.frame >= animation.first && animation.frame <= animation.last)

  property int indentationSize: style.text.font.pixelSize * fontScale
  property int childrenAvailableWidth: width - (bullet.width - indentation.width)

  Timer
  {
    id: delayedVisibility
    interval: 1000
    onTriggered:
    {
      for(var i = 1; i < root.children.length; ++i)
      {
        root.children[i].visible = Qt.binding(function() { return root.children_visible; } )
      }
    }
  }

  onChildrenChanged:
  {
    delayedVisibility.start()
  }

  onPreviousLineChanged: computeBulletNumber()

  function getBulletNumberRec(_indentation)
  {
    if(_indentation == root.indentation)
    {
      return __bulletNumberCache + 1;
    } else if(_indentation > root.indentation)
    {
      return 1;
    } else if(previousLine) {
      return previousLine.getBulletNumberRec(_indentation);
    } else {
      return 1;
    }
  }
  function computeBulletNumber()
  {
    if(previousLine)
    {
      __bulletNumberCache = previousLine.getBulletNumberRec(root.indentation)
    } else {
      __bulletNumberCache = 1
    }
  }

  Item {
    id: indentation
    height: root.indentationSize
    width: root.indentationSize * (root.indentation + 1 - (root.bulletType != noBullet))
  }
  Item {
    id: bullet
    visible: root.bulletType != root.noBullet
    height: root.indentationSize * visible
    width: root.indentationSize * visible
    Rectangle
    {
      visible: root.bulletType == root.shapeBullet
      anchors.centerIn: parent
      color: root.style.bulletColor
      height: root.style.bulletSize * indentationSize
      width: root.style.bulletSize * indentationSize
      radius: 0.5 * width * root.style.bulletRadius
      border.width: root.style.bulletBorderWidth
      border.color: root.style.bulletBorderColor
    }
    ScalableText
    {
      visible: root.bulletType == root.numberBullet
      anchors.centerIn: parent
      color: root.style.bulletColor
      baseFont: root.style.text.font
      text: root.__bulletNumberCache
      fontScale: root.style.bulletSize
    }
  }
}
