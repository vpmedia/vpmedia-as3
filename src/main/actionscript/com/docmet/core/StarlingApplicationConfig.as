/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Docmet Systems
 *  http://www.docmet.com
 *
 *  For information about the licensing and copyright please
 *  contact us at info@docmet.com
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package com.docmet.core {
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.display3D.Context3DTextureFormat;
import flash.system.Capabilities;
import flash.ui.Keyboard;
import flash.ui.MultitouchInputMode;

import hu.vpmedia.framework.BaseConfig;

/**
 * StarlingApplicationConfig
 */
public class StarlingApplicationConfig extends BaseConfig {

    /**
     * Starling based context class for the main Window
     */
    public var ContextClass:Class;

    /**
     * Display-list based context class for the main Window
     */
    public var NativeContextClass:Class;

    /**
     * Starling based context class for the 2nd Window
     *
     * Runtime: AIR
     */
    public var SecondaryContextClass:Class;

    /**
     * Display-list based context class for the 2nd Window
     *
     * Runtime: AIR
     */
    public var SecondaryNativeContextClass:Class;

    /**
     * The Stage scale mode
     *
     * @see flash.display.StageScaleMode
     */
    public var stageScaleMode:String;

    /**
     * The Stage align mode
     *
     * @see flash.display.StageAlign
     */
    public var stageAlign:String;

    /**
     * The Stage quality mode
     *
     * @see flash.display.StageQuality
     */
    public var stageQuality:String;

    /**
     * Flag indicating whether to show the default context menu
     */
    public var stageShowDefaultContextMenu:Boolean;

    /**
     * Flag indicating whether to show the Stage focus rectangle
     */
    public var stageFocusRect:Boolean;

    /**
     * TBD
     */
    public var inputMode:String;

    /**
     * TBD
     */
    public var mapTouchToMouse:Boolean;

    /**
     * Indicates whether the application should close when all windows have closed.
     *
     * Runtime: AIR
     */
    public var autoExit:Boolean;

    /**
     * TBD
     */
    public var autoFullScreen:Boolean;

    /**
     * TBD
     *
     * Runtime: AIR
     */
    public var preventExit:Boolean;

    /**
     * TBD
     *
     * Runtime: AIR
     */
    public var alwaysInFront:Boolean;

    /**
     * TBD
     */
    public var isFluidStage:Boolean;

    /**
     * TBD
     */
    public var isMouseLock:Boolean;

    /**
     * TBD
     */
    public var isUseLog:Boolean;

    /**
     * TBD
     */
    public var isAllowModuleLoad:Boolean;

    /**
     * TBD
     */
    public var consoleKey:uint;

    /**
     * TBD
     */
    public var consoleEnabled:Boolean;

    /**
     *  Indicates whether to show stats screen.
     */
    public var showStats:Boolean;

    /**
     *  The anti-aliasing level. 0 - no anti-alasing, 16 - maximum anti-aliasing.
     */
    public var antiAlias:uint;

    /**
     * TBD
     */
    public var starlingScaleMode:String;

    /**
     * Indicates if Starling multi touch enabled.
     */
    public var isMultiTouch:Boolean;

    /**
     * The Stage3d texture format.
     */
    public var textureFormat:String;

    /**
     * Indicates if Stage3D render methods will report errors.
     */
    public var isStage3DDebug:Boolean;

    /**
     *  The shared stage3d instance.
     */
    public var stage3D:Stage3D;

    /**
     *  The shared stage3d profile.
     */
    public var stage3DProfile:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function StarlingApplicationConfig(parameters:Object = null) {
        super(parameters);
    }

    /**
     * @inheritDoc
     */
    override public function setupDefaults():void {
        stageScaleMode = StageScaleMode.NO_SCALE;
        stageAlign = StageAlign.TOP_LEFT;
        stageQuality = StageQuality.MEDIUM;
        stageShowDefaultContextMenu = false;
        stageFocusRect = false;
        inputMode = MultitouchInputMode.NONE;
        mapTouchToMouse = true;
        autoExit = true;
        autoFullScreen = true;
        consoleEnabled = APP::DEBUG;
        isUseLog = APP::DEBUG;
        consoleKey = Keyboard.NUMBER_0;
        textureFormat = Context3DTextureFormat.BGRA;
        starlingScaleMode = StageScaleMode.SHOW_ALL;
        stage3DProfile = "auto";
        PLATFORM::WEB {
            isFluidStage = true;
        }
    }

    /**
     * Returns type description information.
     */
    public function toString():String {
        return "[StarlingApplicationConfig"
                + " isFluidStage=" + isFluidStage
                + " alwaysInFront=" + alwaysInFront
                + " preventExit=" + preventExit
                + " autoExit=" + autoExit
                + "]";
    }
}
}