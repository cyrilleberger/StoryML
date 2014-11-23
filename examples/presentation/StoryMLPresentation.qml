import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0
import StoryML.Components.Diagram 1.0
import StoryML.Styles 1.0
import StoryML.Layouts 1.0

Presentation
{
  id: root
  defaultStyle: Simple {
    footer.color: "darkorange"
  }
  defaultSectionStyle: Simple {
    backgroundColor: "black"
    title.color: "white"
    text.color: "white"
    showSliceCounter: false
  }

  Slice {
    style: root.defaultSectionStyle
    layout: Title {}
    title: "StoryML"
    notes: "Introduction presentation of StoryML"
  }
  Slice {
    title: "Content"
    content: Utils.itemifyList(root.storyTeller.sections)
  }
  Section {
    title: "Introduction to StoryML"
    Slice
    {
      title: "What is StoryML?"
      content: ["*StoryML is a presentation and story telling tool using QML"]
    }
    Slice
    {
      title: "StoryPlayer"
    }
    Slice
    {
      title: "StoryEditor"
    }
  }
  Section {
    title: "How to use StoryML"
    Slice
    {
      title: "Presentation"
    }
    Slice
    {
      title: "Animation"
    }
    Slice
    {
      title: "Creating Style"
    }
    Slice
    {
      title: "Creating Layouts"
    }
  }
  Section {
    title: "StoryML Components"
    Section {
      title: "Text"
      content: [
        "*Content box",
        "*Autoscalable text"
      ]
    }
    Section {
      title: "Multimedia"
      Slide {
        title: "Multimedia"
        content: [
          "*Support for images",
          "*Support for video"
        ]
      }
    }
    Section {
      title: "Diagram"
      Slice {
        title: "Diagrams"
        content: [
          "*You can create diagrams:"
        ]
        Shape {
          id: firstItem
          x: 100
          y: 200
          width: 100
          height: 50
          text: "First item"
        }
        Shape {
          id: secondItem
          x: 400
          y: 200
          width: 100
          height: 50
          text: "Second item"
        }
        Shape {
          id: thirdItem
          animation.first:1
          x: 400
          y: 400
          width: 100
          height: 50
          text: "Third item"
        }
        Connector
        {
          connectionPoint1: firstItem.connectionPoints[3]
          connectionPoint2: secondItem.connectionPoints[7]
        }
        Connector
        {
          animation.first:1
          marker1: "none"
          connectionPoint1: firstItem.connectionPoints[4]
          connectionPoint2: thirdItem.connectionPoints[0]
        }
        Connector
        {
          animation.first:2
          marker2: "none"
          connectionPoint1: thirdItem.connectionPoints[1]
          connectionPoint2: secondItem.connectionPoints[5]
        }
      }
    }
  }
}
