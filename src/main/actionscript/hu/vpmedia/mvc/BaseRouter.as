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
package hu.vpmedia.mvc {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import hu.vpmedia.framework.IBaseDisposable;

import hu.vpmedia.statemachines.hfsm.IState;
import hu.vpmedia.statemachines.hfsm.State;
import hu.vpmedia.statemachines.hfsm.StateMachine;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The BaseRouter class is a template class for various display list based Routers (Flash, Starling, Etc.)
 */
public class BaseRouter implements IBaseDisposable{

    /**
     * @private
     */
    protected static const LOG:ILogger = getLogger("Router");

    /**
     * @private
     */
    protected var _nextStateQueue:Vector.<RouterStateVO>;

    /**
     * @private
     */
    protected var _urlStateMap:Dictionary;

    /**
     * @private
     */
    protected var _viewStateMap:Dictionary;

    /**
     * @private
     */
    protected var _stateMachine:StateMachine;

    /**
     * @private
     */
    protected var _nextStateURL:String;

    /**
     * @private
     */
    protected var _prevStateURL:String;

    /**
     * @private
     */
    protected var _inTransition:Boolean;

    /**
     * @private
     */
    protected var _setStateTO:uint;

    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * The router signal set.
     */
    public var signal:ISignal;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseRouter() {
        super();
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        signal = new Signal(String, String);
        _nextStateQueue = new Vector.<RouterStateVO>();
        _urlStateMap = new Dictionary();
        _viewStateMap = new Dictionary();
        _stateMachine = new StateMachine();
        _stateMachine.completed.add(onStateChangeComplete);
        _stateMachine.denied.add(onStateChangeDenied);
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        if(_stateMachine) {
            _stateMachine.completed.remove(onStateChangeComplete);
            _stateMachine.denied.remove(onStateChangeDenied);
            _stateMachine = null;
        }
        if(signal) {
            signal.removeAll();
            signal = null;
        }
        if(_nextStateQueue)
            _nextStateQueue.length = 0;
        _nextStateQueue = null;
        _urlStateMap = null;
        _viewStateMap = null;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Adds a list of route elements to the Router.
     *
     * @param routes The list containing RouterStateVO objects.
     */
    public function addRoutes(routes:Array):void {
        // validate input
        if (!routes)
            return;
        // iterate over list
        const n:uint = routes.length;
        for (var i:uint = 0; i < n; i++) {
            addRoute(routes[i]);
        }
    }

    /**
     * Adds a route element to the Router.
     *
     * @param route The RouterStateVO object.
     * @return The new IState object added to the router's state machine.
     */
    public function addRoute(route:RouterItem):IState {
        // save new route
        _urlStateMap[route.url] = route;
        // create state machine configuration object
        const stateConfig:Object = { enter: onStateChangeEnter, exit: onStateChangeExit };
        // get parent path (root or sibling)
        const parentPath:String = RouterUtil.getParentPath(route.url);
        if (_stateMachine.canChangeStateTo(parentPath)) {
            stateConfig.parent = parentPath;
        }
        // create new state machine element
        const stateItem:IState = new State(route.url, stateConfig);
        // add it to state machine
        _stateMachine.addState(stateItem);
        // return it
        return stateItem;
    }

    /**
     * setValue
     *
     * @param url
     */
    public function setState(url:String, isAddToHistory:Boolean = true):void {
        LOG.debug("setState: " + arguments + " (" + _inTransition + ")");
        // clear possible timeout call
        clearTimeout(_setStateTO);
        // check for transition state
        if(_inTransition) {
            _setStateTO = setTimeout(setState, 100, url, isAddToHistory);
            return;
        }
        // check for not registered state
        if (!_stateMachine.canChangeStateTo(url)) {
            signal.dispatch(RouterCodes.ROUTE_NOT_FOUND, url);
            return;
        }
        // check for already in state
        if (_stateMachine.state == url) {
            signal.dispatch(RouterCodes.ROUTE_ALREADY_SET, url);
            return;
        }
        // mark as transitioning immediately
        _inTransition =  true;
        // notify subscribers
        signal.dispatch(RouterCodes.ROUTE_CHANGE_START, url);
        // save state identifiers
        if(isAddToHistory) {
            _prevStateURL = _nextStateURL;
        }
        _nextStateURL = url;
        // start state transition
        _stateMachine.changeState(_nextStateURL);
    }

    /**
     * Return whether the router is in transition phase.
     */
    public function isTransitioning():Boolean {
        return _inTransition;
    }

    /**
     * Clears any running transition.
     */
    public function cancel():void {
        _inTransition = false;
        clearTimeout(_setStateTO);
    }

    /**
     * Return the current state url.
     */
    public function currentURL():String {
        return _nextStateURL;
    }

    /**
     * Return the previous state url.
     */
    public function previousURL():String {
        return _prevStateURL;
    }

    /**
     * Returns the current transition url.
     */
    public function getTransitionURL():String {
        if (_nextStateQueue.length > 0) {
            return _nextStateQueue[0].currentState;
        }
        return _nextStateURL;
    }

    //----------------------------------
    //  Getters
    //----------------------------------

    /**
     * Get the router's state machine.
     *
     * @return StateMachine
     */
    public function get stateMachine():StateMachine {
        return _stateMachine;
    }

    //----------------------------------
    //  Protected Abstract Methods
    //----------------------------------

    /**
     * @private
     */
    protected function clearState(url:String):void {
        // Abstract
        throw new IllegalOperationError("Not implemented");
    }

    /**
     * @private
     */
    protected function nextState(url:String):void {
        // Abstract
        throw new IllegalOperationError("Not implemented");
    }

    /**
     * @private
     */
    protected function doTransition():void {
        // Abstract
        throw new IllegalOperationError("Not implemented");
    }

    //----------------------------------
    //  Signal handlers
    //----------------------------------

    /**
     * @private
     */
    protected function viewTransitionInHandler():void {
        //LOG.debug("viewTransitionInHandler");
        signal.dispatch(BaseViewSignalTypes.TRANSITION_IN_COMPLETE, getTransitionURL());
        nextTransition();
    }

    /**
     * @private
     */
    protected function viewTransitionOutHandler():void {
        //LOG.debug("viewTransitionOutHandler");
        signal.dispatch(BaseViewSignalTypes.TRANSITION_OUT_COMPLETE, getTransitionURL());
        if (_nextStateQueue.length > 0) {
            const item:RouterStateVO = _nextStateQueue[0];
            clearState(item.currentState);
        }
        nextTransition();
    }

    /**
     * @private
     */
    protected function onStateChangeEnter(oldState:String, currentState:String, toState:String):void {
        const item:RouterStateVO = new RouterStateVO(currentState, RouterStateVO.ENTER_CALLBACK);
        _nextStateQueue.push(item);
    }

    /**
     * @private
     */
    protected function onStateChangeExit(oldState:String, currentState:String, toState:String):void {
        const item:RouterStateVO = new RouterStateVO(currentState, RouterStateVO.EXIT_CALLBACK);
        _nextStateQueue.push(item);
    }

    /**
     * @private
     */
    protected function onStateChangeComplete(toState:String):void {
        LOG.debug("onStateChangeComplete: " + toState + " (" + _inTransition + ")" + " [" + _nextStateQueue + "]");
        //if (!_inTransition) {
            if (_nextStateQueue.length == 0) {
                nextState(_nextStateURL);
            } else {
                _inTransition = true;
                doTransition();
            }
        //} else {
        //    // TODO: Throw error?
        //    LOG.debug("onStateChangeComplete::InTransitionError: " + toState);
        //}
    }

    /**
     * @private
     */
    protected function onStateChangeDenied(toState:String):void {
        LOG.debug("onStateChangeDenied: " + toState);
    }

    //----------------------------------
    //  Protected Template Methods
    //----------------------------------

    /**
     * @private
     */
    protected function nextTransition():void {
        //LOG.debug("nextTransition");
        // transition in/out complete, remove item from queue
        _nextStateQueue.shift();
        // check for next transition or notify subscribers about route change complete
        if (_nextStateQueue.length > 0) {
            doTransition();
        } else {
            signal.dispatch(RouterCodes.ROUTE_CHANGE_COMPLETE, _stateMachine.state);
            _inTransition = false;
        }
    }

}
}
