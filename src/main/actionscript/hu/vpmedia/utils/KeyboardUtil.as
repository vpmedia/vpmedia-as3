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

package hu.vpmedia.utils {
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for Keyboard manipulation.
 *
 * @see flash.ui.Keyboard
 */
public class KeyboardUtil {

    /**
     * TBD
     */
    public static const JUST_PRESSED:uint = 0;

    /**
     * TBD
     */
    public static const DOWN:uint = 1;

    /**
     * TBD
     */
    public static const JUST_RELEASED:uint = 2;

    /**
     * TBD
     */
    public static const UP:uint = 3;

    /**
     * @private
     */
    private static var _stage:Stage;

    /**
     * @private
     */
    private static var _keys:Dictionary;

    /**
     * @private
     */
    private static var _keysReleased:Vector.<int> = new Vector.<int>();

    /**
     * @private
     */
    public function KeyboardUtil() {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function initialize(stage:Stage):void {
        if (_stage) {
            //throw new Error("Already initialized");
            return;
        }
        _stage = stage;
        reset();
        _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyChanged, false, 0, true);
        _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyChanged, false, 0, true);
    }

    /**
     * TBD
     */
    public static function reset():void {
        _keys = new Dictionary(true);
        _keysReleased.length = 0;
    }

    /**
     * TBD
     */
    public static function dispose():void {
        _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyChanged);
        _stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyChanged);
        _stage = null;
        _keys = null;
        _keysReleased = null;
    }

    /**
     * TBD
     */
    public static function update(event:Event = null):void {
        for (var key:Object in _keys) {
            if (_keys[key] == JUST_PRESSED)
                _keys[key] = DOWN;
        }
        _keysReleased.length = 0;
    }

    /**
     * TBD
     */
    public static function isDown(keyCode:int):Boolean {
        return _keys[keyCode] == DOWN;
    }

    /**
     * TBD
     */
    public static function justPressed(keyCode:int):Boolean {
        return _keys[keyCode] == JUST_PRESSED;
    }

    /**
     * TBD
     */
    public static function justReleased(keyCode:int):Boolean {
        return _keysReleased.indexOf(keyCode) != -1;
    }

    /**
     * TBD
     */
    public static function getState(keyCode:int):uint {
        if (_keys[keyCode])
            return _keys[keyCode];
        else if (_keysReleased.indexOf(keyCode) != -1)
            return JUST_RELEASED;
        else
            return UP;
    }

    /**
     * @private
     */
    private static function onKeyChanged(event:KeyboardEvent):void {
        switch (event.type) {
            case KeyboardEvent.KEY_DOWN:
                if (!_keys[event.keyCode]) {
                    _keys[event.keyCode] = JUST_PRESSED;
                }
                break;
            case KeyboardEvent.KEY_UP:
                delete _keys[event.keyCode];
                _keysReleased.push(event.keyCode);
                break;
        }
    }
}
}
