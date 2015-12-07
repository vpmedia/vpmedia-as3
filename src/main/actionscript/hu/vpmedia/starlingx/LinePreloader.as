/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2014 Docmet Systems
 *  http://www.docmet.com
 *
 *  For information about the licensing and copyright please
 *  contact us at info@docmet.com
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */
package hu.vpmedia.starlingx {
import starling.display.Quad;
import starling.display.QuadBatch;
import starling.display.Sprite;

/**
 * Simple line preloader
 */
public final class LinePreloader extends Sprite implements IPreloader{

    /**
     * @private
     */
    private var preloaderWidth:uint;

    /**
     * @private
     */
    private var preloaderHeight:uint;

    /**
     * @private
     */
    private var progressColor:uint;

    /**
     * @private
     */
    private var backgroundColor:uint;

    /**
     * @private
     */
    private var background:Quad;

    /**
     * @private
     */
    private var progress:Quad;

    /**
     * @inheritDoc
     */
    public function LinePreloader(preloaderWidth:uint, preloaderHeight:uint, backgroundColor:uint, progressColor:uint) {
        this.preloaderWidth = preloaderWidth;
        this.preloaderHeight = preloaderHeight;
        this.backgroundColor = backgroundColor;
        this.progressColor = progressColor;
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        background = new Quad(preloaderWidth, preloaderHeight, backgroundColor);
        addChild(background);
        progress = new Quad(preloaderWidth, preloaderHeight, progressColor);
        addChild(progress);
        progress.scaleX = 0.0000001;
    }

    /**
     * TBD
     */
    public function set percent(value:Number):void {
        progress.scaleX = value;
    }

}
}