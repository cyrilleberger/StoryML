import QtQuick 2.9
import QtQuick.Controls.Styles 1.4
import StoryML 1.0

TextEdit
{
  id: root
  property string highlightingDefinition
  property SliceAnimation animation: SliceAnimation { parentItem: root }
  onHighlightingDefinitionChanged:
  {
      Extension.setSyntaxHighlighting(textDocument, highlightingDefinition)
  }
  readOnly: true
  height: contentHeight
  property font baseFont: __createBaseFont()
  property real fontScale: 1
  property alias textColor: root.color
  wrapMode: TextEdit.WordWrap

  function __createBaseFont()
  {
    root.baseFont = root.font // Hack to force a deep copy of root.font in root.baseFont and avoid binding loops when updateFont is called
    return root.baseFont
  }

  function updateFont()
  {
    font = baseFont
    font.family = "Monospace"
    font.pointSize = fontScale * baseFont.pointSize
//    font.pixelSize = fontScale * baseFont.pixelSize
  }
  renderType: Text.QtRendering
  selectByMouse: false
  selectByKeyboard: false
  onBaseFontChanged: updateFont()
  onFontScaleChanged: updateFont()
}
