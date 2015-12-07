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
import flash.geom.Point;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * @inheritDoc
 */
public final class ProgressImage extends Sprite {

    /**
     * TBD
     */
    public static const AXIS_X:int = 1;

    /**
     * TBD
     */
    public static const AXIS_Y:int = 2;

    /**
     * @private
     */
    private var _ratio:Number;

    /**
     * @private
     */
    private var _axis:int;

    /**
     * @private
     */
    private var _image:Image;

    /**
     * @private
     */
    private static const HELPER:Point = new Point();

    /**
     * @inheritDoc
     */
    public function ProgressImage(texture:Texture, axis:int = 1) {
        _axis = axis;
        _image = new Image(texture);
        addChild(_image);
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        _ratio = 1.0;
        touchable = false;
    }

    /**
     * Will return the current ratio
     */
    public function get ratio():Number {
        return _ratio;
    }

    /**
     * Will set the ratio and updates the image
     */
    public function set ratio(value:Number):void {
        if (value == _ratio)
            return;
        _ratio = Math.max(0.0, Math.min(1.0, value));
        switch (_axis) {
            case AXIS_X:
            {
                _image.scaleX = _ratio;
                HELPER.setTo(_ratio, 0);
                _image.setTexCoords(1, HELPER);
                HELPER.setTo(_ratio, 1);
                _image.setTexCoords(3, HELPER);
                break;
            }
            case AXIS_Y:
            {
                _image.y = _image.height / _image.scaleY * (1 - _ratio);
                _image.scaleY = _ratio;
                HELPER.setTo(0, 1 - _ratio);
                _image.setTexCoords(0, HELPER);
                HELPER.setTo(1, 1 - _ratio);
                _image.setTexCoords(1, HELPER);
                break;
            }
        }
    }
}
}