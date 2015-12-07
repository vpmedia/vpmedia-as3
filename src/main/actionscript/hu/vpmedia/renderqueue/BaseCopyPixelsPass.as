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
package hu.vpmedia.renderqueue {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.IBitmapDrawable;
import flash.utils.getTimer;

/**
 * TBD
 */
public class BaseCopyPixelsPass implements IBaseRenderPass {

    protected var list:Vector.<IBitmapDrawable>;

    protected var params:Vector.<BaseCopyPixelsPassVars>;

    protected var renderTime:Number;

    protected var startTime:Number

    /**
     * TBD
     */
    public function BaseCopyPixelsPass() {
        removeAll();
    }

    /**
     * TBD
     */
    public function drawTo(canvas:BitmapData):void {
        startTime = getTimer();
        var n:int = list.length;
        var i:int;
        for (i = 0; i < n; i++) {
            canvas.copyPixels(Bitmap(list[i]).bitmapData, params[i].sourceRectangle, params[i].destinationPoint, params[i].alphaBitmapData, params[i].alphaPoint, params[i].mergeAlpha);
        }
        renderTime = getTimer() - startTime;
    }

    /**
     * TBD
     */
    public function add(item:IBitmapDrawable, config:BaseCopyPixelsPassVars = null):void {
        if (!config)
            config = new BaseCopyPixelsPassVars();
        list.push(item);
        params.push(config);
    }

    /**
     * TBD
     */
    public function remove(item:IBitmapDrawable):void {
        var position:int = list.indexOf(item);
        if (position > -1) {
            list.splice(position, 1);
            params.splice(position, 1);
        }
    }

    /**
     * TBD
     */
    public function removeAll():void {
        startTime = 0;
        renderTime = 0;
        list = new Vector.<IBitmapDrawable>;
        params = new Vector.<BaseCopyPixelsPassVars>;
    }

    /**
     * TBD
     */
    public function getRenderTime():Number {
        return renderTime;
    }
}
}
