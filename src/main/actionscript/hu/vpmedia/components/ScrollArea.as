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
import flash.display.Sprite;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.skins.ScrollAreaSkin;

/**
 * TBD
 */
public class ScrollArea extends BaseComponent {

    /**
     * @private
     */
    protected var _content:DisplayObject;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ScrollArea(parent:DisplayObjectContainer, config:Object = null) {
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
            _skinClass = ScrollAreaSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 100;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function skinInitialize():void {
        ScrollAreaSkin(_skin).scrollBar.signal.add(sliderHandler);
    }

    /**
     * @private
     */
    private function sliderHandler(code:String, data:Object, level:String, source:Object):void {
        signal.dispatch(code, data, level, source);
        _content.y = -Number(data) * (_content.height - _currentHeight);
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

    /**
     * TBD
     */
    public function set content(value:DisplayObject):void {
        var container:Sprite = ScrollAreaSkin(_skin).content;
        while (container.numChildren > 0) {
            container.removeChildAt(0);
        }
        container.addChild(value);
        _content = value;
    }

    /**
     * TBD
     */
    public function get content():DisplayObject {
        return _content;
    }
}
}
