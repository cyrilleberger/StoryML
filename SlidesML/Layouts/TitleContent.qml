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
import SlidesML 1.0
import SlidesML.Components 1.0

SlideLayout
{
  id: root
  property int margin: 30
  property int marginBottom: 0
  property int marginRight: 0

  AutoscalableText {
    id: titleText
    x: root.margin
    y: root.margin
    width: root.width - 2 * root.margin
    height: slide.style_instance.titleSize

    color: slide.style_instance.title.color
    baseFont: slide.style_instance.title.font
    text: slide.title

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  ContentBox
  {
    x: root.margin
    y: slide.style_instance.headerSize + root.margin
    width: root.width - 2 * root.margin - marginRight
    height: root.height - 3 * root.margin - slide.style_instance.footerSize - root.marginBottom - slide.style_instance.headerSize

    content: slide.content
    style: slide.style_instance
  }
}
