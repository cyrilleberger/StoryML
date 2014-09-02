import QtQuick 2.0

Item
{
  id: root
  readonly property Item slide: __slide // TODO: Item should be Style, but this is recursive and crash...
  property SlideAnimation animation: SlideAnimation { parentItem: root }
}
