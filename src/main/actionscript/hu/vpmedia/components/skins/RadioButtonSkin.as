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
import hu.vpmedia.components.Label;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.components.core.IBaseSelectable;
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.shapes.Ellipse;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;
import hu.vpmedia.shapes.textures.SolidFill;

/**
 * @inheritDoc
 */
public class RadioButtonSkin extends BaseSkin {

    /**
     * @private
     */
    public var background:Ellipse;

    /**
     * @private
     */
    public var buttonArea:Rect;

    /**
     * @private
     */
    public var buttonAreaStyle:ShapeConfig;

    /**
     * @private
     */
    public var icon:Ellipse;

    /**
     * @private
     */
    public var label:Label;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function RadioButtonSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        buttonArea = new Rect();
        addChild(buttonArea);
        var buttonAreaStyle:ShapeConfig = new ShapeConfig();
        var _fill:SolidFill = new SolidFill();
        _fill.color = 0x000000;
        _fill.alpha = 0;
        buttonAreaStyle.fill = _fill;
        buttonArea.setStyle(buttonAreaStyle);
        background = new Ellipse();
        addChild(background);
        icon = new Ellipse();
        addChild(icon);
        var iconStyle:ShapeConfig = new ShapeConfig();
        _fill = new SolidFill();
        _fill.color = 0x666666;
        _fill.alpha = 1;
        iconStyle.fill = _fill;
        icon.setStyle(iconStyle, false);
        label = new Label(this, {styleGroup: _owner.toString()});
        label.text = IBaseTextField(_owner).text;
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        var state:String = _owner.getState();
        var backgroundStyle:ShapeConfig = ShapeConfig(_owner.getStyle(_config.backgroundStyleID));
        backgroundStyle.width = _owner.height;
        backgroundStyle.height = _owner.height;
        background.setStyle(backgroundStyle);
        icon.setSize(_owner.height - 10, _owner.height - 10);
        icon.x = icon.y = 5;
        icon.visible = IBaseSelectable(_owner).selected;
        buttonArea.setSize(_owner.width, _owner.height);
        label.setState(state);
        label.text = IBaseTextField(_owner).text;
        label.draw();
        label.x = _owner.height + 5;
        label.y = (_owner.height - label.height) * 0.5;
    }
}
}
