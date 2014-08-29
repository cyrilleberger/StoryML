import QtQuick 2.0
import SlidesML 1.0

Text {
  id: slideCounter

  property Slide slide
  property Presentation __presentation: slide ? slide.parent : null;
  property bool showTotal: true

  color: slide.style_instance.footer.color
  font: slide.style_instance.footer.font
  text: showTotal ? slide.slideNumber + " / " + __presentation.slides.length : slide.slideNumber
}
