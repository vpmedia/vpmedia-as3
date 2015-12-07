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
 * TBD
 */
public interface IState {
    /**
     * TBD
     */
    function init(stateMachine:StateMachine):void

    /**
     * TBD
     */
    function allowTransitionFrom(stateName:String):Boolean

    /**
     * TBD
     */
    function get name():String

    /**
     * TBD
     */
    function get from():Object

    /**
     * TBD
     */
    function get enter():Function

    /**
     * TBD
     */
    function get exit():Function

    /**
     * TBD
     */
    function get parent():IState

    /**
     * TBD
     */
    function set parent(parent:IState):void

    /**
     * TBD
     */
    function get parentName():String

    /**
     * TBD
     */
    function get parents():Array

    /**
     * TBD
     */
    function get children():Array

    /**
     * TBD
     */
    function set children(children:Array):void

    /**
     * TBD
     */
    function get root():IState

    /**
     * TBD
     */
    function toString():String
}
}
