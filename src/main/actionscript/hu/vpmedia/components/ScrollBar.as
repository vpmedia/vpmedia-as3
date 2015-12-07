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

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.skins.ScrollBarSkin;

/**
 * TBD
 */
public class ScrollBar extends BaseComponent {
    //--------------------------------------
    //  Variables
    //--------------------------------------

    /**
     * @private
     */
    protected var _slider:ScrollBarSlider;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ScrollBar(parent:DisplayObjectContainer, config:Object = null) {
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
            _skinClass = ScrollBarSkin;
        if (!_currentWidth)
            _currentWidth = 15;
        if (!_currentHeight)
            _currentHeight = 100;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function skinInitialize():void {
        ScrollBarSkin(_skin).slider.signal.add(sliderHandler);
        ScrollBarSkin(_skin).up.signal.add(scrollUpHandler);
        ScrollBarSkin(_skin).down.signal.add(scrollDownHandler);
    }

    //--------------------------------------
    //  Event handlers
    //--------------------------------------

    /**
     * @private
     */
    private function sliderHandler(code:String, data:Object, level:String, source:Object):void {
        signal.dispatch(code, data, level, source);
    }

    /**
     * @private
     */
    private function scrollUpHandler(code:String, data:Object, level:String, source:Object):void {
        ScrollBarSkin(_skin).slider.value -= 0.05;
    }

    /**
     * @private
     */
    private function scrollDownHandler(code:String, data:Object, level:String, source:Object):void {
        ScrollBarSkin(_skin).slider.value += 0.05;
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------
}
}
