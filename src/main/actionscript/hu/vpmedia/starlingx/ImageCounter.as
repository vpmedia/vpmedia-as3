/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright(c) 2014 Andras Csizmadia.
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact Andras Csizmadia at andras@vpmedia.eu.
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
import hu.vpmedia.utils.StringUtil;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * ImageCounter class encapsulates a Starling image counter display object.
 */
public final class ImageCounter extends Sprite {

    /**
     * @private
     */
    private var autoAlign:Boolean;

    /**
     * @private
     */
    private var gap:int;

    /**
     * @private
     */
    private var numDigits:uint;

    /**
     * @private
     */
    private var currentValue:String;

    /**
     * @private
     */
    private var digits:Vector.<Image>;

    /**
     * @private
     */
    private var container:Sprite;
    
    /**
     * @private
     */
    private var mul:Image;

    /**
     * @private
     */
    private var atlas:TextureAtlas;

    /**
     * @private
     */
    private var atlasPrefix:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function ImageCounter(numDigits:uint, gap:int, atlas:TextureAtlas, atlasPrefix:String = "", autoAlign:Boolean = true) {
        this.atlas = atlas;
        this.autoAlign = autoAlign;
        this.numDigits = numDigits;
        this.gap = gap;
        this.atlasPrefix = atlasPrefix;
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
        this.touchable = false;
        // create digit list
        digits = new Vector.<Image>(numDigits);
        // create digit container
        container = new Sprite();
        addChild(container);
        // create digits
        for (var i:uint = 0; i < numDigits; i++) {
            var texture:Texture = atlas.getTexture(atlasPrefix + "0");
            var image:Image = new Image(texture);
            image.x = i * (image.width + gap);
            image.visible = false;
            // add to container
            container.addChild(image);
            // add to list
            digits[i] = image;
        }
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        digits.length = 0;
        // remove private object references
        atlas = null;
        // remove inherited behaviors
        super.dispose();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will update the counter display
     */
    public function update(value:int):void {
        var newValue:String = StringUtil.addLeadingZero(value, numDigits);
        // update not necessary
        if (value == -1) {
            this.visible = false;
            return;
        } else {
            this.visible = true;
        }
        if (currentValue == newValue)
            return;
        // update needed
        currentValue = newValue;
        var values:Vector.<String> = Vector.<String>(currentValue.split(""));
        var numVisibleItems:uint = 0;
        for (var i:uint = 0; i < numDigits; i++) {
            if (numVisibleItems || values[i] != "0" || (i == numDigits - 1)) {
                digits[i].texture = atlas.getTexture(atlasPrefix + values[i]);
                digits[i].visible = true;
                numVisibleItems++;
            } else {
                digits[i].visible = false;
            }
        }
        if (autoAlign) {
            const itemWidth:uint = digits[0].width + gap;
            const totalWidth:uint = numDigits * itemWidth;
            const expectedWidth:uint = numVisibleItems * itemWidth;
            container.x = (expectedWidth - totalWidth) * 0.5;
            if(mul)
                mul.x = container.x + container.width;
        }
    }

    /**
     * Will show multiplier 'x' as suffix
     */
    public function showMul():void {
        if(!mul) {
            mul = new Image(atlas.getTexture(atlasPrefix + "x"));
            addChild(mul);
        }
    }
    
    /**
     * Will return the total width of the object.
     */
    public function get totalWidth():uint {
        return (numDigits * totalHeight) + ((numDigits - 1) * gap);
    }

    /**
     * Will return the total height of the object.
     */
    public function get totalHeight():uint {
        return digits[0].height;
    }

    /**
     * Will return the first digit item.
     */
    public function get firstItem():Image {
        return digits[0];
    }
}
}
