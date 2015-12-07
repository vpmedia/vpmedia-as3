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

package hu.vpmedia.profilers {
import flash.display.DisplayObjectContainer;

/**
 * TBD
 */
public class DisplayListProfiler implements IBaseProfiler {

    /**
     * TBD
     */
    public var container:DisplayObjectContainer;

    /**
     * TBD
     */
    public var data:ProfilerData;

    /**
     * TBD
     */
    public function DisplayListProfiler(container:DisplayObjectContainer) {
        this.container = container;
        data = new ProfilerData();
    }

    /**
     * TBD
     */
    public function dispose():void {
        container = null;
        data = null;
    }

    /**
     * TBD
     */
    public function step(timeDelta:Number):void {
        data.cur = 0;
        countDisplayList(container);
    }

    /**
     * TBD
     */
    private function countDisplayList(target:DisplayObjectContainer):void {
        var n:int = target.numChildren;
        data.step(data.cur + n);
        for (var i:uint = 0; i < n; i++) {
            if (target.getChildAt(i) is DisplayObjectContainer) {
                countDisplayList(DisplayObjectContainer(target.getChildAt(i)));
            }
        }
    }
}
}

