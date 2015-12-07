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
package hu.vpmedia.statemachines.hfsm {
import flash.display.Sprite;

import flexunit.framework.Assert;

public class HFSMStateMachineTest extends Sprite {
    private var subject:StateMachine;

    [Before]
    public function setUp():void {
        subject = new StateMachine();
        subject.addState(new State("opened"));
        subject.addState(new State("closed", { from: ["opened", "locked"] }));
        subject.addState(new State("locked", { from: ["closed"] }));
        subject.initialState = "opened";
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
    public function test_initialState():void {
        Assert.assertTrue(subject.state == "opened");
        Assert.assertEquals(subject.state, "opened");
    }

    [Test]
    public function test_canChangeState():void {
        Assert.assertFalse(subject.canChangeStateTo("opened"));
        Assert.assertFalse(subject.canChangeStateTo("locked"));
        Assert.assertTrue(subject.canChangeStateTo("closed"));
    }

    [Test]
    public function test_changingtToUnexistingState():void {
        Assert.assertFalse(subject.changeState("unknown"));
    }

    [Test]
    public function test_changingtToDeniedState():void {
        Assert.assertFalse(subject.changeState("locked"));
    }

    [Test]
    public function test_changingState():void {
        Assert.assertTrue(subject.changeState("closed"));
    }

    /*
     public function testInAvailStates():void{
     assertTrue("opened exists in states",("opened" in fsm.states));
     assertFalse("opera doesent exists in states",("opera" in fsm.states));
     } */
}
}
