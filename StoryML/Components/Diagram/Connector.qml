import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0
import StoryML.Components.Diagram 1.0

Canvas
{
  id: root
  property real thickness: 1
  property color color: "black"
  property ConnectionPoint connectionPoint1
  property ConnectionPoint connectionPoint2
  property real arrowSize: 10
  property SliceAnimation animation: SliceAnimation { parentItem: root }
  opacity: root.animation.inFrame ? 1 : root.parent.style_instance.hiddenOpacity

  property string marker1: "arrow"
  property string marker2: "arrow"

  onConnectionPoint1Changed: __updateGeometry()
  onConnectionPoint2Changed: __updateGeometry()

  property real __margin: Math.max(thickness, arrowSize)

  function __updateGeometry()
  {
    if(connectionPoint1 && connectionPoint2)
    {
      root.x = Qt.binding(function() { return Math.min(connectionPoint1.absoluteX, connectionPoint2.absoluteX) - root.__margin })
      root.y = Qt.binding(function() { return Math.min(connectionPoint1.absoluteY, connectionPoint2.absoluteY) - root.__margin })
      root.width = Qt.binding(function() { return Math.abs(connectionPoint1.absoluteX - connectionPoint2.absoluteX) + 2 * root.__margin })
      root.height = Qt.binding(function() { return Math.abs(connectionPoint1.absoluteY - connectionPoint2.absoluteY) + 2 * root.__margin })
    } else {
      root.width  = 0
      root.height = 0
    }
  }

  function __drawArrow(ctx, x_1, y_1, x_e, y_e)
  {
    var x_sl = x_e - x_1
    var y_sl = y_e - y_1
    var n_sl = Math.sqrt(x_sl * x_sl + y_sl * y_sl)
    x_sl = x_sl / n_sl * root.arrowSize
    y_sl = y_sl / n_sl * root.arrowSize

    ctx.save()
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = thickness;
    ctx.beginPath()
    ctx.moveTo(x_e - x_sl + 0.5 * y_sl, y_e - y_sl - 0.5 * x_sl)
    ctx.lineTo(x_e, y_e)
    ctx.lineTo(x_e - x_sl - 0.5 * y_sl, y_e - y_sl + 0.5 * x_sl)
    ctx.lineTo(x_e - 0.5 * x_sl, y_e - 0.5 * y_sl)
    ctx.closePath()
    ctx.fill()
    ctx.restore()
  }

  function __drawMarker(type, ctx, x_1, y_1, x_e, y_e)
  {
    if(type === "arrow")
    {
      __drawArrow(ctx, x_1, y_1, x_e, y_e)
    } else if(type !== "none")
    {
      console.log("Unknown marker type: ", type)
    }
  }

  onPaint: {
    var x_1 = connectionPoint1.absoluteX - x
    var y_1 = connectionPoint1.absoluteY - y
    var x_2 = connectionPoint2.absoluteX - x
    var y_2 = connectionPoint2.absoluteY - y

    var ctx = getContext('2d');
    ctx.save()
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = thickness;
    ctx.beginPath();
    ctx.moveTo(x_1, y_1)
    ctx.lineTo(x_2, y_2)
    ctx.closePath()
    ctx.stroke()
    ctx.restore()

    __drawMarker(root.marker2, ctx, x_1, y_1, x_2, y_2)
    __drawMarker(root.marker1, ctx, x_2, y_2, x_1, y_1)
  }
}

