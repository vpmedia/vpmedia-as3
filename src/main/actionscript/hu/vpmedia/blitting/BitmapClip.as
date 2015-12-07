/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013-2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * For information about the licensing and copyright please
 * contact Andras Csizmadia at andras@vpmedia.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */
package hu.vpmedia.blitting {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Rectangle;

import hu.vpmedia.framework.IBaseSteppable;

/**
 * TBD
 */
public class BitmapClip extends Sprite implements IBaseSteppable {
    /**
     * @private
     */
    private var _bitmap:Bitmap;

    /**
     * @private
     */
    private var _bitmapData:BitmapData;

    /**
     * @private
     */
    private var _blit:BlitGroup;

    /**
     * @private
     */
    private var _fillRect:Rectangle;

    /**
     * TBD
     */
    public function BitmapClip(atlas:BlitAtlas, prefix:String = "", fps:int = 30) {
        _bitmapData = new BitmapData(220, 220, true, 0x00FFFFFF);
        _bitmap = new Bitmap(_bitmapData);
        addChild(_bitmap);
        _fillRect = new Rectangle(0, 0, _bitmap.width, _bitmap.height);
        var clip:BlitClip = new BlitClip(_bitmapData, atlas, prefix, fps);
        _blit = new BlitGroup(clip);
        _blit.currentSequence.step(0.0001);
        super();
    }

    /**
     * TBD
     */
    public function play(value:String):void {
        _blit.play(value);
    }

    /**
     * TBD
     */
    public function step(timeDelta:Number):void {
        _blit.currentSequence.canvas.fillRect(_fillRect, 0x00FFFFFF);
        _blit.currentSequence.step(timeDelta);
    }
}
}
