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
package hu.vpmedia.display {
import flash.display.Bitmap;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * TBD
 */
public class ParallaxBitmap extends Bitmap {
    public var matrix:Matrix;

    public var parallaxAmount:Number = 1;

    /**
     * Constructor
     */
    public function ParallaxBitmap() {
        matrix = this.transform.matrix.clone();
        this.smoothing = true;
    }

    /**
     * TBD
     */
    public function move(dx:Number, dy:Number):void {
        matrix = this.transform.matrix.clone();
        matrix.translate(dx * parallaxAmount, dy * parallaxAmount);
        /*if(dx!=0)
         matrix.tx%=scrollingBitmap.width;
         if(dy!=0)
         matrix.ty%=scrollingBitmap.height;*/
        this.transform.matrix = matrix;
        if (stage == null) {
            return
        }
        if (this.getBounds(stage).intersects(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight))) {
            this.visible = true;
        }
        else {
            this.visible = false;
        }
    }

}

}
