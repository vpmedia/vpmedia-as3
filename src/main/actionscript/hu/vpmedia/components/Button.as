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
package hu.vpmedia.components {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.ComponentState;
import hu.vpmedia.components.core.IBaseSelectable;
import hu.vpmedia.components.core.IBaseTextField;
import hu.vpmedia.components.core.InvalidationType;
import hu.vpmedia.components.skins.ButtonSkin;

/**
 * TBD
 */
public class Button extends BaseComponent implements IBaseTextField, IBaseSelectable {
    //--------------------------------------
    //  Variables
    //--------------------------------------

    /**
     * @private
     */
    protected var _currentText:String = "";

    /**
     * @private
     */
    protected var _isOver:Boolean;

    /**
     * @private
     */
    protected var _isDown:Boolean;

    /**
     * @private
     */
    protected var _isSelected:Boolean;

    /**
     * @private
     */
    protected var _isToggle:Boolean;

    /**
     * @private
     */
    protected var _showIcon:Boolean;

    /**
     * @private
     */
    protected var _showLabel:Boolean;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function Button(parent:DisplayObjectContainer, config:Object = null) {
        _showLabel = true;
        super(parent, config);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override protected function preInitialize():void {
        if (!_skinClass)
            _skinClass = ButtonSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 22;
        buttonMode = true;
        mouseChildren = false;
        super.preInitialize();
    }

    /**
     * @inheritDoc
     */
    override protected function createListeners():void {
        addEventListener(MouseEvent.ROLL_OVER, mouseHandler, false, 0, true);
        addEventListener(MouseEvent.ROLL_OUT, mouseHandler, false, 0, true);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler, false, 0, true);
    }

    /**
     * @inheritDoc
     */
    override protected function removeListeners():void {
        super.removeListeners();
        removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
        removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
        removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        if (stage)
            stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
    }

    /**
     * @inheritDoc
     */
    protected function mouseHandler(event:MouseEvent):void {
        switch (event.type) {
            case MouseEvent.ROLL_OVER:
                _isOver = true;
                setState(ComponentState.OVER);
                break;
            case MouseEvent.ROLL_OUT:
                _isOver = false;
                if (!_isDown) {
                    setState(ComponentState.DEFAULT);
                }
                break;
            case MouseEvent.MOUSE_DOWN:
                _isDown = true;
                stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
                setState(ComponentState.DOWN);
                break;
            case MouseEvent.MOUSE_UP:
                _isDown = false;
                stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
                if (_isOver) {
                    if (_isToggle) {
                        _isSelected = !_isSelected;
                    }
                    setState(ComponentState.OVER);
                    sendTransmission(Event.CHANGE, null, name, this);
                } else {
                    setState(ComponentState.DEFAULT);
                }
                break;
        }
    }

    /**
     * Sets the label text
     *
     * @param value String
     */
    public function setText(value:String, isInvalid:Boolean):void {
        if (_currentText == value) {
            return;
        }
        _currentText = value;
        if(isInvalid) {
            invalidate(InvalidationType.DATA, true);
        }
    }

    //--------------------------------------
    //  Getters/setters
    //--------------------------------------

    /**
     * TBD
     */
    public function set text(value:String):void {
        if (_currentText != value) {
            _currentText = value;
            draw();
        }
    }

    /**
     * TBD
     */
    public function get text():String {
        return _currentText;
    }

    /**
     * TBD
     */
    public function set toggle(value:Boolean):void {
        _isToggle = value;
    }

    /**
     * TBD
     */
    public function get toggle():Boolean {
        return _isToggle;
    }

    /**
     * TBD
     */
    public function set showIcon(value:Boolean):void {
        if (_showIcon != value) {
            _showIcon = value;
            draw();
        }
    }

    /**
     * TBD
     */
    public function get showIcon():Boolean {
        return _showIcon;
    }

    /**
     * TBD
     */
    public function set showLabel(value:Boolean):void {
        if (_showLabel != value) {
            _showLabel = value;
            draw();
        }
    }

    /**
     * TBD
     */
    public function get showLabel():Boolean {
        return _showLabel;
    }

    /**
     * TBD
     */
    public function set selected(value:Boolean):void {
        if (_isSelected != value) {
            _isSelected = value;
            draw();
        }
    }

    /**
     * TBD
     */
    public function get selected():Boolean {
        return _isSelected;
    }
}
}
