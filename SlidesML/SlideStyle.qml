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

Item
{
  id: root

  readonly property Item slide: __slide // TODO: Item should be Slide, but this is recursive and crash...
  property TextStyle title: TextStyle { font.pointSize: 50 }
  property TextStyle text: TextStyle { font.pointSize: 30 }
  property TextStyle footer: TextStyle { font.pointSize: 20 }
  property real headerSize: 100
  property real footerSize: 0

  property TextLineStyle level0: TextLineStyle { text: TextStyle { font.pointSize: 30 } }
  property TextLineStyle level1: TextLineStyle { text: TextStyle { font.pointSize: 25 } bulletSize: 0.35; bulletColor: "white"; bulletBorderColor: "black" }
  property TextLineStyle level2: TextLineStyle { text: TextStyle { font.pointSize: 20 } bulletSize: 0.3;  bulletRadius: 0.5; bulletColor: "white"; bulletBorderColor: "black"; bulletBorderWidth: 0}
}
