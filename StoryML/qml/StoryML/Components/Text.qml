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
import StoryML 1.0

Text
{
  id: root
  property SliceAnimation animation: SliceAnimation { parentItem: root }
  opacity: animation.inFrame ? 1 : __parent_slice ? __parent_slice.style_instance.hiddenOpacity : 0
  property Slice __parent_slice: __find_parent_slice(parent)
  function __find_parent_slice(p)
  {
    if(p)
    {
      if(p.style_instance) // Not really a perfect check that p is a slice
      {
        return p
      }
      return __find_parent_slice(p.parent)
    }
    return null
  }
}
