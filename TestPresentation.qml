import QtQuick 2.0
import SlidesML 1.0
import SlidesML.Styles 1.0

Presentation {
  defaultStyle: Simple {
    backgroundColor: "#999"
  }

  Slide {
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
  Slide {
    title: "Next slide"
    content: "next content"
    Component.onCompleted:
    {
      style_instance.showTotalCount = false
    }
  }
  Slide {
    title: "Content lines"
    contentLines: [ TextLine { text: "Einstein is a genius." }, TextLine { text: "Can you believe it ?" } ]
  }
  Slide {
    title: "Yet another slide"
    content: ["Ah", "doh", "*boh", "**booh", "##llaaaa", "*hum", "ah", " lag", { type: 'TextLine', text: "this is a textline" } ]
  }
  Slide {
    title: "Animation"
    property ContentLine workaround: TextLine { text: "workaround" }
    content: ["<1->Ah", "<2>doh", "<2-3>*boh", "<-3>**booh", "<4->##llaaaa", "<2>*hum", workaround, "<-3>ah", "<-5> lag", "<-2> Rah is Einstein for calculus", { type: 'TextLine', text: "TextLine", "animation.first": 2, "animation.last": 3 } ]
  }
  Slide {
    title: "Numbered"
    content: [ "#hello", "##bonjour", "##guten tag", "#buenos dias", "##hej", "###salut", "###bon dia", "##prozit"]
  }
}
