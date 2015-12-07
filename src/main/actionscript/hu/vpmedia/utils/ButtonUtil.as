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
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

import hu.vpmedia.errors.StaticClassError;

/**
 * Utility class for Button manipulation
 *
 * @see flash.display.SimpleButton
 * @see help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/SimpleButton.html
 */
public class ButtonUtil {
    /**
     * @private
     */
    public function ButtonUtil() {
        throw new StaticClassError();
    }

    /**
     * SimpleButton factory helper method
     */
    public static function createSimpleButton(target:Sprite, x:int, y:int, upState:flash.display.DisplayObject = null,overState:flash.display.DisplayObject = null,downState:flash.display.DisplayObject = null,hitTestState:flash.display.DisplayObject = null):SimpleButton {
        if(!overState)
            overState = upState;
        if(!downState)
            downState = upState;
        if(!hitTestState)
            hitTestState = upState;
        const component:SimpleButton = new SimpleButton(upState, overState, downState, hitTestState);
        component.x = x;
        component.y = y;
        if(target)
            target.addChild(component);
        component.useHandCursor = true;
        return component;
    }

    /**
     * Draw rectangle button area on graphics display object.
     */
    public static function drawHitArea(target:Sprite, alpha:Number = 0):Sprite {
        var w:Number = target.width;
        var h:Number = target.height;
        target.graphics.beginFill(0xFFFFFF, alpha);
        target.graphics.drawRect(0, 0, w, h);
        target.graphics.endFill();
        return target;
    }

    /**
     * Will enable all button mode related properties.
     */
    public static function setButtonMode(target:Sprite, isEnabled:Boolean):void {
        target.mouseChildren = !isEnabled;
        target.buttonMode = isEnabled;
    }

    /**
     * TBD
     */
    public static function addHandler(target:InteractiveObject, clickHandler:Function, rollHandler:Function, isSetButtonMode:Boolean = false):void {
        addClickHandler(target, clickHandler, isSetButtonMode);
        addRollHandler(target, rollHandler);
    }

    /**
     * TBD
     */
    public static function removeHandler(target:InteractiveObject, clickHandler:Function, rollHandler:Function):void {
        removeClickHandler(target, clickHandler);
        removeRollHandler(target, rollHandler);
    }

    /**
     * TBD
     */
    public static function addClickHandler(target:InteractiveObject, handler:Function, isSetButtonMode:Boolean = false, isDrawArea:Boolean = false):void {
        if (isDrawArea && target is Sprite)
            drawHitArea(Sprite(target));
        if (isSetButtonMode && target is Sprite)
            setButtonMode(Sprite(target), true);
        target.addEventListener(MouseEvent.CLICK, handler, false, 0, true);
    }

    /**
     * TBD
     */
    public static function removeClickHandler(target:InteractiveObject, handler:Function):void {
        target.removeEventListener(MouseEvent.CLICK, handler);
    }

    /**
     * TBD
     */
    public static function addRollHandler(target:InteractiveObject, handler:Function):void {
        target.addEventListener(MouseEvent.ROLL_OVER, handler, false, 0, true);
        target.addEventListener(MouseEvent.ROLL_OUT, handler, false, 0, true);
    }

    /**
     * TBD
     */
    public static function removeRollHandler(target:InteractiveObject, handler:Function):void {
        target.removeEventListener(MouseEvent.ROLL_OVER, handler);
        target.removeEventListener(MouseEvent.ROLL_OUT, handler);
    }
}
}
