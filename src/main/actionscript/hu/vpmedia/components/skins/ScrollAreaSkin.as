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
import flash.display.Sprite;

import hu.vpmedia.components.ScrollBar;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * @inheritDoc
 */
public class ScrollAreaSkin extends BaseSkin {

    /**
     * TBD
     */
    public var background:Rect;

    /**
     * TBD
     */
    public var scrollBar:ScrollBar;

    /**
     * TBD
     */
    public var content:Sprite;

    /**
     * TBD
     */
    public var masker:Rect;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ScrollAreaSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        background = new Rect();
        addChild(background);
        content = new Sprite();
        addChild(content);
        masker = new Rect();
        addChild(masker);
        content.mask = masker;
        scrollBar = new ScrollBar(this);
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        var state:String = owner.getState();
        var backgroundStyle:ShapeConfig = ShapeConfig(owner.getStyle(_config.backgroundStyleID));
        backgroundStyle.width = owner.width;
        backgroundStyle.height = owner.height;
        background.setStyle(backgroundStyle);
        masker.setStyle(backgroundStyle);
        scrollBar.height = owner.height;
        scrollBar.x = owner.width - scrollBar.width;
    }
}
}
