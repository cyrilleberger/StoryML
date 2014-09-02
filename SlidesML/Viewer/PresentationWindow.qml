import QtQuick 2.0
import QtQuick.Window 2.0

Window
{
  id: root
  property Component presentation
  signal presentationClosed
  Loader
  {
    id: presentationLoader
    sourceComponent: root.presentation
    anchors.fill: parent
    focus: true
    Keys.onPressed:
    {
      if((event.modifiers == (Qt.ControlModifier | Qt.ShiftModifier)) && event.key == Qt.Key_F)
      {
        if(root.visibility == Window.FullScreen)
          root.visibility = Window.Windowed
        else
          root.visibility = Window.FullScreen
      } else if(event.key == Qt.Key_Escape)
      {
        presentationClosed()
      }
    }
  }
  onVisibleChanged:
  {
    presentationLoader.item.focus = true
    presentationLoader.item.forceActiveFocus()
  }
}
