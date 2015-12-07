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
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * @inheritDoc
 */
public class ListItemSkin extends BaseSkin {

    public var background:Rect;

    public var label:Label;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ListItemSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        background = new Rect();
        addChild(background);
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
        backgroundStyle.width = _owner.width;
        backgroundStyle.height = _owner.height;
        background.setStyle(backgroundStyle);
        label.setState(state);
        label.text = IBaseTextField(_owner).text;
        label.draw();
        label.x = (_owner.width - label.width) * 0.5;
        label.y = (_owner.height - label.height) * 0.5;
    }
}
}
