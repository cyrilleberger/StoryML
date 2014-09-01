import QtQuick 2.0
import SlidesML 1.0

Row
{
  id: root
  readonly property int noBullet: 0
  readonly property int shapeBullet: 1
  readonly property int numberBullet: 2

  readonly property bool isContentLine: true
  property int begin: 0
  property int end: 90071992
  property real fontScale: 1
  property TextLineStyle style: TextLineStyle {}
  property Item previousLine

  property int indentation: 0
  property int bulletType: noBullet
  property int __bulletNumberCache: 1

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
    height: root.height
    width: root.height * (root.indentation + 1 - (root.bulletType != noBullet))
  }
  Item {
    id: bullet
    visible: root.bulletType != root.noBullet
    height: root.height * visible
    width: root.height * visible
    Rectangle
    {
      visible: root.bulletType == root.shapeBullet
      anchors.centerIn: parent
      color: root.style.bulletColor
      height: root.style.bulletSize * parent.height
      width: root.style.bulletSize * parent.width
      radius: 0.5 * width * root.style.bulletRadius
      border.width: root.style.bulletBorderWidth
      border.color: root.style.bulletBorderColor
    }
    Text
    {
      visible: root.bulletType == root.numberBullet
      anchors.centerIn: parent
      color: root.style.bulletColor
      font: root.style.text.font
      text: root.__bulletNumberCache
    }
  }
}
