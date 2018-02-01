import QtQuick 2.2
import StoryML 1.0

Image
{
  property string formula: "No text specified"
  property bool forceCompile: false
  property bool centered: true
  property string color: "black"

  source: Extension.formulaFile(formula, color, centered)

  smooth: true
  sourceSize.width: width
  sourceSize.height: height
  fillMode: Image.PreserveAspectFit
}
