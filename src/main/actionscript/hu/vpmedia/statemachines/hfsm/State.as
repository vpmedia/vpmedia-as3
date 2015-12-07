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

/**
 * State representation object
 */
public class State implements IState {
    //----------------------------------
    //  Private properties
    //----------------------------------
    /**
     * @private
     */
    private var _name:String;
    /**
     * @private
     */
    private var _from:Object;
    /**
     * @private
     */
    private var _enter:Function;
    /**
     * @private
     */
    private var _exit:Function;
    /**
     * @private
     */
    private var _parent:IState;
    /**
     * @private
     */
    private var _parentName:String;
    /**
     * @private
     */
    private var _children:Array;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function State(stateName:String, stateData:Object = null) {
        this._name = stateName;
        if (stateData) {
            this._from = stateData.from;
            this._enter = stateData.enter;
            this._exit = stateData.exit;
            this._parentName = stateData.parent;
        }
        if (!_from)
            _from = "*";
        this.children = [];
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function init(stateMachineInstance:StateMachine):void {
        if (_parentName) {
            parent = IState(stateMachineInstance.states[_parentName]);
        }
    }

    /**
     * @inheritDoc
     */
    public function allowTransitionFrom(stateName:String):Boolean {
        return (_from.indexOf(stateName) != -1 || from == "*");
    }

    /**
     * @inheritDoc
     */
    public function get name():String {
        return _name;
    }

    /**
     * @inheritDoc
     */
    public function get from():Object {
        return _from;
    }

    /**
     * @inheritDoc
     */
    public function get enter():Function {
        return _enter;
    }

    /**
     * @inheritDoc
     */
    public function get exit():Function {
        return _exit;
    }

    /**
     * @inheritDoc
     */
    public function get parent():IState {
        return _parent;
    }

    /**
     * @inheritDoc
     */
    public function set parent(parent:IState):void {
        _parent = parent;
        _parent.children.push(this);
    }

    /**
     * @inheritDoc
     */
    public function get parentName():String {
        return _parentName;
    }

    /**
     * @inheritDoc
     */
    public function get parents():Array {
        var parentList:Array = [];
        var parentState:IState = _parent;
        if (parentState) {
            parentList.push(parentState);
            while (parentState.parent) {
                parentState = parentState.parent;
                parentList.push(parentState);
            }
        }
        return parentList;
    }

    /**
     * @inheritDoc
     */
    public function get children():Array {
        return _children;
    }

    /**
     * @inheritDoc
     */
    public function set children(children:Array):void {
        _children = children;
    }

    /**
     * @inheritDoc
     */
    public function get root():IState {
        var parentState:IState = _parent;
        if (parentState) {
            while (parentState.parent) {
                parentState = parentState.parent;
            }
        }
        return parentState;
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        _enter = null;
        _exit = null;
        _from = null;
        _parent = null;
        _name = null;
        _parentName = null;
        _children = null;
    }

    /**
     * @inheritDoc
     */
    public function toString():String {
        //throw new Error("Deprecated method in State:toString()");
        return this.name;
    }
}
}