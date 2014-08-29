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
  }
  Slide {
    title: "Next slide"
    content: "next content"
    Component.onCompleted:
    {
      style_instance.showTotalCount = false
    }
  }
}
