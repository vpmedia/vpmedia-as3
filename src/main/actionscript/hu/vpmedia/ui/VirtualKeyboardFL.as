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
package hu.vpmedia.ui {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import hu.vpmedia.utils.ButtonUtil;
import hu.vpmedia.utils.ObjectUtil;
import hu.vpmedia.utils.TextFieldUtil;

/**
 * VirtualKeyboard class encapsulates a Starling virtual keyboard display object.
 */
public final class VirtualKeyboardFL extends Sprite {

    //----------------------------------
    //  Public variables
    //----------------------------------

    /**
     * @private
     */
    private var texture:BitmapData;

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
    private var textFormat:TextFormat;

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
    public function VirtualKeyboardFL(texture:BitmapData, softKeyboardType:String = null, textFormat:TextFormat = null) {
        super();
        this.texture = texture;
        this.textFormat = textFormat;
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
        if (!textFormat) {
            textFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
        }
        textFormat.align = TextFormatAlign.CENTER;
        const n:uint = _dp.length;
        for (var i:uint = 0; i < n; i++) {
            var row:Sprite = new Sprite();
            addChild(row);
            row.y = i * 40;
            const m:uint = _dp[i].length;
            for (var j:uint = 0; j < m; j++) {
                var container:Sprite = new Sprite();
                var button:SimpleButton = ButtonUtil.createSimpleButton(container, 0, 0, new Bitmap(texture));
                var label:TextField = TextFieldUtil.create("label", 0, 10, 40, 40, false, false, false, false, TextFieldAutoSize.NONE, textFormat);
                label.text = _dp[i][j];
                container.addChild(label);
                container.mouseChildren = false;
                container.buttonMode = true;
                container.addEventListener(MouseEvent.CLICK, onKeyPress, false, 0, true);
                container.x = j * 40;
                row.addChild(container);
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
        const text:String = TextField(event.target.getChildAt(1)).text;
        if (text == CAPITAL)
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
                const button:TextField = TextField(DisplayObjectContainer(row.getChildAt(j)).getChildAt(1));
                if (isCapital)
                    button.text = button.text.toUpperCase();
                else
                    button.text = button.text.toLowerCase();
            }
        }
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        keyHandler = null;
        // remove object references
        ObjectUtil.dispose(this);
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
