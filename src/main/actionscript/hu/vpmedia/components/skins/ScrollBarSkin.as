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
import hu.vpmedia.components.ScrollBarSlider;
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;

/**
 * @inheritDoc
 */
public class ScrollBarSkin extends BaseSkin {

    /**
     * TBD
     */
    public var slider:ScrollBarSlider;

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
     * Constructor
     */
    public function ScrollBarSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
        var upButtonParams:BaseSkinConfig = new BaseSkinConfig();
        upButtonParams.iconStyleID = "upIcon";
        up = new Button(this, {width: 15, height: 15, showIcon: true, showLabel: false, skinParams: upButtonParams, styleGroup: _owner.toString()});
        slider = new ScrollBarSlider(this, {y: 15, width: 15, height: 70, name: "slider", styleGroup: _owner.toString()});
        var downButtonParams:BaseSkinConfig = new BaseSkinConfig();
        downButtonParams.iconStyleID = "downIcon";
        down = new Button(this, {y: 85, width: 15, height: 15, showIcon: true, showLabel: false, skinParams: downButtonParams, styleGroup: _owner.toString()});
    }

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
        var state:String = _owner.getState();
        up.setSize(_owner.width, _owner.width);
        slider.y = up.height;
        slider.setSize(_owner.width, _owner.height - _owner.width * 2);
        // SliderSkin(slider.skin).
        down.setSize(_owner.width, _owner.width);
        down.y = _owner.width + _owner.height - _owner.width * 2;
    }
}
}
