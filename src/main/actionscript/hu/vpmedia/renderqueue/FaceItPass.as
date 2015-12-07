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
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.getTimer;

import hu.vpmedia.faceit.Tracker;

public class FaceItPass implements IBaseRenderPass {
    protected var renderTime:Number;
    protected var startTime:Number;
    protected var detector:Tracker;
    protected var detectionMap:BitmapData;
    public var sourceWidth:uint = 320;
    public var sourceHeight:uint = 240;
    public var detectScale:uint = 4;
    protected var detectMatrix:Matrix;
    private var hasTrackedInitialized:Boolean;
    public var detectRect:Rectangle;

    public function FaceItPass() {
        initialize();
    }

    protected function initialize():void {
        detector = new Tracker();
        detectionMap = new BitmapData(sourceWidth / detectScale, sourceHeight / detectScale, false, 0);
        detectMatrix = new Matrix(1 / detectScale, 0, 0, 1 / detectScale);
        detectRect = new Rectangle(0, 0, sourceWidth, sourceHeight);
    }

    public function drawTo(canvas:BitmapData):void {
        startTime = getTimer();
        detectionMap.lock();
        detectionMap.draw(canvas, detectMatrix, null, "normal", null, true);
        if (!hasTrackedInitialized) {
            hasTrackedInitialized = true;
            detector.initTracker(detectionMap, detectRect, detectScale);
        }
        detectionMap.unlock();
        detector.track(detectionMap);
        renderTime = getTimer() - startTime;
    }

    public function getRenderTime():Number {
        return renderTime;
    }
}
}
