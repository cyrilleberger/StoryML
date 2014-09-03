import QtQuick 2.0

Text {
  id: root
  property font baseFont: root.font
  property real fontScale: 1

  function updateFont()
  {
    font = baseFont
    font.pixelSize = fontScale * baseFont.pixelSize
  }

  onBaseFontChanged: updateFont()
  onFontScaleChanged: updateFont()
}
