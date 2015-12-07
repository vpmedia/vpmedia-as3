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
import flash.events.Event;

import hu.vpmedia.components.Label;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * @inheritDoc
 */
public class TextInputSkin extends BaseSkin {

    /**
     * TBD
     */
    public var background:Rect;

    /**
     * TBD
     */
    public var label:Label;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function TextInputSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * TBD
     */
    override protected function createChildren():void {
        background = new Rect();
        addChild(background);
        label = new Label(this, {styleGroup: _owner.toString()});
        LabelSkin(label.skin).textField.addEventListener(Event.CHANGE, onLabelChange, false, 0, true);
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        LabelSkin(label.skin).textField.removeEventListener(Event.CHANGE, onLabelChange);
        super.dispose();
    }

    /**
     * TBD
     */
    private function onLabelChange(event:Event):void {
        IBaseTextField(_owner).setText(event.target.text, false);
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        //var state:String = _owner.getState();
        var backgroundStyle:ShapeConfig = ShapeConfig(_owner.getStyle(_config.backgroundStyleID));
        backgroundStyle.width = _owner.width;
        backgroundStyle.height = _owner.height;
        background.setStyle(backgroundStyle);
        //var labelStyle:TextFieldConfig = TextFieldConfig(_owner.getStyle(_config.labelStyleID));
        //label.setSize(_owner.width, _owner.height);
        label.width = _owner.width;
        label.y = (_owner.height - label.height) * 0.5;
        label.text = IBaseTextField(_owner).text;
    }
}
}
