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
import flash.events.Event;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.IBaseRangeable;
import hu.vpmedia.components.skins.ProgressBarSkin;
import hu.vpmedia.math.Range;

/**
 * TBD
 */
public class ProgressBar extends BaseComponent implements IBaseRangeable {

    /**
     * TBD
     */
    protected var _currentValue:Number = 0;

    /**
     * TBD
     */
    protected var _range:Range;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ProgressBar(parent:DisplayObjectContainer, config:Object = null) {
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
        if (!_skinClass)
            _skinClass = ProgressBarSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 6;
        super.preInitialize();
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
