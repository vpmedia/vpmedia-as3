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
package hu.vpmedia.components {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.IBaseRangeable;
import hu.vpmedia.components.skins.SliderSkin;
import hu.vpmedia.math.Range;

/**
 * TBD
 */
public class Slider extends BaseComponent implements IBaseRangeable {

    /**
     * @private
     */
    protected var _currentValue:Number = 0;

    /**
     * @private
     */
    protected var _range:Range;

    /**
     * @private
     */
    protected var _tickInterval:Number;

    /**
     * @private
     */
    private var skinButton:Sprite;

    /**
     * @private
     */
    private var skinBackground:Sprite;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function Slider(parent:DisplayObjectContainer, config:Object = null) {
        super(parent, config);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override protected function preInitialize():void {
        if (!_range)
            _range = new Range();
        if (isNaN(_tickInterval))
            _tickInterval = 1;
        if (!_skinClass)
            _skinClass = SliderSkin;
        if (!_currentWidth)
            _currentWidth = 15;
        if (!_currentHeight)
            _currentHeight = 100;
        mouseChildren = true;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function skinInitialize():void {
        skinButton = Sprite(_skin.getChildByName("button"));
        skinButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonDragHandler, false, 0, true);
        skinBackground = Sprite(_skin.getChildByName("background"));
        skinBackground.addEventListener(MouseEvent.MOUSE_DOWN, bgHandler, false, 0, true);
    }

    /**
     * @private
     */
    protected function bgHandler(event:MouseEvent):void {
        switch (event.type) {
            case MouseEvent.MOUSE_DOWN:
                skinButton.y = int(mouseY - skinButton.height / 2);
                validateButtonPosition();
                updateValue();
                break;
        }
    }

    /**
     * @private
     */
    protected function buttonDragHandler(event:MouseEvent):void {
        switch (event.type) {
            case MouseEvent.MOUSE_DOWN:
                stage.addEventListener(MouseEvent.MOUSE_MOVE, buttonDragHandler, false, 0, true);
                stage.addEventListener(MouseEvent.MOUSE_UP, buttonDragHandler, false, 0, true);
                var dragBounds:Rectangle = new Rectangle(0, 0, 0, height - skinButton.height);
                skinButton.startDrag(false, dragBounds);
                break;
            case MouseEvent.MOUSE_UP:
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, buttonDragHandler);
                stage.removeEventListener(MouseEvent.MOUSE_UP, buttonDragHandler);
                skinButton.stopDrag();
                updateValue();
                break;
            case MouseEvent.MOUSE_MOVE:
                updateValue();
                break;
        }
    }

    /**
     * @private
     */
    protected function updateValue():void {
        var maxHeight:Number = height - skinButton.height;
        var _newValue:Number = (skinButton.y / maxHeight) * _range.max;
        _currentValue = _range.normalizeInRange(_newValue);
        sendTransmission(Event.CHANGE, _currentValue, name, this);
    }

    /**
     * @private
     */
    protected function validateButtonPosition():void {
        var maxHeight:Number = height - skinButton.height
        if (skinButton.y < 0) {
            skinButton.y = 0;
        }
        else if (skinButton.y > maxHeight) {
            skinButton.y = maxHeight;
        }
    }

    /**
     * @private
     */
    protected function updateButtonPosition():void {
        var maxHeight:Number = height - skinButton.height
        skinButton.y = _currentValue * maxHeight;
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

    /**
     * TBD
     */
    public function get value():Number {
        return _currentValue;
    }

    /**
     * TBD
     */
    public function set value(value:Number):void {
        _currentValue = _range.normalizeInRange(value);
        updateButtonPosition();
        sendTransmission(Event.CHANGE, _currentValue, name, this);
    }

    /**
     * TBD
     */
    public function get range():Range {
        return _range;
    }

    /**
     * TBD
     */
    public function set range(value:Range):void {
        _range = value;
    }

    /**
     * TBD
     */
    public function get tickInterval():Number {
        return _tickInterval;
    }

    /**
     * TBD
     */
    public function set tickInterval(value:Number):void {
        _tickInterval = value;
    }
}
}
