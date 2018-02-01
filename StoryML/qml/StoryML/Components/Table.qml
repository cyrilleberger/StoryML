import QtQuick 2.0

Grid
{
  id: root
  property variant content
  property real fontScale: 1
  property TableCellStyle defaultStyle: TableCellStyle
  {
    text: root.parent.style.text
  }
  rowSpacing: 0
  columnSpacing: 0

  property variant __items

  Repeater
  {
    model: root.content
    TableCell
    {
      id: tableCell
      fontScale: root.fontScale
      function setOption(item, key, value)
      {
        if(key === "backgroundColor")
        {
          tableCell.color = value
        } else {
          console.log("Unknwon key " + key + " for value " + value)
        }
      }

      Component.onCompleted: {

        var item
        if(typeof modelData == 'string')
        {
          item = Qt.createQmlObject("import QtQuick 2.0;
          ScalableText {
            id: cellText
            baseFont: parent.style.text.font
            color: parent.style.text.color
            fontScale: parent.fontScale
          }", tableCell, "Table's text element")

          var start = 0
          if(modelData[start] === '[')
          {
            start += 1;
            var currentString = ""
            var currentKey = ""
            while(modelData[start] !== ']' && start < modelData.length)
            {
              var character = modelData[start]
              if(character === ',')
              {
                if(currentKey.length > 0)
                {
                  tableCell.setOption(item, currentKey, currentString)
                } else {
                  tableCell.setOption(item, currentString, "")
                }
                currentString = ""
                currentKey    = ""
              } else if(character === "=")
              {
                currentKey = currentString
                currentString = ""
              } else {
                currentString += character
              }
              start += 1;
            }
            start += 1
            if(currentString.length > 0)
            {
              if(currentKey.length > 0)
              {
                tableCell.setOption(item, currentKey, currentString)
              } else {
                tableCell.setOption(item, currentString, "")
              }
            }
          }

          if(start < modelData.length)
          {
            item.text = modelData.substring(start, modelData.length);
          } else {
            item.text = " "
          }

        } else {
          item = Qt.createQmlObject("import QtQuick 2.0; ScalableText { text: \"Unsupported type for " + modelData + "\"; color: \"red\" }", root, "Table's unsupported element")
        }
        item.fontScale = Qt.binding(function () { return tableCell.fontScale; })
        var items = []
        items.push(item)
        tableCell.children = items

        width   = Qt.binding(function () { return item.width })
        height  = Qt.binding(function () { return item.height })
      }
    }
  }
}
