import QtQuick 2.0

Item
{
  readonly property Item slide: __slide // TODO: Item should be Style, but this is recursive and crash...
}
