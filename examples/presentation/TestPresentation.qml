import QtQuick 2.0
import StoryML 1.0
import StoryML.Components 1.0
import StoryML.Styles 1.0

Presentation {
  defaultStyle: Simple {
    backgroundColor: "#999"
  }

  Slice {
    style: Simple {
      backgroundColor: "#191919"
      title.color: "red"
      text.color: "white"
      footer.color: "orange"
    }
    title: "Slide title"
    content: "Text of the slide"
    notes: "Example of notes"
  }
  Slice {
    title: "Next slide"
    content: "next content"
    Component.onCompleted:
    {
      style_instance.showTotalCount = false
    }
  }
  Slice {
    title: "Content lines"
    contentLines: [ TextLine { text: "Einstein is a genius." }, TextLine { text: "Can you believe it ?" } ]
  }
  Slice {
    title: "Yet another slide"
    content: ["Ah", "doh", "*boh", "**booh", "##llaaaa", "*hum", "ah", " lag", { type: 'TextLine', text: "this is a textline" } ]
  }
  Slice {
    title: "Animation"
    property ContentLine workaround: TextLine { text: "workaround" }
    content: ["Ah", "<2>doh", "<2-3>*boh", "<-3>**booh", "<4->##llaaaa", "<2>*hum", workaround, "<-3>ah", "<-5> lag", "<-2> Rah is Einstein for calculus", { type: 'TextLine', text: "TextLine", "animation.first": 2, "animation.last": 3 } ]
  }
  Slice {
    title: "Numbered"
    content: [ "#hello", "##bonjour", "##guten tag", "#buenos dias", "##hej", "###salut", "###bon dia", "##prozit"]
  }
}
