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

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.IBaseRangeable;
import hu.vpmedia.components.skins.NumericStepperSkin;
import hu.vpmedia.math.Range;

/**
 * TBD
 */
public class NumericStepper extends BaseComponent implements IBaseRangeable {

    /**
     * TBD
     */
    protected var _currentValue:Number;

    /**
     * TBD
     */
    protected var _range:Range;

    /**
     * TBD
     */
    protected var _tickInterval:Number;

    /**
     * TBD
     */
    protected var upButton:Sprite;

    /**
     * TBD
     */
    protected var downButton:Sprite;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function NumericStepper(parent:DisplayObjectContainer, config:Object = null) {
        super(parent, config);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * TBD
     */
    override protected function preInitialize():void {
        if (!_range)
            _range = new Range();
        if (isNaN(_currentValue))
            _currentValue = 0;
        if (isNaN(_tickInterval))
            _tickInterval = 0.1;
        if (!_skinClass)
            _skinClass = NumericStepperSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 22;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function skinInitialize():void {
        upButton = Sprite(_skin.getChildByName("up"));
        upButton.addEventListener(MouseEvent.CLICK, upClickHandler, false, 0, true);
        downButton = Sprite(_skin.getChildByName("down"));
        downButton.addEventListener(MouseEvent.CLICK, downClickHandler, false, 0, true);
    }

    /**
     * @private
     */
    protected function upClickHandler(event:MouseEvent):void {
        _currentValue = _range.normalizeInRange(_currentValue += _tickInterval);
    }

    /**
     * @private
     */
    protected function downClickHandler(event:MouseEvent):void {
        _currentValue = _range.normalizeInRange(_currentValue -= _tickInterval);
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

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
    public function get value():Number {
        return _currentValue;
    }

    /**
     * TBD
     */
    public function set value(value:Number):void {
        _currentValue = _range.normalizeInRange(value);
        sendTransmission(Event.CHANGE, _currentValue, name, this);
    }
}
}
