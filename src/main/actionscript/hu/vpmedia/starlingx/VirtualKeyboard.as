/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
package hu.vpmedia.starlingx {
import hu.vpmedia.ui.VirtualKeyboardType;
import hu.vpmedia.utils.ObjectUtil;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

/**
 * VirtualKeyboard class encapsulates a Starling virtual keyboard display object.
 */
public final class VirtualKeyboard extends Sprite {

    //----------------------------------
    //  Public variables
    //----------------------------------

    /**
     * @private
     */
    private var texture:Texture;

    /**
     * @private
     */
    private var _softKeyboardType:String;

    /**
     * @private
     */
    private var _dp:Vector.<Vector.<String>>;

    /**
     * @private
     */
    private var isCapital:Boolean;

    /**
     * @private
     */
    private static const CAPITAL:String = "^";

    /**
     * @private
     */
    public var keyHandler:Function;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function VirtualKeyboard(texture:Texture, softKeyboardType:String = null) {
        super();
        this.texture = texture;
        if (softKeyboardType)
            this.softKeyboardType = softKeyboardType;
        else
            this.softKeyboardType = VirtualKeyboardType.DEFAULT;
        initialize();
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @private
     */
    private function initialize():void {
        const n:uint = _dp.length;
        for (var i:uint = 0; i < n; i++) {
            var row:Sprite = new Sprite();
            addChild(row);
            row.y = i * 40;
            const m:uint = _dp[i].length;
            for (var j:uint = 0; j < m; j++) {
                var button:Button = new Button(texture);
                button.fontName = "Arial";
                button.fontColor = 0xFFFFFF;
                button.fontBold = true;
                button.text = _dp[i][j];
                button.addEventListener(Event.TRIGGERED, onKeyPress);
                row.addChild(button);
                button.x = j * 40;
            }
        }
        autoAlign();
    }

    /**
     * @private
     */
    private function autoAlign():void {
        // auto-align rows to center
        const n:uint = _dp.length;
        var w:uint = this.width;
        for (var i:uint = 0; i < n; i++) {
            var row:Sprite = Sprite(getChildAt(i));
            row.x = (w - row.width) * 0.5;
        }
    }

    /**
     * @private
     */
    private function onKeyPress(event:Event):void {
        const text:String = Button(event.target).text;
        if(text == CAPITAL)
            switchCapital();
        else if (keyHandler != null)
            keyHandler(text);
    }

    /**
     * @inheritDoc
     */
    public function switchCapital():void {
        isCapital = !isCapital;
        const n:uint = _dp.length;
        for (var i:uint = 0; i < n; i++) {
            const row:Sprite = Sprite(getChildAt(i));
            const m:uint = row.numChildren;
            for (var j:uint = 0; j < m; j++) {
                const button:Button = Button(row.getChildAt(j));
                if(isCapital)
                    button.text = button.text.toUpperCase();
                else
                    button.text = button.text.toLowerCase();
            }
        }
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        keyHandler = null;
        // remove object references
        ObjectUtil.dispose(this);
        // remove inherited behaviors
        super.dispose();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Getter/setter for the 'softKeyboardType' property
     *
     * @see flash.text.SoftKeyboardType
     */
    public function get softKeyboardType():String {
        return _softKeyboardType;
    }

    /**
     * @private
     */
    public function set softKeyboardType(value:String):void {
        _softKeyboardType = value;
        _dp = VirtualKeyboardType.getLayoutByType(value);
    }
}
}
