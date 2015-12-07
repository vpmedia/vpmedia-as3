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

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.system.Security;
import flash.ui.Multitouch;
import flash.utils.setTimeout;

import hu.vpmedia.display.Console;
import hu.vpmedia.utils.SystemUtil;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.LOGGER_FACTORY;
import org.as3commons.logging.api.getLogger;
import org.as3commons.logging.setup.SimpleSetup;
import org.as3commons.logging.setup.target.TraceTarget;

import starling.core.Starling;
import starling.text.TextField;
import starling.utils.RectangleUtil;

RUNTIME::AIR
{
    import flash.desktop.NativeApplication;

    import org.as3commons.logging.setup.target.AirFileTarget;
}

PLATFORM::DESKTOP
{
    import flash.desktop.SystemIdleMode;
    import flash.display.NativeWindow;
    import flash.display.NativeWindowDisplayState;
    import flash.display.NativeWindowInitOptions;
    import flash.display.NativeWindowRenderMode;
    import flash.display.NativeWindowSystemChrome;
    import flash.display.Screen;
    import flash.events.NativeWindowDisplayStateEvent;
}

/**
 * The StarlingApplication class is the template class for all Starling based apps.
 */
public class StarlingApplication extends Sprite {

    /**
     * @private
     */
    protected var ContextClass:Class;

    //----------------------------------
    //  Getter properties
    //----------------------------------

    /**
     * @private
     */
    protected var _starling:Starling;

    /**
     * @private
     */
    protected var _nativeContext:DisplayObject;

    /**
     * @private
     */
    protected var _stageViewPort:Rectangle;

    /**
     * @private
     */
    protected var _console:Console;

    /**
     * @private
     */
    protected var _isDoubleScreen:Boolean;

    /**
     * @private
     */
    protected var _isDebugSWF:Boolean;

    /**
     * @private
     */
    protected var _config:StarlingApplicationConfig;

    //----------------------------------
    //  Double-Monitor getter properties
    //----------------------------------

    /**
     * @private
     */
    protected var _secondStarling:Starling;

    /**
     * @private
     */
    protected var _secondStage:Stage;

    //----------------------------------
    //  Static properties
    //----------------------------------

    /**
     * The static singleton reference to the application.
     */
    private static var _current:StarlingApplication;

    /**
     * The static singleton logger
     */
    private static const LOG:ILogger = getLogger("Main");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function StarlingApplication(stageWidth:uint, stageHeight:uint, config:StarlingApplicationConfig = null) {
        super();
        if (_current)
            throw new IllegalOperationError("Only one application can run at the same time.");
        _current = this;
        _config = config != null ? config : new StarlingApplicationConfig();
        if (_config.ContextClass)
            ContextClass = _config.ContextClass;
        _stageViewPort = new Rectangle(0, 0, stageWidth, stageHeight);
        addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @private
     */
    protected function onAdded(event:Event):void {
        // Init stage
        stage.scaleMode = _config.stageScaleMode;
        stage.align = _config.stageAlign;
        stage.quality = _config.stageQuality;
        stage.showDefaultContextMenu = _config.stageShowDefaultContextMenu;
        stage.stageFocusRect = _config.stageFocusRect;
        // Init logging
        if(_config.isUseLog) {
            initLogging();
        }
        // Set strict security policy
        Security.disableAVM1Loading = true;
        // Init inputs
        Multitouch.inputMode = _config.inputMode;
        // Initialize AIR runtime specific settings
        RUNTIME::AIR
        {
            Multitouch.mapTouchToMouse = _config.mapTouchToMouse;
            NativeApplication.nativeApplication.autoExit = _config.autoExit;
        }
        // Setup listeners
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
        // Bootstrap
        //LOG.debug("onAdded");
        setTimeout(onInitialized, 1);
    }

    /**
     * @private
     */
    protected function onInitialized():void {
        // Security Constraints
        PLATFORM::WEB {
            // Deny loading as module
            if(!_config.isAllowModuleLoad && !loaderInfo.sameDomain) {
                //LOG.error("Security Error");
                while(this) {}
                return;
            }
            // Do NOT allow External player
            if(!APP::DEBUG && Capabilities.playerType == SystemUtil.PLAYER_EXTERNAL) {
                //LOG.error("Security Error");
                while(this) {}
                return;
            }
            // Do NOT allow StandAlone player
            if(!APP::DEBUG && Capabilities.playerType == SystemUtil.PLAYER_STAND_ALONE) {
                //LOG.error("Security Error");
                while(this) {}
                return;
            }
        }
        LOG.debug("onInitialized");
        // Initialize Desktop platform specific settings
        PLATFORM::DESKTOP
        {
            var isSingleScreen:Boolean = Screen.screens && Screen.screens.length > 0;
            var isDoubleScreen:Boolean = isSingleScreen && Screen.screens.length > 1;
            if (isSingleScreen)
                LOG.debug("Display Screen #1: " + Screen(Screen.screens[0]).bounds);
            if (isDoubleScreen)
                LOG.debug("Display Screen #2: " + Screen(Screen.screens[1]).bounds);
            // keep awake app.
            NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
            // setup first window
            stage.nativeWindow.alwaysInFront = _config.alwaysInFront;
            stage.nativeWindow.activate();
            stage.nativeWindow.x = 0;
            stage.nativeWindow.y = 0;
            // resize first window to full screen
            if (_config.autoFullScreen && stage.nativeWindow.displayState != NativeWindowDisplayState.MAXIMIZED) {
                stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onNativeWindowDisplayChange, false, 0, true);
                //stage.nativeWindow.maximize();
                stage.nativeWindow.width = stage.fullScreenWidth;
                stage.nativeWindow.height = stage.fullScreenHeight;
                //stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            // attach window close handler
            stage.nativeWindow.addEventListener(Event.CLOSING, onNativeWindowClosing, false, 0, true);
            // setup second window
            _isDoubleScreen = Screen.screens.length > 1 && _config.SecondaryContextClass != null;
            if (_isDoubleScreen)
                setTimeout(initDoubleScreen, 1);
        }
        // Initialize Mobile platform specific settings
        PLATFORM::MOBILE
        {
            stage.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
        }
        // Initialize Common settings
        stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChange, false, 0, true);
        stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, onFullScreenInteractive, false, 0, true);
        stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
        // Initialize Starling Context
        if (ContextClass) {
            initStarling();
        }
        // Create console if enabled
        if (_config.consoleEnabled) {
            _console = new Console(_config.consoleKey);
            _console.addCommand("stats", switchStats);
            _console.addCommand("enableFullScreen", enableFullScreen);
            _console.addCommand("disableFullScreen", disableFullScreen);
        }
        // Initialize Native Context
        if (_config.NativeContextClass) {
            _nativeContext = new _config.NativeContextClass();
            stage.addChild(_nativeContext);
        }
        // Add console on top of everything
        if (_config.consoleEnabled) {
            stage.addChild(_console);
        }
    }

    /**
     * @private
     */
    protected function onRemoved(event:Event):void {
        LOG.debug("onRemoved");
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
        _starling.dispose();
        _starling = null;
    }

    /**
     * @private
     */
    PLATFORM::DESKTOP
    protected function initDoubleScreen():void {
        LOG.debug("initDoubleScreen");
        // get second screen
        const secondScreen:Screen = Screen(Screen.screens[1]);
        // create window options
        const secondWindowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
        secondWindowOptions.systemChrome = NativeWindowSystemChrome.NONE;
        secondWindowOptions.transparent = false;
        secondWindowOptions.renderMode = NativeWindowRenderMode.DIRECT;
        // create window
        const secondWindow:NativeWindow = new NativeWindow(secondWindowOptions);
        // make it full screen
        secondWindow.bounds = secondScreen.bounds;
        // configure forced screen
        secondWindow.alwaysInFront = _config.alwaysInFront;
        // copy title from first window
        secondWindow.title = stage.nativeWindow.title;
        // log it with display state
        LOG.debug("[SecondaryWindow displayState=" + secondWindow.displayState + "]");
        // setup window stage
        _secondStage = secondWindow.stage;
        _secondStage.align = _config.stageAlign;
        _secondStage.scaleMode = _config.stageScaleMode;
        _secondStage.color = 0x0;
        // activate second window
        secondWindow.activate();
        // block closing secondary window with F4
        secondWindow.addEventListener(Event.CLOSING, onNativeWindowClosing, false, 0, true);
        // init secondary starling
        if (_config.SecondaryContextClass) {
            _secondStarling = new Starling(_config.SecondaryContextClass, _secondStage, null, null, "auto", _config.stage3DProfile);
            _secondStarling.start();
            _starling.makeCurrent();
        } else if (_config.SecondaryNativeContextClass) {
            _nativeContext = new _config.SecondaryNativeContextClass();
            _secondStage.addChild(_nativeContext);
        }
    }

    /**
     * @private
     */
    protected function initLogging():void {
        try {
            _isDebugSWF = new Error().getStackTrace() != null && Capabilities.isDebugger;
        } catch (error:Error) {
            // swallow
        }
        PLATFORM::DESKTOP
        {
            LOGGER_FACTORY.setup = new SimpleSetup(new AirFileTarget());
        }
        PLATFORM::WEB
        {
            if (_isDebugSWF) {
                LOGGER_FACTORY.setup = new SimpleSetup(new TraceTarget());
            }
        }
        PLATFORM::MOBILE
        {
            if (_isDebugSWF) {
                LOGGER_FACTORY.setup = new SimpleSetup(new TraceTarget());
            }
        }
        /*if(PLATFORM::WEB && _config.isUseLog && Capabilities.os == "Linux") {
         var debugTextField:TextFieldTarget = new TextFieldTarget();
         debugTextField.width = VIEWPORT::WIDTH;
         debugTextField.height = VIEWPORT::HEIGHT;
         debugTextField.textColor = 0xFFFFFF;
         stage.addChild(debugTextField);
         LOGGER_FACTORY.setup = new SimpleSetup(debugTextField);
         }*/
    }

    /**
     * @private
     */
    protected function initStarling():void {
        LOG.debug("initStarling::expected view port: " + _stageViewPort);
        // Set native stage frame rate to 60fps!
        stage.frameRate = 60;
        // Setup global properties
        Starling.multitouchEnabled = _config.isMultiTouch;
        TextField.defaultTextureFormat = _config.textureFormat;
        // Create Starling
        if (_config.isFluidStage || RUNTIME::AIR)
            _starling = new Starling(ContextClass, stage, null, _config.stage3D, "auto", _config.stage3DProfile);
        else
            _starling = new Starling(ContextClass, stage, _stageViewPort.clone(), _config.stage3D, "auto", _config.stage3DProfile);
        // Setup screen size
        _starling.stage.stageWidth = _stageViewPort.width;
        _starling.stage.stageHeight = _stageViewPort.height;
        // Trigger full-screen on Mobile
        PLATFORM::MOBILE
        {
            enableFullScreen();
        }
        if (_config.isFluidStage) {
            const currentStageRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            LOG.debug("Resizing fluid stage: " + currentStageRect + " (" + _config.starlingScaleMode + ")");
            _starling.viewPort = RectangleUtil.fit(_stageViewPort, currentStageRect, _config.starlingScaleMode);
        }
        _starling.showStats = _config.showStats;
        _starling.enableErrorChecking = _config.isStage3DDebug;
        _starling.simulateMultitouch = false;
        _starling.antiAliasing = _config.antiAlias;
        _starling.start();
        LOG.debug("initStarling::rendered view port: " + _starling.viewPort);
    }

    //----------------------------------
    //  Getters/setters
    //----------------------------------

    /**
     * Returns the Static reference to the application
     */
    public static function get current():StarlingApplication {
        return _current;
    }

    /**
     * Returns the expected stage view port.
     */
    public function get viewPort():Rectangle {
        return _stageViewPort;
    }

    /**
     * Returns the primary starling instance.
     */
    public function get starling():Starling {
        return _starling;
    }

    /**
     * Returns the primary native context instance.
     */
    public function get nativeContext():DisplayObject {
        return _nativeContext;
    }

    /**
     * Returns the flash vars parameter object.
     */
    public function get flashVars():Object {
        var result:Object = null;
        if (loaderInfo && loaderInfo.parameters)
            result = loaderInfo && loaderInfo.parameters;
        return result;
    }

    /**
     * Returns the console object.
     */
    public function get console():Console {
        return _console;
    }

    /**
     * Returns the application config object.
     */
    public function get config():StarlingApplicationConfig {
        return _config;
    }

    /**
     * Returns whether double screen is enabled.
     */
    public function get isDoubleScreen():Boolean {
        return _isDoubleScreen;
    }

    /**
     * Returns the secondary starling instance.
     */
    public function get secondStarling():Starling {
        return _secondStarling;
    }

    /**
     * Returns the secondary stage.
     * Desktop only.
     */
    public function get secondStage():Stage {
        return _secondStage;
    }

    /**
     * Returns the stage3d driver info.
     * Desktop only.
     */
    public function get driverInfo():String {
        return stage.stage3Ds[0].context3D.driverInfo;
    }

    /**
     * Shut down application
     */
    public function shutdown():void {
        RUNTIME::AIR {
            NativeApplication.nativeApplication.exit(0);
        }
        PLATFORM::WEB {
            if (_starling)
                _starling.stop(true);
        }
    }

    //----------------------------------
    //  Helpers - Used by Console
    //----------------------------------

    /**
     * @private
     */
    protected function switchStats():void {
        _starling.showStats = !_starling.showStats;
    }

    /**
     * @private
     */
    protected function enableFullScreen():void {
        if (!_starling) {
            return;
        }
        const currentStageRect:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        LOG.debug("enableFullScreen: " + currentStageRect);
        _starling.viewPort = RectangleUtil.fit(_stageViewPort, currentStageRect, _config.starlingScaleMode);

    }

    /**
     * @private
     */
    protected function disableFullScreen():void {
        if (!_starling) {
            return;
        }
        LOG.debug("disableFullScreen: " + _stageViewPort);
        if (_config.isFluidStage) {
            const currentStageRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            _starling.viewPort = RectangleUtil.fit(_stageViewPort, currentStageRect, _config.starlingScaleMode);
        } else {
            _starling.viewPort = _stageViewPort.clone();
        }
    }

    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * @private
     */
    protected function onFullScreenChange(event:FullScreenEvent):void {
        if (!_starling || !_starling.root) {
            return;
        }
        LOG.debug("onFullScreenChange fullScreen=" + event.fullScreen + " interactive=" + event.interactive);
        _starling.root.touchable = !event.interactive;
        event.fullScreen ? enableFullScreen() : disableFullScreen();
    }

    /**
     * @private
     */
    protected function onFullScreenInteractive(event:FullScreenEvent):void {
        if (!_starling || !_starling.root) {
            return;
        }
        LOG.debug("onFullScreenInteractive fullScreen=" + event.fullScreen + " interactive=" + event.interactive);
        _starling.juggler.delayCall(enableStarlingTouches, 0.1);
    }

    /**
     * @private
     */
    protected function enableStarlingTouches():void {
        if (!_starling || !_starling.root) {
            return;
        }
        _starling.root.touchable = true;
    }

    /**
     * @private
     */
    protected function onStageResize(event:Event):void {
        if (_starling && _config.isFluidStage) {
            const currentStageRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            LOG.debug("onStageResize: " + currentStageRect);
            _starling.viewPort = RectangleUtil.fit(_stageViewPort, currentStageRect, _config.starlingScaleMode);
        }
    }

    //----------------------------------
    //  Event Handlers (Desktop only)
    //----------------------------------

    PLATFORM::DESKTOP {

        /**
         * @private
         */
        protected function onNativeWindowDisplayChange(event:NativeWindowDisplayStateEvent):void {
            LOG.debug("onNativeWindowDisplayChange beforeDisplayState=" + event.beforeDisplayState + " afterDisplayState=" + event.afterDisplayState);
            stage.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onNativeWindowDisplayChange);
            enableFullScreen();
        }

        /**
         * @private
         */
        protected function onNativeWindowClosing(event:Event):void {
            //LOG.debug("onNativeWindowClosing");
            event.preventDefault();
            if (!_config.preventExit && event.target == stage.nativeWindow) {
                closeAllWindows();
            }
        }

        /**
         * @private
         */
        protected function closeAllWindows():void {
            const n:uint = NativeApplication.nativeApplication.openedWindows.length;
            for (var i:int = n - 1; i >= 0; --i) {
                NativeWindow(NativeApplication.nativeApplication.openedWindows[i]).close();
            }
        }
    }

    //----------------------------------
    //  Event Handlers (Mobile only)
    //----------------------------------

    PLATFORM::MOBILE {
        /**
         * @private
         */
        protected function onActivate(event:Event):void {
            LOG.debug("onActivate");
            // remove activate stage listener
            stage.removeEventListener(Event.ACTIVATE, onActivate);
            // start starling rendering if available
            if (_starling)
                _starling.start();
        }

        /**
         * @private
         */
        protected function onDeactivate(event:Event):void {
            LOG.debug("onDeactivate");
            // add activate stage listener
            stage.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
            // stop starling rendering if available
            if (_starling)
                _starling.stop();
        }
    }

    // EOC
}

//EOP

}