import QtQuick 2.0
import StoryML 1.0
import StoryML.StoryTellers 1.0

Story
{
  id: root
  property Component defaultSectionStyle: defaultStyle
  property Component defaultSubsectionStyle: defaultSectionStyle

  storyTeller: Linear { story: root }

}
