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

/**
 * TBD
 */
public class PixelateEffectPass implements IBaseRenderPass {
    protected var renderTime:Number;
    protected var startTime:Number
    private var scale:Number;
    private var invertedScale:Number;
    private var drawBitmapData:BitmapData;
    private var drawMatrix:Matrix;
    private var originalBitmapData:BitmapData;
    public var pixelation:Number = 0;

    public function PixelateEffectPass() {
    }

    public function drawTo(canvas:BitmapData):void {
        if (!originalBitmapData) {
            originalBitmapData = canvas.clone();
        }
        startTime = getTimer();
        //
        if (pixelation == 1) {
            scale = 0.00001;
            drawBitmapData = new BitmapData(1, 1);
        }
        else {
            scale = 1 - pixelation;
            drawBitmapData = new BitmapData(Math.ceil(canvas.width * scale), Math.ceil(canvas.height * scale));
        }
        invertedScale = 1 / scale;
        drawMatrix = new Matrix(scale, 0, 0, scale);
        drawBitmapData.draw(originalBitmapData, drawMatrix);
        drawMatrix.a = drawMatrix.d = invertedScale;
        canvas.draw(drawBitmapData, drawMatrix);
        drawBitmapData.dispose();
        //
        renderTime = getTimer() - startTime;
    }

    public function getRenderTime():Number {
        return renderTime;
    }
}
}
