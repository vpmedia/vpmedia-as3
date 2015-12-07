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
import hu.vpmedia.components.Button;
import hu.vpmedia.components.Image;
import hu.vpmedia.components.Label;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.shapes.PixelIcon;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * @inheritDoc
 */
public class ButtonSkin extends BaseSkin {
    //--------------------------------------
    //  Variables
    //--------------------------------------

    public var background:Rect;

    public var label:Label;

    public var icon:Image;

    public var pixelIcon:PixelIcon;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ButtonSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        createBackground();
        if (Button(_owner).showLabel) {
            createLabel();
        }
        if (Button(_owner).showIcon) {
            createIcon();
        }
    }

    /**
     * @private
     */
    private function createBackground():void {
        background = new Rect();
        addChild(background);
    }

    /**
     * @private
     */
    private function createLabel():void {
        label = new Label(this, {styleGroup: _owner.toString()});
        label.text = IBaseTextField(_owner).text;
    }

    /**
     * @private
     */
    private function createIcon():void {
        icon = new Image(this);
        pixelIcon = new PixelIcon();
        icon.source = pixelIcon;
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        var state:String = _owner.getState();
        var backgroundStyle:ShapeConfig = ShapeConfig(_owner.getStyle(_config.backgroundStyleID));
        if (backgroundStyle) {
            backgroundStyle.width = _owner.width;
            backgroundStyle.height = _owner.height;
            background.setStyle(backgroundStyle);
        }
        if (label) {
            label.setState(state);
            label.text = IBaseTextField(_owner).text;
            label.draw();
            label.x = (_owner.width - label.width) * 0.5;
            label.y = (_owner.height - label.height) * 0.5;
        }
        if (icon) {
            var iconStyle:ShapeConfig = ShapeConfig(_owner.getStyle(_config.iconStyleID));
            if (iconStyle) {
                pixelIcon.setStyle(iconStyle);
                icon.x = (_owner.width - iconStyle.width) * 0.5;
                icon.y = (_owner.height - iconStyle.height) * 0.5;
            }
        }
    }
}
}
