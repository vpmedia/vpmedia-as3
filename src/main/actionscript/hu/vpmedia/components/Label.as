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
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.components.core.InvalidationType;
import hu.vpmedia.components.skins.LabelSkin;

/**
 * Label class (TextField wrapper)
 */
public class Label extends BaseComponent implements IBaseTextField {
    //--------------------------------------
    //  Variables
    //--------------------------------------

    /**
     * @private
     */
    protected var _currentText:String = "Label";

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     *
     * @param config Object
     */
    function Label(parent:DisplayObjectContainer, config:Object = null) {
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
            _skinClass = LabelSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 22;
        super.preInitialize();
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

    /**
     * Sets the label text
     *
     * @param value String
     */
    public function set text(value:String):void {
        //trace(this, "set", "text", value);
        if (_currentText == value) {
            return;
        }
        _currentText = value;
        invalidate(InvalidationType.DATA, true);
    }

    /**
     * Sets the label text
     *
     * @param value String
     */
    public function setText(value:String, isInvalid:Boolean):void {
        if (_currentText == value) {
            return;
        }
        _currentText = value;
        if(isInvalid) {
            invalidate(InvalidationType.DATA, true);
        }
    }

    /**
     * Returns the current label text.
     *
     * @return String
     */
    public function get text():String {
        return _currentText;
    }
}
}
