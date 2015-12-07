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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.IBaseDataList;
import hu.vpmedia.components.core.InvalidationType;
import hu.vpmedia.components.skins.ListSkin;

/**
 * TBD
 */
public class List extends BaseComponent implements IBaseDataList {
    protected var _data:Array;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function List(parent:DisplayObjectContainer, config:Object = null) {
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
            _skinClass = ListSkin;
        if (!_currentWidth)
            _currentWidth = 80;
        if (!_currentHeight)
            _currentHeight = 100;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function skinInitialize():void {
        ListSkin(_skin).scrollBar.signal.add(sliderHandler);
    }

    /**
     * @private
     */
    private function sliderHandler(code:String, data:Object, level:String, source:Object):void {
        //signal.dispatch(code, data, level, source);
        var content:DisplayObject = ListSkin(_skin).content;
        content.y = -Number(data) * (content.height - _currentHeight);
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
