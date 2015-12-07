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
import flash.utils.getTimer;

import hu.vpmedia.objectdetection.ObjectDetector;
import hu.vpmedia.objectdetection.ObjectDetectorEvent;
import hu.vpmedia.objectdetection.ObjectDetectorOptions;

public class ObjectDetectionPass implements IBaseRenderPass {
    protected var renderTime:Number;
    protected var startTime:Number;
    protected var detector:ObjectDetector;
    protected var detectionMap:BitmapData;
    public var sourceWidth:uint = 320;
    public var sourceHeight:uint = 240;
    public var detectScale:uint = 4;
    public var detectMinSize:uint = 15;
    protected var detectMatrix:Matrix;

    public function ObjectDetectionPass() {
        initialize();
    }

    protected function initialize():void {
        detector = new ObjectDetector();
        var options:ObjectDetectorOptions = new ObjectDetectorOptions();
        options.min_size = detectMinSize;
        detector.options = options;
        detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler, false, 0, true);
        var detectWidth:Number = sourceWidth / detectScale;
        var detectHeight:Number = sourceHeight / detectScale;
        detectionMap = new BitmapData(detectWidth, detectHeight, false, 0);
        detectMatrix = new Matrix(1 / detectScale, 0, 0, 1 / detectScale);
        //trace(detectWidth,detectHeight,detectMatrix);
    }

    private function detectionHandler(event:ObjectDetectorEvent):void {
        /* if (event.rects && event.rects[0])
         {
         trace(this, "detectionHandler", event.type);
         }*/
    }

    public function drawTo(canvas:BitmapData):void {
        startTime = getTimer();
        detectionMap.lock();
        detectionMap.draw(canvas, detectMatrix, null, "normal", null, true);
        detectionMap.unlock();
        detector.detect(detectionMap);
        renderTime = getTimer() - startTime;
    }

    public function getDetectionMap():BitmapData {
        return detectionMap;
    }

    public function getRenderTime():Number {
        return renderTime;
    }
}
}
