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
import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getTimer;

/**
 * TBD
 */
public class BasePostProcessPass implements IBasePostProcessPass {
    protected var list:Vector.<BitmapFilter>;
    protected var renderTime:Number;
    protected var startTime:Number;

    public function BasePostProcessPass() {
        removeAll();
    }

    public function drawTo(canvas:BitmapData):void {
        startTime = getTimer();
        var n:int = list.length;
        var i:int;
        for (i = 0; i < n; i++) {
            canvas.applyFilter(canvas, new Rectangle(0, 0, canvas.width, canvas.height), new Point(), list[i]);
        }
        renderTime = getTimer() - startTime;
    }

    public function add(filter:BitmapFilter):void {
        list.push(filter);
    }

    public function remove(filter:BitmapFilter):void {
        var position:int = list.indexOf(filter);
        if (position > -1)
            list.splice(position, 1);
    }

    public function removeAll():void {
        list = new Vector.<BitmapFilter>;
        startTime = 0;
        renderTime = 0;
    }

    public function getRenderTime():Number {
        return renderTime;
    }
}
}
