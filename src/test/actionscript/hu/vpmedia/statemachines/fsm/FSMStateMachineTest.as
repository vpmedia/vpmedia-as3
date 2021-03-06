/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013 Andras Csizmadia
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
import flash.display.Sprite;

import flexunit.framework.Assert;

public class FSMStateMachineTest extends Sprite {
    private var subject:StateMachine;

    [Before]
    public function setUp():void {
        subject = new StateMachine();
    }

    [After]
    public function tearDown():void {
        subject = null;
    }

    [Test]
    public function test_instantiate():void {
        Assert.assertNotNull(subject);
    }

    [Test]
    public function test_defaultStateIsNull():void {
        Assert.assertNull(subject.getState());
    }

    [Test]
    public function test_canAddState():void {
        const stateA:IState = new MockStateA();
        subject.addState(stateA);
        Assert.assertStrictlyEquals(subject.getState(), stateA);
    }

    [Test]
    public function test_canChangeState():void {
        const stateA:IState = new MockStateA();
        const stateB:IState = new MockStateB();
        subject.addState(stateA);
        subject.addState(stateB);
        Assert.assertStrictlyEquals(subject.getState(), stateA);
        subject.setState(MockStateB);
        Assert.assertStrictlyEquals(subject.getState(), stateB);
    }
}
}
