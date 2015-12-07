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
import flash.display.Graphics;

import hu.vpmedia.framework.BaseConfig;

/**
 * @inheritDoc
 */
public class BaseGraphicsTexture extends BaseConfig implements IBaseGraphicsTexture {

    /**
     * @private
     */
    protected var _width:Number;

    /**
     * @private
     */
    protected var _height:Number;

    /**
     * @private
     */
    protected var _colorType:uint;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function BaseGraphicsTexture(parameters:Object = null) {
        super(parameters);
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

    /**
     * @inheritDoc
     */
    public function set colorType(value:uint):void {
        _colorType = value;
    }

    /**
     * @inheritDoc
     */
    public function get colorType():uint {
        return _colorType;
    }

    /**
     * @inheritDoc
     */
    public function set width(value:Number):void {
        _width = value;
    }

    /**
     * @inheritDoc
     */
    public function get width():Number {
        return _width;
    }

    /**
     * @inheritDoc
     */
    public function set height(value:Number):void {
        _height = value;
    }

    /**
     * @inheritDoc
     */
    public function get height():Number {
        return _height;
    }

    /**
     * @inheritDoc
     */
    public function draw(graphics:Graphics):void {
        // Override
    }
}
}
