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

package hu.vpmedia.statemachines.fsm {
import flash.utils.Dictionary;

/**
 * TBD
 */
public class StateMachine {
    //----------------------------------
    //  Properties
    //----------------------------------

    /**
     * TBD
     */
    private var _states:Dictionary;

    /**
     * Reference to current state
     */
    private var _state:IState;

    /**
     * Constructor
     */
    public function StateMachine() {
        _states = new Dictionary(false);
        _state = null;
    }

    /**
     * TBD
     */
    public function addState(state:IState):void {
        var type:Class = Class(Object(state).constructor);
        _states[type] = state;
        if (!_state)
            _state = state;
    }

    /**
     * TBD
     */
    public function setState(type:Class):void {
        var state:IState = type in _states ? _states[type] : _states[type] = new type();

        if (_state) {
            _state.exit();
        }

        _state = state;

        if (_state) {
            _state.enter();
        }
    }

    /**
     * TBD
     */
    public function getState():IState {
        return _state;
    }

    /**
     * TBD
     */
    public function update():void {
        if (_state) {
            _state.update();
        }
    }

    /**
     * TBD
     */
    public function dispose():void {
        _states = null;
        _state = null;
    }


}
}
