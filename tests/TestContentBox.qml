import QtQuick 2.0
import StoryML 1.0
import StoryML.Styles 1.0

Presentation {

  Slice {
    title: "Slice title"
    content: [
      "Text of the slice which should be very long so that it overflow 1",
      "Text of the slice 2",
      "Text of the slice 3",
      "Text of the slice which should be very long so that it overflow 4",
      "Text of the slice 5",
      "Text of the slice 6",
      "*Text of the slice which should be very long so that it overflow and that should help with debugging that issue but seem to work while it does not always work 7",
      "Text of the slice 8",
      "Text of the slice 9",
      "Text of the slice 10"
    ]
  }
}
