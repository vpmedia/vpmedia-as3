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
package hu.vpmedia.shapes.core {
import flash.display.BlendMode;
import flash.display.Shape;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import hu.vpmedia.framework.BaseConfig;

/**
 * TBD
 */
public class DisplayObjectConfig extends BaseConfig {

    /**
     * @see flash.display.DisplayObject.name
     */
    public var name:String;

    /**
     * @see flash.display.DisplayObject.x
     */
    public var x:Number;

    /**
     * @see flash.display.DisplayObject.y
     */
    public var y:Number;

    /**
     * @see flash.display.DisplayObject.width
     */
    public var width:Number;

    /**
     * @see flash.display.DisplayObject.height
     */
    public var height:Number;

    /**
     * @see flash.display.DisplayObject.visible
     */
    public var visible:Boolean;

    /**
     * @see flash.display.DisplayObject.cacheAsBitmap
     */
    public var cacheAsBitmap:Boolean;

    /**
     * @see flash.display.DisplayObject.scrollRect
     */
    public var scrollRect:Rectangle;

    /**
     * @see flash.display.DisplayObject.scale9Grid
     */
    public var scale9Grid:Rectangle;

    /**
     * @see flash.display.DisplayObject.scaleX
     */
    public var scaleX:Number;

    /**
     * @see flash.display.DisplayObject.scaleY
     */
    public var scaleY:Number;

    /**
     * @see flash.display.DisplayObject.rotation
     */
    public var rotation:Number;

    /**
     * @see flash.display.DisplayObject.alpha
     */
    public var alpha:Number;

    /**
     * @see flash.display.DisplayObject.blendMode
     */
    public var blendMode:String;

    /**
     * @see flash.display.DisplayObject.mask
     */
    public var mask:Shape;

    /**
     * @see flash.display.DisplayObject.matrix
     */
    public var matrix:Matrix;

    /**
     * @see flash.display.DisplayObject.colorTransform
     */
    public var colorTransform:ColorTransform;

    /**
     * @see flash.display.DisplayObject.filters
     */
    public var filters:Array;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function DisplayObjectConfig(config:Object = null) {
        x = 0;
        y = 0;
        width = 0;
        height = 0;
        visible = true;
        scaleX = 1;
        scaleY = 1;
        rotation = 0;
        alpha = 1;
        blendMode = BlendMode.NORMAL;
        super(config);
    }
}
}
