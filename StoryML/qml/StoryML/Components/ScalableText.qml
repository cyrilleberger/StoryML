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

Text {
  id: root
  property font baseFont: __createBaseFont()
  property real fontScale: 1
  function __createBaseFont()
  {
    root.baseFont = root.font // Hack to force a deep copy of root.font in root.baseFont and avoid binding loops when updateFont is called
    return root.baseFont
  }

  function updateFont()
  {
    if(fontScale * baseFont.pointSize < 1)
    {
      console.log("Requesting a very small font for text:", root.text)
    }
    font = baseFont
    font.pointSize = Math.max(1, fontScale * baseFont.pointSize)
//    font.pixelSize = fontScale * baseFont.pixelSize
  }

  onBaseFontChanged: updateFont()
  onFontScaleChanged: updateFont()
}
