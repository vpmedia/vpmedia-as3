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
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;
import hu.vpmedia.shapes.Rect;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * @inheritDoc
 */
public class NumericStepperSkin extends BaseSkin {

    /**
     * TBD
     */
    public var background:Rect;

    /**
     * TBD
     */
    public var up:Button;

    /**
     * TBD
     */
    public var down:Button;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function NumericStepperSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        background = new Rect();
        addChild(background);
        up = new Button(this, {styleGroup: _owner.toString(), name: "up", showIcon: true, showLabel: false});
        down = new Button(this, {styleGroup: _owner.toString(), name: "down", showIcon: true, showLabel: false});
        up.width = down.width = 20;
        up.height = down.height = _owner.height * 0.5;
        up.x = down.x = _owner.width - 20;
        up.rotation = 180;
        up.x += up.width;
        up.y += up.height;
        down.y = up.height;
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

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
    }
}
}
