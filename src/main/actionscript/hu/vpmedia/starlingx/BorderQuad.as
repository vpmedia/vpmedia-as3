/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
package hu.vpmedia.starlingx {
import starling.display.Quad;
import starling.display.QuadBatch;

/**
 * Simple border graphics impl.
 */
public final class BorderQuad extends QuadBatch {

    /**
     * @private
     */
    private var borderWidth:uint;
    /**
     * @private
     */
    private var borderHeight:uint;
    /**
     * @private
     */
    private var borderSize:uint;
    /**
     * @private
     */
    private var borderColor:uint;
    /**
     * @private
     */
    private var top:Quad;
    /**
     * @private
     */
    private var bottom:Quad;
    /**
     * @private
     */
    private var left:Quad;
    /**
     * @private
     */
    private var right:Quad;

    /**
     * @inheritDoc
     */
    public function BorderQuad(borderWidth:uint, borderHeight:uint, borderSize:uint, borderColor:uint, borderAlpha:Number = 1) {
        this.borderWidth = borderWidth;
        this.borderHeight = borderHeight;
        this.borderSize = borderSize;
        this.borderColor = borderColor;
        this.alpha = borderAlpha;
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        top = new Quad(borderWidth, borderSize, borderColor);
        top.x = 0;
        top.y = 0;
        addQuad(top);
        bottom = new Quad(borderWidth, borderSize, borderColor);
        bottom.x = 0;
        bottom.y = borderHeight - borderSize;
        addQuad(bottom);
        left = new Quad(borderSize, borderHeight - borderSize - borderSize, borderColor);
        left.x = 0;
        left.y = borderSize;
        addQuad(left);
        right = new Quad(borderSize, borderHeight - borderSize - borderSize, borderColor);
        right.x = borderWidth - borderSize;
        right.y = borderSize;
        addQuad(right);
    }

    /**
     * Updates the color of all child quads
     */
    public function set color(value:uint):void {
        setQuadColor(0, value);
        setQuadColor(1, value);
        setQuadColor(2, value);
        setQuadColor(3, value);
    }

    /**
     * Returns the color of the child quads
     */
    public function get color():uint {
        return getQuadColor(0);
    }

}
}