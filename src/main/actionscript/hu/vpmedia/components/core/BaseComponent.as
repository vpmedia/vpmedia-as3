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
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

import hu.vpmedia.components.themes.ThemeManager;
import hu.vpmedia.framework.BaseConfig;
import hu.vpmedia.framework.IBaseDisposable;
import hu.vpmedia.utils.ClassUtil;
import hu.vpmedia.utils.ObjectUtil;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * TBD
 */
public class BaseComponent extends Sprite implements IBaseDisposable {

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
    protected var _changedPropertyGroups:Dictionary;

    /**
     * @private
     */
    protected var _skin:BaseSkin;

    /**
     * @private
     */
    protected var _skinClass:Class;

    /**
     * @private
     */
    protected var _skinParams:BaseSkinConfig;

    /**
     * @private
     */
    protected var _styleSheet:BaseStyleSheet;

    /**
     * @private
     */
    protected var _styleGroup:String;

    /**
     * @private
     */
    protected var _stateList:Vector.<String>;

    /**
     * @private
     */
    protected var _currentState:String;

    /**
     * @private
     */
    protected var _previousState:String;

    /**
     * @private
     */
    protected var _signal:ISignal;

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("BaseComponent");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    function BaseComponent(parent:DisplayObjectContainer, config:Object = null) {
        super();
        // setup default properties
        _changedPropertyGroups = new Dictionary(true);
        _currentWidth = 0;
        _currentHeight = 0;
        // setup display list handler
        addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
        // pre-init component properties
        preInitialize();
        // copy configuration properties (x, y, width, height)
        if (config)
            ObjectUtil.copyProperties(config, this);
        // register component to theme manager
        ThemeManager.register(this);
        // add component to parent
        if (parent)
            parent.addChild(this);
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @inheritDoc
     */
    protected function initialize():void {
        //trace(this, "initialize");
        invalidate(InvalidationType.ALL, false);
        // create state machine
        _currentState = ComponentState.DEFAULT;
        // create skin
        createSkin();
        // create listeners
        createListeners();
    }

    /**
     * TBD
     */
    public function dispose():void {
        //trace(this, "dispose");
        removeListeners();
        removeChildren();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Resizes display object
     * @param w int
     * @param h int
     */
    public function setSize(w:int, h:int, drawAfter:Boolean = true):void {
        _currentWidth = w;
        _currentHeight = h;
        invalidate(InvalidationType.SIZE, drawAfter);
    }

    /**
     * Moves display object to position
     * @param x int
     * @param y int
     */
    public function move(x:int, y:int):void {
        this.x = x;
        this.y = y;
    }

    /**
     * @inheritDoc
     */
    public function draw():void {
        if (_skin)
            _skin.draw();
    }

    /**
     * TBD
     */
    public function invalidate(type:uint = 0, drawAfter:Boolean = false, waitFrame:Boolean = false):void {
        // flag current change
        _changedPropertyGroups[type] = true;
        // draw if needed
        if (drawAfter && waitFrame)
            addEventListener(Event.ENTER_FRAME, onFrameEnter, false, 0, true);
        else if (drawAfter)
            draw();
    }

    /**
     * @private
     */
    internal function validate(type:uint):void {
        if (type == InvalidationType.ALL) {
            _changedPropertyGroups = new Dictionary(true);
        }
        else {
            delete _changedPropertyGroups[type];
        }
    }

    /**
     * @private
     */
    internal function isInvalid(type:uint):Boolean {
        if (_changedPropertyGroups[type]) {
            return true;
        }
        else if (_changedPropertyGroups[InvalidationType.ALL]) {
            return true;
        }
        return false;
    }

    /**
     * State getter
     */
    public function getState():String {
        return _currentState;
    }

    /**
     * State setter
     */
    public function setState(value:String):void {
        if (!value || value == _currentState) {
            return;
        }
        _currentState = value;
        invalidate(InvalidationType.STATE, true);
    }

    /**
     * Style setter
     */
    public function setStyle(name:String, value:BaseConfig, drawAfter:Boolean = true, waitFrameBeforeDraw:Boolean = false):void {
        //LOG.debug("setStyle: " + arguments);
        if (!_styleSheet)
            _styleSheet = new BaseStyleSheet();
        _styleSheet[name] = value;
        invalidate(InvalidationType.STYLE, drawAfter, waitFrameBeforeDraw);
    }

    /**
     * Style getter
     */
    public function getStyle(value:String, appendState:Boolean = true):BaseConfig {
        // appends current state to id
        var result:BaseConfig;
        if (appendState) {
            value = value + _currentState;
        }
        //LOG.debug("getStyleValue", value);
        if (parent is BaseSkin && BaseSkin(parent).owner.hasInstanceStyle(value)) {
            result = BaseSkin(parent).owner.getStyle(value, false);
            //LOG.debug("getStyleValue::GroupInstance: " + parent + ", " + value + " => " + result);
            return result;
        }
        if (_styleSheet && _styleSheet[value] is BaseConfig) {
            result = _styleSheet[value]
            //LOG.debug("getStyleValue::SelfInstance: " + ", " + value + " => " + result);
            return result;
        }
        if (_styleGroup && ThemeManager.hasStyle(_styleGroup)) {
            result = ThemeManager.getStyleByName(_styleGroup, value);
            //LOG.debug("getStyleValue::GroupClass : " + _styleGroup + ", " + value + " => " + result);
            return result;
        }
        result = ThemeManager.getStyleByClass(this.toClass(), value);
        //LOG.debug("getStyleValue::SelfClass: " + value + " => " + result);
        return result;
    }

    /**
     * Internal style definition helper
     */
    internal function hasInstanceStyle(value:String):Boolean {
        return _styleSheet && _styleSheet[value] is BaseConfig;
    }

    /**
     * Signal helper method
     */
    public function sendTransmission(code:String, data:Object = null, level:String = null, source:Object = null):void {
        if (_signal)
            _signal.dispatch(code, data, level, source);
    }

    /**
     * @inheritDoc
     */
    override public function toString():String {
        return ClassUtil.getClassName(this);
    }

    /**
     * TBD
     */
    public function toClass():Class {
        return ClassUtil.getConstructor(this);
    }

    //----------------------------------
    //  Getters/Setters
    //----------------------------------

    /**
     * Skin getter
     */
    public function get skin():BaseSkin {
        return _skin;
    }

    /**
     * Skin setter
     */
    public function set skin(value:BaseSkin):void {
        //LOG.debug("skin", value);
        // remove previous skin if available
        if (_skin) {
            skinDispose();
            removeChild(_skin);
        }
        // store new reference
        _skin = value;
        // set skin owner to component
        _skin.owner = this;
        // update skin class if necessary
        var newSkinClass:Class = ClassUtil.getConstructor(_skin);
        if (newSkinClass != _skinClass) {
            _skinClass = newSkinClass;
        }
        // add to display list
        addChild(_skin);
        skinInitialize();
        invalidate(InvalidationType.ALL, true);
    }

    /**
     * Sets skin class
     */
    public function set skinClass(clazz:Class):void {
        // check for matching class
        if (_skinClass == clazz)
            return;
        // save new class
        _skinClass = clazz;
        // add to stage if available
        if (stage)
            createSkin();
    }

    /**
     * Style Sheet getter
     */
    public function get styleSheet():BaseStyleSheet {
        return _styleSheet;
    }

    /**
     * Style Sheet setter
     */
    public function set styleSheet(value:BaseStyleSheet):void {
        //LOG.debug("setStyleSheet: " + arguments);
        _styleSheet = value;
        invalidate(InvalidationType.STYLE);
    }

    /**
     * Style Group getter
     */
    public function get styleGroup():String {
        return _styleGroup;
    }

    /**
     * Style Group setter
     */
    public function set styleGroup(value:String):void {
        //LOG.debug("setStyleGroup: " + arguments);
        _styleGroup = value;
        invalidate(InvalidationType.STYLE, true);
    }

    /**
     * skinParams getter
     */
    public function get skinParams():BaseSkinConfig {
        return _skinParams;
    }

    /**
     * skinParams setter
     */
    public function set skinParams(value:BaseSkinConfig):void {
        //LOG.debug("setSkinParams: " + arguments);
        _skinParams = value;
    }

    /**
     * TBD
     */
    public function get signal():ISignal {
        if (!_signal)
            _signal = new Signal(String, Object, String, Object);
        return _signal;
    }

    /**
     * TBD
     */
    public function set signal(value:ISignal):void {
        _signal = value;
    }

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
        invalidate(InvalidationType.SIZE, true);
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
        invalidate(InvalidationType.SIZE, true);
    }

    /**
     *
     */
    public function get enabled():Boolean {
        return mouseEnabled;
    }

    /**
     *
     */
    public function set enabled(isEnabled:Boolean):void {
        mouseEnabled = isEnabled;
        // TODO: use prev state
        setState(isEnabled ? ComponentState.DEFAULT : ComponentState.DISABLED);
    }

    //----------------------------------
    //  Template methods
    //----------------------------------

    /**
     * TBD
     */
    protected function skinInitialize():void {
        // template
    }

    /**
     * TBD
     */
    protected function skinDispose():void {
        // template
    }

    /**
     * Setup default component related properties (width, height, etc.)
     */
    protected function preInitialize():void {
        // template
    }

    /**
     * TBD
     */
    protected function createListeners():void {
        // template
    }

    /**
     * TBD
     */
    protected function removeListeners():void {
        // template
        if (_signal)
            _signal.removeAll();
    }

    /**
     * @private
     */
    private function createSkin():void {
        if (_skinClass) {
            skin = new _skinClass(_skinParams);
        }
    }

    //--------------------------------------
    //  Event Handlers
    //--------------------------------------

    /**
     * @private
     */
    private final function onAdded(event:Event):void {
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        initialize();
    }

    /**
     * @private
     */
    private final function onRemoved(event:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
        dispose();
    }

    /**
     * @private
     */
    private final function onFrameEnter(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, onFrameEnter);
        draw();
    }
}
}
