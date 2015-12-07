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
import hu.vpmedia.components.Image;
import hu.vpmedia.components.Label;
import hu.vpmedia.components.List;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.components.core.ComponentState;
import hu.vpmedia.components.core.IBaseDataList;
import hu.vpmedia.shapes.PixelIcon;
import hu.vpmedia.shapes.PixelIconTypes;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;
import hu.vpmedia.shapes.textures.SolidFill;

/**
 * @inheritDoc
 */
public class ComboBoxSkin extends BaseSkin {

    /**
     * TBD
     */
    public var label:Label;

    /**
     * TBD
     */
    public var background:Rect;

    /**
     * TBD
     */
    public var open:Rect;

    /**
     * TBD
     */
    public var list:List;

    /**
     * TBD
     */
    public var icon:Image;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function ComboBoxSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        //
        background = new Rect();
        addChild(background);
        //
        label = new Label(this, {x: 5, text: ""});
        addChild(label);
        //
        open = new Rect();
        addChild(open);
        //
        icon = new Image(this);
        var config:ShapeConfig = new ShapeConfig();
        var fill:SolidFill = new SolidFill();
        fill.color = 0x666666;
        config.data = {data: PixelIconTypes.ARROW_2_DOWN};
        config.fill = fill;
        config.width = config.data.data[0].length;
        config.height = config.data.data.length;
        icon.source = new PixelIcon(config);
        //
        list = new List(this);
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        var state:String = _owner.getState();
        //
        label.width = _owner.width - _owner.height;
        label.height = _owner.height;
        //
        var backgroundStyle:ShapeConfig = ShapeConfig(_owner.getStyle(_config.backgroundStyleID));
        backgroundStyle.width = _owner.width;
        backgroundStyle.height = _owner.height;
        background.setStyle(backgroundStyle);
        //
        backgroundStyle.width = _owner.height;
        backgroundStyle.height = _owner.height;
        open.setStyle(backgroundStyle);
        open.x = _owner.width - _owner.height;
        //
        icon.x = _owner.width - 13;
        icon.y = 10;
        //
        list.width = _owner.width;
        list.draw();
        list.y = _owner.height;
        list.visible = (state == ComponentState.OVER);
        list.data = IBaseDataList(_owner).data;
    }
}
}
