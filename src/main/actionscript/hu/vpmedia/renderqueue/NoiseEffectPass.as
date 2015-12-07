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
public class NoiseEffectPass implements IBaseRenderPass {
    protected var renderTime:Number;
    protected var startTime:Number
    public var grayScale:Boolean;

    public function NoiseEffectPass() {
    }

    public function drawTo(canvas:BitmapData):void {
        startTime = getTimer();
        canvas.noise(Math.floor(1000 * Math.random()), 0, 255, 1 | 2 | 4, grayScale);
        renderTime = getTimer() - startTime;
    }

    public function getRenderTime():Number {
        return renderTime;
    }
}
}
