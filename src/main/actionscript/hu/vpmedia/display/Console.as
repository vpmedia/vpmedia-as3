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
package hu.vpmedia.display {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

/**
 * Console helper display object.
 */
public final class Console extends Sprite {
    /**
     * @private
     */
    private var _openKey:uint;

    /**
     * @private
     */
    private var _inputField:TextField;

    /**
     * @private
     */
    private var _executeKey:int;

    /**
     * @private
     */
    private var _paramKey:String;

    /**
     * @private
     */
    private var _prevHistoryKey:int;

    /**
     * @private
     */
    private var _nextHistoryKey:int;

    /**
     * @private
     */
    private var _commandHistory:Array;

    /**
     * @private
     */
    private var _historyMax:Number;

    /**
     * @private
     */
    private var _currHistoryIndex:int;

    /**
     * @private
     */
    private var _numCommandsInHistory:Number;

    /**
     * @private
     */
    private var _commandDelegates:Dictionary;

    /**
     * @private
     */
    private var _enabled:Boolean = true;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Creates the instance of the console. This is a display object, so it is also added to the stage.
     */
    public function Console(openKey:int = 9, paramKey:String = "-") {
        _openKey = openKey;
        _paramKey = paramKey;
        initialize();
    }

    //----------------------------------
    //  Private Methods
    //----------------------------------

    /**
     * @private
     */
    private function initialize():void {
        _executeKey = Keyboard.ENTER;
        _prevHistoryKey = Keyboard.UP;
        _nextHistoryKey = Keyboard.DOWN;
        _historyMax = 25;
        _currHistoryIndex = 0;
        _numCommandsInHistory = 0;

        _commandHistory = [];
        _commandDelegates = new Dictionary();

        _inputField = new TextField();
        addChild(_inputField);
        _inputField.type = TextFieldType.INPUT;
        _inputField.defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFF, false, false, false);

        visible = false;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will dispose the object.
     */
    public function dispose():void {

        stage.removeEventListener(KeyboardEvent.KEY_UP, onToggleKeyPress);
        stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyPressInConsole);

    }

    /**
     * Will add a new command.
     */
    public function addCommand(name:String, func:Function):void {
        _commandDelegates[name] = func;
    }

    /**
     * Will remove a registered command.
     */
    public function removeCommand(name:String):void {
        _commandDelegates[name] = null;
        delete _commandDelegates[name];
    }

    /**
     * Will return all command keys as a list.
     */
    public function getCommands():Vector.<String> {
        var list:Vector.<String> = new <String>[];
        for (var p:String in _commandDelegates) {
            list.push(p);
        }
        return Vector.<String>([list]);
    }

    /**
     * Will add a command to the history.
     */
    public function addCommandToHistory(command:String):void {
        var commandIndex:int = _commandHistory.indexOf(command);
        if (commandIndex != -1) {
            _commandHistory.splice(commandIndex, 1);
            _numCommandsInHistory--;
        }

        _commandHistory.push(command);
        _numCommandsInHistory++;

        if (_commandHistory.length > _historyMax) {
            _commandHistory.shift();
            _numCommandsInHistory--;
        }
    }

    /**
     * Will return the previous command from history.
     */
    public function getPreviousHistoryCommand():String {
        if (_currHistoryIndex > 0)
            _currHistoryIndex--;

        return getCurrentCommand();
    }

    /**
     * Will return the next command history.
     */
    public function getNextHistoryCommand():String {
        if (_currHistoryIndex < _numCommandsInHistory)
            _currHistoryIndex++;

        return getCurrentCommand();
    }

    /**
     * Will return the current command history.
     */
    public function getCurrentCommand():String {
        var command:String = _commandHistory[_currHistoryIndex];

        if (!command) {
            return "";
        }
        return command;
    }

    /**
     * Will show the object.
     */
    public function show():void {
        if (!visible) {
            clear();
            visible = true;
            stage.focus = _inputField;
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyPressInConsole, false, 0, true);
            _currHistoryIndex = _numCommandsInHistory;
        }
    }

    /**
     * Will hide the object.
     */
    public function hide():void {
        if (visible) {
            visible = false;
            stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyPressInConsole);
        }
    }

    /**
     * Will clear the object text field.
     */
    public function clear():void {
        _inputField.text = "";
    }

    //----------------------------------
    //  Getters / Setters
    //----------------------------------

    /**
     * Determines whether the console can be used. Set this property to false before releasing your final game.
     */
    public function get enabled():Boolean {
        return _enabled;
    }

    /**
     * Will enable the console.
     */
    public function set enabled(value:Boolean):void {
        if (_enabled == value)
            return;

        _enabled = value;

        if (_enabled) {
            stage.addEventListener(KeyboardEvent.KEY_UP, onToggleKeyPress, false, 0, true);
        }
        else {
            stage.removeEventListener(KeyboardEvent.KEY_UP, onToggleKeyPress);
            hide();
        }
    }

    /**
     * Will return the text field display object.
     */
    public function get textField():TextField {
        return _inputField;
    }

    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * @private
     */
    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        const sW:uint = stage.fullScreenWidth;
        graphics.beginFill(0x000000, .8);
        graphics.drawRect(0, 0, sW, 30);
        graphics.endFill();
        _inputField.width = sW - 8;
        _inputField.y = 4;
        _inputField.x = 4;
        stage.addEventListener(KeyboardEvent.KEY_UP, onToggleKeyPress, false, 0, true);
    }

    /**
     * @private
     */
    private function onToggleKeyPress(event:KeyboardEvent):void {
        if (event.keyCode == _openKey && event.ctrlKey) {
            if (visible)
                hide();
            else
                show();
        }
    }

    /**
     * @private
     */
    private function onKeyPressInConsole(event:KeyboardEvent):void {
        if (event.keyCode == _executeKey) {
            if (_inputField.text == "" || _inputField.text == " ") {
                return;
            }
            addCommandToHistory(_inputField.text);
            var args:Array = _inputField.text.split(_paramKey);
            var command:String = args.shift();
            clear();
            var func:Function = _commandDelegates[command];
            if (func != null) {
                try {
                    func.apply(this, args);
                } catch (error:Error) {
                }
            }
            hide();
        } else if (event.keyCode == _prevHistoryKey) {
            _inputField.text = getPreviousHistoryCommand();
            event.preventDefault();
            _inputField.setSelection(_inputField.text.length, _inputField.text.length);
        } else if (event.keyCode == _nextHistoryKey) {
            _inputField.text = getNextHistoryCommand();
            event.preventDefault();
            _inputField.setSelection(_inputField.text.length, _inputField.text.length);
        }
    }
}
}
