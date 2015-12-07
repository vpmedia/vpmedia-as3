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
import flash.display.Sprite;
import flash.events.Event;

/**
 * TBD
 */
public class BaseShape extends Sprite {

    /**
     * TBD
     */
    protected var _currentWidth:Number;

    /**
     * TBD
     */
    protected var _currentHeight:Number;

    /**
     * TBD
     */
    protected var _style:ShapeConfig;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function BaseShape(style:ShapeConfig = null) {
        _currentWidth = 0;
        _currentHeight = 0;
        if (style) {
            _style = style;
        }
        addEventListener(Event.REMOVED_FROM_STAGE, eventHandler, false, 0, true);
        if (stage) {
            draw();
        }
        else {
            addEventListener(Event.ADDED_TO_STAGE, eventHandler, false, 0, true);
        }
    }

    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * TBD
     */
    protected function eventHandler(event:Event):void {
        switch (event.type) {
            case Event.ADDED_TO_STAGE:
                removeEventListener(Event.ADDED_TO_STAGE, eventHandler);
                draw();
                break;
            case Event.REMOVED_FROM_STAGE:
                removeEventListener(Event.ADDED_TO_STAGE, eventHandler);
                removeEventListener(Event.REMOVED_FROM_STAGE, eventHandler);
                graphics.clear();
                break;
        }
    }

    //----------------------------------
    //  Getters/Setters
    //----------------------------------

    /**
     * Width getter
     */
    override public function get width():Number {
        return _currentWidth;
    }

    /**
     * width
     */
    override public function set width(value:Number):void {
        _currentWidth = value;
    }

    /**
     * height
     */
    override public function get height():Number {
        return _currentHeight;
    }

    /**
     * height
     */
    override public function set height(value:Number):void {
        _currentHeight = value;
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

    /**
     * TBD
     */
    public function setStyle(value:ShapeConfig, drawAfter:Boolean = true):void {
        _style = value;
        if (drawAfter) {
            draw();
        }
    }

    /**
     * TBD
     */
    public function getStyle():ShapeConfig {
        return _style;
    }

    /**
     * TBD
     */
    public function getStyleValue(value:String):* {
        return _style[value];
    }

    /**
     * TBD
     */
    public function setSize(w:int, h:int):void {
        _currentWidth = w;
        _currentHeight = h;
        draw();
    }

    /**
     * Override to not draw immediately
     */
    public function applyStyle(target:Sprite, config:DisplayObjectConfig):void {
        if (config.name) {
            try {
                target.name = config.name;
            }
            catch (e:Error) {
                //trace(e.toString());
            }
        }
        target.alpha = config.alpha;
        target.x = config.x;
        target.y = config.y;
        if (config.width > 0 && config.height > 0) {
            target.width = config.width;
            target.height = config.height;
            //target.setSize(width, height, false); //do not redraw (called by skin/skin part owner)
        }
        target.scaleX = config.scaleX;
        target.scaleY = config.scaleY;
        target.rotation = config.rotation;
        target.blendMode = config.blendMode;
        target.visible = config.visible;
        if (config.scrollRect)
            target.scrollRect = config.scrollRect; // use .clone() ?
        if (config.scale9Grid)
            target.scale9Grid = config.scale9Grid; // use .clone() ?
        if (config.matrix)
            target.transform.matrix = config.matrix;
        if (config.colorTransform)
            target.transform.colorTransform = config.colorTransform;
        if (config.filters && config.filters.length > 0)
            target.filters = config.filters;
        if (config.mask)
            target.mask = config.mask;
        if (config.cacheAsBitmap)
            target.cacheAsBitmap = config.cacheAsBitmap;
    }

    public function draw():void {
        if (!_style) {
            return;
        }
        applyStyle(this, _style);
        //trace(this, "draw", _style, _currentWidth, _currentHeight);
        if (_currentWidth == 0 || _currentHeight == 0) {
            return;
        }
        //trace(this, parent, "draw", _currentWidth, _currentHeight, _style.hasFill, _style.hasStroke);
        graphics.clear();
        if (_style.hasFill()) {
            _style.fill.width = _currentWidth;
            _style.fill.height = _currentHeight;
            _style.fill.draw(graphics);
        }
        if (_style.hasStroke()) {
            _style.stroke.width = _currentWidth;
            _style.stroke.height = _currentHeight;
            _style.stroke.draw(graphics);
        }
    }
}
}
