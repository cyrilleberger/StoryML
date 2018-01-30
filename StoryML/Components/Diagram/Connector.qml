import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0
import StoryML.Components.Diagram 1.0

Canvas
{
  id: root
  property real thickness: 1
  property color color: "black"
  property ConnectionPoint connectionPoint1: __getConnectionPoint(connectionPoints, 0)
  property ConnectionPoint connectionPoint2: __getConnectionPoint(connectionPoints, 1)
  property variant connectionPoints
  property real arrowSize: 10
  property SliceAnimation animation: SliceAnimation { parentItem: root }
  opacity: root.animation.inFrame ? 1 : root.parent.style_instance.hiddenOpacity
  property alias text: text_box.text

  property string marker1: "arrow"
  property string marker2: "arrow"

  onConnectionPoint1Changed: __updateGeometry()
  onConnectionPoint2Changed: __updateGeometry()

  property real __margin: Math.max(thickness, arrowSize)

  function __getConnectionPoint(arr, idx)
  {
    if(arr.length === 2)
    {
      return arr[idx]
    } else if(arr.length === 4) {
      return arr[2*idx].connectionPoints[arr[2*idx + 1]]
    } else {
      return null
    }
  }

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
  Text
  {
    id: text_box
    transform: [
      Translate {
        x: (root.width - text_box.width) * 0.5
        y: root.height * 0.5 - text_box.height
      },
      Rotation {
        origin.x: root.width * 0.5
        origin.y: root.height * 0.5
        angle: 180 * Math.atan2(connectionPoint2.absoluteY - connectionPoint1.absoluteY, connectionPoint2.absoluteX - connectionPoint1.absoluteX) / Math.PI
      }
    ]
  }
}

