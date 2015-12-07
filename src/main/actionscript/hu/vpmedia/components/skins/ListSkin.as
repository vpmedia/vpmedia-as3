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
import flash.display.Shape;
import flash.display.Sprite;

import hu.vpmedia.components.ListItem;
import hu.vpmedia.components.ScrollBar;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.components.core.IBaseDataList;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * @inheritDoc
 */
public class ListSkin extends BaseSkin {

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
    public var contentMasker:Shape;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function ListSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * TBD
     */
    override protected function createChildren():void {
        background = new Rect();
        addChild(background);
        content = new Sprite();
        addChild(content);
        contentMasker = new Shape();
        addChild(contentMasker);
        contentMasker.graphics.beginFill(0x00FF00, 1);
        contentMasker.graphics.drawRect(0, 0, 1, 1);
        contentMasker.graphics.endFill();
        content.mask = contentMasker;
        contentMasker.y = 1;
        content.y = 0;
        scrollBar = new ScrollBar(this);
    }

    /**
     * TBD
     */
    override public function draw():void {
        super.draw();
        var state:String = _owner.getState();
        var backgroundStyle:ShapeConfig = ShapeConfig(_owner.getStyle(_config.backgroundStyleID));
        backgroundStyle.width = _owner.width;
        backgroundStyle.height = _owner.height;
        background.setStyle(backgroundStyle);
        scrollBar.height = _owner.height;
        scrollBar.draw();
        scrollBar.x = _owner.width - scrollBar.width;
        contentMasker.width = scrollBar.x;
        contentMasker.height = _owner.height - 1;
        populateData();
    }

    /**
     * TBD
     */
    private function populateData():void {
        var dp:Array = IBaseDataList(_owner).data;
        if (!dp) {
            return;
        }
        while (content.numChildren > 0) {
            content.removeChildAt(0);
        }
        var n:int = dp.length;
        for (var i:int = 0; i < n; i++) {
            var item:ListItem = new ListItem(content, {width: scrollBar.x});
            item.signal.add(listItemHandler)
            item.text = dp[i].label;
            item.y = item.height * i;
        }
    }

    /**
     * @private
     */
    private function listItemHandler(code:String, data:Object, level:String, source:Object):void {
        trace(this, "listItemHandler", arguments);
    }
}
}
