/* Copyright (c) 2014, Cyrille Berger <cberger@cberger.net>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 */

import QtQuick 2.0

Item {
  id: root
  property Item inherits
  property alias font: forfont.font
  property color color: inherits ? inherits.color : "black"
  Text {
    id: forfont
    visible: false
  }
  onInheritsChanged:
  {
    if(root.inherits)
    {
      if(font.bold === forfontdefault.font.bold)
      {
        font.bold = Qt.binding(function() { return root.inherits.font.bold })
      }
      if(font.family === forfontdefault.font.family)
      {
        font.family = Qt.binding(function() { return root.inherits.font.family })
      }
      if(font.italic === forfontdefault.font.italic)
      {
        font.italic = Qt.binding(function() { return root.inherits.font.italic })
      }
      if(font.letterSpacing === forfontdefault.font.letterSpacing)
      {
        font.letterSpacing = Qt.binding(function() { return root.inherits.font.letterSpacing })
      }
      if(font.overline === forfontdefault.font.overline)
      {
        font.overline = Qt.binding(function() { return root.inherits.font.overline })
      }
      if(font.pointSize === forfontdefault.font.pointSize)
      {
        font.pointSize = Qt.binding(function() { return root.inherits.font.pointSize })
      }
      if(font.strikeout === forfontdefault.font.strikeout)
      {
        font.strikeout = Qt.binding(function() { return root.inherits.font.strikeout })
      }
      if(font.underline === forfontdefault.font.underline)
      {
        font.underline = Qt.binding(function() { return root.inherits.font.underline })
      }
      if(font.weight === forfontdefault.font.weight)
      {
        font.weight = Qt.binding(function() { return root.inherits.font.weight })
      }
      if(font.wordSpacing === forfontdefault.font.wordSpacing)
      {
        font.wordSpacing = Qt.binding(function() { return root.inherits.font.wordSpacing })
      }
    }
  }
  Text
  {
    id: forfontdefault
    visible: false
  }
}
