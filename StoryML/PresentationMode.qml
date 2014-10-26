import QtQuick 2.0

Item
{
  id: root

  readonly property Item story: __story // TODO: Item should be Slice, but this is recursive and crash...


}
