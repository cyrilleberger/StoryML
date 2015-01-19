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
    font.bold: root.inherits ? root.inherits.font.bold : forfontdefault.font.bold
    font.capitalization: root.inherits ? root.inherits.font.capitalization : forfontdefault.font.capitalization
    font.family: root.inherits ? root.inherits.font.family : forfontdefault.font.family
    font.italic: root.inherits ? root.inherits.font.italic : forfontdefault.font.italic
    font.letterSpacing: root.inherits ? root.inherits.font.letterSpacing : forfontdefault.font.letterSpacing
    font.overline: root.inherits ? root.inherits.font.overline : forfontdefault.font.overline
    font.pointSize: root.inherits ? root.inherits.font.pointSize : forfontdefault.font.pointSize
    font.strikeout: root.inherits ? root.inherits.font.strikeout : forfontdefault.font.strikeout
    font.underline: root.inherits ? root.inherits.font.underline : forfontdefault.font.underline
    font.weight: root.inherits ? root.inherits.font.weight : forfontdefault.font.weight
    font.wordSpacing: root.inherits ? root.inherits.font.wordSpacing : forfontdefault.font.wordSpacing
  }
  Text
  {
    id: forfontdefault
    visible: false
  }
}
