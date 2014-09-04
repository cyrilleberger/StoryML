import SlidesML.Components 1.0

ScalableText
{
  id: root

  property bool __updatingFontScale: false

  function updateFontSize()
  {
    if(__updatingFontScale) return;
    __updatingFontScale = true;
    if(root.width != 0)
    {
      fontScale = Math.min(1, root.fontScale * root.width / root.contentWidth)
    }
    __updatingFontScale = false;
  }
  onTextChanged: updateFontSize()
  onWidthChanged: updateFontSize()
  onFontChanged: updateFontSize()
}
