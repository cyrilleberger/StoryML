import QtQuick 2.0
import StoryML.Components 1.0

ItemsLine {
  id: root
  property alias videoHeight: root.itemHeight
  property alias videoHeights: root.itemHeights
  property alias videoSpacing: root.itemSpacing
  property alias sources: root.model

  component: Video {
    source: itemData
  }
}


