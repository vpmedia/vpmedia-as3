////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Cássio S. Antonio
// Contributors: Andras Csizmadia <andras@vpmedia.eu> 
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  
//=END LICENSE MIT
////////////////////////////////////////////////////////////////////////////////
package hu.vpmedia.statemachines.hfsm {
import flash.utils.Dictionary;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * StateMachine implementation
 */
public class StateMachine {
    /**
     * TBD
     */
    public var id:String;

    /**
     * TBD
     */
    public var entered:ISignal;

    /**
     * TBD
     */
    public var exited:ISignal;

    /**
     * TBD
     */
    public var started:ISignal;

    /**
     * TBD
     */
    public var completed:ISignal;

    /**
     * TBD
     */
    public var denied:ISignal;

    /**
     * TBD
     */
    public var states:Dictionary;

    /**
     * TBD
     */
    private var _state:String;

    /**
     * TBD
     */
    private var _prevState:String;

    /**
     * Creates a generic StateMachine.
     */
    public function StateMachine() {
        states = new Dictionary();

        entered = new Signal(String, String, String);
        exited = new Signal(String, String, String);
        started = new Signal(String, String);
        completed = new Signal(String);
        denied = new Signal(String);
    }

    /**
     * Adds a new state
     * @param stateName    The name of the new State
     * @param stateData    A hash containing state enter and exit callbacks and allowed states to transition from
     * The "from" property can be a string or and array with the state names or * to allow any transition
     **/
    public function addState(newState:IState):void {
        if (newState.name in states)
            trace("[StateMachine]", id, "Overriding existing state " + newState.name);

        states[newState.name] = newState;
        newState.init(this);
    }

    /**
     * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
     * These will only occour if no state is defined
     * @param stateName    The name of the State
     **/
    public function set initialState(stateName:String):void {
        if (_state == null && stateName in states) {
            _state = stateName;

            if (states[_state].root) {
                var parentStates:Array = states[_state].parents
                for (var j:int = states[_state].parents.length - 1; j >= 0; j--) {
                    if (parentStates[j].enter) {
                        // from, current, to
                        parentStates[j].enter.call(null, null, parentStates[j].name, stateName)
                    }
                }
            }

            if (states[_state].enter) {
                // from, current, to
                states[_state].enter.call(null, null, _state, stateName)
            }
            completed.dispatch(stateName);
        }
    }

    /**
     * Returns the current state name
     */
    public function get state():String {
        //trace(_state, states[_state]);
        /*var result:String = null;
        if(_state && states.hasOwnProperty(_state))
            result = IState(states[_state]).name;
        return result;*/
        // Tricky: uses State.toString() or returns null if state is not set.
        //return states[_state];
        return _state;
    }

    /**
     * Returns the current state name
     */
    public function get prevState():String {
        return _prevState;
    }

    /**
     * TBD
     */
    public function getStateByName(name:String):IState {
        for each (var s:IState in states) {
            if (s.name == name)
                return s;
        }

        return null;
    }

    /**
     * Verifies if a transition can be made from the current state to the state passed as param
     *
     * @param stateName The name of the State
     * @return Whether the state change is possible
     **/
    public function canChangeStateTo(stateName:String):Boolean {
        if (!states[stateName]) {
            return false;
        }
        return (stateName != _state && states[stateName] && (states[stateName].from.indexOf(_state) != -1 || states[stateName].from == "*"));
    }

    /**
     * Discovers the how many "exits" and how many "enters" are there between two
     * given states and returns an array with these two integers
     *
     * @param stateFrom The state to exit
     * @param stateTo The state to enter
     **/
    public function findPath(stateFrom:String, stateTo:String):Array {
        // Verifies if the states are in the same "branch" or have a common parent
        var fromState:IState = states[stateFrom];
        var c:int = 0;
        var d:int = 0;
        while (fromState) {
            d = 0;
            var toState:IState = states[stateTo];
            while (toState) {
                if (fromState == toState) {
                    // They are in the same brach or have a common parent Common parent
                    return [ c, d ];
                }
                d++;
                toState = toState.parent;
            }
            c++;
            fromState = fromState.parent;
        }
        // No direct path, no commom parent: exit until root then enter until element
        return [ c, d ];
    }

    /**
     * Changes the current state
     * This will only be done if the intended state allows the transition from the current state
     * Changing states will call the exit callback for the exiting state and enter callback for the entering state
     *
     * @param stateTo The name of the state to transition to
     * @return Whether the state change is possible
     **/
    public function changeState(stateTo:String):Boolean {
        // If there is no state that matches stateTo
        if (!(stateTo in states)) {
            return false;
        }
        // If current state is not allowed to make this transition
        if (!canChangeStateTo(stateTo)) {
            denied.dispatch(stateTo);
            return false;
        }
        // call exit and enter callbacks (if they exits)
        var path:Array = findPath(_state, stateTo);
        if (path[0] > 0) {
            if (states[_state].exit) {
                // from, current, to
                states[_state].exit.call(null, _state, _state, stateTo);
            }
            var parentState:IState = states[_state];
            for (var i:int = 0; i < path[0] - 1; i++) {
                parentState = parentState.parent;
                if (parentState.exit != null) {
                    // from, current, to
                    parentState.exit.call(null, _state, parentState.name, stateTo);
                }
            }
        }
        var oldState:String = _state;
        _prevState = oldState;
        _state = stateTo;
        if (path[1] > 0) {
            if (states[stateTo].root) {
                var parentStates:Array = states[stateTo].parents
                for (var k:int = path[1] - 2; k >= 0; k--) {
                    if (parentStates[k] && parentStates[k].enter) {
                        // from, current, to
                        //_enterCallbackEvent.currentState = parentStates[k].name;
                        parentStates[k].enter.call(null, oldState, parentStates[k].name, stateTo);
                    }
                    entered.dispatch(oldState, parentStates[k].name, stateTo);
                }
            }
            if (states[_state].enter) {
                // from, current, to
                states[_state].enter.call(null, oldState, _state, stateTo);
            }
            entered.dispatch(oldState, _state, stateTo);
        }
        completed.dispatch(stateTo);
        return true;
    }
}
}