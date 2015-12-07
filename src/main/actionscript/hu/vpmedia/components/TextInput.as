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
import flash.text.TextField;

import hu.vpmedia.components.skins.LabelSkin;
import hu.vpmedia.components.skins.TextInputSkin;

/**
 * TBD
 */
public class TextInput extends Label {
    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function TextInput(parent:DisplayObjectContainer, config:Object = null) {
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
            _skinClass = TextInputSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 22;
        super.preInitialize();
    }

    /**
     * TBD
     */
    public function get textField():TextField {
        return LabelSkin(TextInputSkin(skin).label.skin).textField;
    }

    /**
     * TBD
     */
    public function appendText(value:String):void {
        var newText:String = _currentText.substr(0, textField.caretIndex) + value + _currentText.substr(textField.caretIndex, _currentText.length);
        var caretIndex:int = textField.caretIndex + 1;
        setText(newText, true);
        textField.setSelection(caretIndex, caretIndex);
    }

    /**
     * TBD
     */
    public function setFocus():void {
        stage.focus = textField;
    }
}
}
