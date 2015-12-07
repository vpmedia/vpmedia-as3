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
import flash.events.MouseEvent;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.ComponentState;
import hu.vpmedia.components.core.IBaseDataList;
import hu.vpmedia.components.core.InvalidationType;
import hu.vpmedia.components.skins.ComboBoxSkin;

/**
 * TBD
 */
public class ComboBox extends BaseComponent implements IBaseDataList {
    protected var _data:Array;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ComboBox(parent:DisplayObjectContainer, config:Object = null) {
        super(parent, config);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override protected function preInitialize():void {
        if (!_skinClass)
            _skinClass = ComboBoxSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 22;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function createListeners():void {
        addEventListener(MouseEvent.ROLL_OVER, mouseHandler, false, 0, true);
        addEventListener(MouseEvent.ROLL_OUT, mouseHandler, false, 0, true);
    }

    /**
     * @inheritDoc
     */
    override protected function removeListeners():void {
        super.removeListeners();
        removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
        removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
    }

    /**
     * @private
     */
    protected function mouseHandler(event:MouseEvent):void {
        switch (event.type) {
            case MouseEvent.ROLL_OVER:
                setState(ComponentState.OVER);
                break;
            case MouseEvent.ROLL_OUT:
                setState(ComponentState.DEFAULT);
                break;
        }
    }

    //--------------------------------------
    //  Getters/Setters
    //--------------------------------------

    /**
     * TBD
     */
    public function get data():Array {
        return _data;
    }

    /**
     * TBD
     */
    public function set data(value:Array):void {
        _data = value;
        invalidate(InvalidationType.DATA, true);
    }
}
}
