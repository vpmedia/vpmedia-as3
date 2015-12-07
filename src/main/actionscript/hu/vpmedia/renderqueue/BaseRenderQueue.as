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
import flash.utils.getTimer;

/**
 * TBD
 */
public class BaseRenderQueue implements IBaseRenderQueue {

    /**
     * TBD
     */
    protected var list:Vector.<IBaseRenderPass>;

    /**
     * TBD
     */
    protected var renderTime:Number;

    /**
     * TBD
     */
    protected var startTime:Number

    /**
     * TBD
     */
    protected var bitmapData:BitmapData;

    /**
     * TBD
     */
    public function BaseRenderQueue(target:BitmapData) {
        removeAll();
        bitmapData = target;
    }

    /**
     * TBD
     */
    public function draw():void {
        startTime = getTimer();
        var n:int = list.length;
        var i:int;
        bitmapData.lock();
        for (i = 0; i < n; i++) {
            list[i].drawTo(bitmapData);
        }
        bitmapData.unlock();
        renderTime = getTimer() - startTime;
    }

    /**
     * TBD
     */
    public function add(pass:IBaseRenderPass):void {
        list.push(pass);
    }

    /**
     * TBD
     */
    public function remove(pass:IBaseRenderPass):void {
        var position:int = list.indexOf(pass);
        if (position > -1)
            list.splice(position, 1);
    }

    /**
     * TBD
     */
    public function removeAll():void {
        list = new Vector.<IBaseRenderPass>;
        startTime = 0;
        renderTime = 0;
    }

    /**
     * TBD
     */
    public function getRenderTime():Number {
        return renderTime;
    }
}
}
