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
package hu.vpmedia.components.skins {
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.utils.TextFieldConfig;

/**
 * @inheritDoc
 */
public class LabelSkin extends BaseSkin {

    /**
     * TextField instance
     */
    public var textField:TextField;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function LabelSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        textField = new TextField();
        addChild(textField);
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        // style
        var labelStyle:TextFieldConfig = TextFieldConfig(_owner.getStyle(_config.labelStyleID));
        labelStyle.applyTo(textField);
        // data
        textField.htmlText = IBaseTextField(_owner).text;
        // size
        if (textField.autoSize != TextFieldAutoSize.NONE) {
            _currentWidth = textField.width;
            _currentHeight = textField.height;
            _owner.setSize(_currentWidth, _currentHeight, false);
        }
        else {
            _currentWidth = _owner.width;
            _currentHeight = _owner.height;
            textField.width = _currentWidth;
            textField.height = _currentHeight;
        }
    }
}
}
