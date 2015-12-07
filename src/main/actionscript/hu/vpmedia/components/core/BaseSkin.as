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
package hu.vpmedia.components.core {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

import hu.vpmedia.framework.IBaseDisposable;
import hu.vpmedia.shapes.core.BaseShape;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

/**
 * TBD
 */
public class BaseSkin extends Sprite implements IBaseDisposable {

    /**
     * @private
     */
    protected var _owner:BaseComponent;

    /**
     * @private
     */
    protected var _config:BaseSkinConfig;

    /**
     * @private
     */
    protected var _shapePartList:Vector.<BaseShape>;

    /**
     * @private
     */
    protected var _componentPartList:Vector.<BaseComponent>;

    /**
     * @private
     */
    protected var _currentWidth:Number;

    /**
     * @private
     */
    protected var _currentHeight:Number;

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("BaseSkin");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseSkin(config:BaseSkinConfig = null) {
        super();
        _shapePartList = new Vector.<BaseShape>();
        _componentPartList = new Vector.<BaseComponent>();
        if (config)
            _config = config;
        else
            _config = new BaseSkinConfig();
        addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @private
     */
    private final function addedHandler(event:Event):void {
        addEventListener(Event.REMOVED_FROM_STAGE, removedHandler, false, 0, true);
        removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
        createChildren();
    }

    /**
     * @private
     */
    private final function removedHandler(event:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
        dispose();
    }

    /**
     * TBD
     */
    public function dispose():void {
        //trace(this, "dispose");
        //removeListeners();
        removeChildren();
    }


    /**
     * @inheritDoc
     */
    protected function createChildren():void {
        // template
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

    /**
     * Owner setter
     */
    public function set owner(value:BaseComponent):void {
        _owner = value;
    }

    /**
     * Owner getter
     */
    public function get owner():BaseComponent {
        return _owner;
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override public function addChild(value:DisplayObject):DisplayObject {
        const result:DisplayObject = super.addChild(value);
        if (value is BaseShape) {
            _shapePartList.push(value);
        }
        else if (value is BaseComponent) {
            _componentPartList.push(value);
            // copy style group to new child
            if (_owner.styleGroup)
                BaseComponent(value).styleGroup = _owner.styleGroup;
        }
        return result;
    }

    /**
     * @inheritDoc
     */
    public function draw():void {
        if (_owner.isInvalid(InvalidationType.STYLE) || _owner.isInvalid(InvalidationType.STATE)) {
            updateStyle();
            _owner.validate(InvalidationType.STYLE);
            _owner.validate(InvalidationType.STATE);
        }
        if (_owner.isInvalid(InvalidationType.DATA)) {
            updateData();
            _owner.validate(InvalidationType.DATA);
        }
        if (_owner.isInvalid(InvalidationType.SIZE)) {
            updateSize();
            _owner.validate(InvalidationType.SIZE);
        }
        if (_owner.isInvalid(InvalidationType.ALL)) {
            _owner.validate(InvalidationType.ALL);
        }
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @private
     */
    protected function updateStyle():void {
        //LOG.debug("updateStyle");
        // template
    }

    /**
     * @private
     */
    protected function updateData():void {
        //LOG.debug("updateStyle");
        // template
    }

    /**
     * @private
     */
    protected function updateSize():void {
        //LOG.debug("updateStyle");
        // template
    }

    //----------------------------------
    //  Getters/Setters
    //----------------------------------

    /**
     * @private
     */
    override public function get width():Number {
        return _currentWidth;
    }

    /**
     * @private
     */
    override public function set width(value:Number):void {
        _currentWidth = value;
    }

    /**
     * @private
     */
    override public function get height():Number {
        return _currentHeight;
    }

    /**
     * @private
     */
    override public function set height(value:Number):void {
        _currentHeight = value;
    }
}
}
