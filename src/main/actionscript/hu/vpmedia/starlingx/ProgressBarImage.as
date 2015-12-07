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
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * ImageCounter class encapsulates a Starling image progress bar display object.
 */
public final class ProgressBarImage extends Sprite {

    /**
     * @private
     */
    private var numRows:uint;

    /**
     * @private
     */
    private var gap:int;

    /**
     * @private
     */
    private var texture:Texture;

    /**
     * @private
     */
    private var direction:String;

    /**
     * @private
     */
    private var rows:Vector.<Image>;

    //----------------------------------
    //  Static Consts
    //----------------------------------

    /**
     * TBD
     */
    public static const TOP_BOTTOM:String = "TOP_BOTTOM";

    /**
     * TBD
     */
    public static const BOTTOM_TOP:String = "BOTTOM_TOP";

    /**
     * TBD
     */
    public static const LEFT_RIGHT:String = "LEFT_RIGHT";

    /**
     * TBD
     */
    public static const RIGHT_LEFT:String = "RIGHT_LEFT";

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function ProgressBarImage(texture:Texture, numRows:uint, gap:int = 0, direction:String = "BOTTOM_TOP") {
        this.numRows = numRows;
        this.texture = texture;
        this.gap = gap;
        this.direction = direction;
        super();
        initialize();
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @private
     */
    private function initialize():void {
        // setup component
        touchable = false;
        // create digit list
        rows = new Vector.<Image>(numRows);
        // create digits
        for (var i:uint = 0; i < numRows; i++) {
            const image:Image = new Image(texture);
            switch (direction) {
                case TOP_BOTTOM:
                case BOTTOM_TOP:
                    image.y = i * (image.height + gap);
                    break;
                case LEFT_RIGHT:
                case RIGHT_LEFT:
                    image.x = i * (image.width + gap);
                    break;
            }
            image.visible = false;
            // add to container
            addChild(image);
            // add to list
            rows[i] = image;
        }
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        // dispose list
        if (rows)
            rows.length = 0;
        rows = null;
        // remove private object references
        texture = null;
        // remove inherited behaviors
        super.dispose();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function setProgress(value:int):void {
        switch (direction) {
            case TOP_BOTTOM:
            case LEFT_RIGHT:
                setProgressDefault(value);
                break;
            case BOTTOM_TOP:
            case RIGHT_LEFT:
                setProgressReverted(value);
                break;
        }
    }


    /**
     * @inheritDoc
     */
    private function setProgressDefault(value:int):void {
        trace(this, "setProgressDefault", value);
        for (var i:uint = 0; i < numRows; i++) {
            const image:Image = Image(getChildAt(i));
            image.visible = (value >= i);
        }
    }

    /**
     * @inheritDoc
     */
    private function setProgressReverted(value:int):void {
        trace(this, "setProgressReverted", value);
        var c:uint = 0;
        for (var i:int = numRows - 1; i >= 0; i--) {
            const image:Image = Image(getChildAt(i));
            image.visible = (value >= c);
            c++;
        }
    }

}
}
